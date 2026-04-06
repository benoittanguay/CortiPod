#pragma once

// =============================================================================
// power_mgmt.h  —  Sleep modes and wake scheduling for nRF52832
//
// CortiPod is battery-powered.  Outside of measurement cycles the MCU should
// spend as much time as possible in a low-power state.
//
// Sleep strategy:
//   - Between measurements: nRF52832 System-OFF (lowest power, ~0.4 µA)
//     with an RTC-based wake-up after MEASUREMENT_INTERVAL_MS.
//   - While waiting for AD5941 data-ready: WFI (wait-for-interrupt) — the
//     CPU halts but the BLE stack and SysTick stay alive.
//   - BLE advertising / connected: normal run mode; BLE stack manages radio
//     duty-cycling automatically.
//
// Public API:
//   powerMgmt_init()            — configure RTC and wake sources
//   powerMgmt_scheduleWakeup()  — arm the RTC alarm
//   powerMgmt_enterDeepSleep()  — drop to System-OFF (non-returning on HW)
//   powerMgmt_enterLightSleep() — WFI until the next interrupt
//   powerMgmt_getBatteryMv()    — read VBAT via ADC
//   powerMgmt_isLowBattery()    — true if VBAT < LOW_BATTERY_THRESHOLD_MV
// =============================================================================

#include <Arduino.h>
#include "config.h"

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

/// Battery voltage below which the LOW_BATTERY status flag is set (mV).
#define LOW_BATTERY_THRESHOLD_MV    3400

/// Fully charged LiPo voltage (mV) — used for battery percentage estimate.
#define BATTERY_FULL_MV             4200

/// nRF52832 SAADC pin used to measure the VBAT divider.
/// Adafruit Feather nRF52832 routes VBAT through a 1/2 divider to A7 (pin 31).
#define VBAT_ADC_PIN                A7

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

/**
 * @brief Initialise the power management module.
 *
 * Configures the nRF52832 RTC1 peripheral as the low-power wake timer and
 * sets up the VBAT ADC channel.  Must be called once in setup().
 */
void powerMgmt_init(void);

/**
 * @brief Arm the RTC alarm to fire after the specified delay.
 *
 * After calling powerMgmt_enterDeepSleep(), the device will automatically
 * wake and resume execution (from reset vector) after this delay.
 *
 * @param delayMs  Wake-up delay in milliseconds.
 */
void powerMgmt_scheduleWakeup(uint32_t delayMs);

/**
 * @brief Enter System-OFF mode (deepest nRF52832 sleep state).
 *
 * CAUTION: On real hardware this is non-returning — the MCU wakes via a
 * full reset.  In practice the firmware re-runs setup() on wake.
 *
 * In simulation / dev builds (CORTIPOD_DEBUG=1) this function instead calls
 * powerMgmt_enterLightSleep() so the host serial connection is not lost.
 *
 * Preconditions:
 *   - BLE connection should be cleanly disconnected first.
 *   - potentiostat_sleep() should be called first.
 *   - powerMgmt_scheduleWakeup() must have been called to set the RTC alarm.
 */
void powerMgmt_enterDeepSleep(void);

/**
 * @brief Halt the CPU with WFI until the next interrupt fires.
 *
 * The BLE SoftDevice and all peripherals remain active.  This is the idle
 * state used while waiting for the AD5941 data-ready interrupt during a
 * measurement.
 */
void powerMgmt_enterLightSleep(void);

/**
 * @brief Read the battery voltage via the VBAT ADC divider.
 *
 * Applies the 2× divider compensation to return the true pack voltage.
 *
 * @return Battery voltage in millivolts, or 0 on ADC error.
 */
uint16_t powerMgmt_getBatteryMv(void);

/**
 * @brief Estimate battery state-of-charge as a percentage.
 *
 * Uses a simple linear approximation between LOW_BATTERY_THRESHOLD_MV and
 * BATTERY_FULL_MV.  Not compensated for temperature or discharge rate.
 *
 * @return Estimated SOC in percent (0–100).
 */
uint8_t powerMgmt_getBatteryPct(void);

/**
 * @brief Returns true if the battery voltage is below the low-battery threshold.
 */
bool powerMgmt_isLowBattery(void);
