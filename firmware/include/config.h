#pragma once

// =============================================================================
// config.h  —  CortiPod firmware-wide constants
//
// All hardware pin numbers, timing parameters, BLE UUIDs, and protocol
// constants live here.  Source files include only what they need from this
// header — never hard-code magic numbers elsewhere.
// =============================================================================

// ---------------------------------------------------------------------------
// Electrode configuration
// ---------------------------------------------------------------------------
// Each electrode is contacted by a ring of pogo pins; two electrodes are
// present in the assembly: MIP (cortisol-selective) and NIP (control/reference).
#define POGO_COUNT_PER_ELECTRODE    4
#define ELECTRODE_COUNT             2
#define POGO_TOTAL                  (POGO_COUNT_PER_ELECTRODE * ELECTRODE_COUNT)  // 8

// ---------------------------------------------------------------------------
// AD5941 switch matrix — working electrode selection
// ---------------------------------------------------------------------------
// The AD5941 SWCON register routes WE1 or WE2 to the TIA input.
// WE1 = MIP (cortisol-detecting electrode), index 0
// WE2 = NIP (control/reference electrode), index 1
//
// Register SWCON (0x0238, High-Power Switch Matrix Control):
//   Bits [3:2] select the working electrode fed into the LPTIA:
//     00 = WE1 (default, maps to MIP)
//     01 = WE2 (maps to NIP)
#define AD5941_REG_SWCON            0x0238   // Switch matrix control register
#define AD5941_SWCON_WE1_MASK       0x00000000UL  // Select WE1 (MIP)
#define AD5941_SWCON_WE2_MASK       0x00000004UL  // Select WE2 (NIP); bit 2 set

// ---------------------------------------------------------------------------
// SPI — AD5941 Potentiostat
// ---------------------------------------------------------------------------
// Adafruit Feather nRF52832 Arduino pin numbers (SPI0 peripheral).
// Adjust for Raytac MDBT42Q via #ifdef ENV_PROD if the PCB routing differs.
#define AD5941_MOSI_PIN     24   // SPI MOSI
#define AD5941_MISO_PIN     23   // SPI MISO
#define AD5941_SCK_PIN      25   // SPI clock
#define AD5941_CS_PIN        7   // Chip-select (active-low)
#define AD5941_INT_PIN      11   // Data-ready interrupt (active-low)
#define AD5941_RESET_PIN    12   // Hardware reset (active-low, optional)

// SPI bus speed for AD5941 (max 16 MHz per datasheet; use conservative value)
#define AD5941_SPI_FREQ_HZ  8000000UL

// ---------------------------------------------------------------------------
// I2C — Environmental sensors (TMP117, SHT40)
// ---------------------------------------------------------------------------
#define I2C_SDA_PIN         25   // nRF52832 TWI SDA
#define I2C_SCL_PIN         26   // nRF52832 TWI SCL
#define I2C_FREQ_HZ         400000UL   // 400 kHz fast-mode

#define TMP117_I2C_ADDR     0x48  // ADD0 pin = GND
#define SHT40_I2C_ADDR      0x44  // Default Sensirion SHT40 address

// ---------------------------------------------------------------------------
// ADC — Galvanic Skin Response (GSR)
// ---------------------------------------------------------------------------
// nRF52832 SAADC input pin (Arduino analog pin numbering)
#define GSR_ADC_PIN         A0

// Pull-up resistor value in the GSR voltage divider (ohms)
#define GSR_PULLUP_OHMS     100000UL   // 100 kΩ

// Skin contact detection: resistance above this threshold = no contact (ohms)
// At 3.3 V supply: V_adc < ~0.3 V means R_skin > ~1 MΩ (no contact)
#define GSR_CONTACT_THRESHOLD_OHMS  500000UL

// ADC reference voltage (mV) — nRF52832 internal 3.6 V reference
#define ADC_REF_MV          3600
#define ADC_RESOLUTION_BITS 12
#define ADC_MAX_COUNTS      ((1 << ADC_RESOLUTION_BITS) - 1)   // 4095

// ---------------------------------------------------------------------------
// Status LED
// ---------------------------------------------------------------------------
#define LED_STATUS_PIN      LED_BUILTIN   // Adafruit Feather built-in red LED

// ---------------------------------------------------------------------------
// Measurement timing
// ---------------------------------------------------------------------------
// How often the device wakes and runs a full measurement cycle
#define MEASUREMENT_INTERVAL_MS     900000UL   // 15 minutes

// Chronoamperometry waveform parameters
#define CHRONO_STEP_VOLTAGE_MV      150        // Step potential (mV vs. Ag/AgCl)
#define CHRONO_DURATION_S           60         // Total measurement window (seconds)
#define CHRONO_SAMPLE_RATE_HZ       10         // Samples per second during measurement
#define CHRONO_TOTAL_SAMPLES        (CHRONO_DURATION_S * CHRONO_SAMPLE_RATE_HZ)  // 600

// Duration of the pre-conditioning phase before the chrono step (ms)
#define CHRONO_PRECONDITION_MS      5000

// Timeout waiting for AD5941 data-ready interrupt (ms)
#define AD5941_DRY_TIMEOUT_MS       2000

// ---------------------------------------------------------------------------
// Offline data buffer
// ---------------------------------------------------------------------------
// Maximum number of SensorReading records stored in SRAM when BLE is not
// connected.  Each reading is ~32 bytes → 50 readings ≈ 1.6 kB.
#define OFFLINE_BUFFER_SIZE         50

// ---------------------------------------------------------------------------
// BLE service & characteristic UUIDs
// ---------------------------------------------------------------------------
// Base UUID: use a randomly generated 128-bit base.
// Short 16-bit UUIDs are listed for clarity; the stack expands them.
//
// Service:   CortiPod Measurement Service
#define BLE_CORTIPOD_SERVICE_UUID           "12340001-0000-1000-8000-00805F9B34FB"

// Characteristic: Raw chronoamperometry current array (NOTIFY)
#define BLE_CHAR_CHRONO_DATA_UUID           "12340002-0000-1000-8000-00805F9B34FB"

// Characteristic: Temperature (NOTIFY, degrees C * 100, int16)
#define BLE_CHAR_TEMPERATURE_UUID           "12340003-0000-1000-8000-00805F9B34FB"

// Characteristic: Relative humidity (NOTIFY, % * 100, uint16)
#define BLE_CHAR_HUMIDITY_UUID              "12340004-0000-1000-8000-00805F9B34FB"

// Characteristic: GSR resistance (NOTIFY, ohms, uint32)
#define BLE_CHAR_GSR_UUID                   "12340005-0000-1000-8000-00805F9B34FB"

// Characteristic: Device status flags (NOTIFY, uint8 bitmask)
#define BLE_CHAR_STATUS_UUID                "12340006-0000-1000-8000-00805F9B34FB"

// Characteristic: Command / control (WRITE, uint8)
#define BLE_CHAR_COMMAND_UUID               "12340007-0000-1000-8000-00805F9B34FB"

// Characteristic: NIP (control electrode) raw chronoamperometry array (NOTIFY)
#define BLE_CHAR_NIP_CHRONO_DATA_UUID       "12340008-0000-1000-8000-00805F9B34FB"

// BLE advertising device name (max 20 chars for AD payload)
#define BLE_DEVICE_NAME                     "CortiPod"

// BLE TX power (dBm).  Valid values: -40, -20, -16, -12, -8, -4, 0, +4
#define BLE_TX_POWER_DBM                    0

// Connection interval targets (units: 1.25 ms)
#define BLE_CONN_INTERVAL_MIN               8    // 10 ms
#define BLE_CONN_INTERVAL_MAX               16   // 20 ms

// ---------------------------------------------------------------------------
// Status flag bitmask (BLE_CHAR_STATUS_UUID payload)
// ---------------------------------------------------------------------------
#define STATUS_FLAG_BLE_CONNECTED           (1 << 0)
#define STATUS_FLAG_SKIN_CONTACT            (1 << 1)
#define STATUS_FLAG_MEASURING               (1 << 2)
#define STATUS_FLAG_LOW_BATTERY             (1 << 3)
#define STATUS_FLAG_SENSOR_ERROR            (1 << 4)

// ---------------------------------------------------------------------------
// Command codes (BLE_CHAR_COMMAND_UUID payload)
// ---------------------------------------------------------------------------
#define CMD_TRIGGER_MEASUREMENT             0x01
#define CMD_RESET_DEVICE                    0x02
#define CMD_ENTER_SLEEP                     0x03

// ---------------------------------------------------------------------------
// Misc
// ---------------------------------------------------------------------------
#define FIRMWARE_VERSION_MAJOR  0
#define FIRMWARE_VERSION_MINOR  1
#define FIRMWARE_VERSION_PATCH  0
