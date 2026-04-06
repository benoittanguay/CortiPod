// =============================================================================
// main.cpp  —  CortiPod firmware entry point
//
// Architecture overview:
//
//   setup()  — one-time hardware init; runs on power-on and after each
//              System-OFF wakeup (which is a full reset on nRF52832).
//
//   loop()   — cooperative scheduler:
//               1. Check if BLE is connected; if so, flush offline buffer.
//               2. If the measurement interval has elapsed, run a cycle.
//               3. Sleep (WFI) until the next event.
//
// There is no RTOS.  The firmware is single-threaded; all blocking operations
// (potentiostat measurement) happen synchronously in measurementCycle_run().
// BLE events are handled by the SoftDevice interrupt in the background.
//
// Power budget (rough estimate at 3.7 V):
//   Idle + BLE advertising : ~3–5 µA average
//   Measurement cycle      : ~8 mA for ~65 s → ~145 µAh per cycle
//   15-minute interval     : ~97 µA average continuous equivalent
// =============================================================================

#include <Arduino.h>
#include "config.h"
#include "ble_service.h"
#include "potentiostat.h"
#include "sensors.h"
#include "measurement_cycle.h"
#include "power_mgmt.h"

// ---------------------------------------------------------------------------
// Module-private state
// ---------------------------------------------------------------------------

static uint32_t s_lastMeasurementMs = 0;
static bool     s_forceMeasurement  = false; // set by BLE command callback

// ---------------------------------------------------------------------------
// BLE command handler (called from BLE ISR context)
// ---------------------------------------------------------------------------

static void onBleCommand(uint8_t cmd) {
    switch (cmd) {
        case CMD_TRIGGER_MEASUREMENT:
            // Set a flag; actual measurement happens in loop() (not ISR-safe here)
            s_forceMeasurement = true;
#if CORTIPOD_DEBUG
            Serial.println("[MAIN] BLE command: force measurement");
#endif
            break;

        case CMD_RESET_DEVICE:
#if CORTIPOD_DEBUG
            Serial.println("[MAIN] BLE command: device reset");
            Serial.flush();
#endif
            // TODO: Graceful BLE disconnect before reset
            NVIC_SystemReset();
            break;

        case CMD_ENTER_SLEEP:
#if CORTIPOD_DEBUG
            Serial.println("[MAIN] BLE command: enter sleep");
#endif
            powerMgmt_scheduleWakeup(MEASUREMENT_INTERVAL_MS);
            powerMgmt_enterDeepSleep();
            break;

        default:
#if CORTIPOD_DEBUG
            Serial.printf("[MAIN] Unknown BLE command: 0x%02X\n", cmd);
#endif
            break;
    }
}

// ---------------------------------------------------------------------------
// setup()
// ---------------------------------------------------------------------------

void setup(void) {
#if CORTIPOD_DEBUG
    Serial.begin(115200);
    // Give the host a moment to open a serial monitor before first output
    delay(500);
    Serial.println("=== CortiPod Firmware v"
                   STRINGIFY(FIRMWARE_VERSION_MAJOR) "."
                   STRINGIFY(FIRMWARE_VERSION_MINOR) "."
                   STRINGIFY(FIRMWARE_VERSION_PATCH) " ===");
#endif

    // --- Power management (first: configures RTC and ADC references) ---
    powerMgmt_init();

    // --- Status LED ---
    pinMode(LED_STATUS_PIN, OUTPUT);
    digitalWrite(LED_STATUS_PIN, HIGH); // on during init
    delay(100);
    digitalWrite(LED_STATUS_PIN, LOW);

    // --- SPI + AD5941 potentiostat ---
    if (!potentiostat_init()) {
#if CORTIPOD_DEBUG
        Serial.println("[MAIN] FATAL: Potentiostat init failed");
#endif
        // Signal error: fast blink and halt
        while (true) {
            digitalWrite(LED_STATUS_PIN, !digitalRead(LED_STATUS_PIN));
            delay(100);
        }
    }

    // --- I2C + environmental sensors ---
    if (!sensors_init()) {
#if CORTIPOD_DEBUG
        Serial.println("[MAIN] WARNING: One or more sensors not detected");
#endif
        // Non-fatal: continue without all sensors
    }

    // --- Measurement cycle module ---
    measurementCycle_init();

    // --- BLE service ---
    bleService_setCommandCb(onBleCommand);
    if (!bleService_init()) {
#if CORTIPOD_DEBUG
        Serial.println("[MAIN] FATAL: BLE init failed");
#endif
        while (true) {
            digitalWrite(LED_STATUS_PIN, !digitalRead(LED_STATUS_PIN));
            delay(250);
        }
    }
    bleService_startAdv();

    s_lastMeasurementMs = millis();

#if CORTIPOD_DEBUG
    Serial.println("[MAIN] Setup complete — entering main loop");
#endif
}

// ---------------------------------------------------------------------------
// loop()
// ---------------------------------------------------------------------------

void loop(void) {
    uint32_t now = millis();

    // --- Flush any offline-buffered readings if BLE just connected ---
    if (bleService_isConnected() && measurementCycle_offlineBufferCount() > 0) {
        uint8_t flushed = measurementCycle_flushOfflineBuffer();
#if CORTIPOD_DEBUG
        Serial.printf("[MAIN] Flushed %u offline records over BLE\n", flushed);
#endif
        (void)flushed;
    }

    // --- Determine whether it's time for a measurement ---
    bool intervalElapsed = (now - s_lastMeasurementMs) >= MEASUREMENT_INTERVAL_MS;
    bool shouldMeasure   = intervalElapsed || s_forceMeasurement;

    if (shouldMeasure && !measurementCycle_isRunning()) {
        s_forceMeasurement  = false;
        s_lastMeasurementMs = now;

        // Pulse LED to indicate measurement start
        digitalWrite(LED_STATUS_PIN, HIGH);

        CycleStatus result = measurementCycle_run();

        digitalWrite(LED_STATUS_PIN, LOW);

#if CORTIPOD_DEBUG
        switch (result) {
            case CycleStatus::SUCCESS:
                Serial.println("[MAIN] Cycle complete: SUCCESS");
                break;
            case CycleStatus::NO_SKIN_CONTACT:
                Serial.println("[MAIN] Cycle skipped: no skin contact");
                break;
            case CycleStatus::SENSOR_ERROR:
                Serial.println("[MAIN] Cycle failed: sensor error");
                break;
            case CycleStatus::POTENTIOSTAT_ERROR:
                Serial.println("[MAIN] Cycle failed: potentiostat error");
                break;
            case CycleStatus::TRANSMIT_ERROR:
                Serial.println("[MAIN] Cycle complete: transmit error (buffered)");
                break;
            case CycleStatus::ABORTED:
                Serial.println("[MAIN] Cycle aborted");
                break;
        }
#else
        (void)result;
#endif

        // Update BLE status flags
        uint8_t flags = 0;
        if (bleService_isConnected()) flags |= STATUS_FLAG_BLE_CONNECTED;
        if (sensors_isSkinContact())  flags |= STATUS_FLAG_SKIN_CONTACT;
        if (powerMgmt_isLowBattery()) flags |= STATUS_FLAG_LOW_BATTERY;
        bleService_notifyStatus(flags);
    }

    // --- Sleep until the next interrupt (BLE event, RTC tick, etc.) ---
    powerMgmt_enterLightSleep();
}

// ---------------------------------------------------------------------------
// Preprocessor helper (avoids depending on an external stringify macro)
// ---------------------------------------------------------------------------
#ifndef STRINGIFY
    #define STRINGIFY_INNER(x) #x
    #define STRINGIFY(x) STRINGIFY_INNER(x)
#endif
