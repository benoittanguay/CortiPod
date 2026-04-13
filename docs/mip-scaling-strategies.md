# MIP Fabrication — Scaling Strategies

> How to go from making one electrode at a time to producing batches of 10, 50, or 100+ MIP sensor strips efficiently.

---

## Table of Contents

1. [Current Bottlenecks](#current-bottlenecks)
2. [Level 1: Simple Batch Improvements (2-4x throughput)](#level-1-simple-batch-improvements)
3. [Level 1.5: Batch Immersion Electropolymerization (8-20x throughput)](#level-15-batch-immersion-electropolymerization)
4. [Level 2: Multi-Channel Electropolymerization (8-16x additional throughput)](#level-2-multi-channel-electropolymerization)
5. [Level 3: Panel Electrodes — PCB Batch Fabrication (50-100x throughput)](#level-3-panel-electrodes)
6. [Level 4: Dip-Coating MIP Alternative (100x+ throughput)](#level-4-dip-coating-mip)
7. [Level 5: Roll-to-Roll and Industrial Scale](#level-5-roll-to-roll)
8. [Scaling the Wash Step](#scaling-the-wash-step)
9. [Scaling Quality Control](#scaling-quality-control)
10. [Scaling Roadmap](#scaling-roadmap)

---

## Current Bottlenecks

The current protocol produces **one electrode at a time**. Here's where the time goes:

```
Per-electrode timeline (single unit):

  Pipette MIP solution onto electrode        1 min
  Connect alligator clips                    1 min
  Run CV (10 cycles at 50 mV/s)             5 min
  Overoxidation (1-5 cycles)                0.5-2 min
  Disconnect clips, rinse                    2 min
  ─────────────────────────────────────────
  Subtotal per electrode (active):          ~10 min

  Wash in ethanol:acetic acid              15-20 min  ← can be batched
  PBS rinse + DI rinse + dry                 5 min    ← can be batched
  ─────────────────────────────────────────
  Total wall-clock per electrode:           ~35 min
```

**To make 20 electrodes (10 MIP + 10 NIP) at this rate: ~12 hours.**

The bottlenecks, in order:

1. **Single-channel potentiostat** — the AD5941 eval board (or any single-channel unit) can only drive one electrode at a time during electropolymerization
2. **Manual connections** — clipping alligator leads onto each electrode one at a time
3. **Solution handling** — pipetting 100 µL onto each electrode individually
4. **Sequential CV runs** — 5 minutes per electrode, fully blocking

The wash step is already batch-friendly — you can immerse 10 electrodes in the same vial of wash solution simultaneously.

---

## Level 1: Simple Batch Improvements (2-4x throughput)

**Cost: $0-50. No new equipment.**

These are workflow optimizations that require no new hardware.

### 1a: Pipeline the wash step

Instead of completing one electrode start-to-finish before starting the next, overlap the CV and wash phases:

```
Timeline for 4 electrodes (pipelined):

  Electrode 1: [CV 5min][overox 2min][rinse 2min]
  Electrode 2:          [CV 5min][overox 2min][rinse 2min]
  Electrode 3:                   [CV 5min][overox 2min][rinse 2min]
  Electrode 4:                            [CV 5min][overox 2min][rinse 2min]
                                                              ↓
  All four:                                         [    BATCH WASH 20min    ]
                                                    [rinse + dry 5min]

  Total: ~30 min for 4 electrodes (vs ~140 min sequential)
  Throughput: ~8 electrodes/hour
```

While electrode 2 is running CV, electrode 1 is sitting with its rinse, waiting for the batch wash. The potentiostat is never idle.

### 1b: Pre-dispense solution onto multiple electrodes

Instead of pipetting solution onto one electrode and immediately running CV, prepare a batch:

```
1. Lay out 4-8 electrodes on a clean surface
2. Pipette 100 µL of MIP solution onto each electrode
3. Cover loosely with plastic wrap (prevents evaporation)
4. The cortisol-pyrrole pre-complexation continues while 
   electrodes wait — this is beneficial, not harmful
5. Connect and run CV on each electrode in sequence
```

The pre-complexation time (pyrrole + cortisol interacting before polymerization) is 30 minutes in the standard protocol. By pre-dispensing solution onto a batch and letting it sit, you're getting useful pre-complexation time on later electrodes for free while earlier ones are running CV.

### 1c: Standardize clip-on time with a jig

Build a simple alignment jig from foam board or 3D-printed plastic that holds the electrode in position and guides the alligator clips to the correct pads. This reduces per-electrode connection time from ~60 seconds of fumbling to ~15 seconds of clip-on.

```
Simple jig (make from foam board):

  ┌────────────────────────────┐
  │  Electrode sits in groove  │
  │  ┌──────────────────────┐  │
  │  │  ● WE   ● CE   ● RE │  │  ← Electrode pads aligned
  │  └──────────────────────┘  │
  │     ↑       ↑       ↑     │
  │   slot    slot    slot     │  ← Clip guides
  └────────────────────────────┘
```

---

## Level 1.5: Batch Immersion Electropolymerization (8-20x throughput)

**Cost: ~$45-100 one-time. Same chemicals, same potentiostat, electropolymerization quality at dip-coating throughput.**

This is the single most impactful scaling step. Instead of pipetting solution onto one electrode at a time, you immerse 8-20 electrodes in a shared MIP solution bath and wire all their working electrodes in parallel to one potentiostat output. Each electrode polymerizes simultaneously with the same film quality as individual fabrication.

### Setup

```
                Potentiostat
               WE    CE    RE
                │     │     │
    ┌───────────┼─────┼─────┼───────────┐
    │           │     │     │           │
    │    ┌──┬──┬┘     │     └┐         │
    │    │  │  │      │      │         │
    │   E1 E2 E3      Pt     Ag/AgCl   │
    │   WE WE WE    wire    ref elec   │
    │    │  │  │      │      │         │
    │    └──┴──┴──────┴──────┘         │
    │                                   │
    │     MIP solution (50-100 mL)      │
    │                                   │
    └───────────────────────────────────┘
              Glass beaker
```

All electrode WE pads are wired in parallel (twist leads together at a terminal block). A single external platinum wire serves as the shared counter electrode, and a single external Ag/AgCl reference electrode is shared by all. The potentiostat applies the same voltage to all working electrodes simultaneously — each one polymerizes independently at its own surface.

### What you need beyond current BOM

| Item | Cost | Notes |
|------|-----:|-------|
| External Ag/AgCl reference electrode | ~$20-50 | Reusable. Cannot use the printed RE on each SPE when immersed. One proper reference in the solution serves all. |
| Platinum wire (0.5mm, 10cm) | ~$15-30 | Counter electrode. Large surface area relative to the sum of all WEs. Reusable indefinitely. |
| Glass beaker (100-250 mL) | ~$5 | To hold the MIP solution bath |
| Electrode rack/holder | ~$0-10 | Holds electrodes upright with even spacing. A slotted foam block, PCR tube rack, or 3D-printed holder. |
| Terminal block or wire nuts | ~$3 | To join all WE leads together cleanly |

**Total: ~$45-100 one-time. Reusable indefinitely.**

### Protocol

```
Batch immersion electropolymerization (8-20 electrodes):

1. Prepare MIP solution at standard concentration, scaled up:
   - 50 mL PBS
   - 345 µL pyrrole (0.1 M)
   - 18 mg cortisol (1 mM)
   - Wait 30 minutes for pre-complexation

2. Pour into glass beaker

3. Mount 8-20 electrodes in the rack, sensing face down,
   immersed in the solution with ~5 mm spacing between them

4. Connect all WE pads in parallel to potentiostat WE output
   (twist wires together at a terminal block)

5. Lower the Pt wire counter electrode into the solution
   Connect to potentiostat CE output

6. Lower the Ag/AgCl reference electrode into the solution
   Connect to potentiostat RE output

7. Run CV:
   -200 mV to +800 mV, 50 mV/s, 10 cycles
   (~5 minutes)
   
   Monitor total current — should be roughly N × single-electrode
   current. If it's much lower, one or more electrodes may have
   a bad connection.

8. Run overoxidation:
   -200 mV to +1100 mV, 50 mV/s, 1-5 cycles
   (~30 seconds to 2 minutes)

9. Remove rack from solution
   Rinse all electrodes with PBS (pour or squirt bottle)

10. Transfer entire rack to wash container:
    ethanol:acetic acid 9:1, 20 minutes

11. PBS rinse, DI water rinse, air dry

Total time: ~35 minutes for 20 electrodes
vs ~12 hours making them one at a time
```

### Current compliance

The potentiostat must supply N times the single-electrode current. If each electrode draws ~50 µA during CV, 20 electrodes in parallel draw ~1 mA total. The AD5941 eval board handles this easily — its compliance current is several mA.

### Film uniformity across the batch

Electrodes near the center of the beaker may get slightly less monomer replenishment than those at the edges, because the electrodes compete for pyrrole in the local solution. Mitigations:

- **Space electrodes at least 5 mm apart** — reduces local depletion competition
- **Gently stir the solution** during CV — magnetic stir bar at low speed, or manual swirling between cycles
- **Use excess solution** — 50 mL for 20 electrodes means each electrode's consumption (~0.1 mL equivalent) is negligible relative to the total volume
- **Use charge-controlled termination** — monitor total charge passed, divide by N, stop when per-electrode charge reaches your target (~30-50 mC/cm²)

Expect ±10-20% film thickness variation across a batch. This is acceptable — each electrode gets its own lab calibration, which absorbs the variation.

### Compared to other approaches

| Factor | Single electrode (current) | Batch immersion | Dip-coat (Level 4) |
|--------|:---:|:---:|:---:|
| Film quality | Best | Same as single | Lower (~30-50% less sensitivity) |
| Film adhesion | Excellent | Excellent (grown in situ) | Moderate (particles on surface) |
| Throughput | 1/hour | 8-20/hour | 50-100/batch |
| Equipment | Potentiostat + clips | + beaker, Pt wire, Ag/AgCl ref | No potentiostat needed |
| Extra cost | $0 | ~$45-100 one-time | $0 |

**This is the recommended first scaling step.** It gives you electropolymerization quality at near-dip-coating throughput, with minimal investment.

---

## Level 2: Multi-Channel Electropolymerization (8-16x additional throughput)

**Cost: $50-500. Requires additional hardware.**

If Level 1.5 batch immersion isn't enough (e.g., you need to run MIP and NIP batches simultaneously, or you want to test multiple monomer concentrations in parallel), adding more potentiostat channels multiplies throughput further.

### 2a: Multiple potentiostats

Run 2-4 independent potentiostat channels simultaneously, each driving its own electrode.

**Options:**

| Solution | Cost | Channels | Notes |
|----------|-----:|:--------:|-------|
| 2x AD5941 eval boards | ~$640 CAD | 2 | Each runs independently. Two USB connections, two software instances. Simple but inelegant. |
| PalmSens MultiEmStat3+ | ~$2,000-4,000 | 4-12 | Purpose-built multi-channel potentiostat. Runs synchronized CV on all channels. Professional solution. |
| Open-source CheapStat (DIY) | ~$50-100 each | 1 per unit | Build 4 for ~$200-400. Arduino-based. Lower precision but adequate for electropolymerization. |
| AD5941 on your custom PCB (x4) | ~$60 (4x AD5941 chips) | 4 | Design a multi-channel board. The AD5941 is ~$15/chip. Four chips on one PCB, each with independent SPI CS. |

### 2c: Multiplexed single potentiostat with relay switching

Use one potentiostat but rapidly switch between electrodes using relays or an analog multiplexer.

```
                  ┌──── Relay 1 ──── Electrode 1
  Potentiostat ───┼──── Relay 2 ──── Electrode 2
  WE output       ├──── Relay 3 ──── Electrode 3
                  └──── Relay 4 ──── Electrode 4

  Microcontroller controls which relay is closed.
  Cycle: close relay 1 → run 1 CV cycle → open relay 1 → 
         close relay 2 → run 1 CV cycle → open → ...
  Repeat for 10 rounds = 10 cycles per electrode.
```

**Trade-off:** Each electrode gets intermittent CV pulses rather than continuous cycling. This is actually fine — the literature shows that pulsed electropolymerization can produce MIP films of equal or better quality than continuous CV, because the pause allows monomer diffusion replenishment at the electrode surface.

**Materials:** ~$10 for a 4-channel relay module + Arduino/nRF52 GPIO to control it.

---

## Level 3: Panel Electrodes — PCB Batch Fabrication (50-100x throughput)

**Cost: $5-30 for a panel of 20-50 electrodes. Requires KiCad design work.**

This builds on the custom PCB electrode concept. Instead of individual 12x10mm electrode boards, design a **panelized PCB** with multiple electrodes in a single board that can be snapped apart after MIP fabrication.

### Design concept

```
Panel PCB (100 x 80 mm, fits standard JLCPCB sizing):

  ┌─────┬─────┬─────┬─────┬─────┐
  │  E1 │  E2 │  E3 │  E4 │  E5 │
  ├─────┼─────┼─────┼─────┼─────┤
  │  E6 │  E7 │  E8 │  E9 │ E10 │
  ├─────┼─────┼─────┼─────┼─────┤
  │ E11 │ E12 │ E13 │ E14 │ E15 │
  ├─────┼─────┼─────┼─────┼─────┤
  │ E16 │ E17 │ E18 │ E19 │ E20 │
  └─────┴─────┴─────┴─────┴─────┘
        V-score or mouse-bite perforations
        between each electrode for snap-apart

  Each cell: 20 x 20 mm (generous spacing)
  Each has: WE pad (front), CE pad (front), RE pad (front)
            Contact pads (back, connected via vias)
  
  Common bus traces connect all WE pads together along the panel edge
  → Dip entire panel in MIP solution
  → Connect potentiostat to the WE bus
  → All 20 electrodes polymerize simultaneously
  → Snap apart after fabrication
```

### Why this is powerful

1. **JLCPCB manufactures 5 copies of the panel for ~$5-15 CAD** — that's 100 electrode blanks
2. **Gold electrodeposition can be done on the entire panel at once** — dip the whole board in HAuCl4 solution
3. **MIP electropolymerization runs on all 20 electrodes simultaneously** via the common WE bus
4. **The wash step handles the whole panel** — immerse in ethanol:acetic acid
5. **Snap apart individual electrodes** after all fabrication is complete

**Per-electrode cost: ~$0.10-0.30 for the PCB substrate.**

### Fabrication protocol for panel

```
1. Order panel PCBs from JLCPCB (ENIG finish, V-score between cells)

2. Gold electrodeposition (entire panel):
   - Immerse panel in HAuCl4/H2SO4 solution (large enough container)
   - Connect potentiostat WE to panel's common WE bus
   - External CE (platinum mesh, large area) and RE (Ag/AgCl)
   - Apply -0.2V for 120 seconds
   - All 20 WE pads deposit gold simultaneously
   - Rinse, dry

3. Paint Ag/AgCl reference electrodes:
   - Apply Ag/AgCl ink to each RE pad with a fine brush or stencil
   - Air dry, then cure per ink instructions

4. MIP electropolymerization (entire panel):
   - Prepare 50-100 mL of MIP solution (scale up from single-electrode recipe)
   - Immerse panel in MIP solution
   - Connect potentiostat to WE bus, external CE and RE
   - Run CV: 10 cycles, -200 to +800 mV, 50 mV/s
   - Run overoxidation: 1-5 cycles to +1100 mV
   - Remove panel, rinse with PBS

5. Template wash (entire panel):
   - Immerse panel in ethanol:acetic acid (9:1) for 20 minutes
   - Rinse with PBS, then DI water
   - Air dry

6. Snap apart individual electrodes
   - Break along V-score or mouse-bite perforations
   - Each electrode is now a complete MIP sensor with back contacts

Total active time for 20 electrodes: ~45 minutes
Compare to: ~12 hours for 20 electrodes one at a time
```

### Panel design considerations

- **V-score depth:** 0.3-0.4mm on a 0.8mm board for clean snapping
- **WE bus trace:** Route along the top edge of the panel, with breakable tabs to each electrode. After snapping apart, the bus trace breaks and each electrode is electrically independent.
- **Electrode spacing:** 20mm pitch gives enough room for solution circulation during immersion
- **Panel size:** 100x80mm is JLCPCB's standard size — no extra cost vs a smaller panel
- **Order 5 panels = 100 electrode blanks for ~$15 CAD total**

---

## Level 4: Dip-Coating MIP Alternative (100x+ throughput)

**Cost: $0 additional (uses same chemicals). Requires protocol adaptation.**

This is a fundamentally different fabrication approach. Instead of electropolymerizing the MIP film (which requires a potentiostat connection to each electrode), you chemically polymerize the MIP and apply it by dip-coating.

### How it works

```
Standard approach (electropolymerization):
  Electrode + pyrrole solution + electric current → polymer grows ON electrode

Dip-coating approach (chemical polymerization):
  1. Polymerize MIP in bulk solution (no electrode needed)
     - Mix pyrrole + cortisol template + oxidant (FeCl3 or APS)
     - Polymer forms as nanoparticles in solution
  2. Dip electrodes into the MIP nanoparticle suspension
  3. Let dry → MIP particles coat the electrode surface
  4. Wash out template (same ethanol:acetic acid step)
```

### Bulk MIP synthesis protocol

```
Materials:
  - Pyrrole monomer (0.1 M)
  - Cortisol template (1 mM) 
  - Ammonium persulfate (APS) as oxidant — or FeCl3
  - PBS pH 7.4

Protocol:
  1. Dissolve cortisol in PBS (1 mM, same as current protocol)
  2. Add pyrrole (0.1 M)
  3. Wait 30 minutes (pre-complexation)
  4. Add APS at 1:1 molar ratio with pyrrole
     (APS initiates chemical polymerization without electricity)
  5. Stir gently at room temperature for 2-4 hours
  6. The solution turns dark — polypyrrole-cortisol nanoparticles form
  7. Centrifuge or filter to collect particles
  8. Resuspend in DI water at 1-5 mg/mL

Dip-coating:
  1. Dip electrode into MIP suspension for 30 seconds
  2. Withdraw slowly (1 mm/second)
  3. Air dry 30 minutes
  4. Repeat 2-3 times for thicker coating
  5. Wash template: ethanol:acetic acid 9:1, 20 minutes
  6. Rinse, dry

  Coat 50-100 electrodes from one batch of MIP suspension.
```

### Trade-offs vs electropolymerization

| Factor | Electropolymerization | Dip-Coating |
|--------|:---:|:---:|
| Film adhesion | Excellent (grown directly on surface) | Moderate (particles sit on top) |
| Cavity quality | High (formed in situ on electrode) | Lower (formed in bulk, then deposited) |
| Reproducibility | Moderate (depends on CV control) | Good (same suspension, same dip) |
| Scalability | Limited by potentiostat channels | Unlimited (just dip more electrodes) |
| Equipment needed | Potentiostat per electrode | Beaker + suspension |
| Sensitivity | Higher (direct electrode contact) | Lower (~30-50% less) |
| Throughput | 1-20 per batch | 50-100+ per batch |

**When to use dip-coating:** When you need many electrodes quickly and can accept reduced sensitivity. Good for consumable strip inventory where you'll replace strips frequently anyway.

**When to stick with electropolymerization:** When maximum sensitivity matters (on-body use with marginal sweat). The direct electrode-polymer bond gives better electron transfer.

---

## Level 5: Roll-to-Roll and Industrial Scale

**Cost: $50,000+. For commercialization, not prototyping.**

Included for completeness. If CortiPod reaches a stage where you need 10,000+ electrodes:

### Screen printing on continuous film

```
Roll of polyimide or PET film
        │
        ▼
  [Screen print gold WE/CE layer]  ← Conductive gold ink
        │
        ▼
  [Screen print Ag/AgCl RE layer]  ← Reference electrode ink
        │
        ▼
  [Screen print insulation layer]  ← Defines electrode geometry
        │
        ▼
  [Roll-through MIP dip-coat tank] ← MIP nanoparticle suspension
        │
        ▼
  [Drying oven]
        │
        ▼
  [Roll-through wash tank]         ← Template removal
        │
        ▼
  [Die-cut individual electrodes]
        │
        ▼
  Finished MIP electrodes at ~$0.10-0.50 each
```

This is how glucose test strips are manufactured (billions per year). The same infrastructure works for MIP cortisol strips. Companies like Sterling Electrode and Eastprint have this equipment.

**MOQ for roll-to-roll:** Typically 10,000+ units per run. Setup cost: $10,000-50,000 for custom stencils and tooling.

---

## Scaling the Wash Step

The template removal wash is already the most batch-friendly step. Scaling tips:

### Small batch (10-20 electrodes)

```
- Use a 100 mL beaker with wash solution
- Place electrodes standing upright in a small rack 
  (a PCR tube rack works, or 3D-print a custom holder)
- Gentle agitation: place beaker on an orbital shaker ($30-50 on Amazon)
  or swirl manually every 5 minutes
- All electrodes wash simultaneously
```

### Medium batch (20-100 electrodes)

```
- Use a shallow glass dish (like a Pyrex baking dish)
- Lay electrodes flat, sensing face up, in a single layer
- Pour wash solution to cover all electrodes (~200-500 mL)
- Place on orbital shaker for 20 minutes
- Pour off wash, add PBS rinse, shake 2 minutes, pour off
- Add DI water rinse, shake 2 minutes, pour off
- Air dry on paper towels

Total time: ~30 minutes for 100 electrodes
vs ~30 minutes for 1 electrode in the current protocol
```

### Panel electrodes (Level 3)

The entire panel goes into the wash as a single unit. No electrode handling needed until snap-apart.

---

## Scaling Quality Control

As production increases, you can't run a full 9-point calibration on every electrode. Here's a QC hierarchy:

### Batch QC (test a sample from each batch)

```
From each batch of N electrodes:
  1. Randomly select 3 electrodes for testing
  2. Run a quick 3-point calibration: 0, 50, 100 ng/mL
  3. If all 3 pass (R² > 0.90, imprinting factor > 2):
     → Batch passes, all N electrodes are released
  4. If 1 fails:
     → Test 3 more. If all pass, batch is marginal — release with note.
  5. If 2+ fail:
     → Batch fails. Investigate root cause before making more.

Acceptance criteria:
  - MIP Delta_I at 100 ng/mL: > 1.5 µA (or your established threshold)
  - NIP Delta_I at 100 ng/mL: < 0.5 µA
  - Imprinting factor (MIP/NIP): > 2.0
  - R² of 3-point fit: > 0.90
```

### Quick single-electrode screening (30-second go/no-go)

For rapid screening without running a full calibration:

```
1. Apply blank synthetic sweat (0 ng/mL) → measure baseline current
2. Apply 50 ng/mL cortisol → wait 2 minutes (short incubation)
3. Measure current again
4. If current dropped by >0.5 µA → electrode is likely functional
5. If current didn't change → electrode failed, discard

This doesn't tell you the calibration curve, but it confirms the MIP 
cavities exist and respond to cortisol. Takes ~3 minutes per electrode.
```

### Visual inspection

With experience, you can visually assess electropolymerization quality:

```
Good MIP:
  - Uniform dark coating on WE (pyrrole) or brownish-orange (oPD)
  - Even coverage, no bare spots
  - Slight sheen

Bad MIP:
  - Patchy or uneven coating
  - Bare gold visible through gaps
  - Excessively thick (opaque, cracked)
  - No visible coating at all (polymerization failed)
```

---

## Scaling Roadmap

| Phase | Volume Target | Method | Cost/Unit | Throughput | When |
|-------|:---:|---|---:|---|---|
| **Now** | 4-8 electrodes | Single AD5941, pipelined wash (Level 1) | ~$7-12 | 4-8/hour | Bench validation |
| **First scale-up** | 8-20 | Batch immersion electropolymerization (Level 1.5) | ~$7-12 | 8-20/batch in 35 min | Enough strips for weeks of on-body testing |
| **After bench works** | 20-50 | Panel PCB + batch immersion (Level 1.5 + 3) | ~$0.50-2 | 20/batch in 45 min | On-body testing, spare inventory |
| **If going to users** | 100-500 | Panel PCB + shared-bath CV + orbital shaker wash | ~$0.30-1 | 50-100/batch | Beta testing, early users |
| **Commercialization** | 1,000-10,000 | Dip-coating MIP or contract manufacture (Sterling/Z&P) | ~$0.10-0.50 | 500-1000/batch | Product launch |
| **Scale** | 10,000+ | Roll-to-roll screen printing + dip-coat | ~$0.05-0.20 | Continuous | Mass production |

The key insight: **don't over-invest in scaling infrastructure before the chemistry is validated.** Level 1 (pipelined workflow) costs nothing and gets you through bench validation. Level 3 (panel PCBs) costs $15 and gets you through on-body testing. Levels 4-5 only matter if the product works and you need volume.
