# Custom Dual Electrode PCB — Fabrication & Ordering Guide

> How to order custom CortiPod dual-electrode PCBs (MIP + NIP on one board) from JLCPCB with back-side contacts, stencils for every fabrication step, and batch production workflow.

---

## Table of Contents

1. [Design Overview](#design-overview)
2. [Electrode Cell Geometry](#electrode-cell-geometry)
3. [Panelization](#panelization)
4. [Generating Gerbers](#generating-gerbers)
5. [JLCPCB Order — PCBs](#jlcpcb-order-pcbs)
6. [JLCPCB Order — Stencils](#jlcpcb-order-stencils)
7. [Additional Materials Needed](#additional-materials-needed)
8. [Step-by-Step Fabrication Workflow](#fabrication-workflow)
9. [Batch Production Using the Panel](#batch-production)
10. [Enclosure Compatibility](#enclosure-compatibility)

---

## Design Overview

Each electrode PCB carries a **complete MIP + NIP sensor assembly** on a single 22x26mm board. Two 8mm working electrodes (one for cortisol-sensing MIP, one for the NIP reference) share a common counter electrode frame and a common reference electrode. Four pogo pins on the back connect the board to the CortiPod pod.

```
FRONT (skin / sensing side):

  ┌──────────────────────┐
  │ ████████████████████ │  CE top bar (shared, 20x3mm)
  │██                  ██│  CE left side     CE right side
  │██  ╭────╮  ╭────╮ ██│
  │██  │MIP │  │NIP │ ██│  WE_MIP (8mm)     WE_NIP (8mm)
  │██  │ WE │  │ WE │ ██│  50.3 mm² each
  │██  ╰────╯  ╰────╯ ██│
  │██                  ██│  CE left side     CE right side
  │ ████████████████████ │  CE bottom bar (shared, 20x3mm)
  │        ◉ RE          │  RE (2mm, shared, Ag/AgCl via stencil)
  └──────────────────────┘
         22 x 26 mm

BACK (pogo pin / pod side):

  ┌──────────────────────┐
  │                      │
  │  ◉ WE_MIP  ◉ WE_NIP │  1.8mm contact pads
  │                      │
  │     ◉ CE    ◉ RE     │  1.8mm contact pads
  │                      │
  └──────────────────────┘
       4 pogo pins total
```

### Why this is better than two separate electrodes

| Feature | Two separate SPEs | Combined dual PCB |
|---------|:-:|:-:|
| Sensing area (total WE) | 2 x 12.6 mm² = 25.2 mm² | 2 x 50.3 mm² = **100.6 mm²** (4x more) |
| MIP/NIP environmental match | Different slots, slight offset | Same board, mm apart — **identical conditions** |
| Pogo pins needed | 6 (3 per electrode) | **4** (shared CE + RE) |
| Pod slots | 2 channels + gap | **1 slot** |
| Electrode swaps | Replace 2 strips independently | Replace 1 board |
| Firmware changes | None (already switches WE1/WE2) | None |
| Cost per sensor assembly | ~$14-24 (2 commercial SPEs) | **~$0.30-0.75** |

---

## Electrode Cell Geometry

### Front side (F.Cu — sensing face, exposed to skin/sweat)

| Pad | Net | Shape | Size | Position (from cell center) | Purpose |
|-----|-----|-------|------|:--:|---|
| WE_MIP | WE_MIP | Circle | **8.0 mm** diameter | (-5, 0) | Cortisol-sensing MIP surface |
| WE_NIP | WE_NIP | Circle | **8.0 mm** diameter | (+5, 0) | Non-imprinted reference control |
| CE top | CE | Rounded rect | 20 x 3 mm | (0, -7.5) | Shared counter electrode (top bar) |
| CE bottom | CE | Rounded rect | 20 x 3 mm | (0, +7.5) | Shared counter electrode (bottom bar) |
| CE left | CE | Rounded rect | 1.5 x 11 mm | (-9.5, 0) | Shared counter electrode (left side) |
| CE right | CE | Rounded rect | 1.5 x 11 mm | (+9.5, 0) | Shared counter electrode (right side) |
| RE | RE | Circle | 2.0 mm diameter | (0, +11) | Shared reference (Ag/AgCl via stencil) |

**CE total area:** ~170 mm² (top 60 + bottom 60 + left 16.5 + right 16.5 + connecting areas)
**WE total area:** 100.6 mm² (2 x 50.3 mm²)
**CE/WE ratio:** ~1.7 (adequate for chronoamperometry at µA-level currents)

### Back side (B.Cu — pogo pin contacts, inside pod)

| Pad | Net | Shape | Size | Position (from cell center) | Purpose |
|-----|-----|-------|------|:--:|---|
| WE_MIP contact | WE_MIP | Circle | 1.8 mm | (-4, -2) | Pogo pin landing |
| WE_NIP contact | WE_NIP | Circle | 1.8 mm | (+4, -2) | Pogo pin landing |
| CE contact | CE | Circle | 1.8 mm | (-4, +4) | Pogo pin landing |
| RE contact | RE | Circle | 1.8 mm | (+4, +4) | Pogo pin landing |

**Pogo pin pitch:** 8mm horizontal, 6mm vertical — compatible with standard 2.54mm-grid PCB layout on the main CortiPod board.

### Vias and back traces

Each front pad connects to its back contact through an offset via (0.3mm drill, 0.6mm annular ring) positioned inside the front pad area, with a short 0.5mm trace on B.Cu routing to the back contact pad.

### Bus traces (for batch fabrication)

| Bus | Layer | Position | Purpose |
|-----|-------|----------|---------|
| WE_MIP bus | F.Cu | Left edge (x=1mm), vertical | Connects all MIP WEs when panelized |
| WE_NIP bus | F.Cu | Right edge (x=21mm), vertical | Connects all NIP WEs when panelized |
| MIP bus pad | F.Cu | Top-left (1, 1) | Alligator clip connection for MIP batch CV |
| NIP bus pad | F.Cu | Top-right (21, 1) | Alligator clip connection for NIP batch CV |

The two separate buses allow MIP and NIP electropolymerization in separate passes on the same panel.

### Stencil layers

| KiCad Layer | Gerber | Stencil Purpose | Openings |
|-------------|--------|-----------------|----------|
| F.Paste | `*-F_Paste.gbr` | Ag/AgCl reference electrode | RE pad only (one 2mm circle per cell) |
| User.1 | `*-User_1.gbr` | Nafion / MIP well | Both WE pads (two 8mm circles per cell) |
| User.2 | `*-User_2.gbr` | Gold electrodeposition masking template | Both WE pads + full CE frame (all pads that need gold) |

---

## Panelization

Cell size: 22mm x 26mm. Standard JLCPCB panel: 100mm x 80mm.

**Grid: 4 columns x 3 rows = 12 complete sensor assemblies per panel.**

5 panels = **60 complete MIP+NIP sensor assemblies** for ~$18-25 CAD.

### Using KiKit

```bash
pip install kikit

kikit panelize grid \
  --gridsize 4 3 \
  --space 0 \
  --tabwidth 3 \
  --tabheight 3 \
  --vcuts \
  cortipod-electrode.kicad_pcb \
  cortipod-electrode-panel.kicad_pcb
```

Panel dimensions: 88mm x 78mm (fits within 100x80mm with rail margins).

### Manual panelization

Cell center positions on a 100x80mm board:

```
         Col 1      Col 2      Col 3      Col 4
Row 1:  (11, 13)   (33, 13)   (55, 13)   (77, 13)
Row 2:  (11, 39)   (33, 39)   (55, 39)   (77, 39)
Row 3:  (11, 65)   (33, 65)   (55, 65)   (77, 65)
```

V-score lines at: X = 22, 44, 66 (vertical) and Y = 26, 52 (horizontal).

---

## Generating Gerbers

In KiCad: **File -> Plot** (or **File -> Fabrication Outputs -> Gerbers**).

### PCB Gerbers

| Layer | Contents |
|-------|----------|
| F.Cu | Front copper: WE_MIP, WE_NIP, CE frame, RE pad, bus traces |
| B.Cu | Back copper: 4 contact pads, via-to-pad traces |
| F.Mask | Front solder mask openings (exposes electrode pads) |
| B.Mask | Back solder mask openings (exposes contact pads) |
| F.SilkS | Front labels (MIP, NIP, CE, RE) |
| B.SilkS | Back labels |
| Edge.Cuts | Board outline (22x26mm cell or panelized) |
| Cmts.User | V-score line locations |

Also generate: **Drill file** (Excellon, `.drl`)

### Stencil Gerbers

| Stencil | Layer to Export | Thickness | Purpose |
|---------|----------------|:---------:|---------|
| Ag/AgCl | F.Paste | 0.1 mm | Apply Ag/AgCl paste to RE pad |
| Gold masking | User.2 | 0.1 mm | Kapton tape alignment guide for gold electrodeposition |
| Nafion | User.1 | 0.1 mm | Apply Nafion to both WE pads |
| MIP/NIP well | User.1 (same file) | **0.3 mm** | Contain solution over WE pads during electropolymerization |

---

## JLCPCB Order — PCBs

Go to [jlcpcb.com](https://jlcpcb.com) -> **Order Now** -> upload zipped Gerbers + drill file.

| Parameter | Value |
|-----------|-------|
| Base material | FR4 |
| Layers | 2 |
| Dimensions | 100 x 80 mm (panelized) or 22 x 26 mm (single cell) |
| PCB qty | 5 panels (= 60 sensor assemblies) |
| PCB thickness | **0.8 mm** |
| Surface finish | **Hard Gold** |
| Hard gold thickness | Highest available (1µ" minimum) |
| Solder mask | Any color (green cheapest) |
| Silkscreen | White |
| V-score | **Yes** |
| Remove order number | Yes |

**Add order note:**

```
V-SCORE: Please add V-score lines as marked on Cmts.User layer.
This is a panelized design with 12 identical cells (4x3 grid).
Board thickness: 0.8mm.
```

**Estimated cost:** ~$18-28 CAD for 5 panels (60 sensor assemblies) with hard gold.

---

## JLCPCB Order — Stencils

Order as separate items. Upload one Gerber per stencil.

| Stencil | Upload | Size | Thickness | Est. Cost |
|---------|--------|------|:---------:|----------:|
| Ag/AgCl (RE) | `*-F_Paste.gbr` | 100 x 80 mm | 0.1 mm | ~$5-8 |
| Gold masking (WE + CE) | `*-User_2.gbr` | 100 x 80 mm | 0.1 mm | ~$5-8 |
| Nafion (both WEs) | `*-User_1.gbr` | 100 x 80 mm | 0.1 mm | ~$5-8 |
| MIP/NIP well (both WEs) | `*-User_1.gbr` | 100 x 80 mm | **0.3 mm** | ~$8-12 |

**Total stencils: ~$23-36 CAD.** All reusable indefinitely.

---

## Additional Materials Needed

| Item | Source | Est. Cost (CAD) | Notes |
|------|--------|----------------:|-------|
| Ag/AgCl paste | Sigma-Aldrich CA [901773](https://www.sigmaaldrich.com/CA/en/product/aldrich/901773) | ~$50-60 | For RE pad. Lasts hundreds of boards. |
| HAuCl4 | Already in BOM (Sigma 520918) | $0 | Gold electrodeposition if hard gold insufficient |
| 0.5M H2SO4 | Already in BOM (Sigma 339741) | $0 | Gold electrodeposition bath |
| Kapton tape | Amazon.ca | ~$10 | Masking during gold deposition + MIP/NIP isolation |
| HAuCl4 (gold chloride) | Already in BOM (Sigma 520918) | $0 | Gold electrodeposition if hard gold fails test |
| 0.5M H2SO4 | Already in BOM (Sigma 339741) | $0 | Gold electrodeposition bath |
| Nafion 5% | Sigma-Aldrich [510211](https://www.sigmaaldrich.com/CA/en/product/aldrich/510211) | ~$50 | Anti-fouling (optional but recommended) |
| External Ag/AgCl ref electrode | Lab supplier or Amazon | ~$20-50 | For batch immersion electropolymerization |
| Platinum wire (0.5mm, 10cm) | Lab supplier or Amazon | ~$15-30 | Shared CE for batch immersion |
| Glass dish (shallow, ~200mL) | Amazon.ca | ~$5 | Batch immersion vessel (panel lies flat) |
| Squeegee or old credit card | Already have | $0 | Stencil paste application |

---

## Step-by-Step Fabrication Workflow

### Phase A: Receive and inspect

```
1. Open the JLCPCB package. 5 panels, 12 cells each = 60 boards.

2. Visual inspection:
   - Two large gold circles (WE_MIP, WE_NIP) visible on front
   - Gold CE frame surrounding both WE circles
   - Small RE pad below
   - Solder mask covers everything except pad areas
   - Back shows 4 small contact pads per cell
   - V-score grooves visible between cells

3. Snap-apart test: break off one corner cell.
   Save it for the gold quality test (Phase B).
```

### Phase B: Gold surface quality test (one cell, 5 minutes)

```
1. Connect the test cell to your AD5941 eval board:
   - WE clip to front WE_MIP pad
   - CE clip to front CE frame
   - RE: external Ag/AgCl reference in a drop of PBS

2. Drop 100 µL of PBS onto the front (cover both WEs and CE)

3. Run chronoamperometry: +150 mV, 30 seconds, 10 Hz

4. Check baseline stability:
   - Drift < 5% over 30 seconds: hard gold is clean enough.
     SKIP gold electrodeposition. Go to Phase C.
   - Drift > 5%: nickel leaching. Do Phase B2 first.

Phase B2 (gold electrodeposition — only if hard gold test fails):

  First, mask everything that should NOT get gold using the gold stencil:

  1. Lay the gold masking stencil (User.2, 0.1mm) on the panel
     - The openings show you exactly which pads WILL get gold
       (both WE circles + the full CE frame)
     - Everything else (RE pad, traces, test points, solder mask)
       should be covered

  2. Apply Kapton tape over all areas OUTSIDE the stencil openings:
     - Press tape firmly around the openings
     - The stencil ensures precise tape placement — no measuring
     - Pay special attention to the RE pad — tape must cover it
       (RE gets Ag/AgCl later, not gold)

  3. Carefully remove the stencil, leaving the Kapton tape in place
     - The WE and CE pads are now exposed through windows in the tape
     - Everything else is masked

  4. Gold electrodeposition (batch, entire panel):
     - Connect potentiostat WE to MIP bus pad (top-left of panel)
     - Immerse panel face-down in 1 mM HAuCl4 / 0.5M H2SO4
     - External Pt wire CE and Ag/AgCl RE in solution
     - Apply -0.2V for 120 seconds
     - All exposed WE_MIP pads + CE frame pads deposit gold simultaneously

  5. Rinse with DI water

  6. Repeat step 4 with potentiostat connected to NIP bus pad (top-right)
     - All exposed WE_NIP pads deposit gold

  7. Rinse, air dry
  8. Peel off all Kapton tape
  9. Re-run the gold quality test on one cell — should now be stable
```

### Phase C: Ag/AgCl reference electrode (stencil, 2 minutes per panel)

```
1. Lay panel flat, front side up
2. Place Stencil 1 (Ag/AgCl, 0.1mm) aligned on panel
3. Apply bead of Ag/AgCl paste along top edge
4. Single squeegee pass across the panel
5. Lift stencil straight up
6. Cure: air dry 30-60 min, or oven 20-30 min at 60-80°C
```

### Phase D: MIP electropolymerization (two passes, ~20 minutes)

MIP and NIP use different solutions, so they're fabricated in separate passes on the same panel. The separate bus traces make this straightforward.

```
PASS 1 — MIP (with cortisol template):

  1. Prepare 100 mL MIP solution:
     - 100 mL PBS pH 7.4
     - 690 µL pyrrole (0.1 M)
     - 36 mg cortisol (1 mM)
     - Wait 30 minutes for pre-complexation

  2. Cover all NIP WE pads with Kapton tape
     (use the Nafion stencil as an alignment guide:
     place stencil, apply tape over right-side openings,
     remove stencil — tape stays on NIP pads)

  3. Immerse panel face-down in MIP solution (shallow glass dish)

  4. Connect potentiostat:
     - WE output → MIP bus pad (left edge of panel)
     - CE output → platinum wire in solution
     - RE output → external Ag/AgCl reference in solution

  5. Run CV: -200 mV to +800 mV, 50 mV/s, 10 cycles (~5 min)
  6. Run overoxidation: -200 mV to +1100 mV, 50 mV/s, 1-5 cycles
  7. Remove panel, rinse with PBS
  8. Peel off Kapton tape from NIP pads

PASS 2 — NIP (without cortisol template):

  1. Prepare 100 mL NIP solution:
     - 100 mL PBS pH 7.4
     - 690 µL pyrrole (0.1 M)
     - NO cortisol

  2. Cover all MIP WE pads with Kapton tape (protect the MIP film)

  3. Immerse panel face-down in NIP solution

  4. Connect potentiostat:
     - WE output → NIP bus pad (right edge of panel)
     - CE and RE: same as Pass 1

  5. Run CV: same parameters as Pass 1
  6. Run overoxidation: same level as Pass 1
  7. Remove panel, rinse with PBS
  8. Peel off Kapton tape from MIP pads

Both WEs now have their respective polymer films.
Same overoxidation level on both ensures valid differential subtraction.
```

### Phase E: Template wash (batch, 20 minutes)

```
1. Prepare wash: ethanol:acetic acid 9:1 (90 mL + 10 mL)
2. Immerse entire panel (both MIP and NIP wash simultaneously)
3. Soak 20 minutes, swirl every 5 minutes
4. Rinse: PBS, then DI water
5. Air dry 10 minutes
```

### Phase F: Nafion anti-fouling (stencil, optional, 2 minutes per panel)

```
1. Prepare 0.5% Nafion: 100 µL of 5% stock + 900 µL ethanol
2. Lay panel flat
3. Place Stencil 2 (Nafion, 0.1mm) — openings over BOTH WE pads per cell
4. Pipette 3 µL into each opening (or squeegee a thin film)
5. Lift stencil
6. Air dry 60 minutes (do not heat above 50°C)
```

### Phase G: Snap apart and store

```
1. Snap cells apart along V-score lines
2. Label each board with date on the back (fine marker)
3. Store dry in sealed container at room temperature
4. Shelf life: weeks to months
```

**Total hands-on time for one panel (12 complete sensor assemblies): ~1.5-2 hours.**

---

## Batch Production Using the Panel

### Full production run: 5 panels = 60 sensor assemblies

```
Day 1 (30 min active + overnight cure):
  Phase A: Inspect all 5 panels
  Phase B: Gold quality test (1 cell)
  Phase C: Ag/AgCl stencil on all 5 panels (10 min total)
  → Cure overnight

Day 2 (~2 hours active + wash/dry time):
  Phase D Pass 1: MIP polymerization on all 5 panels
    (process panels sequentially — same MIP solution for all 5)
  Phase D Pass 2: NIP polymerization on all 5 panels
    (same NIP solution for all 5)
  Phase E: Wash all 5 panels
  Phase F: Nafion stencil on all 5 panels
  → Dry 60 min
  Phase G: Snap apart, label, store

Result: 60 complete MIP+NIP sensor assemblies
At one assembly per day of wear: ~2 months of sensor supply
```

### Stencil reuse

All three stencils are reusable indefinitely. After each use:
- Wipe excess paste/solution with a lint-free cloth
- If paste dried in openings, soak stencil in ethanol 5 minutes
- Store flat, don't bend

---

## Enclosure Compatibility

The dual electrode (22x26mm) replaces two separate DRP-220AT strips (each 33.8x10.2mm). Update `cad/parameters.scad`:

```openscad
// ---- Custom Dual PCB Electrode (replaces 2x DRP-220AT) ----
electrode_length     = 22.0;    // mm (was 33.8 per strip)
electrode_width      = 26.0;    // mm (was 10.2 per strip)
electrode_thickness  = 0.8;     // mm (PCB, was 0.5 ceramic)
electrode_pad_length = 0;       // mm (no connector tail — back contacts)
electrode_count      = 1;       // one board carries both MIP + NIP (was 2)
electrode_gap        = 0;       // mm (no gap needed — single board)

// ---- Back contact pad positions (for pogo pin placement on main PCB) ----
// Relative to electrode board center (11, 13):
contact_we_mip_x = -4;  contact_we_mip_y = -2;
contact_we_nip_x =  4;  contact_we_nip_y = -2;
contact_ce_x     = -4;  contact_ce_y     =  4;
contact_re_x     =  4;  contact_re_y     =  4;
contact_pad_diameter = 1.8;  // mm

spring_contacts_per_elec = 4;  // WE_MIP, WE_NIP, CE, RE (was 3x2=6)

// ---- Pod dimensions (potentially smaller) ----
// Old: 44 x 26 x 10 mm (fit two 33.8mm strips)
// New: 28 x 32 x 10 mm (fit one 22x26mm board + walls)
// Or keep current size for prototyping comfort
```

The main CortiPod PCB needs 4 pogo pins repositioned to match the back contact layout. This is a straightforward change in the Phase 3.3 PCB design.

---

## Cost Summary

### First order (setup)

| Item | Cost (CAD) |
|------|----------:|
| 5 panels x 12 cells = 60 sensor assemblies (JLCPCB, hard gold) | ~$18-28 |
| Stencil 1: Ag/AgCl (0.1mm) | ~$5-8 |
| Stencil 2: Gold masking (0.1mm) | ~$5-8 |
| Stencil 3: Nafion (0.1mm) | ~$5-8 |
| Stencil 4: MIP/NIP well (0.3mm) | ~$8-12 |
| Ag/AgCl paste (Sigma 901773) | ~$50-60 |
| External Ag/AgCl reference electrode | ~$20-50 |
| Platinum wire | ~$15-30 |
| Kapton tape | ~$10 |
| **Total first order** | **~$130-210** |

### Per sensor assembly (after setup)

| Component | Cost |
|-----------|-----:|
| PCB blank (hard gold, dual electrode) | ~$0.30-0.47 |
| Ag/AgCl paste consumed | ~$0.01 |
| MIP + NIP chemicals consumed | ~$0.10 |
| Nafion consumed | ~$0.02 |
| **Total per complete sensor assembly** | **~$0.43-0.60** |

### Reorder (just PCBs, stencils are reusable)

5 more panels (60 more sensor assemblies): **~$18-28 CAD.**
