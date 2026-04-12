# CortiPod User Manual

> Wearable cortisol sensor — setup, daily use, cleaning, and maintenance.

---

## Table of Contents

1. [What's in the Kit](#whats-in-the-kit)
2. [Device Overview](#device-overview)
3. [First-Time Setup](#first-time-setup)
4. [Wearing the Device](#wearing-the-device)
5. [Connecting to the iPhone App](#connecting-to-the-app)
6. [Taking a Reading](#taking-a-reading)
7. [Understanding Your Readings](#understanding-your-readings)
8. [Calibration](#calibration)
9. [Sensor Strip Replacement](#sensor-strip-replacement)
10. [Cleaning & Maintenance](#cleaning-and-maintenance)
11. [Charging](#charging)
12. [Troubleshooting](#troubleshooting)
13. [Specifications](#specifications)

---

## What's in the Kit

| Item | Qty | Notes |
|------|:---:|-------|
| CortiPod sensor pod | 1 | Pre-assembled with PCB, battery, and pogo pins |
| 18 mm silicone strap | 1 | Quick-release, fits 140–195 mm wrist circumference |
| Magnetic charging cable | 1 | USB-A on one end, magnetic pogo pads on the other |
| MIP sensor strips (cortisol-selective) | 4+ | Consumable — each lasts approximately 15–20 use cycles |
| NIP sensor strips (reference control) | 4+ | Must always be installed alongside a MIP strip |
| Wash solution vial (ethanol:acetic acid 9:1) | 1 | For sensor regeneration between sessions |
| PBS rinse vial | 1 | For final rinse after washing |

---

## Device Overview

```
               TOP VIEW
        ┌─────────────────────┐
        │                     │
  strap ┤   ● LED    [mag]   ├ strap
   lug  │                     │  lug
        │     CortiPod        │
        │                     │
        └─────────────────────┘
              44 × 26 mm

             BOTTOM VIEW (skin side)
        ┌─────────────────────┐
        │  ┌───────────────┐  │
        │  │ MIP strip slot │←── electrode slides in from side
        │  └───────────────┘  │
        │  ┌───────────────┐  │
        │  │ NIP strip slot │  │
        │  └───────────────┘  │
        │   ◉ ◉  GSR pads    │←── must touch skin
        └─────────────────────┘
```

**Key components:**
- **LED** (top): Pulses during a measurement cycle.
- **Magnetic charging pads** (top edge): Snap onto charging cable magnetically.
- **Electrode slots** (bottom): Two channels hold the MIP and NIP sensor strips. Spring-loaded pogo pins inside make electrical contact automatically.
- **GSR pads** (bottom): Two small metal pads that must sit flush against your skin to detect sweat and confirm the device is being worn.

---

## First-Time Setup

### 1. Charge the device

Connect the magnetic charging cable to the pads on the top edge of the pod. The magnets self-align. Charge until the app shows 100% (approximately 1–2 hours from empty).

### 2. Install sensor strips

1. Hold the pod bottom-side up.
2. Slide a **MIP** strip into the MIP channel, sensing face down, until it stops.
3. Slide a **NIP** strip into the NIP channel the same way.
4. No tools or clips needed — the pogo pins engage automatically.

### 3. Install the app

Download **CortiPod** from the App Store. Open it and allow Bluetooth access when prompted.

### 4. Pair the device

1. Open the app → **Device** tab.
2. Tap **Scan**.
3. Select "CortiPod" from the list.
4. The status indicator turns green when connected.

### 5. Calibrate (before first use)

See [Calibration](#calibration) below. The device will take readings without calibration, but they won't be converted to ng/mL until you complete at least one calibration point.

---

## Wearing the Device

### Positioning

Wear the CortiPod on the **inside of your wrist** (same side as your pulse), about 2 cm above the wrist bone. The bottom of the pod (sensor strips and GSR pads) must sit directly against bare skin.

### Strap tightness

Snug but comfortable — similar to how you'd wear a fitness band during a workout. The GSR pads need consistent skin contact. If the strap is too loose, the device will report "No Contact" and skip measurements.

### Skin preparation

- **Shave or trim hair** at the sensor area if you have significant wrist hair. The GSR pads need direct skin contact.
- **Clean, dry skin** for initial placement. After 10–15 minutes, passive perspiration provides sufficient moisture for sensing.
- Avoid applying lotion or sunscreen to the sensor area before wearing.

### When to wear it

- The device measures automatically every **15 minutes** while worn.
- For meaningful cortisol patterns, wear it for at least 4–6 hours at a stretch.
- Best results come from full-day wear (wake to sleep) to capture the natural cortisol cycle: high in the morning, declining through the afternoon, lowest in the evening.

---

## Connecting to the App

The CortiPod communicates over **Bluetooth Low Energy (BLE)**. Keep your iPhone within ~10 metres of the device.

**Auto-reconnect:** If the connection drops (out of range, phone locked), the app will reconnect automatically when back in range. Readings taken while disconnected are stored on the device (up to 50 readings) and uploaded automatically when the connection resumes.

**Manual measurement:** Tap **Take Reading** on the Dashboard tab to trigger an immediate measurement instead of waiting for the next 15-minute interval.

---

## Taking a Reading

Readings happen automatically every 15 minutes. You can also trigger one manually from the app.

### What happens during a measurement

1. **Contact check** (~1 second) — the device checks that it's on your skin via GSR. If no skin contact is detected, the cycle is skipped.
2. **Environmental sensors** (~1 second) — reads temperature, humidity, and skin conductance.
3. **MIP electrode measurement** (~30 seconds) — a 5-second pre-conditioning phase, then a 60-second chronoamperometry measurement on the cortisol-selective electrode.
4. **NIP electrode measurement** (~30 seconds) — the same measurement on the reference electrode.
5. **Data transmission** — results are sent to the app over BLE (or buffered if disconnected).

**Total cycle time:** approximately 65 seconds. The LED pulses during this time.

### What you see in the app

After each reading, the **Dashboard** updates with:
- **Cortisol level** in ng/mL (colour-coded: blue = low, green = normal, orange = elevated, red = high)
- **Confidence score** (0–100%) — how reliable this particular reading is, based on contact quality, temperature range, and sweat detection
- **Trend chart** — your cortisol over the past 24 hours

---

## Understanding Your Readings

### Cortisol ranges

| Range | Typical ng/mL (sweat) | What it means |
|-------|:---:|---|
| Low | < 20 | Evening/night levels, or very relaxed state |
| Normal | 20–80 | Typical daytime range |
| Elevated | 80–140 | Morning peak, moderate stress, exercise |
| High | > 140 | Acute stress response, intense exercise |

### The diurnal pattern

Healthy cortisol follows a predictable daily curve:

```
Cortisol
(ng/mL)
  140 ┤  ●
      │  ● ●
  100 ┤      ●
      │        ●
   60 ┤          ●  ●
      │                ●  ●
   20 ┤                      ●  ●  ●
      └──────────────────────────────────
      6AM   9AM  12PM  3PM  6PM  9PM  12AM
```

**Morning peak:** Cortisol surges 30–60 minutes after waking (the cortisol awakening response). This should be your highest reading of the day.

**Gradual decline:** Levels drop through the afternoon.

**Evening low:** Lowest levels in the late evening. If your levels don't follow this pattern, it may indicate chronic stress, disrupted sleep, or a sensor issue.

### Confidence score

Each reading includes a confidence score that accounts for:

| Factor | Penalty |
|--------|---------|
| Poor skin contact (contact quality < 50%) | Reading discarded entirely |
| Temperature outside 20–37 °C | Confidence ×0.7 |
| Very low sweat (GSR < 0.5 µS) | Confidence ×0.5 |

Readings with confidence below 50% should be treated as unreliable. The app flags these visually.

---

## Calibration

Calibration translates the sensor's raw electrical signal into a cortisol concentration in ng/mL. There are two stages.

### Stage 1: Lab calibration

This is done during sensor fabrication using known cortisol concentrations. The calibration curve (slope, intercept, baseline) is entered into the app's calibration profile. If you fabricated the sensor yourself, see the [Calibration Guide](calibration-guide.md) for the full bench procedure.

### Stage 2: Personal calibration (on-body)

Your skin, sweat rate, and sweat-to-blood cortisol ratio are unique. Personal calibration adjusts for this using a commercial saliva cortisol test as the reference.

**What you need:** A home saliva cortisol test kit (e.g., Everlywell or ZRT Lab, ~$30–50 per kit).

**Procedure:**

1. **Morning calibration (high cortisol):**
   - Within 30 minutes of waking, put on the CortiPod and wait 10 minutes.
   - Tap **Take Reading** in the app.
   - Immediately take the saliva test per its kit instructions.
   - When the saliva result arrives, open the app → **Calibrate** tab → enter the saliva value in ng/dL → tap **Apply Calibration**.

2. **Afternoon calibration (medium cortisol):**
   - Repeat at 2–4 PM.

3. **Evening calibration (low cortisol):**
   - Repeat at 8–10 PM.

**How many points?**

| Points | Accuracy | Effort |
|:------:|----------|--------|
| 1 | Rough (~30–40% error) | Minimal |
| 3 | Good (~15–20% error) | One day of saliva tests |
| 5–7 | Best (~10–15% error) | 2–3 days of saliva tests |

3 points is the recommended minimum.

**Tips:**
- Do not eat, drink, or brush your teeth within 30 minutes before a saliva test.
- Try to capture different cortisol levels (morning high, midday medium, evening low) for the best calibration spread.

### When to recalibrate

| Trigger | Action |
|---------|--------|
| New sensor strip installed | 1–3 saliva points |
| Readings feel consistently off | Quick check: 1 saliva test. If off by >20%, do 3 points |
| Season change (summer ↔ winter) | 1–3 saliva points |
| Every 2–3 months | 1 saliva point as a spot-check |

---

## Sensor Strip Replacement

Each sensor strip lasts approximately **15–20 measurement-wash cycles** before signal degrades beyond usable levels. With daily washing and 15-minute measurement intervals, expect to replace strips every **3–7 days** depending on usage and overoxidation level used during fabrication.

### Signs that a strip needs replacing

- Baseline current has drifted more than 20% from the value at lab calibration.
- Readings are consistently flat (no variation across the day).
- The app's R² quality metric drops below 0.90.
- Confidence scores are consistently low even with good skin contact.

### Replacement procedure

1. Remove the pod from the strap (or just flip it over).
2. Slide the old MIP strip out from the side channel.
3. Slide the old NIP strip out from its channel.
4. Slide in a fresh MIP strip (sensing face down).
5. Slide in a fresh NIP strip.
6. **Recalibrate** — a new strip requires at least 1 personal calibration point (3 recommended).

Always replace MIP and NIP strips at the same time. They should have been fabricated as a matched pair (same polymerization and overoxidation parameters).

---

## Cleaning and Maintenance

### Daily sensor regeneration (required)

After each wearing session, clean the sensor strips to remove bound cortisol from the MIP cavities and restore them for the next session.

**What you need:**
- Wash solution: ethanol and acetic acid, 9:1 ratio (provided in kit, or mix your own — 9 mL ethanol + 1 mL glacial acetic acid)
- PBS rinse solution
- Distilled water
- A small clean container (glass vial or shallow dish)

**Procedure:**

```
Step 1: Remove the sensor strips from the pod.
        Slide each strip out gently from its channel.

Step 2: Immerse both strips (MIP and NIP) in the wash solution.
        Use enough liquid to fully cover the electrode surfaces.
        Duration: 10–15 minutes.
        Swirl gently every 3–5 minutes.

Step 3: Remove strips from wash solution.
        Rinse each strip with PBS solution (a gentle pour or 
        pipette stream across the electrode surface).

Step 4: Rinse with distilled water.
        A gentle pour across the surface — do not scrub.

Step 5: Air dry.
        Lay the strips on a clean paper towel, electrode face up.
        Allow 5–10 minutes to dry completely.
        Do not blow-dry or heat — air dry only.

Step 6: Re-insert the strips into the pod.
        Or store them dry in a sealed container until next use.
```

**Important:**
- Never touch the electrode surface (the dark-coated area) with your fingers. Handle strips by the edges or the connector tail.
- Never use soap, alcohol wipes, or household cleaners on the electrode surface.
- The wash solution can be reused 3–5 times before preparing a fresh batch. Discard if it becomes cloudy or discoloured.

### Weekly pod cleaning

The pod itself (the enclosure, GSR pads, and strap) should be cleaned weekly.

**Procedure:**

```
Step 1: Remove the sensor strips from the pod first.

Step 2: Wipe the pod exterior with a soft cloth lightly 
        dampened with water. 
        Do not submerge the pod.

Step 3: Clean the GSR pads (two metal circles on the bottom) 
        with a cotton swab dampened with isopropyl alcohol.
        These accumulate skin oils and salt from sweat.
        Let dry for 1 minute.

Step 4: Clean the pogo pins inside the electrode channels.
        Use a dry cotton swab to gently wipe the pin tips.
        If visibly corroded or discoloured, use a cotton swab 
        with isopropyl alcohol. Let dry for 2 minutes.

Step 5: Clean the magnetic charging pads (top edge) with a 
        dry cloth. Remove any debris that might prevent 
        the charging cable from making contact.

Step 6: Rinse the silicone strap under running water with 
        mild soap. Dry with a towel.

Step 7: Re-insert sensor strips and reattach the strap.
```

### Storage

- **Short-term (overnight to a few days):** Leave the sensor strips installed in the pod. Store in a cool, dry place.
- **Long-term (more than a week):** Remove the sensor strips and store them dry in a sealed container at room temperature. Charge the pod to ~50% before storing. Sensor strips stored dry last weeks to months.
- **Wash solution:** Cap tightly and store at room temperature. Shelf life: several months.
- **PBS:** Refrigerate after opening. Shelf life: 1–2 weeks at room temperature, months refrigerated.

---

## Charging

### How to charge

1. Bring the magnetic charging cable near the top edge of the pod.
2. The magnets will snap the cable into alignment automatically.
3. Plug the USB-A end into any USB power source (phone charger, laptop, power bank).
4. Charging time: approximately 1–2 hours from empty.

### Battery life

| Usage pattern | Estimated battery life |
|---------------|:---:|
| 15-min intervals, BLE connected | ~16–24 hours |
| 15-min intervals, BLE disconnected (buffering) | ~24–30 hours |
| Manual readings only (a few per day) | ~3–5 days |

**Low battery warning:** The app shows an orange/red battery indicator when below 20%. The device continues measuring until the battery is depleted — no data is lost (the last 50 readings are buffered in device memory and uploaded when next connected and charged).

### Charging tips

- Charge nightly, like a fitness band.
- The device can take readings while charging (useful for overnight monitoring on a nightstand).
- Do not leave the device discharged for extended periods — lithium batteries degrade when stored empty.

---

## Troubleshooting

### "No Contact" on every reading

- **Strap too loose.** Tighten so the pod sits flush against skin with no gaps.
- **Hair under the GSR pads.** Shave or trim the sensor area.
- **Dry skin.** Wait 10–15 minutes after putting the device on for passive sweating to begin. Try wearing during light activity (walking) for the first session.
- **Dirty GSR pads.** Clean with isopropyl alcohol (see [Weekly pod cleaning](#weekly-pod-cleaning)).

### Flat readings (no variation through the day)

- **Sensor strips exhausted.** If you've used them for 15+ wash cycles, replace with fresh strips.
- **Template removal was incomplete during fabrication.** The MIP cavities are still blocked. Re-wash the strips in ethanol:acetic acid for 30 minutes (longer than the standard 10–15 minutes).
- **Insufficient sweat.** If skin is very dry and GSR is near zero, the sensor doesn't have enough fluid to detect cortisol. Try wearing during light activity.

### Readings seem too high or too low

- **Recalibrate.** Take a saliva test alongside a CortiPod reading. If the CortiPod is off by more than 20%, enter 2–3 new calibration points.
- **Extreme temperature.** Very cold (<20 °C) or very hot (>37 °C) conditions shift the signal. The app compensates, but extreme conditions reduce confidence. Move to a moderate environment for important readings.
- **New strip without recalibration.** Every new sensor strip needs its own calibration point(s).

### App won't connect

- Verify Bluetooth is enabled on your iPhone (Settings → Bluetooth → On).
- Make sure the CortiPod is charged and powered on (press the pod gently — the LED should flash briefly).
- Kill and reopen the CortiPod app.
- If "CortiPod" doesn't appear in the scan list, try toggling Bluetooth off and on.
- Move closer to the device (within 3 metres for initial pairing).

### Random spikes in readings

- **Motion artifact.** If the pod shifted during measurement, the pogo pin contact fluctuated. Readings with low contact quality are flagged automatically. Tighten the strap.
- **Sweat burst.** A sudden onset of sweating (entering a warm room, start of exercise) can flush concentrated cortisol onto the sensor. This is real data, but may not reflect systemic cortisol. The app flags readings where GSR changed rapidly.

### LED blinks rapidly and device won't start

- **Potentiostat initialization failure.** The AD5941 chip isn't responding. Try a full power cycle: disconnect from charging, wait 10 seconds, reconnect. If the problem persists, the SPI connection between the MCU and potentiostat may have a hardware fault.

---

## Specifications

### Physical

| Parameter | Value |
|-----------|-------|
| Pod dimensions | 44 × 26 × 10 mm |
| Weight (with battery, without strap) | ~12–15 g |
| Strap width | 18 mm (standard quick-release) |
| Wrist circumference range | 140–195 mm |
| Water resistance | Splash-resistant (sealed enclosure with O-ring). Do not submerge. |
| Skin-contact surface curvature | 40 mm radius |

### Electrical

| Parameter | Value |
|-----------|-------|
| MCU | nRF52832 (ARM Cortex-M4, BLE 5.0) |
| Potentiostat | AD5941 (Analog Devices) |
| Battery | LiPo, 60–100 mAh |
| Charging | Magnetic pogo, USB via TP4056 |
| Regulated voltage | 3.3 V (AP2112K LDO) |
| Low battery threshold | 3.4 V |

### Sensing

| Parameter | Value |
|-----------|-------|
| Measurement interval | 15 minutes (automatic) |
| Measurement duration | ~65 seconds per cycle |
| Cortisol detection method | MIP chronoamperometry, +150 mV step |
| Sample rate | 10 Hz |
| Environmental sensors | TMP117 (±0.1 °C), SHT40 (humidity), GSR (skin conductance) |
| Skin contact threshold | < 500 kΩ skin resistance |
| Offline buffer | 50 readings |

### Wireless

| Parameter | Value |
|-----------|-------|
| Protocol | Bluetooth Low Energy (BLE) |
| Advertising name | CortiPod |
| TX power | 0 dBm |
| Range | ~10 m (typical indoor) |
| Companion app | iOS 17+ (iPhone) |
