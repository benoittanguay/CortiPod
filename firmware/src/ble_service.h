#pragma once

// =============================================================================
// ble_service.h  —  BLE GATT service for CortiPod
//
// Declares the CortiPod Measurement Service and all its characteristics.
// The service is built on top of the Adafruit Bluefruit nRF52 BLE stack
// (bluefruit.h / BLEService / BLECharacteristic).
//
// Public API:
//   bleService_init()          — call once in setup(); registers service + chars
//   bleService_startAdv()      — begin advertising
//   bleService_isConnected()   — returns true if a central is connected
//   bleService_notify*()       — push data to subscribed centrals
//   bleService_setCommandCb()  — register callback for incoming CMD writes
// =============================================================================

#include <Arduino.h>
#include <bluefruit.h>

// ---------------------------------------------------------------------------
// Data structures
// ---------------------------------------------------------------------------

/**
 * @brief Packed payload sent over BLE_CHAR_CHRONO_DATA_UUID.
 *
 * Because BLE ATT MTU is typically 20–244 bytes, large chrono arrays are
 * chunked by the caller into multiple notifications.
 */
struct ChronoPacket {
    uint16_t sequenceIndex;    ///< Index of the first sample in this packet
    uint16_t sampleCount;      ///< Number of samples in this packet
    int32_t  currentNanoAmps[4]; ///< Up to 4 samples (fits in 20-byte ATT MTU)
};

/**
 * @brief Callback type for BLE command writes from the central (iPhone app).
 * @param command  One of the CMD_* constants defined in config.h.
 */
typedef void (*CommandCallback)(uint8_t command);

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

/**
 * @brief Initialise the BLE stack, register the CortiPod GATT service, and
 *        configure all characteristics.
 *
 * Must be called once during setup(), before bleService_startAdv().
 *
 * @return true on success, false if the BLE stack failed to start.
 */
bool bleService_init(void);

/**
 * @brief Start BLE advertising so the iPhone app can discover the device.
 *
 * Call after bleService_init().  Advertising continues until a central
 * connects; it resumes automatically after disconnection.
 */
void bleService_startAdv(void);

/**
 * @brief Returns true if a BLE central is currently connected.
 */
bool bleService_isConnected(void);

/**
 * @brief Register a callback invoked when the central writes a command byte.
 * @param cb  Function pointer matching the CommandCallback signature.
 */
void bleService_setCommandCb(CommandCallback cb);

/**
 * @brief Notify the central with a chunk of MIP (WE1) chronoamperometry data.
 *
 * The caller is responsible for splitting large arrays into ChronoPacket
 * chunks and calling this function once per chunk.
 *
 * @param packet  Pointer to a populated ChronoPacket.
 * @return true if notification was sent successfully.
 */
bool bleService_notifyChrono(const ChronoPacket* packet);

/**
 * @brief Notify the central with a chunk of NIP (WE2) chronoamperometry data.
 *
 * The NIP (control/reference electrode) waveform is transmitted separately
 * so the iPhone app can compute the differential signal (MIP - NIP) to
 * isolate the true cortisol response.
 *
 * The caller is responsible for splitting large arrays into ChronoPacket
 * chunks and calling this function once per chunk.
 *
 * @param packet  Pointer to a populated ChronoPacket.
 * @return true if notification was sent successfully.
 */
bool bleService_notifyNipChrono(const ChronoPacket* packet);

/**
 * @brief Notify the central with the latest temperature reading.
 * @param tempCelsius  Temperature in degrees Celsius.
 * @return true if notification was sent successfully.
 */
bool bleService_notifyTemperature(float tempCelsius);

/**
 * @brief Notify the central with the latest relative humidity reading.
 * @param humidityPct  Relative humidity in percent (0–100).
 * @return true if notification was sent successfully.
 */
bool bleService_notifyHumidity(float humidityPct);

/**
 * @brief Notify the central with the latest GSR resistance reading.
 * @param resistanceOhms  Skin resistance in ohms.
 * @return true if notification was sent successfully.
 */
bool bleService_notifyGSR(uint32_t resistanceOhms);

/**
 * @brief Notify the central with the current device status flags.
 * @param statusFlags  Bitmask of STATUS_FLAG_* values defined in config.h.
 * @return true if notification was sent successfully.
 */
bool bleService_notifyStatus(uint8_t statusFlags);
