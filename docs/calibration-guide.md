# CortiPod Calibration Guide

> How to make the sensor's electrical readings mean something — converting microamps to sweat cortisol concentration.

---

## Table of Contents

1. [What is Calibration and Why You Need It](#what-is-calibration)
2. [Lab Calibration](#lab-calibration)
3. [How the Math Works](#the-math)
4. [When to Recalibrate](#when-to-recalibrate)
5. [Troubleshooting](#troubleshooting)

---

## What is Calibration and Why You Need It

The MIP sensor doesn't directly tell you "your cortisol is 85 ng/mL." It tells you "the current dropped by 3.2 microamps." Calibration is the process of building a translation table between electrical signal and cortisol concentration.

Think of it like a thermometer: the mercury rises a certain distance, but without the numbered scale printed on the glass, you can't read the temperature. Calibration creates that numbered scale for your sensor.

**Why you can't skip it:**
- Every MIP electrode is slightly different (film thickness, number of cavities, gold deposition)
- The AD5941's analog front-end has component tolerances
- Environmental conditions shift the baseline
- Without calibration, a reading of "4.7 uA" is meaningless

**Why you have to redo it periodically:**
- The MIP film changes slowly over time (swelling from washes, minor degradation)
- Seasonal temperature and humidity shifts change the baseline
- A new sensor strip needs its own calibration (even if fabricated identically)

---

## Lab Calibration

### What you need

- 1 freshly fabricated MIP sensor strip (from Phase 1 of the build plan)
- 1 NIP control strip (non-imprinted, from Task 1.4)
- Cortisol stock solution (1 mg/mL hydrocortisone in ethanol)
- Synthetic sweat (0.1% NaCl, 0.1% urea, 0.1% lactic acid in DI water, pH 6)
- PBS pH 7.4
- Wash solution (ethanol:acetic acid 9:1)
- Micropipettes
- Potentiostat (AD5941 dev board or standalone)
- Spreadsheet or notebook for recording results

### Step-by-step procedure

#### Step 1: Prepare calibration standards

Create a series of cortisol solutions at known concentrations by diluting your stock solution in synthetic sweat:

```
Stock solution: 1 mg/mL cortisol in ethanol
                (= 1,000,000 ng/mL)

Dilution series (in synthetic sweat):

Standard 1:   0 ng/mL    (blank — synthetic sweat only)
Standard 2:   1 ng/mL    (below physiological range)
Standard 3:   5 ng/mL    (near lower detection limit)
Standard 4:  10 ng/mL    (low physiological — evening/night)
Standard 5:  25 ng/mL    (moderate — afternoon)
Standard 6:  50 ng/mL    (moderate — midday)
Standard 7: 100 ng/mL    (high — morning peak)
Standard 8: 150 ng/mL    (high — morning peak / acute stress)
Standard 9: 200 ng/mL    (above normal — validation)
```

**How to dilute:**

```
To make 1 mL of 100 ng/mL standard:
  1. Take 0.1 uL of stock (1 mg/mL) + 999.9 uL synthetic sweat
     (This is impractical at small volumes)

Better approach — serial dilution:
  1. Intermediate stock: 10 uL stock + 990 uL synthetic sweat 
     = 10,000 ng/mL
  2. From intermediate:
     - 1 uL intermediate + 999 uL synth. sweat = 10 ng/mL
     - 5 uL intermediate + 995 uL synth. sweat = 50 ng/mL
     - 10 uL intermediate + 990 uL synth. sweat = 100 ng/mL
     - 15 uL intermediate + 985 uL synth. sweat = 150 ng/mL
     - 20 uL intermediate + 980 uL synth. sweat = 200 ng/mL
  
  For the low concentrations:
  3. Second intermediate: 10 uL of 10,000 ng/mL + 990 uL 
     = 100 ng/mL
  4. From second intermediate:
     - 10 uL + 990 uL = 1 ng/mL
     - 50 uL + 950 uL = 5 ng/mL
     - 250 uL + 750 uL = 25 ng/mL
```

Label each vial clearly. Keep standards refrigerated if not using immediately (cortisol is stable for hours at room temperature, days refrigerated).

#### Step 2: Record the baseline

```
1. Place the MIP sensor strip in the device (or connect via 
   clips to the potentiostat)
2. Drop 10 uL of blank synthetic sweat (Standard 1, 0 ng/mL) 
   onto the sensor
3. Wait 5 minutes
4. Run chronoamperometry:
   - Step voltage: +150 mV
   - Duration: 60 seconds
   - Sample rate: 10 Hz
5. Record the peak current (highest current in the first 
   1-2 seconds after the step)
6. This is your BASELINE — the signal with zero cortisol

Write it down: Baseline = _____ uA
```

#### Step 3: Measure each standard (low to high)

**Important:** Always go from lowest concentration to highest. This minimizes carryover (residual cortisol from a high-concentration test contaminating the next reading).

For each standard (2 through 9):

```
1. Wash the sensor:
   - Immerse in ethanol:acetic acid (9:1) for 10 minutes
   - Rinse with PBS
   - Rinse with DI water
   - Air dry 2 minutes

2. Apply 10 uL of the standard onto the sensor

3. Wait 5 minutes (incubation — cortisol binds to MIP cavities)

4. Run chronoamperometry:
   - Step voltage: +150 mV
   - Duration: 60 seconds
   - Sample rate: 10 Hz

5. Record the peak current

6. Calculate the signal change:
   Delta_I = Baseline_current - Sample_current
   (Current DECREASES as cortisol fills cavities, 
    so delta should be positive)
```

#### Step 4: Repeat on the NIP control

Run the same procedure (all 9 standards) on the NIP (non-imprinted) electrode. The NIP should show minimal or random response — no consistent dose-dependent pattern.

#### Step 5: Record your results

```
| Standard | Conc (ng/mL) | MIP Current (uA) | MIP Delta_I (uA) | NIP Current (uA) | NIP Delta_I (uA) |
|----------|-------------|-------------------|-------------------|-------------------|-------------------|
| 1        | 0           | ___               | 0 (baseline)      | ___               | 0 (baseline)      |
| 2        | 1           | ___               | ___               | ___               | ___               |
| 3        | 5           | ___               | ___               | ___               | ___               |
| 4        | 10          | ___               | ___               | ___               | ___               |
| 5        | 25          | ___               | ___               | ___               | ___               |
| 6        | 50          | ___               | ___               | ___               | ___               |
| 7        | 100         | ___               | ___               | ___               | ___               |
| 8        | 150         | ___               | ___               | ___               | ___               |
| 9        | 200         | ___               | ___               | ___               | ___               |
```

#### Step 6: Build the calibration curve

Plot your data:
- **X axis:** Cortisol concentration (ng/mL) — use logarithmic scale
- **Y axis:** Delta_I (uA) — the signal change from baseline

**What you should see:**

```
Delta_I (uA)
    ^
    |                                    ●  200 ng/mL
    |                              ●     150 ng/mL  
    |                        ●           100 ng/mL
    |                  ●                  50 ng/mL
    |            ●                        25 ng/mL
    |       ●                             10 ng/mL
    |    ●                                 5 ng/mL
    |  ●                                   1 ng/mL
    └──────────────────────────────────► log [Cortisol] (ng/mL)
    
    MIP:  clear upward trend (good!)
    NIP:  flat or random scatter (expected)
```

The relationship is typically **log-linear** — Delta_I is proportional to log(concentration) over the physiological range.

#### Step 7: Fit the calibration equation

Using any spreadsheet (Excel, Google Sheets) or a calculator:

```
Fit a line to: Delta_I  vs  log10(Concentration)

The equation will be:
  Delta_I = slope × log10(Conc) + intercept

To convert a future raw reading back to concentration:
  log10(Conc) = (Delta_I - intercept) / slope
  Conc = 10 ^ ((Delta_I - intercept) / slope)
```

**Record these values — they go into the iPhone app:**
```
slope     = _____ uA per log(ng/mL)
intercept = _____ uA
R-squared = _____ (should be > 0.95 for a good sensor)
baseline  = _____ uA (the zero-cortisol reading)
```

#### Step 8: Validate with a spot-check

Pick a concentration NOT in your calibration set (e.g., 75 ng/mL). Prepare it, measure it, and use your calibration equation to predict the concentration. It should be within 15-20% of the true value.

```
Validation:
  True concentration:      75 ng/mL
  Measured Delta_I:        _____ uA
  Predicted concentration: _____ ng/mL
  Error:                   _____% 
  
  Acceptable if error < 20%
```

---

## How the Math Works

### The full signal processing pipeline

```
Raw sensor reading (from AD5941)
        │
        ▼
Step 1: Extract peak current from chronoamperogram
        │  Peak_I = max current in first 2 seconds
        │
        ▼
Step 2: Calculate signal change from baseline
        │  Delta_I = Baseline_I - Peak_I
        │
        ▼
Step 3: Temperature compensation
        │  Delta_I_comp = Delta_I / (1 + 0.025 × (T - 25°C))
        │  
        │  Why: electrochemistry is faster when warm.
        │  A reading at 33°C would be artificially high without this.
        │  The 0.025 coefficient (2.5%/°C) is typical — measure yours 
        │  during lab calibration at 2-3 temperatures to refine it.
        │
        ▼
Step 4: Humidity compensation  
        │  Delta_I_comp2 = Delta_I_comp × humidity_factor(RH%)
        │
        │  Why: low humidity → sweat evaporates → cortisol concentrates 
        │  → reading too high. The humidity factor is determined 
        │  empirically (test at 30%, 50%, 70% RH if possible).
        │  
        │  Simple model: humidity_factor = 1.0 at 50% RH (reference)
        │  Adjust ±0.5% per 1% RH deviation
        │
        ▼
Step 5: Sweat rate normalization (via GSR + evaporative model)
        │  sweat_rate = estimate_sweat_rate(GSR, RH%, T_skin)
        │  dilution_factor = sweat_rate / sweat_rate_reference
        │  Delta_I_comp3 = Delta_I_comp2 × dilution_factor
        │
        │  Why: more sweat = more dilute cortisol = weaker signal.
        │  Uses GSR as primary sweat rate proxy, refined by an
        │  evaporative model that accounts for humidity and skin
        │  temperature (sweat evaporates faster in dry/warm air,
        │  concentrating the cortisol — which inflates the reading).
        │
        │  Evaporative correction:
        │    p_skin = 610.78 × exp(17.27 × T_skin / (T_skin + 237.3))
        │    p_ambient = (RH/100) × 610.78 × exp(17.27 × T_air / (T_air + 237.3))
        │    evap_factor = (p_skin - p_ambient) / p_ref
        │    sweat_rate = GSR_proxy / (1 + k_evap × evap_factor)
        │  where k_evap is calibrated empirically (~0.3-0.5).
        │
        ▼
Step 6: Apply lab calibration curve
        │  Conc = 10 ^ ((Delta_I_comp3 - intercept) / slope)
        │
        │  Uses the slope + intercept from lab calibration
        │
        ▼
Step 7: Transport lag estimation
        │  lag_minutes = estimate_lag(sweat_rate)
        │  estimated_blood_time = measurement_time - lag_minutes
        │
        │  Why: cortisol takes 5-20 minutes to travel from blood
        │  through ISF and the eccrine gland to the skin surface.
        │  The lag depends on sweat rate — higher sweat = faster
        │  transport = shorter lag.
        │
        │  Lookup table (calibrated during on-body validation):
        │    sweat_rate > 1.0 mg/cm2/min  → lag = 5 min
        │    sweat_rate 0.3-1.0           → lag = 10 min
        │    sweat_rate 0.1-0.3           → lag = 18 min
        │    sweat_rate < 0.1             → lag = 25 min (low confidence)
        │
        │  The app timestamps each reading with estimated_blood_time
        │  for trend display. This aligns sweat measurements with the
        │  systemic cortisol timeline for more accurate trend plotting.
        │
        ▼
Step 8: Confidence scoring
        │  confidence = contact_quality × temp_penalty × gsr_penalty
        │                × lag_penalty
        │
        │  Penalize readings taken in extreme conditions:
        │  - Contact quality < 50%: discard reading entirely
        │  - Temperature outside 20-37°C: reduce confidence
        │  - GSR near zero (no sweat detected): reduce confidence
        │  - Lag > 20 min: reduce confidence (stale measurement)
        │
        ▼
Final output: Sweat cortisol = XX ng/mL
              Confidence: high/medium/low
              Estimated blood time: HH:MM (measurement_time - lag)
```

### Example walkthrough

```
Raw reading from AD5941:
  Baseline current: 65.0 uA
  Peak current after cortisol exposure: 61.2 uA
  Air temperature: 32.5°C
  Skin temperature: 33.0°C
  Humidity: 45%
  GSR: 3.2 uS (reference: 2.8 uS)
  Contact quality: 92%
  Measurement time: 14:30

Step 1: Peak_I = 61.2 uA
Step 2: Delta_I = 65.0 - 61.2 = 3.8 uA
Step 3: Delta_I_comp = 3.8 / (1 + 0.025 × (32.5 - 25))
                     = 3.8 / 1.1875
                     = 3.2 uA
Step 4: Delta_I_comp2 = 3.2 × (1 + 0.005 × (50 - 45))
                      = 3.2 × 1.025
                      = 3.28 uA
Step 5: Sweat rate estimation:
          p_skin = 610.78 × exp(17.27 × 33.0 / (33.0 + 237.3)) = 5034 Pa
          p_ambient = (45/100) × 610.78 × exp(17.27 × 32.5 / (32.5 + 237.3))
                    = 0.45 × 4890 = 2201 Pa
          evap_factor = (5034 - 2201) / 3000 = 0.94  (p_ref = 3000 Pa at 50% RH, 25°C)
          sweat_rate_proxy = (3.2 / 2.8) / (1 + 0.4 × 0.94) = 1.143 / 1.376 = 0.83
        Dilution correction:
          Delta_I_comp3 = 3.28 × (0.83 / 0.70)  [0.70 = reference sweat rate from calibration]
                        = 3.28 × 1.186
                        = 3.89 uA
Step 6: Conc = 10 ^ ((3.89 - 0.5) / 1.8)
             = 10 ^ (1.883)
             = 76.4 ng/mL
Step 7: Transport lag estimation:
          sweat_rate ~0.83 (moderate range 0.3-1.0)
          lag = 10 minutes
          estimated_blood_time = 14:30 - 10 min = 14:20
Step 8: Confidence:
          contact = 0.92
          temp_penalty = 1.0 (32.5°C within 20-38°C)
          gsr_penalty = 1.0 (3.2 uS well above 0.5 threshold)
          lag_penalty = 1.0 (10 min < 20 min threshold)
          confidence = 0.92 × 1.0 × 1.0 × 1.0 = 0.92 (high)

Output: Sweat cortisol = 76.4 ng/mL (confidence: high)
        Estimated blood time: 14:20
        Transport lag: 10 min
```

---

## Body site and wear position

CortiPod is designed and calibrated for the **volar (inner) wrist**. The personal calibration process establishes the sweat-to-saliva cortisol ratio at the wrist specifically. Moving the device to a different body site (e.g., upper arm, forehead) invalidates the calibration and requires recalibration at the new site.

**Why the wrist:**
- Social acceptability (watch form factor, always visible for glanceable data)
- Consistent eccrine sweat production (~120 glands/cm2, moderate density)
- Accessible for electrode swapping (user can do it one-handed)
- Passive sweat sufficient at room temperature for most users
- Published sweat cortisol data available for this site

**Site-specific considerations:** The forehead produces 2-3x higher cortisol concentrations (higher gland density, higher sweat rate) but is impractical for continuous wear. The volar wrist has moderate concentration — well within the sensor's detection range (8-140 ng/mL) but lower than forehead or upper back. The personal calibration compensates for this automatically because the saliva-to-sweat mapping is learned *at the wrist*.

**Wear consistency:** For best accuracy, wear the device on the same wrist, in the same position (1-2cm proximal to the wrist crease), every day. Sweat gland density varies even across a few centimeters of skin. Consistent placement reduces measurement-to-measurement noise.

See also: `docs/sweat-cortisol-correlation-factors.md` — Factor 4 (body site consistency).

---

## When to Recalibrate

### Lab recalibration (full 9-point curve)

| Trigger | Why |
|---------|-----|
| New sensor strip installed | Every strip has slightly different film thickness and cavity density |
| Signal baseline drifts >20% from original | The MIP film may be degrading |
| Temperature coefficient seems off | Recalibrate at 2-3 temperatures |
| R-squared drops below 0.90 | Sensor may be losing selectivity |


---

## Troubleshooting

### "My calibration curve is flat (no dose response)"

**Possible causes:**
- Template removal was incomplete — cortisol still blocking all cavities
  - **Fix:** Repeat the wash step (ethanol:acetic acid) for 30 minutes instead of 15
- Pyrrole didn't polymerize properly — no MIP film formed
  - **Fix:** Check potentiostat settings. During CV, you should see increasing current with each cycle. If current is flat, the polymerization isn't happening. Check electrode connections and pyrrole freshness (pyrrole oxidizes over time — it should be pale yellow, not dark brown).
- Wrong electrode polarity — common mistake
  - **Fix:** Double-check working/counter/reference connections

### "My MIP and NIP give the same response"

**Possible causes:**
- Non-specific adsorption — cortisol sticking to the polymer surface rather than binding in specific cavities
  - **Fix:** More aggressive washing, or add a brief PBS rinse step between incubation and measurement
- Too many CV cycles during polymerization — film is too thick, deepest cavities are buried
  - **Fix:** Reduce from 10 cycles to 5-7. Thinner film = better cavity accessibility for bench use.
  - **Note:** A thicker film is not always bad. For on-body use, more cycles (or overoxidation) create a denser matrix that blocks protein fouling while surface cavities remain accessible. If MIP ≈ NIP on bench with standard 10 cycles, reduce cycles. If bench works fine but on-body signal degrades fast, try extended overoxidation instead (see build plan Task 1.2, Step 2b).

### "Signal drifts during the 60-second chronoamperometry"

**This is normal.** The current always decays during chronoamperometry (capacitive charging effect). What matters is the peak current in the first 1-2 seconds. If the decay is erratic (noisy), check:
- Electrode connections (loose clips or dirty pogo pins)
- Electrical noise (move away from motors, fluorescent lights)
- Solution evaporation (cover the electrode with a small cap during measurement)

### "On-body readings don't match lab readings"

**Expected.** Lab calibration uses synthetic sweat at controlled temperature. On-body conditions are different — real sweat composition, skin temperature, and sweat rate all affect the reading. The temperature, humidity, and GSR compensation steps in the signal processing pipeline account for much of this, but some offset is normal. Use consistent wearing conditions (same wrist position, similar activity level) for the most comparable readings.

### "Contact quality is always low"

- **Strap too loose** — tighten so the pod sits flush against skin
- **Dry skin** — the sensor needs a small amount of sweat. After 10-15 minutes of wear, passive sweating should produce enough. If your skin is very dry, try wearing it during light activity first.
- **Hair on wrist** — the GSR pads need direct skin contact. Shave the sensor area or reposition.

### "Readings spike randomly"

- **Motion artifact** — if the pod shifts during measurement, the pogo pin contact fluctuates. The contact quality check should catch this (readings with low contact quality are flagged). If not, tighten the strap or add a measurement retry in firmware.
- **Sweat burst** — sudden sweating (e.g., entering a warm room) can flush a bolus of concentrated cortisol onto the sensor. This is real data, not an error — but it may not represent your systemic cortisol level. The app should flag readings where GSR changes rapidly.
