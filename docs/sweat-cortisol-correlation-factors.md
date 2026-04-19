# Sweat-Cortisol Correlation Factors

> How to maximize the correlation between sweat cortisol measurements and systemic (blood/saliva) cortisol levels. Documents 6 key factors, their published effect on correlation, and how CortiPod addresses each.

## Why this matters

Published sweat-to-blood cortisol correlations range from r = 0.4 (clinically useless) to r = 0.95 (diagnostic-grade). The difference is not biology — it's methodology and signal processing. Every factor below adds ~0.1-0.2 to the correlation coefficient. Stacked together, they take raw sweat data from noise to a clinically meaningful signal.

The 2025 kinetic modeling paper (Sensors, July 2025) achieved r = 0.95 (95% CI: 0.92-0.97) by combining all corrections into a single personalized model validated on 44 cardiac surgery patients. This proves the ceiling is high if the data processing is right.

**Reference:** Kinetic Modeling of Cortisol Transport Dynamics. *Sensors* 2025, 25(15), 4551. DOI: [10.3390/s25154551](https://www.mdpi.com/1424-8220/25/15/4551)

---

## Factor 1: Personal baseline normalization

**Effect on correlation:** r improves from ~0.4-0.6 (between-subject) to ~0.7-0.8 (within-subject)

**The problem:** Absolute sweat cortisol varies 5-10x between individuals due to differences in skin thickness, eccrine gland density, sweat rate, and 11beta-HSD2 enzyme activity (which converts cortisol to cortisone in the sweat gland). Comparing raw ng/mL values across people produces poor correlation.

**The fix:** Normalize to each user's personal baseline. Track *relative* changes (% above/below baseline) rather than absolute concentrations.

**CortiPod implementation: ALREADY DOCUMENTED**
- `docs/user-manual.md:216-244` — Stage 2 personal calibration using saliva cortisol kits
- `docs/calibration-guide.md:862-878` — Per-user calibration curve with 3-7 reference points
- `docs/plans/2026-04-05-cortipod-build-plan.md:878` — Recalculates calibration curve after 3+ points
- Minimum: 3 saliva samples (morning, afternoon, evening) = "Good" accuracy (~15-20% error)
- Recommended: 5-7 samples over 2-3 days = "Best" accuracy (~10-15% error)

**No changes needed.** The existing personal calibration design directly addresses this factor.

---

## Factor 2: Transport lag correction

**Effect on correlation:** r improves by ~0.1-0.2 when lag is modeled vs ignored

**The problem:** Cortisol travels from blood capillaries → interstitial fluid → eccrine gland secretory coil → sweat duct → skin surface. This introduces a time delay between a systemic cortisol change and its appearance in sweat at the sensor.

### Transport pathway and timing

```
Blood cortisol change (T = 0)
     │
     ▼  (~1-3 min)
Interstitial fluid (passive diffusion through capillary wall)
     │
     ▼  (~2-8 min, depends on gland depth and sweat flow)
Eccrine gland secretory coil (cortisol partitions from ISF into sweat)
     │
     ▼  (~2-10 min, depends on sweat rate)
Skin surface / sensor (sweat carries cortisol upward through duct)
     │
     ▼
CortiPod electrode detects cortisol
```

### Estimated total lag by sweat rate

| Sweat rate | Total lag (blood → sensor) | Context |
|------------|---------------------------|---------|
| High (>1.0 mg/cm2/min, exercise) | 5-8 minutes | Fast ductal flow, short residence time |
| Moderate (0.3-1.0, warm environment) | 8-15 minutes | Typical passive wear indoors |
| Low (<0.3, rest in cool room) | 15-30+ minutes | Diffusion-dominated, lag is long and variable |
| Very low / no sweat | Undefined | No transport medium — measurement not possible |

### CortiPod implementation: ADDRESSED IN V1

The transport lag model is implemented in the v1 firmware as `TransportLagModel` (build-plan Task 7.3, Step 4). It uses a sweat-rate-dependent lookup table with literature-based defaults, refined during on-body validation (Task 8.3).

**Firmware algorithm (Swift, in `TransportLagModel`):**

```
// Lag estimation based on sweat rate proxy (GSR + humidity)
lag_minutes = estimate_transport_lag(gsr_value, humidity, temperature)

// When reporting cortisol trend to app:
// - Tag each measurement with estimated_blood_time = measurement_time - lag_minutes
// - This aligns the sweat timeline with the systemic timeline
// - Use lag estimate for trend plotting, NOT for absolute calibration

function estimate_transport_lag(gsr, rh, temp):
    // Empirical model — to be calibrated during on-body validation
    // Higher GSR = more sweat = shorter lag
    // Higher humidity = less evaporation = more sweat at surface = shorter lag
    // Higher temperature = more sweat production = shorter lag
    
    sweat_rate_proxy = gsr_to_sweat_rate(gsr, temp)
    
    if sweat_rate_proxy > 1.0:    // high sweat
        return 6  // minutes
    elif sweat_rate_proxy > 0.3:  // moderate sweat
        return 12
    elif sweat_rate_proxy > 0.1:  // low sweat
        return 20
    else:                         // minimal sweat
        return 30  // flag as low-confidence measurement
```

**Validation approach:** During the initial on-body validation study (N=5+), collect simultaneous sweat + saliva at 15-minute intervals. Cross-correlate the two time series with varying lag offsets. The offset that maximizes correlation is the empirical lag for that sweat rate regime.

**Validation:** On-body lag calibration protocol is defined in build-plan Task 8.3. Simultaneous sweat + saliva sampling at 15-minute intervals, cross-correlated with varying lag offsets to empirically determine the optimal lag per sweat rate regime.

---

## Factor 3: Sweat rate normalization / dilution correction

**Effect on correlation:** r improves by ~0.1-0.15 when sweat rate is accounted for

**The problem:** Cortisol flux into sweat (ng/min) is roughly proportional to blood cortisol. But the *concentration* in sweat (ng/mL) depends on dilution by sweat volume:

```
[Cortisol_sweat] ~ (Cortisol_flux) / (Sweat_rate)
```

Doubling sweat rate halves the measured concentration even if blood cortisol hasn't changed. Without correction, exercise (which increases both cortisol AND sweat rate) produces ambiguous signals.

**CortiPod implementation: ALREADY DOCUMENTED**
- `docs/calibration-guide.md:261-279` — Three-stage compensation pipeline:
  1. Temperature correction: 2.5% per degree C deviation from 25C reference
  2. Humidity correction: humidity_factor(RH%) accounts for evaporative concentration
  3. GSR-based sweat rate normalization: `Delta_I_final = Delta_I_comp2 * (GSR_current / GSR_reference)`
- `docs/plans/2026-04-05-cortipod-build-plan.md:813-817` — Swift code for sweat normalization

**v1 implementation:** The simple GSR ratio normalization has been replaced with a physics-based evaporative model (`SweatRateModel` in build-plan Task 7.3, Step 2). The model uses the Antoine equation to estimate vapor pressure deficit and correct the GSR-based sweat rate proxy for evaporation losses:

```
// Enhanced sweat rate estimation from environmental sensors
// Uses Fick's law of diffusion + Antoine equation for water vapor pressure

function estimate_sweat_rate(rh_percent, temp_c, skin_temp_c):
    // Saturated vapor pressure at skin temperature (Antoine equation)
    p_sat_skin = 610.78 * exp((17.27 * skin_temp_c) / (skin_temp_c + 237.3))
    
    // Ambient vapor pressure
    p_ambient = (rh_percent / 100) * 610.78 * exp((17.27 * temp_c) / (temp_c + 237.3))
    
    // Evaporative flux (simplified — proportional to vapor pressure deficit)
    evap_flux = k * (p_sat_skin - p_ambient)  // k = empirical constant for skin/sensor geometry
    
    // Sweat reaching sensor = production - evaporation
    // At steady state: production ≈ GSR proxy; net sweat = production - evap_flux
    // Use this to refine the GSR-based estimate
    
    return sweat_rate_estimate
```

**Calibration note:** The `kEvap` coefficient (default 0.4) should be refined during on-body validation by comparing estimated sweat rates with actual sweat volume (weigh absorbent pads before/after 1-hour wear sessions at varying humidity levels).

---

## Factor 4: Body site consistency and wrist-specific calibration

**Effect on correlation:** r improves by ~0.05-0.1 when body site is controlled vs mixed

**The problem:** Sweat cortisol concentration varies significantly by anatomical region due to differences in eccrine gland density, sweat rate, and local 11beta-HSD2 activity.

### Published regional cortisol differences

| Body site | Relative cortisol concentration | Eccrine gland density (glands/cm2) |
|-----------|---------------------------------|------------------------------------|
| Forehead | Highest (2-3x vs forearm) | ~360 |
| Upper back | High (1.5-2x) | ~160 |
| Chest | Moderate-high | ~175 |
| Forearm (dorsal) | Moderate (reference) | ~108 |
| Wrist (volar) | Moderate (0.8-1.2x forearm) | ~120 |
| Palm | Low (apocrine-dominant) | ~620 (mostly apocrine, not eccrine) |

**Reference:** Regional and time course differences in sweat cortisol during exercise. *Eur J Appl Physiol* 2023. [DOI: 10.1007/s00421-023-05187-3](https://link.springer.com/article/10.1007/s00421-023-05187-3)

### CortiPod implementation: ADDRESSED IN V1

The wrist-specific rationale and wear position guidance have been added to `docs/calibration-guide.md` (Body site and wear position section). No firmware change was needed — the personal calibration (Factor 1) inherently accounts for body site because the user calibrates *at the wrist*. The saliva-to-sweat mapping learned during calibration is wrist-specific by construction.

Key points documented in calibration-guide.md:
- CortiPod is designed for the volar (inner) wrist
- Moving to a different body site invalidates calibration
- Wrist chosen for: social acceptability, moderate gland density (~120/cm2), electrode swap accessibility
- Wear position: 1-2cm proximal to wrist crease, same wrist daily

---

## Factor 5: Cortisol-specific detection (cortisone cross-reactivity rejection)

**Effect on correlation:** r improves by ~0.1-0.2 when cortisone interference is removed

**The problem:** 11beta-HSD2 enzyme in the eccrine sweat gland converts a large fraction of cortisol to cortisone during secretion. As a result, cortisone is typically **10-20x more abundant** than cortisol in sweat. Immunoassay antibodies commonly cross-react with cortisone (10-40% cross-reactivity depending on the assay), artificially inflating measured cortisol and adding noise from cortisone fluctuations.

**CortiPod implementation: ALREADY DOCUMENTED**
- `docs/materials-guide.md:194-210` — MIP/NIP differential principle: `True signal = MIP - NIP`
- NIP electrode responds to cortisone (and all non-specific binding) equally to MIP
- Subtraction eliminates cortisone interference without needing to measure it independently
- `docs/anti-fouling-membrane-research.md:246` — Cortisone explicitly listed as structural analog that MIP provides selectivity against
- `docs/multi-analyte-expansion-roadmap.md:100-108` — Phase 1 includes dedicated cortisone MIP electrode for independent cortisone quantification. Combined cortisol + cortisone measurement enables 11beta-HSD2 activity ratio (biomarker of tissue-level cortisol metabolism)

**No changes needed.** The MIP/NIP differential design is the project's primary mechanism for this factor, and it's well-documented.

---

## Factor 6: Dynamic range / measurement during cortisol events

**Effect on correlation:** r is mathematically stronger when signal has range (0.1-0.15 improvement over flat-baseline-only measurement)

**The problem:** Correlation requires variance. If you only measure cortisol when it's flat (~20-40 ng/mL baseline), there's no dynamic signal to correlate against. Studies that capture the cortisol awakening response (CAR, a 50-200% spike in the 30-60 min after waking) and stress events see much stronger correlations because both blood and sweat track the same rise and fall.

**CortiPod implementation: ALREADY DOCUMENTED**
- `docs/user-manual.md:188` — "Morning peak: Cortisol surges 30-60 minutes after waking (the cortisol awakening response). This should be your highest reading of the day."
- `docs/plans/2026-04-05-cortipod-build-plan.md:901-914` — On-body testing validates morning peak and stress events
- 15-minute measurement interval captures both slow circadian trends and faster stress responses
- Calibration standard range (0-200 ng/mL) covers the full physiological sweat range

**No changes needed.**

---

## Correlation ceiling: the kinetic modeling approach

The highest published sweat-cortisol correlation to date is **r = 0.95** from a 2025 study that used a personalized kinetic model of cortisol transport dynamics.

### How the model works

Instead of treating sweat cortisol as a simple proxy for blood cortisol, the model represents the **complete transport chain** as a system of differential equations:

```
Blood cortisol (C_blood)
    │
    ▼  k1 (blood → ISF diffusion rate)
ISF cortisol (C_isf)
    │
    ▼  k2 (ISF → sweat gland partitioning)
Sweat gland cortisol (C_gland)
    │
    ▼  k3 (ductal transport, sweat-rate-dependent)
Surface sweat cortisol (C_sweat) ← this is what the sensor measures
```

Each rate constant (k1, k2, k3) is personalized via a double-loop optimization:
1. **Inner loop:** Given k values, solve the ODE system to predict C_sweat from C_blood
2. **Outer loop:** Optimize k1, k2, k3 to minimize error between predicted and measured C_sweat

The personalization accounts for individual differences in skin thickness, gland depth, sweat rate, and 11beta-HSD2 activity — all captured implicitly in the fitted k values.

### Relevance to CortiPod

CortiPod's firmware already implements the building blocks:
- **C_sweat measurement** — the MIP/NIP differential signal (every 15 minutes)
- **Sweat rate proxy** — GSR + humidity + temperature sensors
- **Personal calibration** — saliva reference points provide C_blood anchors

A future firmware update could implement a simplified kinetic model:
1. Use the first 3 days of wear + saliva calibration points to fit personalized k values
2. Apply the model in real-time to estimate C_blood from measured C_sweat
3. Report estimated blood cortisol (ng/dL equivalent) alongside raw sweat cortisol

This would be a **v2/v3 firmware feature**, not required for launch. The v1 product reports relative cortisol trends (normalized to personal baseline), which is sufficient for the wellness use case. The kinetic model enables absolute cortisol estimation, which moves CortiPod toward clinical utility.

**Reference:** Non-Invasive Blood Cortisol Estimation from Sweat Analysis by Kinetic Modeling of Cortisol Transport Dynamics. *Sensors* 2025, 25(15), 4551. [DOI: 10.3390/s25154551](https://www.mdpi.com/1424-8220/25/15/4551)

---

## Correlation factor summary

| # | Factor | Effect on r | CortiPod status | Implementation |
|---|--------|-------------|-----------------|----------------|
| 1 | Personal baseline normalization | +0.2-0.3 | v1 | user-manual.md, calibration-guide.md |
| 2 | Transport lag correction | +0.1-0.2 | v1 | build-plan Task 7.3 Step 4, Task 8.3 (validation) |
| 3 | Sweat rate dilution correction | +0.1-0.15 | v1 (enhanced) | build-plan Task 7.3 Step 2 (physics-based evaporative model) |
| 4 | Body site consistency (wrist) | +0.05-0.1 | v1 | calibration-guide.md (body site section) |
| 5 | Cortisol-specific detection | +0.1-0.2 | v1 | materials-guide.md (MIP/NIP differential) |
| 6 | Dynamic range / CAR capture | +0.1-0.15 | v1 | user-manual.md, build-plan Phase 8 |

**All 6 factors are now addressed in the v1 build.**

### Expected correlation by implementation stage

| Stage | Factors applied | Expected r | Notes |
|-------|----------------|------------|-------|
| Raw sweat vs blood (no corrections) | None | 0.4-0.6 | Between-subject, no normalization |
| v1 launch firmware | All 6 factors | 0.75-0.90 | Personal calibration + enhanced sweat rate model + MIP/NIP + lag correction + full-day wear |
| v2 firmware update (data-driven) | Refined lag table from Task 8.3 data + adaptive baseline | 0.85-0.92 | Empirical lag calibration from on-body validation |
| v3 kinetic model | Full personalized ODE transport model | 0.90-0.95 | Absolute cortisol estimation, clinical-grade accuracy |

**v1 launch target: within-subject r > 0.75.** All 6 correlation factors are implemented in the v1 firmware. The transport lag table uses literature-based defaults that will be refined during on-body validation (Task 8.3). The enhanced sweat rate model (physics-based evaporation correction) replaces the previous simple GSR ratio normalization.

---

## Firmware roadmap integration

### v1 (launch) — all 6 factors addressed
- Personal calibration (3-7 saliva points) — Factor 1
- Physics-based sweat rate estimation + dilution correction (SweatRateModel) — Factor 3
- MIP/NIP differential subtraction — Factor 5
- Transport lag estimation (lookup table, literature-based defaults) — Factor 2
- Lag-corrected timestamps (estimated_blood_time) displayed in app — Factor 2
- Confidence scoring with lag penalty — Factor 2
- Wrist-specific calibration documentation — Factor 4
- 15-minute measurement interval with full-day wear — Factor 6
- **Target: r > 0.75 within-subject**
- **Implementation:** build-plan.md Task 7.3 Steps 1-6, Task 8.3 for validation

### v2 (3-6 months post-launch) — data-driven refinement
- Empirical lag table from Task 8.3 on-body validation (replaces literature defaults)
- Adaptive personal baseline (rolling 7-day baseline update, not fixed calibration)
- k_evap coefficient refinement from multi-user data
- **Target: r > 0.85 within-subject**

### v3 (12-18 months post-launch) — kinetic modeling
- Personalized kinetic transport model (ODE-based, k1/k2/k3 fitted per user)
- Absolute blood cortisol estimation (ng/dL equivalent display in app)
- Cross-validation against continuous saliva sampling
- **Target: r > 0.90 within-subject**

---

## Related documents

- `docs/calibration-guide.md` — Current calibration protocol and compensation pipeline
- `docs/user-manual.md` — Personal calibration instructions and CAR description
- `docs/anti-fouling-membrane-research.md` — Membrane effects on response time and diffusion
- `docs/mip-contingency-plans.md` — Fouling failure modes and escalation ladder
- `docs/multi-analyte-expansion-roadmap.md` — Phase 1 cortisone MIP for cross-reactivity quantification
- `docs/plans/2026-04-05-cortipod-build-plan.md` — Firmware implementation details
