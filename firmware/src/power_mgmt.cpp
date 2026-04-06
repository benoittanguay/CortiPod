// =============================================================================
// power_mgmt.cpp  —  Sleep modes and wake scheduling for nRF52832
//
// The nRF52832 has two relevant sleep states:
//
//   System-ON (WFI):   CPU halted, all peripherals + SoftDevice running.
//                      Typical current with BLE advertising: ~3–5 µA average.
//
//   System-OFF:        Everything off except RTC and GPIO sense.
//                      Wakes via RTC compare event or GPIO edge.
//                      Typical current: ~0.4 µA.
//                      Reset-like wake — firmware re-executes from reset vector.
//
// For the nRF52832 + Arduino framework the low-level sleep calls are:
//   sd_power_system_off()  — SoftDevice API to enter System-OFF
//   __WFE() / __WFI()     — ARM Cortex-M4 intrinsics for WFI
// =============================================================================

#include "power_mgmt.h"
#include "config.h"

// ---------------------------------------------------------------------------
// Module-private state
// ---------------------------------------------------------------------------

static uint32_t s_wakeupDelayMs = 0;

// ---------------------------------------------------------------------------
// Public API
// ---------------------------------------------------------------------------

void powerMgmt_init(void) {
    // Configure VBAT ADC channel
    analogReference(AR_INTERNAL_3_0);
    analogReadResolution(ADC_RESOLUTION_BITS);

    // Configure nRF52832 RTC1 as the low-power wake timer.
    // Enable LFCLK if not already running.
    if (!(NRF_CLOCK->LFCLKSTAT & CLOCK_LFCLKSTAT_STATE_Msk)) {
        NRF_CLOCK->TASKS_LFCLKSTART = 1;
        while (!(NRF_CLOCK->LFCLKSTAT & CLOCK_LFCLKSTAT_STATE_Msk)) {}
    }

    // Stop RTC1, clear counter, set prescaler to 0 (32768 Hz tick rate), then start.
    NRF_RTC1->TASKS_STOP  = 1;
    NRF_RTC1->TASKS_CLEAR = 1;
    NRF_RTC1->PRESCALER   = 0; // tick = 1/32768 s (~30.5 µs)
    NRF_RTC1->TASKS_START = 1;

    // Ensure LED is configured
    pinMode(LED_STATUS_PIN, OUTPUT);
    digitalWrite(LED_STATUS_PIN, LOW);

#if CORTIPOD_DEBUG
    Serial.println("[PWR] Power management initialised");
#endif
}

void powerMgmt_scheduleWakeup(uint32_t delayMs) {
    s_wakeupDelayMs = delayMs;

    // Program nRF52832 RTC1 COMPARE[0] register.
    // With prescaler = 0, the tick rate is 32768 Hz.
    uint32_t ticks = (uint32_t)((uint64_t)delayMs * 32768UL / 1000UL);
    NRF_RTC1->CC[0] = (NRF_RTC1->COUNTER + ticks) & 0xFFFFFFUL;
    NRF_RTC1->INTENSET = RTC_INTENSET_COMPARE0_Msk;
    NRF_RTC1->EVTENSET = RTC_EVTENSET_COMPARE0_Msk;
    NVIC_EnableIRQ(RTC1_IRQn);

#if CORTIPOD_DEBUG
    Serial.printf("[PWR] Wake-up scheduled in %lu ms\n", (unsigned long)delayMs);
#endif
}

void powerMgmt_enterDeepSleep(void) {
#if CORTIPOD_DEBUG
    // In debug builds, emulate deep sleep with a long light-sleep loop
    // so the USB serial connection is preserved.
    Serial.printf("[PWR] Deep sleep requested — using light sleep for %lu ms (DEBUG)\n",
                  (unsigned long)s_wakeupDelayMs);
    Serial.flush();

    uint32_t wakeAt = millis() + s_wakeupDelayMs;
    while (millis() < wakeAt) {
        powerMgmt_enterLightSleep();
    }
#else
    // Production: enter System-OFF.
    // The RTC alarm (set by powerMgmt_scheduleWakeup) will reset the MCU.

#if defined(SOFTDEVICE_PRESENT)
    // With SoftDevice running, use the SD API to enter System-OFF safely.
    sd_power_system_off();
#else
    // No SoftDevice — use direct register write.
    NRF_POWER->SYSTEMOFF = 1;
    __DSB(); // ensure the write completes before the CPU halts
    while (1) { __WFE(); } // unreachable; silences compiler warning
#endif
#endif
}

void powerMgmt_enterLightSleep(void) {
    // ARM Cortex-M4 Wait-For-Interrupt — halts CPU until the next interrupt.
    // The SoftDevice (BLE stack) and all peripherals remain active.
    __WFI();
}

uint16_t powerMgmt_getBatteryMv(void) {
    // VBAT is divided by 2 on the Adafruit Feather nRF52832 board.
    uint16_t counts = (uint16_t)analogRead(VBAT_ADC_PIN);
    float vRaw_mV = (float)counts * ADC_REF_MV / ADC_MAX_COUNTS;
    return (uint16_t)(vRaw_mV * 2.0f); // compensate for 1/2 voltage divider
}

uint8_t powerMgmt_getBatteryPct(void) {
    uint16_t vMv = powerMgmt_getBatteryMv();
    if (vMv >= BATTERY_FULL_MV)             return 100;
    if (vMv <= LOW_BATTERY_THRESHOLD_MV)    return 0;

    uint32_t range = BATTERY_FULL_MV - LOW_BATTERY_THRESHOLD_MV;
    uint32_t above = vMv - LOW_BATTERY_THRESHOLD_MV;
    return (uint8_t)(above * 100UL / range);
}

bool powerMgmt_isLowBattery(void) {
    return (powerMgmt_getBatteryMv() < LOW_BATTERY_THRESHOLD_MV);
}
