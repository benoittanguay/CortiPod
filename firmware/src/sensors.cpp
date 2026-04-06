// =============================================================================
// sensors.cpp  —  TMP117, SHT40, and GSR sensor drivers
//
// References:
//   TMP117  : Texas Instruments SBOS685 datasheet
//   SHT40   : Sensirion Datasheet SHT4x Version 2 (April 2021)
//   nRF52832: SAADC peripheral (nRF52832 Product Specification v1.4, Ch. 37)
// =============================================================================

#include "sensors.h"
#include "config.h"

// ---------------------------------------------------------------------------
// TMP117 register map (relevant subset)
// ---------------------------------------------------------------------------
#define TMP117_REG_TEMP_RESULT  0x00  // Temperature result (16-bit, 2's complement)
#define TMP117_REG_CONFIG       0x01  // Configuration
#define TMP117_REG_DEVICE_ID    0x0F  // Device ID (expect 0x0117)
#define TMP117_DEVICE_ID_EXPECTED 0x0117

// TMP117 temperature LSB = 7.8125 m°C
#define TMP117_RESOLUTION_DEGC  0.0078125f

// ---------------------------------------------------------------------------
// SHT40 command bytes
// ---------------------------------------------------------------------------
#define SHT40_CMD_MEASURE_HIGH_REP  0xFD  // High repeatability measurement
#define SHT40_MEASUREMENT_DELAY_MS  10    // Datasheet: ≤8.2 ms; use 10 ms

// SHT40 raw-to-physical conversion constants (from Sensirion datasheet)
// T(°C) = -45 + 175 * (raw_T / 65535)
// RH(%) =  -6 + 125 * (raw_RH / 65535)
#define SHT40_TEMP_OFFSET   (-45.0f)
#define SHT40_TEMP_SCALE    (175.0f / 65535.0f)
#define SHT40_RH_OFFSET     (-6.0f)
#define SHT40_RH_SCALE      (125.0f / 65535.0f)

// ---------------------------------------------------------------------------
// CRC helper (Sensirion CRC-8, poly 0x31, init 0xFF)
// ---------------------------------------------------------------------------
static uint8_t sht40_crc8(const uint8_t* data, size_t len) {
    uint8_t crc = 0xFF;
    for (size_t i = 0; i < len; i++) {
        crc ^= data[i];
        for (uint8_t bit = 0; bit < 8; bit++) {
            crc = (crc & 0x80) ? (uint8_t)((crc << 1) ^ 0x31) : (uint8_t)(crc << 1);
        }
    }
    return crc;
}

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

bool sensors_init(void) {
    // Initialise I2C bus at the configured speed
    Wire.begin();
    Wire.setClock(I2C_FREQ_HZ);

    bool allOk = true;

    // --- TMP117 presence check ---
    // Read TMP117 device ID register and verify
    Wire.beginTransmission(TMP117_I2C_ADDR);
    Wire.write(TMP117_REG_DEVICE_ID);
    if (Wire.endTransmission(false) != 0) { allOk = false; }
    Wire.requestFrom(TMP117_I2C_ADDR, 2);
    uint16_t id = ((uint16_t)Wire.read() << 8) | Wire.read();
    if (id != TMP117_DEVICE_ID_EXPECTED) { allOk = false; }

    // --- SHT40 presence check ---
    // A write-only ping: send a soft-reset command (0x94) and expect ACK
    Wire.beginTransmission(SHT40_I2C_ADDR);
    Wire.write(0x94); // soft reset
    if (Wire.endTransmission() != 0) { allOk = false; }
    delay(2); // SHT40 reset time

    // --- GSR ADC channel ---
    // Configure nRF52832 SAADC channel for GSR_ADC_PIN
    analogReference(AR_INTERNAL_3_0); // or AR_VDD4 depending on supply
    analogReadResolution(ADC_RESOLUTION_BITS);

    if (!allOk) {
#if CORTIPOD_DEBUG
        Serial.println("[SENS] WARNING: One or more sensors not detected");
#endif
    } else {
#if CORTIPOD_DEBUG
        Serial.println("[SENS] All sensors initialised");
#endif
    }

    return allOk;
}

bool sensors_readAll(SensorReading* out) {
    if (out == nullptr) return false;

    out->timestampMs = millis();
    bool allOk = true;

    // --- TMP117 ---
    out->tmp117Valid = sensors_readTMP117(&out->temperatureTMP117_C);
    if (!out->tmp117Valid) allOk = false;

    // --- SHT40 ---
    out->sht40Valid = sensors_readSHT40(&out->temperatureSHT40_C, &out->humidityPct);
    if (!out->sht40Valid) allOk = false;

    // --- GSR ---
    out->gsrValid = sensors_readGSR(&out->gsrResistance_ohms, &out->gsrRawADC);
    if (!out->gsrValid) allOk = false;
    out->skinContact = out->gsrValid &&
                       (out->gsrResistance_ohms < GSR_CONTACT_THRESHOLD_OHMS);

    return allOk;
}

bool sensors_readTMP117(float* tempC) {
    if (tempC == nullptr) return false;

    // Trigger a one-shot conversion and read the result register
    Wire.beginTransmission(TMP117_I2C_ADDR);
    Wire.write(TMP117_REG_TEMP_RESULT);
    if (Wire.endTransmission(false) != 0) return false;
    Wire.requestFrom(TMP117_I2C_ADDR, 2);
    int16_t raw = ((int16_t)Wire.read() << 8) | Wire.read();
    *tempC = (float)raw * TMP117_RESOLUTION_DEGC;

    return true;
}

bool sensors_readSHT40(float* tempC, float* humidityPct) {
    if (tempC == nullptr || humidityPct == nullptr) return false;

    // Send measurement command
    Wire.beginTransmission(SHT40_I2C_ADDR);
    Wire.write(SHT40_CMD_MEASURE_HIGH_REP);
    if (Wire.endTransmission() != 0) return false;
    delay(SHT40_MEASUREMENT_DELAY_MS);

    // Read 6 bytes: [T_MSB][T_LSB][T_CRC][RH_MSB][RH_LSB][RH_CRC]
    Wire.requestFrom(SHT40_I2C_ADDR, 6);
    uint8_t buf[6];
    for (int i = 0; i < 6; i++) buf[i] = Wire.read();

    // Validate CRC for temperature and humidity words
    if (sht40_crc8(buf, 2) != buf[2]) return false;
    if (sht40_crc8(buf + 3, 2) != buf[5]) return false;

    // Convert raw values
    uint16_t rawT  = ((uint16_t)buf[0] << 8) | buf[1];
    uint16_t rawRH = ((uint16_t)buf[3] << 8) | buf[4];
    *tempC       = SHT40_TEMP_OFFSET + SHT40_TEMP_SCALE * rawT;
    *humidityPct = SHT40_RH_OFFSET  + SHT40_RH_SCALE  * rawRH;

    return true;
}

bool sensors_readGSR(uint32_t* resistanceOhms, uint16_t* rawADC) {
    if (resistanceOhms == nullptr) return false;

    // Take an ADC reading from GSR_ADC_PIN
    uint16_t counts = (uint16_t)analogRead(GSR_ADC_PIN);

    if (rawADC != nullptr) {
        *rawADC = counts;
    }

    if (counts == 0) {
        // Avoid division by zero — V_adc == 0 means infinite resistance
        *resistanceOhms = UINT32_MAX;
        return true;
    }

    // Voltage divider: V_adc = V_ref * counts / ADC_MAX_COUNTS
    // R_skin = R_pullup * (V_ref / V_adc - 1)
    //        = R_pullup * (ADC_MAX_COUNTS / counts - 1)
    uint32_t maxCounts = (uint32_t)ADC_MAX_COUNTS;
    if (counts >= maxCounts) {
        *resistanceOhms = 0;
    } else {
        // Use 64-bit arithmetic to avoid overflow
        *resistanceOhms = (uint32_t)(
            (uint64_t)GSR_PULLUP_OHMS * (maxCounts - counts) / counts
        );
    }

    return true;
}

bool sensors_isSkinContact(void) {
    uint32_t resistance = 0;
    if (!sensors_readGSR(&resistance, nullptr)) return false;
    return (resistance < GSR_CONTACT_THRESHOLD_OHMS);
}
