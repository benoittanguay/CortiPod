# CortiPod CAD Files

## Design: 2-Piece Shell with Single-Slot Dual Electrode

```
Exploded view (side):

        ┌──────────────────────┐
        │      Top Shell        │  ← PCB + battery (FULLY SEALED)
        │  [pogo pins ↓↓↓↓]   │     4 pogo pins press DOWN through
        └────────┬─────────────┘     pass-through holes in mating face
          O-ring │ seal
        ┌────────┴─────────────┐
        │    Bottom Shell       │  ← single electrode slot + skin window
        │  ┌──────────────────┐│
        │  │ MIP WE   NIP WE ││←── 22x22mm dual electrode PCB
        │  │ (8mm)    (8mm)  ││     sensing face DOWN through skin window
        │  │    CE frame     ││     back contacts face UP toward pogo pins
        │  └──────────────────┘│
        ├──────┐         ┌────┤
        │ lug  │         │lug │
        └──────┘         └────┘
        ═══╤══════════════╤═══  skin
          vent    ◉◉     vent   ← GSR pads + ventilation grooves
                GSR pads
```

## Key Design Changes (v2 — Dual Electrode)

| Feature | v1 (DRP-220AT) | v2 (Custom Dual PCB) |
|---------|:-:|:-:|
| Electrode type | 2 separate commercial SPEs | 1 custom dual PCB (MIP + NIP) |
| WE diameter | 4mm (12.6 mm²) | **8mm (50.3 mm² each, 100.6 mm² total)** |
| Electrode size | 33.8 x 10.2 mm per strip | **22 x 22 mm single board** |
| Slots | 2 channels + center divider | **1 slot** |
| Pogo pins | 6 (3 per electrode, in bottom shell floor) | **4 (on main PCB, press down)** |
| Contact method | Spring contacts push UP from floor | **Pogo pins push DOWN from PCB** |
| Flex cable | Required (bottom shell to PCB) | **None (pogo pins are on the PCB)** |
| Pod dimensions | 44 x 26 x 10 mm | **28 x 28 x 9 mm** |
| Orientation key | None | **Corner chamfer (prevents MIP/NIP swap)** |

## Electrical Contact Design

Pogo pins are mounted on the underside of the main PCB, pointing DOWN. They protrude through 4 pass-through holes in the top shell's mating face. When the shells snap together, the pins compress against the electrode board's back contact pads.

```
Cross-section (assembled):

     ┌─────── Top Shell ────────────┐
     │  [Battery]                    │
     │  [Main PCB ↓↓↓↓ pogo pins]  │
     ├──────────┼┼┼┼────────────────┤  ← parting line (O-ring seal)
     │    ledge ├──────────┤ ledge   │  ← electrode board on ledges
     │          │back pads↑│         │     pogo pins contact back pads
     │          │front▼▼▼▼▼│         │     sensing face hangs below ledges
     │          └──────────┘         │
     │     ════ skin window ════     │
     └───────────────────────────────┘
                   skin
```

No flex cables, no bottom-shell wiring. The electrical path is:
electrode back pad → pogo pin → main PCB trace → AD5941.

## Files

| File | Description | Print this? |
|------|-------------|:-----------:|
| `parameters.scad` | All dimensions — change values here, all parts update | No |
| `top_shell.scad` | Top half (PCB + battery + pogo pass-through holes) | Yes |
| `bottom_shell.scad` | Bottom half (electrode slot, skin window, GSR pads) | Yes |
| `assembly.scad` | Full assembly view — 4 view modes | No (viewing only) |

## How to swap the electrode

```
1. Pull out old electrode  →  slide out from the +X end
2. Slide in new electrode  →  tab end first, sensing face down
                               chamfered funnel guides it in
                               corner chamfer ensures correct orientation
                               pogo pins engage back contacts when shells close
```

No tools. No disassembly of the pod. One step.

## How to use

1. Install [OpenSCAD](https://openscad.org/downloads.html) (free)
2. Open any `.scad` file
3. **F5** = quick preview, **F6** = full render (needed before export)
4. **File > Export > STL** to save for 3D printing

### Assembly view modes

Open `assembly.scad` and change `view_mode`:

| Mode | What it shows |
|------|---------------|
| `"assembled"` | All parts in final position |
| `"exploded"` | Parts stacked with gaps + labels + arrows |
| `"layout"` | All parts laid out flat side by side |
| `"cross"` | Assembled, sliced in half to see inside |

## Key dimensions

```
Pod:              28 x 28 x 9 mm (compact, smaller than Whoop in all dimensions)
Top shell:        6.5 mm thick (PCB + battery + pogo clearance)
Bottom shell:     2.5 mm thick (single slot, convex skin face)
Electrode board:  22 x 22 mm, 0.8 mm thick (custom dual PCB, FR4)
  WE_MIP:         8 mm diameter (50.3 mm²)
  WE_NIP:         8 mm diameter (50.3 mm²)
  CE frame:       ~170 mm² (horseshoe around both WEs)
  RE:             2 mm diameter (Ag/AgCl)
Strap:            18mm standard quick-release
O-ring:           1.0mm CS silicone, 50A durometer
Pogo pins:        4x (Mill-Max 0906, on main PCB)
Back contacts:    4x 1.8mm pads (WE_MIP, WE_NIP, CE, RE)
```

## Printing

### What to print

| Part | Qty | Why |
|------|-----|-----|
| Top shell | 2-3 | Iteration |
| Bottom shell | 2-3 | Iteration |

### Materials

| Material | Method | Where | Notes |
|----------|--------|-------|-------|
| MJF Nylon PA12 | Multi Jet Fusion | JLCPCB, Shapeways | Best overall |
| SLA BioMed Amber | SLA | Xometry | Skin-safe certified |
| PETG | FDM | Home printer | Good for prototyping |
| PLA | FDM | Home printer | Test fit only |

### Ordering online (no printer needed)

1. Export each part as STL (F6 > File > Export > STL)
2. Upload to [JLCPCB 3D Printing](https://jlcpcb.com/3d-printing) or [Shapeways](https://www.shapeways.com)
3. Select MJF Nylon PA12
4. ~$3-10 per set (smaller pod = cheaper), 5-10 day delivery

## Assembly order

1. Mount 4 pogo pins on the main PCB underside (matching electrode back contact positions)
2. Place PCB on standoffs inside top shell (asymmetric standoffs enforce orientation)
3. Connect battery, tuck beside PCB
4. Place 1.0mm CS silicone O-ring in groove on top shell mating face
5. Align shells using alignment pins, snap together
6. Slide dual electrode board in from the +X end (sensing face down, corner chamfer aligns orientation)
7. Attach 18mm strap through lugs

## Related documents

- `docs/custom-electrode-fabrication-guide.md` — PCB electrode ordering and MIP fabrication
- `electrode-pcb/cortipod-electrode.kicad_pcb` — KiCad source for the dual electrode PCB
- `docs/enclosure-design-engineering-reference.md` — engineering principles
- `docs/mechanical-engineering-guidelines.md` — DFM, tolerances, prototyping
