// =============================================================================
// ble_service.cpp  —  BLE GATT service implementation
//
// Registers the CortiPod Measurement Service on the nRF52832 SoftDevice using
// the Adafruit Bluefruit nRF52 library (BLEService / BLECharacteristic).
// =============================================================================

#include "ble_service.h"
#include "config.h"

// ---------------------------------------------------------------------------
// Module-private state
// ---------------------------------------------------------------------------

// GATT service object
static BLEService        s_service(BLE_CORTIPOD_SERVICE_UUID);

// Characteristics
static BLECharacteristic s_charChrono(BLE_CHAR_CHRONO_DATA_UUID,
                                       BLERead | BLENotify,
                                       sizeof(ChronoPacket));

// NIP (control/reference electrode) chronoamperometry characteristic
static BLECharacteristic s_charNipChrono(BLE_CHAR_NIP_CHRONO_DATA_UUID,
                                          BLERead | BLENotify,
                                          sizeof(ChronoPacket));

static BLECharacteristic s_charTemperature(BLE_CHAR_TEMPERATURE_UUID,
                                            BLERead | BLENotify,
                                            sizeof(int16_t));

static BLECharacteristic s_charHumidity(BLE_CHAR_HUMIDITY_UUID,
                                         BLERead | BLENotify,
                                         sizeof(uint16_t));

static BLECharacteristic s_charGSR(BLE_CHAR_GSR_UUID,
                                    BLERead | BLENotify,
                                    sizeof(uint32_t));

static BLECharacteristic s_charStatus(BLE_CHAR_STATUS_UUID,
                                       BLERead | BLENotify,
                                       sizeof(uint8_t));

static BLECharacteristic s_charCommand(BLE_CHAR_COMMAND_UUID,
                                        BLEWrite,
                                        sizeof(uint8_t));

// User-registered command callback
static CommandCallback s_commandCb = nullptr;

// Connection flag (updated via BLE event callbacks)
static volatile bool s_connected = false;

// ---------------------------------------------------------------------------
// BLE event callbacks (private)
// ---------------------------------------------------------------------------

static void onConnect(uint16_t connHandle) {
    (void)connHandle;
    s_connected = true;
#if CORTIPOD_DEBUG
    Serial.println("[BLE] Central connected");
#endif
}

static void onDisconnect(uint16_t connHandle, uint8_t reason) {
    (void)connHandle;
    (void)reason;
    s_connected = false;
#if CORTIPOD_DEBUG
    Serial.printf("[BLE] Disconnected (reason 0x%02X). Restarting advertising.\n", reason);
#endif
    // Restart advertising so the iPhone can reconnect
    Bluefruit.Advertising.start(0);
}

static void onCommandWrite(uint16_t connHandle,
                           BLECharacteristic* chr,
                           uint8_t* data,
                           uint16_t len) {
    (void)connHandle;
    (void)chr;
    if (len < 1) return;
    if (s_commandCb != nullptr) {
        s_commandCb(data[0]);
    }
}

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

bool bleService_init(void) {
    // Configure Bluefruit with device name and TX power
    if (!Bluefruit.begin()) {
        return false;
    }
    Bluefruit.setName(BLE_DEVICE_NAME);
    Bluefruit.setTxPower(BLE_TX_POWER_DBM);
    Bluefruit.Periph.setConnectCallback(onConnect);
    Bluefruit.Periph.setDisconnectCallback(onDisconnect);

    // Add the GATT service and characteristics to the BLE stack
    s_service.begin();
    s_charChrono.begin();
    s_charNipChrono.begin();
    s_charTemperature.begin();
    s_charHumidity.begin();
    s_charGSR.begin();
    s_charStatus.begin();
    s_charCommand.setWriteCallback(onCommandWrite);
    s_charCommand.begin();

    // Set connection interval preferences
    Bluefruit.Periph.setConnInterval(BLE_CONN_INTERVAL_MIN, BLE_CONN_INTERVAL_MAX);

#if CORTIPOD_DEBUG
    Serial.println("[BLE] Service initialised");
#endif

    return true;
}

void bleService_startAdv(void) {
    // Configure advertising payload and start
    Bluefruit.Advertising.addFlags(BLE_GAP_ADV_FLAGS_LE_ONLY_GENERAL_DISC_MODE);
    Bluefruit.Advertising.addTxPower();
    Bluefruit.Advertising.addService(s_service);
    Bluefruit.ScanResponse.addName();
    Bluefruit.Advertising.restartOnDisconnect(true);
    Bluefruit.Advertising.setIntervalMS(20, 152);   // fast 20 ms, then 152 ms
    Bluefruit.Advertising.start(0);                 // 0 = advertise indefinitely

#if CORTIPOD_DEBUG
    Serial.println("[BLE] Advertising started");
#endif
}

bool bleService_isConnected(void) {
    return s_connected;
}

void bleService_setCommandCb(CommandCallback cb) {
    s_commandCb = cb;
}

bool bleService_notifyChrono(const ChronoPacket* packet) {
    if (!s_connected || packet == nullptr) return false;
    return s_charChrono.notify((uint8_t*)packet, sizeof(ChronoPacket));
}

bool bleService_notifyNipChrono(const ChronoPacket* packet) {
    if (!s_connected || packet == nullptr) return false;
    return s_charNipChrono.notify((uint8_t*)packet, sizeof(ChronoPacket));
}

bool bleService_notifyTemperature(float tempCelsius) {
    if (!s_connected) return false;
    // Encode as int16: degrees * 100 to retain 2 decimal places
    int16_t encoded = (int16_t)(tempCelsius * 100.0f);
    return s_charTemperature.notify16(encoded);
}

bool bleService_notifyHumidity(float humidityPct) {
    if (!s_connected) return false;
    uint16_t encoded = (uint16_t)(humidityPct * 100.0f);
    return s_charHumidity.notify16(encoded);
}

bool bleService_notifyGSR(uint32_t resistanceOhms) {
    if (!s_connected) return false;
    return s_charGSR.notify32(resistanceOhms);
}

bool bleService_notifyStatus(uint8_t statusFlags) {
    if (!s_connected) return false;
    return s_charStatus.notify8(statusFlags);
}
