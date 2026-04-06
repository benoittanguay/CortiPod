// =============================================================================
// potentiostat.cpp  —  AD5941 SPI driver + measurement sequences
//
// Reference: AD5941 Datasheet Rev. B (Analog Devices)
//            AD5941 Application Note AN-1468 (Chronoamperometry)
//
// SPI protocol summary:
//   - CPOL=0, CPHA=0 (SPI mode 0)
//   - MSB first
//   - 16-bit address, then 32-bit data (reads return 32 bits after addr write)
//   - CS active-low; must be de-asserted between address and data phases for
//     register reads (per AD5941 datasheet Section 9.2)
// =============================================================================

#include "potentiostat.h"
#include "config.h"
#include "power_mgmt.h"

// ---------------------------------------------------------------------------
// AD5941 register addresses (partial — expand as needed)
// ---------------------------------------------------------------------------
#define AD5941_REG_ADIID        0x0400  // Chip identification register (expect 0x4144)
#define AD5941_REG_CHIPID       0x0404  // Die revision
#define AD5941_REG_SWRST        0x0408  // Software reset (write 0x52 then 0xAD)
#define AD5941_REG_PWRKEY       0x000C  // Power key register
#define AD5941_REG_PMBW         0x0010  // Power mode / bandwidth
#define AD5941_REG_SEQCNT       0x0034  // Sequencer control

// LPDAC registers (Low-Power DAC, used to set working electrode potential)
#define AD5941_REG_LPDACDAT0    0x0200  // LPDAC data register (12-bit DAC code)
#define AD5941_REG_LPDACSW0     0x0204  // LPDAC switch matrix control
#define AD5941_REG_LPDACCON0    0x0208  // LPDAC configuration / enable

// FIFO / data register for reading back ADC results
#define AD5941_REG_DFTREAL      0x0218  // DFT real result / FIFO data output

// High-Power Switch Matrix control register
// Used to select which working electrode (WE1/MIP or WE2/NIP) is routed to
// the LPTIA input.  Bits [3:2] control the WE mux (see datasheet Table 55).
#define AD5941_REG_SWCON        0x0238  // Switch matrix control

// SWCON bit masks for working electrode selection
#define SWCON_WE1_BITS          0x00000000UL  // WE1 selected (MIP, default)
#define SWCON_WE2_BITS          0x00000004UL  // WE2 selected (NIP); bit 2 = 1

// Mask covering the WE mux field so other switch bits are preserved
#define SWCON_WE_MASK           0x0000000CUL  // Bits [3:2]

// SPI command bytes
#define AD5941_SPI_WRITE        0x00  // OR with address MSB to indicate write
#define AD5941_SPI_READ         0x80  // OR with address MSB to indicate read

// Expected ADIID value
#define AD5941_ADIID_EXPECTED   0x4144UL

// Power-mode register values
// Hibernate: power down internal clocks and DAC; chip idles at ~200 nA
#define PWRMODE_HIBERNATE       0x00000000UL
// Active (low-bandwidth): 16 MHz internal RC, low-power AFE blocks enabled
#define PWRMODE_ACTIVE_LP       0x00000001UL

// Sequencer command: abort any running sequence
#define SEQCMD_ABORT            0x00000000UL

// LPDAC reference / full-scale: AD5941 LPDAC is 12-bit, 0–2.4 V (Vref 2.4 V)
// Vdac (V) = code * 2.4 / 4095
// Working electrode potential (mV vs. virtual ground at Vref/2 = 1200 mV):
//   code = (potential_mV + 1200) * 4095 / 2400   — clamp to [0, 4095]
#define LPDAC_VREF_MV           2400
#define LPDAC_VBIAS_MV          1200   // virtual ground midpoint
#define LPDAC_MAX_CODE          4095

// LPDAC switch matrix: connect DAC output to CE0 (counter electrode) and
// bias the working electrode via VZERO0 (see datasheet Table 43).
#define LPDAC_SW_CE_AMP         0x00000007UL   // CE0 connected, VZERO0 to WE

// LPDAC configuration: enable DAC, select 6-bit channel for VBIAS output
#define LPDACCON_ENABLE         0x00000001UL
#define LPDACCON_DISABLE        0x00000000UL

// ---------------------------------------------------------------------------
// Module-private state
// ---------------------------------------------------------------------------
static SPISettings s_spiSettings(AD5941_SPI_FREQ_HZ, MSBFIRST, SPI_MODE0);
static volatile bool s_measuring = false;

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------

static inline void csAssert(void)   { digitalWrite(AD5941_CS_PIN, LOW); }
static inline void csDeassert(void) { digitalWrite(AD5941_CS_PIN, HIGH); }

/**
 * @brief Convert a millivolt potential to a 12-bit LPDAC code.
 *
 * The LPDAC virtual ground sits at LPDAC_VBIAS_MV (1200 mV).  Positive
 * potential_mV values raise the working electrode above virtual ground;
 * negative values lower it.  The result is clamped to the DAC range.
 *
 * @param potential_mV  Electrode potential in mV relative to virtual ground.
 * @return 12-bit DAC code (0–4095).
 */
static uint16_t millivoltsToDacCode(int16_t potential_mV) {
    int32_t code = ((int32_t)potential_mV + LPDAC_VBIAS_MV) * LPDAC_MAX_CODE
                   / LPDAC_VREF_MV;
    if (code < 0)              code = 0;
    if (code > LPDAC_MAX_CODE) code = LPDAC_MAX_CODE;
    return (uint16_t)code;
}

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

bool potentiostat_init(void) {
    // Configure CS, INT, and optional RESET pins
    pinMode(AD5941_CS_PIN,    OUTPUT);
    pinMode(AD5941_INT_PIN,   INPUT_PULLUP);
    digitalWrite(AD5941_CS_PIN, HIGH); // de-assert

#ifdef AD5941_RESET_PIN
    pinMode(AD5941_RESET_PIN, OUTPUT);
    // Toggle RESET low for at least 100 µs, then release (active-low reset)
    digitalWrite(AD5941_RESET_PIN, LOW);
    delay(1);   // 1 ms >> 100 µs minimum hold time
    digitalWrite(AD5941_RESET_PIN, HIGH);
    delay(5);   // allow internal power-on sequence to complete (~1 ms typical)
#endif

    // Initialise the SPI bus
    SPI.begin();

    // Issue software reset sequence: write 0x52 then 0xAD to SWRST register.
    // The AD5941 interprets this two-write sequence as a full soft reset.
    potentiostat_writeReg(AD5941_REG_SWRST, 0x52UL);
    potentiostat_writeReg(AD5941_REG_SWRST, 0xADUL);
    delay(2);   // wait for reset to propagate (~1 ms per datasheet)

    // Verify chip identity — abort early if SPI is not working
    if (!potentiostat_selfTest()) {
#if CORTIPOD_DEBUG
        Serial.println("[PSTAT] ERROR: AD5941 not found or ID mismatch");
#endif
        return false;
    }

    // TODO: Configure clocks — enable internal 16 MHz oscillator via OSCCON
    // TODO: Configure AFE (analog front-end): TIA gain, LPTIA bandwidth, etc.
    // TODO: Load default sequencer configuration for chronoamperometry
    // Leave chip in standby / low-power mode until a measurement is requested
    potentiostat_sleep();

#if CORTIPOD_DEBUG
    Serial.println("[PSTAT] AD5941 initialised");
#endif
    return true;
}

bool potentiostat_selfTest(void) {
    uint32_t id = potentiostat_readReg(AD5941_REG_ADIID);
#if CORTIPOD_DEBUG
    Serial.printf("[PSTAT] ADIID = 0x%04lX (expected 0x%04lX)\n",
                  (unsigned long)id, (unsigned long)AD5941_ADIID_EXPECTED);
#endif
    return (id == AD5941_ADIID_EXPECTED);
}

bool potentiostat_runChrono(const ChronoParams* params, ChronoResult* result) {
    if (params == nullptr || result == nullptr) return false;
    if (result->currentNanoAmps == nullptr)    return false;

    s_measuring = true;
    result->success    = false;
    result->sampleCount = 0;
    result->timestampMs = millis();

    // Wake the AD5941 from standby / hibernate
    potentiostat_wakeup();

    // -------------------------------------------------------------------------
    // Pre-conditioning phase
    // Apply baselinePotential_mV for preconditionMs milliseconds.
    // Use millis() instead of delay() so the BLE stack continues to service
    // connection events during this phase.
    // -------------------------------------------------------------------------
    uint16_t baselineCode = millivoltsToDacCode(params->baselinePotential_mV);

    // Enable LPDAC and connect its output to the electrochemical cell
    potentiostat_writeReg(AD5941_REG_LPDACSW0,  LPDAC_SW_CE_AMP);
    potentiostat_writeReg(AD5941_REG_LPDACCON0, LPDACCON_ENABLE);
    potentiostat_writeReg(AD5941_REG_LPDACDAT0, (uint32_t)baselineCode);

#if CORTIPOD_DEBUG
    Serial.printf("[PSTAT] Preconditioning at %d mV (DAC code %u) for %u ms\n",
                  params->baselinePotential_mV, baselineCode, params->preconditionMs);
#endif

    uint32_t precondStart = millis();
    while ((millis() - precondStart) < params->preconditionMs) {
        // Yield to BLE stack / other interrupts without blocking hard
        powerMgmt_enterLightSleep();
    }

    // -------------------------------------------------------------------------
    // Step edge: switch to stepPotential_mV and record the timestamp
    // -------------------------------------------------------------------------
    uint16_t stepCode = millivoltsToDacCode(params->stepPotential_mV);
    potentiostat_writeReg(AD5941_REG_LPDACDAT0, (uint32_t)stepCode);
    result->timestampMs = millis(); // record step-edge time

#if CORTIPOD_DEBUG
    Serial.printf("[PSTAT] Step to %d mV (DAC code %u), collecting %u samples at %u Hz\n",
                  params->stepPotential_mV, stepCode,
                  (uint16_t)(params->durationS * params->sampleRateHz),
                  params->sampleRateHz);
#endif

    // -------------------------------------------------------------------------
    // Sample collection loop
    // Poll the INT pin (active-low, data-ready) and read one sample per pulse.
    // Each sample is read from the FIFO data register and stored in the
    // caller-supplied buffer.  A per-sample timeout prevents infinite blocking
    // if the AD5941 fails to assert INT.
    // -------------------------------------------------------------------------
    uint16_t expectedSamples = (uint16_t)(params->durationS) * params->sampleRateHz;

    while (result->sampleCount < expectedSamples && s_measuring) {
        // Wait for INT pin to go LOW (data ready), with timeout
        uint32_t sampleDeadline = millis() + AD5941_DRY_TIMEOUT_MS;
        bool timedOut = false;

        while (digitalRead(AD5941_INT_PIN) != LOW) {
            if (millis() >= sampleDeadline) {
                timedOut = true;
                break;
            }
            // Yield CPU until the next interrupt (keeps BLE alive, saves power)
            powerMgmt_enterLightSleep();
        }

        if (timedOut) {
#if CORTIPOD_DEBUG
            Serial.printf("[PSTAT] Timeout waiting for sample %u\n",
                          result->sampleCount);
#endif
            break;
        }

        // Read the raw 32-bit ADC result from the FIFO data register.
        // The AD5941 returns a signed 18-bit value zero-extended to 32 bits;
        // sign-extend and store directly as nanoAmps (calibration applied
        // upstream in measurementCycle).
        uint32_t raw = potentiostat_readReg(AD5941_REG_DFTREAL);

        // Sign-extend 18-bit value (bits 17:0) to int32_t
        int32_t sample = (int32_t)(raw & 0x0003FFFFUL);
        if (sample & 0x00020000UL) {         // bit 17 set → negative
            sample |= (int32_t)0xFFFC0000UL; // sign-extend
        }

        result->currentNanoAmps[result->sampleCount++] = sample;
    }

    // -------------------------------------------------------------------------
    // Wrap up
    // -------------------------------------------------------------------------
    // Disable LPDAC to disconnect the cell and stop sourcing current
    potentiostat_writeReg(AD5941_REG_LPDACCON0, LPDACCON_DISABLE);

    result->success = (result->sampleCount == expectedSamples);

    // Return AD5941 to hibernate to minimise current draw between measurements
    potentiostat_sleep();

    s_measuring = false;

#if CORTIPOD_DEBUG
    Serial.printf("[PSTAT] Chrono complete: %u/%u samples, success=%d\n",
                  result->sampleCount, expectedSamples, (int)result->success);
#endif
    return result->success;
}

void potentiostat_abort(void) {
    // Write the ABORT command to the AD5941 sequencer control register.
    // SEQCMD_ABORT (0x00000000) halts any running sequencer state machine.
    potentiostat_writeReg(AD5941_REG_SEQCNT, SEQCMD_ABORT);

    // Disable the LPDAC so no potential is applied to the cell
    potentiostat_writeReg(AD5941_REG_LPDACCON0, LPDACCON_DISABLE);

    s_measuring = false;
#if CORTIPOD_DEBUG
    Serial.println("[PSTAT] Measurement aborted");
#endif
}

void potentiostat_sleep(void) {
    // Write the hibernate power mode to the AD5941 power management register.
    // This powers down internal oscillators and the DAC, dropping chip current
    // to ~200 nA.  The SPI bus itself remains powered.
    potentiostat_writeReg(AD5941_REG_PMBW, PWRMODE_HIBERNATE);
#if CORTIPOD_DEBUG
    Serial.println("[PSTAT] AD5941 entering hibernate");
#endif
}

void potentiostat_wakeup(void) {
    // Send the wakeup key to the PWRKEY register.  Writing 0x00000001 instructs
    // the AD5941 power sequencer to bring up its internal clocks and AFE blocks.
    // Per the datasheet the chip requires ~500 µs for clocks to stabilise.
    potentiostat_writeReg(AD5941_REG_PWRKEY, 0x00000001UL);
    delayMicroseconds(500); // wait for internal clocks to stabilise
#if CORTIPOD_DEBUG
    Serial.println("[PSTAT] AD5941 wakeup");
#endif
}

void potentiostat_selectElectrode(uint8_t index) {
    // Read the current SWCON value so unrelated switch bits are preserved
    uint32_t swcon = potentiostat_readReg(AD5941_REG_SWCON);

    // Clear the WE mux field and apply the desired electrode selection
    swcon &= ~SWCON_WE_MASK;
    swcon |= (index == 0) ? SWCON_WE1_BITS : SWCON_WE2_BITS;

    potentiostat_writeReg(AD5941_REG_SWCON, swcon);

#if CORTIPOD_DEBUG
    Serial.printf("[PSTAT] Electrode selected: %s (WE%u), SWCON=0x%08lX\n",
                  (index == 0) ? "MIP" : "NIP",
                  (unsigned)(index + 1),
                  (unsigned long)swcon);
#endif
}

void potentiostat_writeReg(uint16_t regAddr, uint32_t value) {
    SPI.beginTransaction(s_spiSettings);
    csAssert();

    // AD5941 SPI write frame (6 bytes total):
    //   Byte 0: WRITE command (0x00) OR'd with address bits [15:8]
    //   Byte 1: address bits [7:0]
    //   Byte 2: data bits [31:24]  (MSB first)
    //   Byte 3: data bits [23:16]
    //   Byte 4: data bits [15:8]
    //   Byte 5: data bits [7:0]   (LSB last)
    SPI.transfer((uint8_t)(AD5941_SPI_WRITE | (regAddr >> 8)));
    SPI.transfer((uint8_t)(regAddr & 0xFF));
    SPI.transfer((uint8_t)((value >> 24) & 0xFF));
    SPI.transfer((uint8_t)((value >> 16) & 0xFF));
    SPI.transfer((uint8_t)((value >>  8) & 0xFF));
    SPI.transfer((uint8_t)( value        & 0xFF));

    csDeassert();
    SPI.endTransaction();
}

uint32_t potentiostat_readReg(uint16_t regAddr) {
    uint32_t result = 0;

    SPI.beginTransaction(s_spiSettings);

    // AD5941 SPI read is a two-phase transaction (datasheet Section 9.2).
    // CS must be de-asserted between the address phase and the data phase so
    // the AD5941 can latch the address and prepare the read data internally.

    // Phase 1: transmit address with READ bit set (2 bytes)
    csAssert();
    SPI.transfer((uint8_t)(AD5941_SPI_READ | (regAddr >> 8)));
    SPI.transfer((uint8_t)(regAddr & 0xFF));
    csDeassert();

    delayMicroseconds(1); // brief CS de-assertion gap required by AD5941

    // Phase 2: clock out 4 data bytes (send dummy 0x00 bytes to drive SCLK)
    csAssert();
    result  = (uint32_t)SPI.transfer(0x00) << 24;
    result |= (uint32_t)SPI.transfer(0x00) << 16;
    result |= (uint32_t)SPI.transfer(0x00) <<  8;
    result |= (uint32_t)SPI.transfer(0x00);
    csDeassert();

    SPI.endTransaction();
    return result;
}
