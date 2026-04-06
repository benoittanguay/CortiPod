#pragma once

// =============================================================================
// sensors.h  —  Environmental & physiological sensor drivers
//
// Wraps:
//   - TMP117  : high-accuracy I2C temperature sensor (±0.1 °C)
//   - SHT40   : I2C temperature + relative humidity sensor (Sensirion)
//   - GSR ADC : galvanic skin response via nRF52832 SAADC
//
// Public API:
//   sensors_init()          — configure I2C bus + ADC, verify sensor presence
//   sensors_readAll()       — populate a SensorReading struct with fresh data
//   sensors_readTMP117()    — read temperature only (TMP117)
//   sensors_readSHT40()     — read temp + humidity (SHT40)
//   sensors_readGSR()       — read skin resistance (ADC)
//   sensors_isSkinContact() — quick contact check, no full ADC read
// =============================================================================

#include <Arduino.h>
#include <Wire.h>
#include "config.h"

// ---------------------------------------------------------------------------
// Data structures
// ---------------------------------------------------------------------------

/**
 * @brief A complete snapshot of all sensor readings for one measurement cycle.
 *
 * Timestamps use millis() so they are relative to power-on, not wall-clock.
 */
struct SensorReading {
    // TMP117
    float    temperatureTMP117_C;    ///< Temperature from TMP117 (°C)
    bool     tmp117Valid;            ///< false if read failed

    // SHT40
    float    temperatureSHT40_C;     ///< Temperature from SHT40 (°C)
    float    humidityPct;            ///< Relative humidity (%)
    bool     sht40Valid;             ///< false if read failed

    // GSR (derived)
    uint32_t gsrResistance_ohms;     ///< Computed skin resistance (Ω)
    uint16_t gsrRawADC;             ///< Raw 12-bit ADC count (for diagnostics)
    bool     gsrValid;               ///< false if ADC read failed
    bool     skinContact;            ///< true if resistance < GSR_CONTACT_THRESHOLD_OHMS

    // Metadata
    uint32_t timestampMs;            ///< millis() when sensors_readAll() was called
};

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

/**
 * @brief Initialise the I2C bus and ADC, then verify each sensor responds.
 *
 * Sends a WHO_AM_I / device-ID read to TMP117 and SHT40.  Configures the
 * nRF52832 SAADC channel connected to GSR_ADC_PIN.
 *
 * @return true if all three sensors were detected, false if any are missing.
 */
bool sensors_init(void);

/**
 * @brief Read all three sensor sources and populate a SensorReading struct.
 *
 * Individual validity flags (tmp117Valid, sht40Valid, gsrValid) indicate
 * which reads succeeded.  The function returns true only if all three pass.
 *
 * @param out  Pointer to a caller-supplied SensorReading to fill.
 * @return true if all sensors read successfully.
 */
bool sensors_readAll(SensorReading* out);

/**
 * @brief Read the TMP117 temperature register over I2C.
 *
 * @param tempC  Output: temperature in degrees Celsius.
 * @return true on success.
 */
bool sensors_readTMP117(float* tempC);

/**
 * @brief Read temperature and relative humidity from the SHT40 over I2C.
 *
 * Uses the "High Repeatability" measurement command (0xFD).
 * Includes a ~9 ms measurement delay as required by the datasheet.
 *
 * @param tempC      Output: temperature in degrees Celsius.
 * @param humidityPct Output: relative humidity in percent.
 * @return true on success (CRC check passes).
 */
bool sensors_readSHT40(float* tempC, float* humidityPct);

/**
 * @brief Take a single GSR ADC reading and compute skin resistance.
 *
 * Uses the voltage-divider equation:
 *   R_skin = GSR_PULLUP_OHMS * (ADC_REF_MV / V_adc - 1)
 *
 * @param resistanceOhms  Output: computed skin resistance in ohms.
 * @param rawADC          Output: raw 12-bit ADC count (may be NULL).
 * @return true if the ADC read completed without error.
 */
bool sensors_readGSR(uint32_t* resistanceOhms, uint16_t* rawADC);

/**
 * @brief Quick skin-contact check without a full SensorReading.
 *
 * Performs a single GSR ADC read and compares against the threshold.
 *
 * @return true if the device appears to be worn / skin contact detected.
 */
bool sensors_isSkinContact(void);
