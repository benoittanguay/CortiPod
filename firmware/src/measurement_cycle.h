#pragma once

// =============================================================================
// measurement_cycle.h  —  Measurement cycle orchestrator
//
// Coordinates the full sensing pipeline for one cortisol measurement event:
//
//   1. Contact check  — verify device is worn before wasting power on a run
//   2. Sensor read    — TMP117 + SHT40 + GSR baseline
//   3. Potentiostat   — chronoamperometry via AD5941
//   4. Transmit       — push data over BLE (or buffer offline if disconnected)
//
// The cycle can be triggered two ways:
//   - Automatically by the scheduler in main.cpp (every MEASUREMENT_INTERVAL_MS)
//   - On demand via a BLE CMD_TRIGGER_MEASUREMENT command
//
// Public API:
//   measurementCycle_init()     — one-time setup (called from setup())
//   measurementCycle_run()      — execute a full measurement cycle (blocking)
//   measurementCycle_isRunning()— true while a cycle is in progress
//   measurementCycle_getLastResult() — access the most recent results
// =============================================================================

#include <Arduino.h>
#include "sensors.h"
#include "potentiostat.h"
#include "config.h"

// ---------------------------------------------------------------------------
// Data structures
// ---------------------------------------------------------------------------

/**
 * @brief Outcome codes for a completed measurement cycle.
 */
enum class CycleStatus : uint8_t {
    SUCCESS         = 0,  ///< All stages completed normally
    NO_SKIN_CONTACT = 1,  ///< Aborted at contact check stage
    SENSOR_ERROR    = 2,  ///< Environmental sensor read failed
    POTENTIOSTAT_ERROR = 3, ///< AD5941 measurement failed
    TRANSMIT_ERROR  = 4,  ///< BLE notification failed (data was buffered)
    ABORTED         = 5,  ///< Externally aborted mid-cycle
};

/**
 * @brief Full result bundle from one measurement cycle.
 *
 * Produced by measurementCycle_run() and accessible via
 * measurementCycle_getLastResult().
 */
struct CycleResult {
    CycleStatus  status;           ///< Outcome of the cycle

    SensorReading sensorData;      ///< Environmental + GSR readings

    // Chronoamperometry data — MIP electrode (WE1, cortisol-selective)
    int32_t      chronoSamples[CHRONO_TOTAL_SAMPLES]; ///< MIP current samples (nA)
    uint16_t     chronoSampleCount;                   ///< Actual MIP samples collected
    uint32_t     chronoTimestampMs; ///< millis() at the MIP CA step edge

    // Chronoamperometry data — NIP electrode (WE2, control/reference)
    int32_t      nipChronoSamples[CHRONO_TOTAL_SAMPLES]; ///< NIP current samples (nA)
    uint16_t     nipChronoSampleCount;                   ///< Actual NIP samples collected
    uint32_t     nipChronoTimestampMs; ///< millis() at the NIP CA step edge

    // Timing
    uint32_t     cycleStartMs;     ///< millis() when the cycle began
    uint32_t     cycleDurationMs;  ///< Total wall-clock time for the cycle

    bool         transmittedViaBLE; ///< true = BLE, false = buffered offline
};

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

/**
 * @brief One-time initialisation for the measurement cycle module.
 *
 * Initialises the internal offline buffer and clears the last result.
 * Must be called once in setup(), after sensors_init() and potentiostat_init().
 */
void measurementCycle_init(void);

/**
 * @brief Execute a complete measurement cycle (blocking).
 *
 * Runs through all pipeline stages in order.  On completion (or error),
 * the result is stored internally and accessible via
 * measurementCycle_getLastResult().
 *
 * Typical duration: ~65–75 seconds (dominated by CHRONO_DURATION_S).
 *
 * @return The status code indicating how the cycle concluded.
 */
CycleStatus measurementCycle_run(void);

/**
 * @brief Returns true if a measurement cycle is currently in progress.
 *
 * Useful for the BLE command handler to reject duplicate trigger commands.
 */
bool measurementCycle_isRunning(void);

/**
 * @brief Abort an in-progress cycle as soon as the current stage completes.
 *
 * The next call to measurementCycle_isRunning() will eventually return false.
 */
void measurementCycle_abort(void);

/**
 * @brief Return a pointer to the most recent CycleResult.
 *
 * The pointer is valid until the next call to measurementCycle_run().
 * Returns nullptr if no cycle has been run yet.
 */
const CycleResult* measurementCycle_getLastResult(void);

/**
 * @brief Flush any buffered offline readings over BLE.
 *
 * Call this after a BLE connection is established to send readings that
 * were captured while the device was disconnected.
 *
 * @return Number of readings successfully transmitted.
 */
uint8_t measurementCycle_flushOfflineBuffer(void);

/**
 * @brief Return the number of readings currently in the offline buffer.
 */
uint8_t measurementCycle_offlineBufferCount(void);
