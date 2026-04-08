# Interdigitated Electrodes (IDEs) for CortiPod — Research Reference

> Researched 2026-04-07. Context: The DRP-220AT standard SPE has a 4mm diameter working electrode (~12.6 mm²), which may be too small for reliable cortisol detection from passive sweat. IDEs are a potential upgrade path that dramatically increases sensitivity.

---

## What Are IDEs?

An interdigitated electrode consists of two interlocking comb-shaped electrode arrays on a single substrate. Each comb has N fingers of width W, separated by gaps of spacing S. The two combs interleave so that each finger of comb A sits between two fingers of comb B.

The key advantage: hundreds of finger edges packed into a small footprint create a concentrated electric field right at the surface where MIP binding occurs. This enables **impedimetric (EIS) sensing**, which detects cortisol binding directly through dielectric changes — no redox probe needed.

## Why IDEs Matter for Cortisol Sensing

### Sensitivity Comparison

| Parameter | Chronoamperometry + Standard SPE | EIS + IDE |
|---|---|---|
| Detection limit (MIP cortisol) | ~1 nM (typical literature) | ~1 pM (1000x better) |
| Label/probe required? | Often needs redox probe (ferricyanide) | No — label-free, non-faradaic |
| Measurement time | 60s | 5-30s for a frequency sweep |
| Power consumption | Moderate (constant current) | Lower (brief AC excitation) |
| Signal interpretation | Simple (current vs time) | More complex (impedance magnitude + phase) |
| Drift susceptibility | High (baseline current drifts with temperature) | Lower (impedance ratio is more stable) |
| MIP mechanism | Cortisol blocks diffusion of redox probe to electrode | Cortisol binding changes local dielectric — directly detected |

### Why the Improvement?

With chronoamperometry, you indirectly detect cortisol by measuring how much it blocks a redox probe from reaching the electrode. With impedimetric sensing on IDEs, you directly detect the binding event itself through dielectric changes in the concentrated electric field between the 5 um fingers. This is why the detection limit improves by ~3 orders of magnitude.

Sweat cortisol ranges from ~8-140 ng/mL (22-386 nM). Both methods can detect within this range, but EIS + IDE offers much more headroom, especially at low sweat rates.

## AD5941 EIS Capability

**The AD5941 already in the CortiPod design natively supports EIS.** No hardware change needed.

- Frequency range: 0.015 Hz to 200 kHz
- Excitation: Programmable sine wave via 12-bit HSDAC
- Measurement: High-speed TIA, 16-bit ADC
- Built-in DFT engine for impedance calculation
- Impedance range: ~100 ohms to >10 Mohms
- Supports 2-electrode mode (perfect for IDEs)
- Can run frequency sweeps autonomously while nRF52832 sleeps
- Reference design: Analog Devices CN0510

Firmware would need new functions for DFT configuration, frequency sweep, and impedance readback, but the hardware is already there.

## Best Commercial IDE Option

### MicruX ED-IDE3-Au (Recommended)

| Spec | Value |
|---|---|
| Material | Gold (Ti/Au thin film) |
| Substrate | Glass, 0.75mm thick |
| Finger width | 5 um |
| Gap | 5 um |
| Finger pairs | 180 |
| Dimensions | **10 x 6 x 0.75 mm** |
| Cell diameter | 3.5 mm |
| Sample volume | 2-10 uL |
| Layer thickness | 50 nm Ti / 150 nm Au |
| Passivation | SU8/PI available |
| Price | ~EUR 10/electrode (50-pack, ~EUR 500-540 total) |
| Supplier | MicruX Technologies (micruxfluidic.com) |

**Significantly smaller than DRP-220AT** (10x6mm vs 33.8x10.2mm). The pod could shrink, or two MicruX IDEs (MIP + NIP) could fit in the space of one DRP-220AT.

### Other Options

| Part | Material | Substrate | Lines/Gaps | Dimensions | Notes |
|---|---|---|---|---|---|
| DropSens DRP-G-IDEAU5-U20 | Gold | Glass | 5 um | 22.9 x 7.6 x 0.7 mm | Larger format, fits CortiPod |
| DropSens DRP-G-IDEAU10-U20 | Gold | Glass | 10 um | 22.9 x 7.6 x 0.7 mm | Good balance |
| DropSens DRP-IDEAU200-U50 | Gold | Ceramic | 200 um | 22.9 x 7.6 x 1.0 mm | Coarser, sturdier |
| DropSens DRP-P-IDEAU50-U50 | Gold | Polymer | 50 um | Smaller | Flexible substrate |
| MicruX ED-IDE1-Au | Gold | Glass | 10/10 um | 10 x 6 x 0.75 mm | 90 pairs, lower sensitivity |
| MicruX ED-IDE2-Au | Gold | Glass | 10/5 um | 10 x 6 x 0.75 mm | 120 pairs |

## MIP Fabrication on IDEs

### Key Differences from Standard 3-Electrode SPE Protocol

**It works, but the protocol needs adjustment:**

1. **Electrode connection for electropolymerization:**
   - Short both IDE combs together → use as single WE
   - Use external Ag/AgCl micro-reference electrode in the droplet
   - Use external CE (platinum wire)
   - This deposits MIP on both combs simultaneously

2. **Deposition parameters (adjusted for IDEs):**
   - **Method:** Potentiostatic at +0.8V (NOT cyclic voltammetry — harder to control on IDEs)
   - **Duration:** 30-45 seconds (shorter than standard SPE)
   - **Pyrrole concentration:** 0.05 M (half of normal — reduces bridging risk)
   - **Charge-controlled termination:** Stop at ~50 mC/cm² total charge
   - **Target film thickness:** 50-200 nm (much thinner than on standard SPEs)

3. **Critical risk — gap bridging:**
   - If polypyrrole grows too thick, it bridges across the 5 um gap between fingers
   - This SHORTS the IDE, destroying it
   - Mitigations: charge-controlled deposition, short time, dilute monomer
   - Verify with impedance measurement after deposition (shorted IDE = near-zero impedance)

4. **Template removal:** Same ethanol:acetic acid wash. Thin MIP film on IDE fingers actually allows faster/more complete template removal due to higher surface-to-volume ratio.

## Sensing Mode: Single-Frequency vs Sweep

For simplicity, start with **single-frequency impedance tracking at 100 Hz:**
- Measure impedance magnitude at 100 Hz before and after cortisol exposure
- The change in impedance correlates to cortisol concentration
- This is the simplest EIS approach — one measurement, one number

For better accuracy, do a **3-5 point frequency sweep** (e.g., 10 Hz, 100 Hz, 1 kHz, 10 kHz):
- Fit to a Randles equivalent circuit
- Extract charge transfer resistance (Rct), which correlates to cortisol binding
- More robust against drift and confounders
- The iPhone app handles the fitting (computational, not hardware-limited)

## Tradeoffs

### Advantages
- ~1000x better detection limit for cortisol
- Label-free (no redox probe needed in sweat)
- Faster measurements (5-30s vs 60s)
- Lower drift from temperature changes
- Smaller footprint (10x6mm vs 33.8x10.2mm)
- AD5941 already supports EIS — no hardware change

### Disadvantages
- Glass substrate is fragile (0.75mm) — handle carefully during MIP fabrication
- MIP deposition is trickier (risk of gap bridging, need charge-controlled termination)
- Only 2 electrode pads (pogo pin layout simplifies from 3 to 2 per electrode)
- Signal processing is more complex (impedance vs simple current)
- No integrated reference electrode (fine for EIS, but can't run amperometry as backup)
- Minimum order: 50-pack (~EUR 500-540)
- Learning curve for EIS measurement and data interpretation

## Impact on CortiPod Enclosure Design

The current ledge-based channel design accommodates IDEs by changing parameters:

```
// For MicruX ED-IDE3-Au (10 x 6 x 0.75 mm):
electrode_length     = 10.0;    // much shorter
electrode_width      = 6.0;     // narrower
electrode_thickness  = 0.75;    // slightly thicker (glass)
electrode_pad_length = 2.0;     // shorter connector tail
spring_contacts_per_elec = 2;   // only 2 pads (Comb A, Comb B)
```

The pod could potentially shrink from 44x26mm to ~25x18mm with IDE electrodes — closer to a Whoop 5.0 form factor.

## Recommended Approach

1. **Start with DRP-220AT** — validate MIP fabrication protocol on standard SPEs first (more literature, more forgiving, fewer wasted electrodes)
2. **Order MicruX ED-IDE3-Au 50-pack** (~EUR 540) — once MIP works on standard SPEs, adapt protocol to IDEs
3. **Add EIS firmware function** — the AD5941 already supports it; start with single-frequency 100 Hz
4. **Compare sensitivity** — run both electrode types against known cortisol concentrations
5. **If IDE wins** (likely) — update `parameters.scad` dimensions and potentially shrink the pod

## Sources

- [Development of Cortisol Sensors with Interdigitated Electrode Platforms (2025)](https://www.mdpi.com/1424-8220/25/11/3346)
- [MicruX Interdigitated Electrodes](https://www.micruxfluidic.com/product/interdigitated-electrodes-ide/)
- [MicruX IDE Datasheet](https://www.micruxfluidic.com/wp-content/uploads/MicruX_thin-film_IDE_electrodes.pdf)
- [DropSens/Metrohm Interdigitated Electrodes](https://metrohm-dropsens.com/category/electrodes/interdigitated-electrodes/)
- [AD5941 Product Page](https://www.analog.com/en/products/ad5941.html)
- [CN0510 EIS Reference Design](https://www.analog.com/en/resources/reference-designs/circuits-from-the-lab/cn0510.html)
- [Polypyrrole on Gold IDEs (Kremers 2020)](https://onlinelibrary.wiley.com/doi/full/10.1002/pssa.201900827)
- [Polypyrrole on Disposable Electrodes (2024)](https://www.dlsu.edu.ph/wp-content/uploads/pdf/conferences/research-congress-proceedings/2024/SEE-25.pdf)
- [IDE Geometry Optimization for Biosensors](https://www.sciencedirect.com/science/article/pii/S2590137024000438)
- [Impedimetric vs Amperometric MIP Cortisol Comparison](https://www.sciencedirect.com/science/article/pii/S2095927325003901)
- [Wearable MIP Cortisol Sensor (2025)](https://pmc.ncbi.nlm.nih.gov/articles/PMC11940103/)
- [MIP Cortisol Sensor with CNT (2024)](https://www.nature.com/articles/s41528-024-00333-z)
