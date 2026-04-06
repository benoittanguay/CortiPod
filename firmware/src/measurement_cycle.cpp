// =============================================================================
// measurement_cycle.cpp  —  Measurement cycle orchestrator
//
// Pipeline: contact check → sensor read → potentiostat → transmit/buffer
// =============================================================================

#include "measurement_cycle.h"
#include "ble_service.h"
#include "power_mgmt.h"
#include "config.h"

// ---------------------------------------------------------------------------
// Module-private state
// ---------------------------------------------------------------------------

static CycleResult s_lastResult;
static bool        s_hasResult   = false;
static bool        s_isRunning   = false;
static bool        s_abortRequested = false;

// Offline buffer: stores summary readings when BLE is not connected.
// For a full implementation, consider storing to flash (e.g. via LittleFS).
// Here we store a lightweight struct with just the key scalar values.
struct OfflineRecord {
    uint32_t timestampMs;
    float    temperatureTMP117_C;
    float    humidityPct;
    uint32_t gsrResistance_ohms;
    // NOTE: chrono waveform arrays (~2.4 kB each) are NOT stored offline.
    //       Only scalar summaries fit in the limited SRAM budget.
};

static OfflineRecord s_offlineBuffer[OFFLINE_BUFFER_SIZE];
static uint8_t       s_offlineHead  = 0; // write index (ring buffer)
static uint8_t       s_offlineCount = 0; // number of valid records

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------

static void bufferRecord(const CycleResult* result) {
    OfflineRecord* rec = &s_offlineBuffer[s_offlineHead];
    rec->timestampMs          = result->sensorData.timestampMs;
    rec->temperatureTMP117_C  = result->sensorData.temperatureTMP117_C;
    rec->humidityPct          = result->sensorData.humidityPct;
    rec->gsrResistance_ohms   = result->sensorData.gsrResistance_ohms;

    s_offlineHead = (s_offlineHead + 1) % OFFLINE_BUFFER_SIZE;
    if (s_offlineCount < OFFLINE_BUFFER_SIZE) {
        s_offlineCount++;
    }
    // When the buffer is full, oldest record is silently overwritten (ring).
}

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

void measurementCycle_init(void) {
    s_offlineHead  = 0;
    s_offlineCount = 0;
    s_isRunning    = false;
    s_abortRequested = false;
    s_hasResult    = false;
    memset(&s_lastResult, 0, sizeof(s_lastResult));

#if CORTIPOD_DEBUG
    Serial.println("[CYCLE] Measurement cycle module initialised");
#endif
}

CycleStatus measurementCycle_run(void) {
    if (s_isRunning) return CycleStatus::ABORTED; // prevent re-entry

    s_isRunning      = true;
    s_abortRequested = false;
    s_lastResult.cycleStartMs = millis();

    CycleResult* r = &s_lastResult;
    r->chronoSampleCount    = 0;
    r->nipChronoSampleCount = 0;
    r->transmittedViaBLE    = false;

    // -----------------------------------------------------------------------
    // Stage 1: Skin contact check
    // -----------------------------------------------------------------------
    if (!sensors_isSkinContact()) {
#if CORTIPOD_DEBUG
        Serial.println("[CYCLE] No skin contact — aborting cycle");
#endif
        r->status = CycleStatus::NO_SKIN_CONTACT;
        goto cycle_done;
    }
    if (s_abortRequested) { r->status = CycleStatus::ABORTED; goto cycle_done; }

    // -----------------------------------------------------------------------
    // Stage 2: Read environmental sensors
    // -----------------------------------------------------------------------
    if (!sensors_readAll(&r->sensorData)) {
#if CORTIPOD_DEBUG
        Serial.println("[CYCLE] Sensor read failed");
#endif
        r->status = CycleStatus::SENSOR_ERROR;
        goto cycle_done;
    }
    if (s_abortRequested) { r->status = CycleStatus::ABORTED; goto cycle_done; }

    // -----------------------------------------------------------------------
    // Stage 3: Chronoamperometry — MIP electrode (WE1) then NIP electrode (WE2)
    // -----------------------------------------------------------------------
    {
        ChronoParams params = {
            .baselinePotential_mV = 0,
            .stepPotential_mV     = CHRONO_STEP_VOLTAGE_MV,
            .preconditionMs       = CHRONO_PRECONDITION_MS,
            .durationS            = CHRONO_DURATION_S,
            .sampleRateHz         = CHRONO_SAMPLE_RATE_HZ,
        };

        // --- MIP measurement (WE1, electrode index 0) ---
        potentiostat_wakeup();
        potentiostat_selectElectrode(0); // WE1 = MIP
        potentiostat_sleep();            // runChrono will wake again internally

        ChronoResult mipResult = {
            .currentNanoAmps = r->chronoSamples,
            .sampleCount     = 0,
            .success         = false,
            .timestampMs     = 0,
        };

        if (!potentiostat_runChrono(&params, &mipResult)) {
#if CORTIPOD_DEBUG
            Serial.println("[CYCLE] MIP potentiostat measurement failed");
#endif
            r->status = CycleStatus::POTENTIOSTAT_ERROR;
            goto cycle_done;
        }

        r->chronoSampleCount = mipResult.sampleCount;
        r->chronoTimestampMs = mipResult.timestampMs;

        if (s_abortRequested) { r->status = CycleStatus::ABORTED; goto cycle_done; }

        // --- NIP measurement (WE2, electrode index 1) ---
        potentiostat_wakeup();
        potentiostat_selectElectrode(1); // WE2 = NIP
        potentiostat_sleep();            // runChrono will wake again internally

        ChronoResult nipResult = {
            .currentNanoAmps = r->nipChronoSamples,
            .sampleCount     = 0,
            .success         = false,
            .timestampMs     = 0,
        };

        if (!potentiostat_runChrono(&params, &nipResult)) {
#if CORTIPOD_DEBUG
            Serial.println("[CYCLE] NIP potentiostat measurement failed");
#endif
            r->status = CycleStatus::POTENTIOSTAT_ERROR;
            goto cycle_done;
        }

        r->nipChronoSampleCount = nipResult.sampleCount;
        r->nipChronoTimestampMs = nipResult.timestampMs;
    }
    if (s_abortRequested) { r->status = CycleStatus::ABORTED; goto cycle_done; }

    // -----------------------------------------------------------------------
    // Stage 4: Transmit or buffer
    // -----------------------------------------------------------------------
    {
        // Build status flags
        uint8_t flags = STATUS_FLAG_MEASURING; // we are still technically in a cycle
        if (bleService_isConnected())  flags |= STATUS_FLAG_BLE_CONNECTED;
        if (r->sensorData.skinContact) flags |= STATUS_FLAG_SKIN_CONTACT;
        if (powerMgmt_isLowBattery())  flags |= STATUS_FLAG_LOW_BATTERY;

        if (bleService_isConnected()) {
            // Send sensor scalars
            bleService_notifyTemperature(r->sensorData.temperatureTMP117_C);
            bleService_notifyHumidity(r->sensorData.humidityPct);
            bleService_notifyGSR(r->sensorData.gsrResistance_ohms);
            bleService_notifyStatus(flags);

            // Send MIP chrono data in chunks
            const uint8_t SAMPLES_PER_PACKET = 4;
            ChronoPacket pkt;
            for (uint16_t i = 0; i < r->chronoSampleCount; i += SAMPLES_PER_PACKET) {
                pkt.sequenceIndex = i;
                pkt.sampleCount   = min((uint16_t)SAMPLES_PER_PACKET,
                                        (uint16_t)(r->chronoSampleCount - i));
                for (uint16_t j = 0; j < pkt.sampleCount; j++) {
                    pkt.currentNanoAmps[j] = r->chronoSamples[i + j];
                }
                bleService_notifyChrono(&pkt);
                // TODO: add small delay or flow-control check between packets
            }

            // Send NIP chrono data in chunks (differential reference electrode)
            for (uint16_t i = 0; i < r->nipChronoSampleCount; i += SAMPLES_PER_PACKET) {
                pkt.sequenceIndex = i;
                pkt.sampleCount   = min((uint16_t)SAMPLES_PER_PACKET,
                                        (uint16_t)(r->nipChronoSampleCount - i));
                for (uint16_t j = 0; j < pkt.sampleCount; j++) {
                    pkt.currentNanoAmps[j] = r->nipChronoSamples[i + j];
                }
                bleService_notifyNipChrono(&pkt);
                // TODO: add small delay or flow-control check between packets
            }

            r->transmittedViaBLE = true;
        } else {
            // Store a summary in the offline ring buffer for later upload
            bufferRecord(r);
#if CORTIPOD_DEBUG
            Serial.printf("[CYCLE] BLE not connected — buffered offline (%u/%u)\n",
                          s_offlineCount, OFFLINE_BUFFER_SIZE);
#endif
        }
    }

    r->status = CycleStatus::SUCCESS;

cycle_done:
    r->cycleDurationMs = millis() - r->cycleStartMs;
    s_hasResult = true;
    s_isRunning = false;

#if CORTIPOD_DEBUG
    Serial.printf("[CYCLE] Done in %lu ms, status=%u\n",
                  (unsigned long)r->cycleDurationMs, (uint8_t)r->status);
#endif

    return r->status;
}

bool measurementCycle_isRunning(void) {
    return s_isRunning;
}

void measurementCycle_abort(void) {
    if (s_isRunning) {
        s_abortRequested = true;
        potentiostat_abort();
    }
}

const CycleResult* measurementCycle_getLastResult(void) {
    return s_hasResult ? &s_lastResult : nullptr;
}

uint8_t measurementCycle_flushOfflineBuffer(void) {
    if (s_offlineCount == 0) return 0;
    if (!bleService_isConnected()) return 0;

    uint8_t sent = 0;
    // Note: chrono waveform data is NOT available in offline records;
    // only scalar summaries are transmitted.
    for (uint8_t i = 0; i < s_offlineCount; i++) {
        uint8_t idx = (s_offlineHead - s_offlineCount + i + OFFLINE_BUFFER_SIZE)
                      % OFFLINE_BUFFER_SIZE;
        OfflineRecord* rec = &s_offlineBuffer[idx];
        bleService_notifyTemperature(rec->temperatureTMP117_C);
        bleService_notifyHumidity(rec->humidityPct);
        bleService_notifyGSR(rec->gsrResistance_ohms);
        sent++;
    }
    s_offlineCount = 0;
    s_offlineHead  = 0;

    return sent;
}

uint8_t measurementCycle_offlineBufferCount(void) {
    return s_offlineCount;
}
