# MIP Fabrication — Contingency Plans & Fallback Protocols

> What to do when the primary build path doesn't work. Organized as an escalation ladder: start at the top, move down only when the simpler fix doesn't resolve the problem.

---

## Table of Contents

1. [How to Use This Document](#how-to-use-this-document)
2. [Failure 1: Flat Calibration Curve (No Dose Response)](#failure-1-flat-calibration-curve)
3. [Failure 2: MIP and NIP Give the Same Response](#failure-2-mip-equals-nip)
4. [Failure 3: Signal Degrades Within Hours On-Body (Fouling)](#failure-3-fouling)
5. [Failure 4: Insufficient Sensitivity (Can't Distinguish Concentrations)](#failure-4-insufficient-sensitivity)
6. [Failure 5: Poor Reproducibility Between Electrodes](#failure-5-poor-reproducibility)
7. [Failure 6: On-Body Readings Don't Correlate With Saliva Tests](#failure-6-on-body-mismatch)
8. [Failure 7: Not Enough Sweat Reaching the Sensor](#failure-7-insufficient-sweat)
9. [Nuclear Options — Full Approach Pivots](#nuclear-options)
10. [Decision Flowchart](#decision-flowchart)
11. [Contingency Parts to Pre-Order](#contingency-parts-to-pre-order)

---

## How to Use This Document

Each failure section follows the same structure:

1. **How you know you have this problem** — the diagnostic signal
2. **Escalation ladder** — fixes ordered from simplest (try first) to most complex (try last)
3. **Hardware/materials needed** — what each fix requires
4. **When to stop and escalate** — the signal that tells you to move to the next rung

Do not skip rungs. Simpler fixes are faster, cheaper, and eliminate variables. Jump to a complex fix only after the simpler ones have failed.

---

## Failure 1: Flat Calibration Curve (No Dose Response)

### How you know

During Phase 2 bench validation, you plot Delta_I vs cortisol concentration and the line is flat or scattered randomly. No consistent increase in signal as cortisol concentration increases. R² < 0.80.

### Escalation ladder

#### Rung 1: Extend the template wash (10 minutes, no cost)

The most common cause is incomplete template removal — cortisol is still stuck in the cavities, so new cortisol can't bind.

```
Protocol:
1. Re-immerse the MIP electrode in ethanol:acetic acid (9:1)
2. Extend soak to 30 minutes (instead of 15-20)
3. Agitate every 3 minutes (more frequently than standard)
4. Rinse: PBS, then distilled water
5. Air dry 10 minutes
6. Re-test with the 0, 50, and 100 ng/mL standards only (quick 3-point check)
```

**Success signal:** Clear separation between 0, 50, and 100 ng/mL readings.

**If it didn't work:** Move to Rung 2.

#### Rung 2: Repeat wash with stronger solvent (30 minutes, no cost)

```
Protocol:
1. Prepare a stronger wash: ethanol:acetic acid 7:3 (v/v)
   (i.e., 7 mL ethanol + 3 mL glacial acetic acid)
2. Immerse MIP electrode for 30 minutes with continuous gentle agitation
3. Follow with 3 sequential PBS rinses (2 minutes each)
4. Distilled water rinse
5. Air dry
6. Re-test 3-point check
```

**Why this helps:** Higher acetic acid concentration more aggressively disrupts hydrogen bonds between cortisol and the polymer.

**If it didn't work:** The problem likely isn't template removal — the MIP film itself may not have formed correctly. Move to Rung 3.

#### Rung 3: Verify polymerization actually occurred (15 minutes, no cost)

Before fabricating a new electrode, confirm the film is actually there.

```
Diagnostic checks:
1. Visual: Is there a dark coating on the working electrode?
   - Pyrrole MIP: dark grey/black film visible
   - oPD MIP: brownish-orange film visible
   - If NO visible film → polymerization failed entirely (see below)

2. Electrochemical: Run a blank chronoamperometry on the MIP vs a bare electrode
   - Step voltage: +150 mV, duration: 10 seconds, in PBS only (no cortisol)
   - Compare peak currents
   - The MIP-coated electrode should show noticeably different current
     (typically lower) than a bare gold electrode
   - If currents are identical → no meaningful polymer film formed
```

**If no film formed:** The polymerization step failed. Common causes:
- Pyrrole has oxidized (should be pale yellow, not brown/black in the bottle)
- Electrode clips were reversed (wrong polarity)
- Potentiostat not outputting voltage (check with multimeter)

```
Fix:
1. Check pyrrole color. If brown → discard and open a fresh bottle.
   Store pyrrole under nitrogen or argon if possible, or at minimum 
   keep tightly capped and refrigerated.
2. Verify clip connections: RED = working electrode, BLACK = counter,
   WHITE/GREEN = reference. Test by measuring a known resistor.
3. Fabricate a new electrode from scratch with verified materials.
```

**If it didn't work:** Move to Rung 4.

#### Rung 4: Switch to oPD monomer (2 hours, ~$0 if already purchased)

oPD forms denser, tighter cavities than pyrrole. If pyrrole MIP consistently shows no response, oPD may succeed where pyrrole failed.

```
Protocol (see beginner's guide Day 2 Alternative for full details):
1. Prepare oPD solution:
   - 5 mM oPD in PBS pH 7.4 (1.1 mg in 2 mL PBS)
   - Add 1 mM cortisol (0.72 mg in 2 mL) as template
   - Wait 30 minutes for pre-complexation (longer than pyrrole)

2. CV parameters (different from pyrrole):
   Potential range: -200 mV to +800 mV
   Scan rate: 50 mV/s
   Cycles: 20 (not 10 — oPD polymerizes slower)

3. Overoxidation: 1 cycle to +1100 mV (same as pyrrole)

4. Wash: ethanol:acetic acid 9:1, 20 minutes

5. Test: same 9-point calibration protocol
```

**Why this helps:** oPD creates a more compact polymer with higher shape fidelity to cortisol. Literature shows poly-oPD MIPs often outperform polypyrrole MIPs for steroid hormones specifically because the denser matrix reduces non-specific binding.

**If it didn't work:** Move to Rung 5.

#### Rung 5: Change the electrode substrate (1-2 days, ~$80-540)

If neither monomer works on your current electrodes, the electrode surface itself may be the problem.

```
Option A: Switch electrode supplier
  - If using carbon (TE100): switch to gold (DRP-220AT)
  - If using DRP-220AT: try DRP-C220AT (different gold ink formulation)
  - Re-run MIP fabrication with pyrrole on the new substrate

Option B: Switch to interdigitated electrodes (IDEs)
  - Order MicruX ED-IDE3-Au (50-pack, ~EUR 540)
  - Requires adjusted protocol (see Failure 4, Rung 4)
  - Enables EIS sensing mode (potentially 1000x better sensitivity)
```

---

## Failure 2: MIP and NIP Give the Same Response

### How you know

Both MIP and NIP electrodes show a dose-dependent response to cortisol. The differential (MIP - NIP) is near zero at all concentrations. Imprinting factor < 1.5.

This means cortisol is binding non-specifically to the polymer surface, not to the imprinted cavities.

### Escalation ladder

#### Rung 1: More aggressive washing between measurements (10 minutes, no cost)

Non-specific adsorption means cortisol lingers on the polymer surface between tests, contaminating the next measurement.

```
Protocol adjustment for calibration testing:
1. After each measurement, wash for 15 minutes (not 10)
2. Add an extra PBS rinse step: 3 rinses of 2 minutes each
3. Add a 5-minute soak in pure distilled water after the PBS rinses
4. Air dry 5 minutes
5. Re-run the full 9-point calibration on both MIP and NIP
```

**Success signal:** MIP response is at least 2x the NIP response at 50 ng/mL.

#### Rung 2: Reduce film thickness (2 hours, no cost — fabricate new electrode)

Thicker films bury cavities deep in the polymer where cortisol can't easily reach them. The surface of a thick film behaves like a NIP regardless of whether cavities exist deeper inside.

```
Protocol:
1. Fabricate a new MIP electrode with FEWER CV cycles:
   - Pyrrole: 5-7 cycles (instead of 10)
   - oPD: 10-15 cycles (instead of 20)
2. Same voltage range, scan rate, and solutions
3. Skip overoxidation for this test (overoxidation adds density
   that may compound the problem)
4. Same template wash
5. Re-test MIP vs NIP at 0, 50, and 100 ng/mL
```

**Why this helps:** Thinner film = cavities are closer to the surface = better accessibility. The trade-off is reduced on-body fouling resistance, but you need the bench to work before worrying about on-body.

#### Rung 3: Increase template concentration during fabrication (2 hours, no cost)

More cortisol molecules present during polymerization = more cavities formed = stronger specific signal.

```
Protocol:
1. Double the cortisol concentration in the pre-polymerization solution:
   - Standard: 1 mM cortisol → New: 2 mM cortisol
   - For 10 mL PBS: use 7.2 mg hydrocortisone (instead of 3.6 mg)
2. Extend the pre-complexation wait to 45 minutes (monomer-template
   interaction time)
3. Fabricate with standard 10 CV cycles
4. Wash template out (may need extended wash — 30 minutes — since
   there's more template to remove)
5. Re-test
```

**Why this helps:** More template molecules = more imprint sites = higher ratio of specific-to-nonspecific binding. The risk is that too much template can disrupt polymerization, but 2 mM is well within published ranges.

#### Rung 4: Switch to oPD (if currently using pyrrole)

See [Failure 1, Rung 4](#rung-4-switch-to-opd-monomer-2-hours-0-if-already-purchased). oPD's tighter cavities inherently produce better imprinting factors for steroid-sized molecules.

#### Rung 5: Add a blocking step (30 minutes, ~$0)

Passivate the non-specific binding sites on both MIP and NIP with a protein blocker before testing.

```
Protocol:
1. After template removal and rinsing, immerse both MIP and NIP
   in 1% BSA (bovine serum albumin) in PBS for 30 minutes
   (BSA is available at most lab suppliers, ~$20 for 10g,
   or use milk powder dissolved in PBS as a crude alternative)
2. Rinse with PBS (3x, 2 minutes each)
3. Now test with cortisol standards

What this does: BSA saturates all non-specific adsorption sites on the
polymer surface. Cortisol can still reach the MIP cavities (BSA is too
large to enter them), but it can't stick non-specifically to the flat
surface anymore.
```

**Why this helps:** If the MIP/NIP differential improves dramatically after BSA blocking, it confirms your cavities work — the problem was surface adsorption, not bad cavities. In that case, an anti-fouling membrane (Nafion) would solve the problem permanently.

---

## Failure 3: Signal Degrades Within Hours On-Body (Fouling)

### How you know

Bench calibration is good (R² > 0.95, clear MIP vs NIP separation), but on-body readings drift steadily downward over 4-8 hours regardless of expected cortisol changes. Morning readings are reasonable; afternoon readings are flat or near-zero.

### Escalation ladder

#### Rung 1: Apply extended overoxidation (2 minutes, no cost)

If you used basic or no overoxidation during fabrication, upgrade to extended.

```
For your next batch of electrodes, use extended overoxidation:

  Method: Cyclic voltammetry
  Start potential:  -200 mV
  End potential:    +1100 mV
  Scan rate:         50 mV/s
  Number of cycles:  3-5

  OR aggressive overoxidation:

  Method: Constant potential (chronoamperometry mode)
  Potential:  +1200 mV
  Duration:   120 seconds

Expected improvement: ~2x fouling resistance vs no overoxidation.
Sensitivity cost: 25-35% reduction in peak current.
```

**Success signal:** On-body signal retains >60% of initial value at hour 8.

#### Rung 2: Add Nafion membrane overlay (~$0.01/electrode, ~$50 for supply)

Nafion is the most proven anti-fouling coating in electrochemical biosensing. It blocks proteins while allowing cortisol through.

```
Materials needed:
  - Nafion 5% dispersion (Sigma-Aldrich cat. 510211, ~$50 for 100 mL)
  - Ethanol (already in kit)
  - Micropipette

Preparation:
  1. Dilute Nafion to 0.5%:
     - 100 uL of 5% Nafion stock + 900 uL ethanol
     - Mix gently (do not vortex — creates bubbles)
     - Store in a glass vial, capped

Application (after MIP fabrication and template removal):
  1. Ensure the electrode is clean and dry
  2. Pipette 3 uL of 0.5% Nafion onto the working electrode area
  3. Spread evenly with the pipette tip if needed
  4. Air dry for 60 minutes at room temperature
     (do NOT heat — Nafion restructures above 50C)
  5. The membrane is invisible — you won't see it

  Apply to BOTH MIP and NIP electrodes (same volume, same drying time).

Validation:
  - Re-run 3-point calibration (0, 50, 100 ng/mL)
  - Expect 15-30% reduction in absolute signal vs bare MIP
  - R² should remain > 0.90
  - On-body: signal should hold >60% at hour 8
```

**Expected outcome:** Sensor life extends from 4-8 hours to 3-7 days.

**If it didn't work (signal still degrades fast):** The Nafion layer may be too thin or too thick. Try:
- **Thicker:** Apply 2 layers (3 uL each, dry 30 minutes between layers)
- **Thinner:** Dilute to 0.25% Nafion instead of 0.5%

#### Rung 3: Add polyurethane membrane (2-4 hours, ~$25-100)

If Nafion alone is insufficient for multi-day wear, a polyurethane (PU) overlayer provides the strongest known anti-fouling protection. This is what Dexcom uses in its CGM sensors.

```
Materials needed:
  - Medical-grade polyurethane pellets
    (Tecoflex SG-80A from Lubrizol, or Sigma cat. 81367, ~$25-100)
  - Tetrahydrofuran (THF) or dimethylacetamide (DMAC) as solvent
  - Glass vial for solution prep

Preparation:
  1. Dissolve PU in THF at 5 wt%:
     - 50 mg PU pellets in 950 uL THF
     - Stir gently for 1-2 hours until fully dissolved
     - Solution should be clear and slightly viscous

Application (after Nafion layer, or directly on bare MIP):
  1. Pipette 5 uL of 5% PU/THF onto the working electrode
  2. Allow THF to evaporate: 2-4 hours at room temperature,
     or 30 minutes at 50C (well-ventilated — THF fumes are irritating)
  3. Resulting membrane: ~10-15 um thick

  Apply to BOTH MIP and NIP electrodes.

SAFETY: THF is flammable and an irritant.
  - Work in a well-ventilated area or near a fan
  - Wear nitrile gloves (THF penetrates latex)
  - No open flames
  - Cap the THF bottle when not in use
```

**Expected outcome:** Sensor life extends to 7-14 days. Sensitivity drops 30-60% (thicker diffusion barrier), and response time increases by 5-10 minutes (acceptable for 15-minute measurement intervals).

**Trade-off:** PU is not user-applicable in the field due to THF. Sensor strips must be prepared in advance. This is a factory step, not a daily maintenance step.

#### Rung 4: Dual membrane stack (Nafion + PU)

For maximum protection, apply Nafion first (charge-based protein rejection), then PU on top (size-based protein exclusion). Two independent rejection mechanisms.

```
Application order:
  1. MIP fabrication + template removal + overoxidation
  2. Nafion: 3 uL of 0.5%, dry 60 minutes
  3. PU: 5 uL of 5% in THF, dry 2-4 hours
  4. Total membrane stack: ~0.5 um Nafion + ~10 um PU

Expected performance:
  - Sensitivity: 40-60% of bare MIP (significant reduction)
  - Fouling resistance: 10-14 days (Dexcom-class)
  - Response time: 5-10 minutes (acceptable at 15-min intervals)
```

**When to use this:** Only if you need multi-day continuous wear and simpler approaches failed. The sensitivity cost is real — validate on bench first to confirm the AD5941 can still resolve the reduced signal.

---

## Failure 4: Insufficient Sensitivity (Can't Distinguish Concentrations)

### How you know

The calibration curve exists (not flat), but the slope is too shallow — the difference in signal between 10 ng/mL and 100 ng/mL is smaller than the measurement noise. LOD is above 10 ng/mL (should be below 5 ng/mL).

### Escalation ladder

#### Rung 1: Increase polymerization cycles for more cavities (2 hours, no cost)

More cycles = thicker film = more cavities (at the cost of some accessibility).

```
Protocol:
  Pyrrole: increase from 10 to 15 CV cycles
  oPD: increase from 20 to 30 CV cycles
  Same voltage range and scan rate
  
  Then use basic overoxidation (1 cycle) — do NOT use extended,
  as it reduces absolute signal further.
```

**Why this helps:** More polymer volume = more total cavities = more binding sites = larger Delta_I for the same cortisol concentration.

#### Rung 2: Use DPV instead of chronoamperometry (firmware change, no hardware cost)

Differential Pulse Voltammetry has inherently better signal-to-noise ratio than chronoamperometry because it subtracts capacitive background current.

```
DPV parameters (for AD5941):
  Scan range: -200 mV to +600 mV
  Step potential: 5 mV
  Pulse amplitude: 50 mV
  Pulse width: 50 ms
  Sample period: 100 ms

Firmware impact:
  - New function: potentiostat_runDPV()
  - AD5941 register configuration for pulse generation
  - ~4-6 hours firmware development
  - No hardware changes

Expected improvement:
  - 2-5x better signal-to-noise vs chronoamperometry
  - Better peak resolution
  - Measurement time: ~160 seconds (longer than 60s chrono)
```

**When to use:** If chronoamperometry shows a dose response but the signal is buried in noise.

#### Rung 3: Add gold nanoparticle enhancement (1 hour, ~$0 if HAuCl4 already purchased)

If using carbon electrodes (TE100), gold nanoparticle deposition dramatically increases surface area and electron transfer kinetics.

If already using gold electrodes (DRP-220AT), you can still electrodeposit additional gold nanoparticles on top of the existing gold surface to increase roughness and surface area.

```
Protocol (works on both carbon and gold substrates):
  1. Prepare 1 mM HAuCl4 in 0.5 M H2SO4
  2. Apply -0.2 V vs Ag/AgCl for 120 seconds
  3. Rinse with distilled water
  4. Air dry
  5. THEN proceed with MIP fabrication on the enhanced surface

Expected improvement:
  - 2-5x increase in effective surface area
  - Better electron transfer kinetics (cleaner signal)
  - More MIP cavities per electrode (more surface = more polymer)
```

#### Rung 4: Switch to IDE electrodes + EIS sensing mode (1-2 weeks, ~EUR 540)

This is the high-investment, high-reward pivot. Interdigitated electrodes with impedimetric sensing offer approximately 1000x better detection limits than standard SPE + chronoamperometry.

```
What to order:
  MicruX ED-IDE3-Au (50-pack, ~EUR 540)
  - Gold on glass, 180 finger pairs, 5 um gaps
  - 10 x 6 x 0.75 mm (much smaller than DRP-220AT)

MIP fabrication on IDEs (different protocol):
  1. Short both IDE combs together → use as single working electrode
  2. Use external Ag/AgCl micro-reference electrode in the droplet
  3. Use external counter electrode (platinum wire, ~$10)
  4. Potentiostatic deposition at +0.8 V (NOT cyclic voltammetry)
  5. Duration: 30-45 seconds (shorter than standard SPE)
  6. Pyrrole concentration: 0.05 M (half normal — prevents gap bridging)
  7. Charge-controlled termination: stop at ~50 mC/cm² total charge
  8. Target film thickness: 50-200 nm

  CRITICAL: Verify after deposition with impedance check.
  Shorted IDE (gap bridging) = near-zero impedance = electrode destroyed.

EIS sensing mode (firmware addition):
  The AD5941 already supports EIS — no hardware change needed.

  Start simple: single-frequency impedance at 100 Hz
  1. Apply 10 mV AC excitation at 100 Hz via HSDAC
  2. Measure impedance magnitude via DFT engine
  3. Compare before/after cortisol exposure
  4. Change in impedance = cortisol concentration

  Advanced: 3-5 point frequency sweep (10 Hz, 100 Hz, 1 kHz, 10 kHz)
  - Extract charge transfer resistance (Rct) via Randles circuit fit
  - iPhone app handles the math (compute-heavy, not firmware-heavy)

Firmware effort: ~8-10 hours development
  - New functions: potentiostat_runEIS(), potentiostat_configDFT()
  - HSDAC sine wave generation
  - DFT result readback and impedance calculation
  - Frequency sweep sequencer

Expected improvement:
  - Detection limit: ~1 pM (vs ~1 nM with chronoamperometry)
  - Faster measurements: 5-30 seconds (vs 65 seconds)
  - Lower drift from temperature changes
  - Label-free (no redox probe needed)
```

**When to use:** If standard SPE + chronoamperometry fundamentally can't resolve physiological cortisol concentrations in sweat, even after optimizing film thickness and monomer choice.

---

## Failure 5: Poor Reproducibility Between Electrodes

### How you know

You fabricate 5 MIP electrodes with the same protocol. Their calibration curves have different slopes, intercepts, or baselines — more than 20% variation between nominally identical sensors.

### Escalation ladder

#### Rung 1: Control pyrrole freshness (no cost)

Pyrrole oxidizes on contact with air. A partially oxidized bottle produces inconsistent films.

```
Protocol:
1. Check pyrrole colour. Must be pale yellow. 
   If brownish → discard and open fresh.
2. After opening, aliquot into small vials (1-2 mL each),
   flush the headspace with nitrogen or argon if available,
   cap tightly, and refrigerate.
3. Use each aliquot only once, then discard.
4. Total shelf life after opening: ~2-4 weeks refrigerated in
   sealed, headspace-flushed vials. Discard at first sign of
   browning.
```

#### Rung 2: Use charge-controlled deposition (no cost)

Instead of running a fixed number of CV cycles (which deposits a variable amount depending on solution freshness, temperature, and electrode variability), terminate based on total charge passed.

```
Protocol:
1. During CV, monitor the total integrated charge
   (many potentiostat software packages display this)
2. Set a target: e.g., 30-50 mC/cm² for pyrrole on gold
3. Stop CV when the target charge is reached, regardless of 
   how many cycles that takes
4. This produces more consistent film thickness across electrodes

If your potentiostat doesn't display charge:
  - Record the current at the end of each cycle
  - Stop when the peak current stabilises (stops growing)
  - Typically 8-12 cycles for pyrrole, 18-25 for oPD
```

#### Rung 3: Pre-clean electrodes before fabrication (15 minutes, no cost)

Surface contamination from manufacturing or handling causes variable deposition.

```
Protocol:
1. Electrochemical cleaning: run 10 CV cycles in 0.5 M H2SO4
   from -0.2 V to +1.2 V at 100 mV/s
   (this strips organic contaminants from the gold surface)
2. Rinse with distilled water
3. Air dry 5 minutes
4. Immediately proceed with MIP fabrication

If you don't have H2SO4:
  - Soak electrodes in ethanol for 10 minutes
  - Rinse with distilled water
  - Air dry
  - Less effective than electrochemical cleaning but helps
```

#### Rung 4: Switch to oPD (more reproducible polymer)

oPD electropolymerization is slower and more controllable than pyrrole. The resulting films are more uniform in thickness and cavity density.

---

## Failure 6: On-Body Readings Don't Correlate With Saliva Tests

### How you know

You complete personal calibration (3 saliva points), but subsequent CortiPod readings don't track with saliva cortisol — morning isn't consistently highest, or readings don't follow the expected diurnal curve.

### Escalation ladder

#### Rung 1: Verify bench calibration still holds (1 hour)

Before blaming on-body conditions, confirm the sensor still works on the bench.

```
Protocol:
1. Remove the sensor strip from the pod
2. Run a 3-point bench test: 0, 50, 100 ng/mL in synthetic sweat
3. Compare to original bench calibration

If bench results match original:
  → Problem is on-body (proceed to Rung 2)

If bench results have degraded:
  → Sensor strip has degraded. Replace and recalibrate.
```

#### Rung 2: Recalibrate with more saliva points (1-3 days, ~$100-150)

3 calibration points may not be enough if your personal sweat-to-saliva ratio is nonlinear.

```
Protocol:
1. Order 5-7 saliva cortisol kits
2. Over 2-3 days, take simultaneous CortiPod + saliva measurements:
   - 2 morning readings (6-8 AM)
   - 2 midday readings (12-2 PM)
   - 2 evening readings (8-10 PM)
   - 1 post-exercise reading (if possible)
3. Enter all results into the app calibration view
4. The app re-fits the personal correction with more data points
```

**Why this helps:** The original 3 points assumed a linear personal correction. With 5-7 points spanning a wider range, the app can detect and correct for nonlinearity.

#### Rung 3: Check compensation sensor accuracy (30 minutes)

If temperature or humidity compensation is miscalibrated, it introduces systematic error.

```
Diagnostic:
1. Compare TMP117 reading to a known thermometer
   - Should match within ±0.5 C
   - If off by >1 C, the 2.5%/C correction is adding error
2. Compare SHT40 humidity to a known hygrometer
   - Should match within ±5% RH
3. Check GSR readings with device on vs off skin
   - On skin: should read < 500 kOhm
   - Off skin: should read > 1 MOhm
   - If the threshold is wrong, contact detection is unreliable

Fix: If TMP117 reads 2 C high, all temperature-compensated readings
are shifted. Adjust the reference temperature in the calibration
profile, or replace the sensor breakout.
```

#### Rung 4: Accept trend-only mode

If absolute ng/mL accuracy proves unreachable, pivot the product to relative trend tracking.

```
Approach:
  - Stop trying to report absolute cortisol concentrations
  - Instead, report relative changes from personal baseline:
    "Your cortisol is 40% above your daily average"
    "Your cortisol is declining as expected"
  - This requires much less calibration accuracy
  - The diurnal pattern (5-10x range from morning to evening) is
    large enough to detect even with 30-40% measurement error
  
App changes:
  - Replace ng/mL display with relative scale (Low / Normal / Elevated / High)
  - Show trend direction (rising / falling / stable)
  - Use rolling 3-day baseline as personal reference
```

**Why this is a valid outcome:** Most users want to know "am I stressed right now?" not "my cortisol is exactly 73.2 ng/mL." Trend tracking answers the useful question without requiring clinical-grade accuracy.

---

## Failure 7: Not Enough Sweat Reaching the Sensor

### How you know

The device frequently reports "No Contact" or very low GSR, even when the strap is snug and the device is clearly on skin. Readings are sparse — many 15-minute intervals are skipped. Most common in cool, dry environments or on individuals with low passive sweat rates.

### Escalation ladder

#### Rung 1: Modify wearing protocol (no cost)

```
Adjustments:
1. Wear the device during light activity (walking, housework)
   for the first 30 minutes to prime sweating
2. In cold/dry environments, wear a long sleeve over the device
   to create a warm microclimate
3. Drink water — hydration directly affects sweat rate
4. If passive sweat remains insufficient, time readings around
   physical activity periods (post-walk, post-exercise)
```

#### Rung 2: Add an occlusive patch (no cost)

Trap moisture at the sensor site to increase local humidity and sweat accumulation.

```
Protocol:
1. Cut a small piece of Tegaderm (transparent medical film, ~$5 
   for a box) or even cling film
2. Place it over the sensor area on your skin BEFORE putting on
   the CortiPod
3. The occlusive film traps transepidermal water loss, creating a
   moist microenvironment at the sensor surface
4. The CortiPod sits on top of the patch, sensing through the 
   accumulated moisture layer

Expected improvement: 3-5x increase in local moisture availability.
This is a standard technique in sweat sensing research.
```

#### Rung 3: Reduce sensor surface area requirements (weeks, ~EUR 540)

Switch to IDE electrodes. The MicruX ED-IDE3-Au needs only 2-10 uL of sample volume and has a 3.5 mm cell diameter (vs 4 mm for DRP-220AT). The smaller sensing area means less sweat is needed.

#### Rung 4: Add iontophoretic sweat stimulation (significant complexity)

This is how clinical sweat testing (e.g., cystic fibrosis chloride test) generates sweat on demand. It uses a small current to drive pilocarpine (a sweat-stimulating drug) into the skin.

```
Concept:
1. A small patch containing pilocarpine gel is placed on the skin
2. A mild current (0.5-1.5 mA for 5 minutes) drives pilocarpine
   into the sweat glands via iontophoresis
3. Localised sweating begins within 5-10 minutes
4. The CortiPod sensor then reads from the stimulated sweat

Hardware addition:
  - Second set of skin electrodes (can share GSR pads with switching)
  - Constant-current source (~0.5 mA) — the AD5941's LPDAC could 
    potentially drive this
  - Pilocarpine gel patches (medical supply, ~$1-3 per patch)

Firmware addition:
  - Iontophoresis mode: apply constant current for 5 minutes
    before each measurement cycle
  - ~2-4 hours firmware development

Regulatory note: Pilocarpine iontophoresis is FDA-cleared for sweat
stimulation (Macroduct system). It is safe at the currents used.
```

**When to use:** Only if passive sweating fundamentally cannot deliver enough fluid in your target use case. This adds significant complexity and cost, but it solves the sweat availability problem definitively.

---

## Nuclear Options — Full Approach Pivots

If multiple failures compound and the MIP + chronoamperometry approach fundamentally doesn't work on-body, these are complete alternative sensing strategies that reuse most of the existing hardware.

### Nuclear Option A: Aptamer-Based Sensor (replaces MIP)

Replace the MIP polymer with a cortisol-specific DNA aptamer tethered to the electrode surface.

```
What changes:
  - Electrode surface chemistry: thiolated aptamer self-assembled
    monolayer on gold (replaces polypyrrole MIP entirely)
  - Sensing mechanism: aptamer folds around cortisol, changing
    electron transfer distance → measurable current change
  - Same AD5941 potentiostat, same chronoamperometry
  - Same compensation sensors, same app

Advantages over MIP:
  - Higher specificity (aptamers are selected for cortisol binding)
  - Better reproducibility (synthetic DNA is manufactured to spec)
  - Faster response (<1 minute)
  - Well-published for wearable cortisol sensing

Disadvantages:
  - Aptamers are expensive (~$200-500 for custom synthesis)
  - Requires thiol-gold chemistry for immobilization
  - Less mechanically robust than polypyrrole (sensitive to pH extremes)
  - Shorter shelf life (DNA degrades over weeks)

Effort: ~2-3 weeks to source materials and develop new fabrication protocol.
Hardware changes: None (same electrode, same potentiostat).
```

### Nuclear Option B: Commercial Enzyme Electrode (replaces entire sensor strip)

Use a pre-made cortisol enzyme immunoassay adapted for electrochemical readout.

```
What changes:
  - Replace MIP strip with a commercial cortisol-antibody-coated electrode
  - Sensing mechanism: competitive immunoassay on the electrode surface
  - Requires enzyme label (HRP) and substrate (TMB) — adds consumable liquids
  - Same AD5941 for electrochemical readout

Advantages:
  - Gold-standard selectivity (antibody-based)
  - Commercial kits exist (adapted from ELISA)

Disadvantages:
  - NOT continuous — each measurement consumes reagent
  - Requires liquid handling on-device (very complex for a wearable)
  - Single-use per electrode
  - Probably not practical for a wearable — included for completeness
```

### Nuclear Option C: Optical Sensing (replaces entire measurement system)

Replace electrochemical sensing with fluorescence-based detection.

```
What changes:
  - Replace AD5941 potentiostat with LED + photodiode
  - Use fluorescently-labelled cortisol aptamer on the sensor surface
  - Cortisol binding changes fluorescence intensity
  - iPhone camera could potentially serve as the detector

Advantages:
  - No electrochemistry → no fouling of electrode surfaces
  - Potentially simpler signal chain
  - Phone camera as detector eliminates custom electronics

Disadvantages:
  - Completely different hardware (LED, optical filter, detector)
  - Ambient light interference
  - Photobleaching of fluorescent labels
  - Much less published literature for wearable format
  - Essentially a new project

Effort: Not recommended unless electrochemistry is abandoned entirely.
```

---

## Decision Flowchart

```
START: Fabricate MIP + NIP on DRP-220AT with pyrrole (10 CV cycles)
  │
  ├─ Bench test: dose response?
  │    │
  │    ├─ YES (R² > 0.95, IF > 2) ──────────────────────────────────┐
  │    │                                                              │
  │    └─ NO                                                          │
  │         ├─ Extend wash (30 min) ──→ retest                       │
  │         ├─ Reduce cycles (5-7) ──→ retest                        │
  │         ├─ Switch to oPD ──→ retest                               │
  │         ├─ Try IDE + EIS ──→ retest                               │
  │         └─ Consider aptamer (Nuclear A)                           │
  │                                                                    │
  ▼                                                                    │
  On-body test: signal stable >4 hours?  ◄─────────────────────────────┘
  │
  ├─ YES ──────────────────────────────────────────────────────────┐
  │                                                                 │
  └─ NO (fouling)                                                   │
       ├─ Extended overoxidation ──→ retest                        │
       ├─ Add Nafion ──→ retest                                     │
       ├─ Add PU membrane ──→ retest                                │
       └─ Nafion + PU stack ──→ retest                              │
                                                                     │
  On-body test: readings correlate with saliva?  ◄──────────────────┘
  │
  ├─ YES (within 20%) ──→ SUCCESS: full cortisol monitor
  │
  ├─ ROUGHLY (within 40%) ──→ Recalibrate with 5-7 points
  │                            └─→ Accept trend-only mode if needed
  │
  └─ NO
       ├─ Verify bench still works ──→ if not, replace strip
       ├─ Check compensation sensors ──→ fix offsets
       ├─ More calibration points (5-7) ──→ retest
       └─ Accept trend-only mode (relative changes, not ng/mL)
```

---

## Contingency Parts to Pre-Order

Order these alongside your primary Phase 1 materials so they're on hand if needed, avoiding 1-2 week shipping delays when a fallback is triggered.

| Item | Why | Cost | Supplier |
|------|-----|------|----------|
| Nafion 5% dispersion, 100 mL (cat. 510211) | Anti-fouling membrane, Rung 2 of Failure 3 | ~$50 | Sigma-Aldrich |
| oPD (o-Phenylenediamine), 5 g (cat. P23938) | Backup monomer if pyrrole fails | ~$35 | Sigma-Aldrich |
| Extra DRP-220AT electrodes (+10 beyond minimum) | Spares for re-fabrication attempts | ~$50-80 | Metrohm DropSens |
| BSA powder, 10 g (cat. A7906) | Blocking agent for Failure 2, Rung 5 | ~$20 | Sigma-Aldrich |
| Tegaderm transparent film dressing (box) | Occlusive patch for Failure 7, Rung 2 | ~$8 | Amazon / pharmacy |

**Total contingency budget: ~$165-195**

These items have long shelf lives (months to years) and cover the most likely failure modes. If none are needed, the Nafion and BSA are useful for sensor optimization regardless.
