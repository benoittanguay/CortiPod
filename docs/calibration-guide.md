# CortiPod Calibration Guide

> How to make the sensor's electrical readings mean something — converting microamps to cortisol concentration.

---

## Table of Contents

1. [What is Calibration and Why You Need It](#what-is-calibration)
2. [The Two Types of Calibration](#two-types)
3. [Lab Calibration (Do This First)](#lab-calibration)
4. [Personal Calibration (Do This On-Body)](#personal-calibration)
5. [How the Math Works](#the-math)
6. [When to Recalibrate](#when-to-recalibrate)
7. [Troubleshooting](#troubleshooting)

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

## The Two Types of Calibration

### 1. Lab Calibration (controlled, on the bench)

**When:** Before first use, and whenever you make a new sensor strip.

**What:** Test the sensor against known cortisol concentrations in synthetic sweat. Builds a full calibration curve (9+ data points).

**Accuracy:** High — controlled conditions, known concentrations.

### 2. Personal Calibration (on-body, real-world)

**When:** After lab calibration, first few days of wearing the device.

**What:** Take a saliva cortisol test and a CortiPod reading at the same time. Creates 1-3 "anchor points" that adjust the lab calibration to your body's specific sweat-to-blood cortisol ratio.

**Why it's needed:** Lab calibration tells you the sensor responds linearly to cortisol. Personal calibration tells you what YOUR cortisol levels map to — because sweat cortisol concentration varies between individuals (skin thickness, sweat gland density, local blood flow).

---

## Lab Calibration (Do This First)

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

## Personal Calibration (Do This On-Body)

Lab calibration gives you a sensor that accurately measures cortisol in synthetic sweat. But your actual sweat is different from synthetic sweat, and sweat cortisol doesn't map 1:1 to blood/saliva cortisol. Personal calibration adjusts for this.

### What you need

- CortiPod device, assembled and working
- Saliva cortisol test kit (Everlywell or ZRT Lab, ~$30 per kit)
- The CortiPod iPhone app

### Procedure

#### Calibration Point 1: Morning (high cortisol)

```
Timing: Within 30 minutes of waking up (cortisol is highest)

1. Put on the CortiPod
2. Wait 10 minutes for sweat to accumulate on the sensor
3. Take a CortiPod reading (tap "Measure" in the app)
4. Immediately take the saliva cortisol test per kit instructions
5. When saliva results come back (24-48 hours for mail-in kits,
   or use a rapid kit):
   - Open the app → Calibration → Add Point
   - Enter the saliva result (e.g., "18.5 ng/dL")
   - The app pairs it with the CortiPod raw reading from that time
```

#### Calibration Point 2: Afternoon (medium cortisol)

```
Timing: 2-4 PM (cortisol is moderate)

Same procedure:
1. CortiPod reading
2. Simultaneous saliva test
3. Enter result when available
```

#### Calibration Point 3: Evening (low cortisol)

```
Timing: 8-10 PM (cortisol is near daily minimum)

Same procedure:
1. CortiPod reading
2. Simultaneous saliva test
3. Enter result when available
```

### What the app does with these points

```
You now have 3 pairs:
  (CortiPod_raw_1, Saliva_1)  — morning
  (CortiPod_raw_2, Saliva_2)  — afternoon
  (CortiPod_raw_3, Saliva_3)  — evening

The app fits a personal correction factor:

  True_cortisol = Lab_calibrated_value × personal_scale + personal_offset

Where personal_scale and personal_offset are derived from 
your 3 calibration points.

This accounts for:
  - Your skin's specific sweat-to-blood cortisol ratio
  - Your sweat gland density at the wrist
  - Your baseline skin conductance
  - Differences between sweat cortisol and saliva cortisol units
```

### How many calibration points do you need?

| Points | Accuracy | Effort |
|--------|----------|--------|
| 1 | Rough (~30-40% error) | Minimal |
| 3 | Good (~15-20% error) | One day of saliva tests |
| 5-7 | Best (~10-15% error) | 2-3 days of saliva tests |

3 points is the sweet spot for a prototype. The diminishing returns after 5 points aren't worth the cost of additional saliva kits.

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
Step 5: Sweat rate normalization (via GSR)
        │  Delta_I_final = Delta_I_comp2 × (GSR_current / GSR_reference)
        │
        │  Why: more sweat = more dilute cortisol = weaker signal.
        │  GSR_reference is your average GSR during lab calibration.
        │  If current GSR is 2x reference, sweat is 2x more abundant,
        │  so cortisol is ~2x more dilute — scale the signal up.
        │
        ▼
Step 6: Apply lab calibration curve
        │  Conc_lab = 10 ^ ((Delta_I_final - intercept) / slope)
        │
        │  Uses the slope + intercept from lab calibration (Step 7 above)
        │
        ▼
Step 7: Apply personal calibration
        │  Conc_personal = Conc_lab × personal_scale + personal_offset
        │
        │  Uses the correction factor from your saliva test calibration
        │
        ▼
Step 8: Confidence scoring
        │  confidence = contact_quality × temp_penalty × gsr_penalty
        │
        │  Penalize readings taken in extreme conditions:
        │  - Contact quality < 50%: discard reading entirely
        │  - Temperature outside 20-37°C: reduce confidence
        │  - GSR near zero (no sweat detected): reduce confidence
        │
        ▼
Final output: Cortisol = XX ng/mL (confidence: high/medium/low)
```

### Example walkthrough

```
Raw reading from AD5941:
  Baseline current: 65.0 uA
  Peak current after cortisol exposure: 61.2 uA
  Temperature: 32.5°C
  Humidity: 45%
  GSR: 3.2 uS (reference: 2.8 uS)
  Contact quality: 92%

Step 1: Peak_I = 61.2 uA
Step 2: Delta_I = 65.0 - 61.2 = 3.8 uA
Step 3: Delta_I_comp = 3.8 / (1 + 0.025 × (32.5 - 25))
                     = 3.8 / 1.1875
                     = 3.2 uA
Step 4: Delta_I_comp2 = 3.2 × (1 + 0.005 × (50 - 45))
                      = 3.2 × 1.025
                      = 3.28 uA
Step 5: Delta_I_final = 3.28 × (3.2 / 2.8)
                      = 3.28 × 1.143
                      = 3.75 uA
Step 6: Conc_lab = 10 ^ ((3.75 - 0.5) / 1.8)
                 = 10 ^ (1.806)
                 = 63.9 ng/mL
Step 7: Conc_personal = 63.9 × 1.15 + (-2.3)
                      = 71.2 ng/mL
Step 8: Confidence = 0.92 × 1.0 × 1.0 = 0.92 (high)

Output: Cortisol = 71.2 ng/mL (confidence: high)
```

This is a midday reading — reasonable for ~2 PM.

---

## When to Recalibrate

### Lab recalibration (full 9-point curve)

| Trigger | Why |
|---------|-----|
| New sensor strip installed | Every strip has slightly different film thickness and cavity density |
| Signal baseline drifts >20% from original | The MIP film may be degrading |
| Temperature coefficient seems off | Recalibrate at 2-3 temperatures |
| R-squared drops below 0.90 | Sensor may be losing selectivity |

### Personal recalibration (1-3 saliva tests)

| Trigger | Why |
|---------|-----|
| New sensor strip + lab recalibration | The lab curve changed, personal correction may need adjusting |
| Readings seem consistently off vs how you feel | Personal correction may have drifted |
| Season change (summer → winter) | Skin hydration and sweat patterns change |
| Every 2-3 months as a check | Good practice |

### Quick recalibration (1 saliva test)

If readings seem off but you don't want to redo the full process:

```
1. Take a single simultaneous CortiPod + saliva reading
2. Compare CortiPod prediction vs saliva result
3. If within 20%: no action needed
4. If off by >20%: 
   - Take 2 more calibration points (different times of day)
   - Update personal calibration
5. If off by >50%:
   - Sensor strip may need replacement
   - Redo full lab calibration with new strip
```

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

**Expected.** Lab calibration uses synthetic sweat at controlled temperature. On-body conditions are different. This is exactly why personal calibration exists. Complete the personal calibration steps before evaluating on-body accuracy.

### "Contact quality is always low"

- **Strap too loose** — tighten so the pod sits flush against skin
- **Dry skin** — the sensor needs a small amount of sweat. After 10-15 minutes of wear, passive sweating should produce enough. If your skin is very dry, try wearing it during light activity first.
- **Hair on wrist** — the GSR pads need direct skin contact. Shave the sensor area or reposition.

### "Readings spike randomly"

- **Motion artifact** — if the pod shifts during measurement, the pogo pin contact fluctuates. The contact quality check should catch this (readings with low contact quality are flagged). If not, tighten the strap or add a measurement retry in firmware.
- **Sweat burst** — sudden sweating (e.g., entering a warm room) can flush a bolus of concentrated cortisol onto the sensor. This is real data, not an error — but it may not represent your systemic cortisol level. The app should flag readings where GSR changes rapidly.
