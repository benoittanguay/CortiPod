#pragma once

// =============================================================================
// potentiostat.h  —  AD5941 SPI driver + electrochemical measurement sequences
//
// The AD5941 is a complete electrochemical front-end from Analog Devices.
// It is controlled over SPI and can autonomously run measurement sequences
// (chronoamperometry, EIS, etc.) while the nRF52832 is in a low-power state.
//
// Public API:
//   potentiostat_init()          — SPI + chip init
//   potentiostat_selfTest()      — verify SPI comms and internal registers
//   potentiostat_runChrono()     — run a full chronoamperometry measurement
//   potentiostat_abort()         — stop any in-progress measurement
//   potentiostat_sleep()         — put AD5941 into hibernate mode
//   potentiostat_wakeup()        — restore AD5941 from hibernate
// =============================================================================

#include <Arduino.h>
#include <SPI.h>
#include "config.h"

// ---------------------------------------------------------------------------
// Data structures
// ---------------------------------------------------------------------------

/**
 * @brief Parameters for a chronoamperometry (CA) measurement.
 *
 * The AD5941 will:
 *   1. Apply baselinePotential_mV for preconditionMs milliseconds.
 *   2. Step to stepPotential_mV.
 *   3. Sample current at sampleRateHz for durationS seconds.
 */
struct ChronoParams {
    int16_t  baselinePotential_mV; ///< Equilibration/baseline potential (mV)
    int16_t  stepPotential_mV;     ///< Step potential after step edge (mV)
    uint16_t preconditionMs;       ///< Duration of baseline phase (ms)
    uint16_t durationS;            ///< Measurement window after step (seconds)
    uint8_t  sampleRateHz;         ///< Samples per second (max 200 Hz for AD5941)
};

/**
 * @brief Result of a completed chronoamperometry measurement.
 *
 * currentNanoAmps is a dynamically-sized array allocated in measurementCycle;
 * the caller must provide the buffer and its length.
 */
struct ChronoResult {
    int32_t* currentNanoAmps; ///< Pointer to caller-supplied sample buffer
    uint16_t sampleCount;     ///< Number of valid samples written
    bool     success;         ///< false if measurement was aborted or errored
    uint32_t timestampMs;     ///< millis() at the moment the step was applied
};

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

/**
 * @brief Initialise the SPI bus and the AD5941.
 *
 * Resets the chip, verifies the ADIID register (0x4144), loads the default
 * sequencer configuration, and leaves the chip in standby mode.
 *
 * @return true on success, false if the chip cannot be reached or ID mismatch.
 */
bool potentiostat_init(void);

/**
 * @brief Run a quick self-test to confirm SPI communication is healthy.
 *
 * Reads the AD5941 ADIID register and compares to the expected value.
 *
 * @return true if the register read matches, false otherwise.
 */
bool potentiostat_selfTest(void);

/**
 * @brief Execute a full chronoamperometry sequence.
 *
 * Blocks until the measurement is complete (or until durationS elapses).
 * Progress can be monitored via the INT pin (data-ready interrupt).
 *
 * @param params   Measurement parameters.
 * @param result   Output struct; currentNanoAmps must point to a buffer of at
 *                 least (params.durationS * params.sampleRateHz) int32_t values.
 * @return true if all samples were collected successfully.
 */
bool potentiostat_runChrono(const ChronoParams* params, ChronoResult* result);

/**
 * @brief Abort any in-progress measurement immediately.
 *
 * Safe to call even if no measurement is running.
 */
void potentiostat_abort(void);

/**
 * @brief Put the AD5941 into hibernate (lowest-power) mode.
 *
 * The SPI bus remains powered but the AD5941 internal clocks and DACs are off.
 * Typical current: ~200 nA.
 */
void potentiostat_sleep(void);

/**
 * @brief Wake the AD5941 from hibernate mode.
 *
 * Issues the WAKEUP command and waits for the chip to be ready (~1 ms).
 */
void potentiostat_wakeup(void);

/**
 * @brief Configure the AD5941 switch matrix to route the selected working
 *        electrode to the TIA (transimpedance amplifier) input.
 *
 * Must be called before potentiostat_runChrono() when changing electrodes.
 * The chip must be awake (potentiostat_wakeup() called) before invoking this.
 *
 * @param index  0 = WE1 / MIP (cortisol-detecting electrode)
 *               1 = WE2 / NIP (control/reference electrode)
 */
void potentiostat_selectElectrode(uint8_t index);

// ---------------------------------------------------------------------------
// Low-level register access (for testing / calibration — not for normal use)
// ---------------------------------------------------------------------------

/**
 * @brief Write a 32-bit value to an AD5941 register.
 * @param regAddr  Register address (16-bit).
 * @param value    32-bit value to write.
 */
void potentiostat_writeReg(uint16_t regAddr, uint32_t value);

/**
 * @brief Read a 32-bit value from an AD5941 register.
 * @param regAddr  Register address (16-bit).
 * @return 32-bit register value, or 0xFFFFFFFF on SPI error.
 */
uint32_t potentiostat_readReg(uint16_t regAddr);
