# CortiPod CAD Files

## Design: 2-Piece Shell with Side-Loading Electrode Slot

```
Exploded view (side):

        ┌──────────────────────┐
        │      Top Shell        │  ← PCB + battery (FULLY SEALED)
        │  [align pins]        │     no cutouts, no openings
        └────────┬─────────────┘
          O-ring │ seal    flex cable pass-through (sealed)
        ┌────────┴─────────────┐
        │    Bottom Shell       │  ← electrode channels + spring contacts
        │  ┌────────────┬──┐ ◄────── chamfered insertion funnel at +X
        │  │ sensing area│●●│  │     (●● = spring contacts under pad zone)
        │  └────────────┴──┘  │
        ├──────┐         ┌────┤
        │ lug  │         │lug │
        └──────┘         └────┘
        ═══╤══════════════╤═══  skin
          vent          vent        ← ventilation grooves
```

## Electrical Contact Design

The DRP-220AT electrode has sensing pads and contact pads on the **same face**.
Since the sensing face must point DOWN toward skin, the contact pads also face down.

**Solution:** Upward-facing spring contacts (pogo pins) are mounted in the solid
floor of the bottom shell, in the zone under the electrode's connector tail (where
there is no skin window). When the electrode slides in, the springs compress and
press up against the downward-facing pads. Signals route to the PCB via a flex
cable through a sealed pass-through at the shell parting line.

- **No ZIF, no lever, no cutouts** — the top shell is fully sealed
- **One-step insertion** — just push the electrode in until it stops
- **~6N total insertion force** (3 pins x 100gf x 2 electrodes)
- **Recommended contacts:** Mill-Max 0906 (0.98mm dia, 100gf, gold-plated)

## Engineering Design Principles Applied

This design is informed by research documented in:
- `docs/enclosure-design-engineering-reference.md` — ergonomics, cartridge mechanisms, sealing, skin contact, DFM, electrical interface
- `docs/mechanical-engineering-guidelines.md` — parametric CAD, tolerances, DFA, prototyping, snap-fits, thermal/moisture

Key features:
- **Spring contacts in channel floor** — upward-facing pogo pins engage electrode pads
- **Fully sealed top shell** — no lever cutouts, targeting IP67
- **Convex bottom surface** (40mm radius) matching dorsal wrist curvature
- **Chamfered insertion funnels** at +X entry for guided electrode loading
- **Asymmetric alignment pins** between shells (poka-yoke prevents 180-degree error)
- **Corrected O-ring groove** (1.5mm wide x 0.75mm deep for 1.0mm CS O-ring, 25% compression)
- **Tapered snap-fit beams** (5mm length >= 5x thickness, 50% taper at tip)
- **Ventilation grooves** on skin face to prevent moisture trapping
- **FDM-friendly channel clearance** (0.3mm per side; reduce for SLA/production)
- **Flex cable pass-through** sealed at parting line for spring contact wiring

## Files

| File | Description | Print this? |
|------|-------------|-------------|
| `parameters.scad` | All dimensions — change values here, all parts update | No |
| `top_shell.scad` | Top half (PCB + battery cavity, fully sealed, alignment pins) | Yes |
| `bottom_shell.scad` | Bottom half (electrode channels, spring contacts, skin windows, vent grooves) | Yes |
| `assembly.scad` | Full assembly view — 4 view modes | No (viewing only) |

## How to swap an electrode

```
1. Pull out old electrode  →  slide out from the +X end
2. Slide in new electrode  →  connector tail first, sensing face down
                               chamfered funnel guides it in
                               spring contacts engage automatically
```

No tools needed. No levers. No disassembly. One step.

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
Pod:              44 x 26 x 10 mm (< 12mm threshold to avoid cuff snagging)
Top shell:        7.5 mm thick (fully sealed)
Bottom shell:     2.5 mm thick (convex skin face, 40mm wrist radius)
Electrode:        33.8 x 10.2 x 0.5 mm (DRP-220AT)
Strap:            18mm standard quick-release
O-ring:           1.0mm CS silicone, 50A durometer
Spring contacts:  6x pogo pins (Mill-Max 0906, 0.98mm, 100gf, gold)
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
| MJF Nylon PA12 | Multi Jet Fusion | JLCPCB, Shapeways | Best overall; vapor-smooth seal surfaces |
| SLA BioMed Amber | SLA | Xometry | Skin-safe certified, smooth enough for O-ring |
| PETG | FDM | Home printer | Good for prototyping; use 0.3mm channel clearance |
| PLA | FDM | Home printer | Test fit only |

### Settings

| Setting | FDM | SLA | MJF |
|---------|-----|-----|-----|
| Layer height | 0.15mm | 0.05mm | 0.08mm |
| Infill | 100% | solid | solid |
| Supports | Lugs only | Minimal | None |

### Ordering online (no printer needed)

1. Export each part as STL (F6 > File > Export > STL)
2. Upload to [JLCPCB 3D Printing](https://jlcpcb.com/3d-printing) or [Shapeways](https://www.shapeways.com)
3. Select MJF Nylon PA12
4. ~$5-15 per set, 5-10 day delivery

### Tolerances by process

| Process | Dimensional | Min wall | Channel clearance |
|---------|------------|----------|-------------------|
| FDM | +/-0.3-0.5mm | 1.2mm | 0.3mm/side (current default) |
| SLA | +/-0.1-0.15mm | 0.5mm | 0.15mm/side |
| MJF | +/-0.2-0.3mm | 1.0mm | 0.2mm/side |
| Injection mold | +/-0.05-0.15mm | 0.8mm | 0.1mm/side |

## Assembly order

1. Press-fit 6 pogo pins into the bottom shell floor holes (3 per electrode channel, in the contact zone)
2. Route flex cable from pogo pins through the parting-line pass-through
3. Place PCB on standoffs inside top shell (asymmetric standoffs enforce orientation)
4. Solder flex cable to PCB pads
5. Connect battery, tuck beside PCB
6. Place 1.0mm CS silicone O-ring in groove on top shell mating face
7. Align shells using alignment pins, snap together
8. Slide each electrode in from the +X end (chamfered funnel guides entry, sensing face down)
9. Attach 18mm strap through lugs

## Future improvements (for Fusion 360 / production)

- True fillet radii (>= 1.5mm) on all skin-facing edges (OpenSCAD limitation)
- Slot gasket (silicone lip at insertion opening, compressed by electrode)
- Electrode keying notch (asymmetric corner to prevent reversed insertion)
- Electrode presence detection (sense contact on a dedicated pad)
- Draft angles (1-1.5 deg) on all internal surfaces for injection molding
- TPU/silicone overmold on skin-contact surface for comfort
- Integrated flex circuit replacing discrete flex cable
