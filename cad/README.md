# CortiPod CAD Files

## Design: 3-Piece Clamshell

```
Exploded view:

        ┌─────────────────┐
        │    Top Shell     │  ← holds PCB + battery
        └────────┬────────┘
                 │
        ┌────────┴────────┐
        │  Bottom Shell    │  ← electrode friction pocket + pogo pins
        │  ┌────────────┐  │
        │  │ electrode   │  │  ← press-fit, sensing face down
        │  └────────────┘  │
        ├──────┐    ┌──────┤
        │ledge │    │ledge │
        └──────┘    └──────┘
                 │
        ┌────────┴────────┐
        │     Door         │  ← snap-on cover, sensor window + GSR pads
        └─────────────────┘
        ═══════════════════  skin
```

## Files

| File | Description | Print this? |
|------|-------------|-------------|
| `parameters.scad` | All dimensions — change values here, all parts update | No |
| `top_shell.scad` | Top half (PCB + battery cavity) | Yes |
| `bottom_shell.scad` | Middle piece (electrode pocket, pogo pins, door ledge) | Yes |
| `door.scad` | Snap-on skin-contact cover (sensor window, GSR pads) | Yes |
| `assembly.scad` | Full assembly view — 4 view modes | No (viewing only) |

## How to swap the electrode

```
1. Unsnap the door     →  flex the edges, pull off
2. Pop out old electrode  →  push from the back through pogo holes
3. Press in new electrode →  sensing face down, friction fit
4. Snap door back on      →  press until clips click
```

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
Pod:        40 x 24 x 10 mm
Top shell:  4.5 mm thick
Bottom:     4.0 mm thick
Door:       1.5 mm thick
Electrode:  33.8 x 10.2 x 0.5 mm (DRP-220AT)
Strap:      18mm standard quick-release
```

## Printing

### What to print

| Part | Qty | Why |
|------|-----|-----|
| Top shell | 2-3 | Iteration |
| Bottom shell | 2-3 | Iteration |
| Door | 3-5 | Keeps get lost; quick to print |

### Materials

| Material | Method | Where | Notes |
|----------|--------|-------|-------|
| MJF Nylon PA12 | Multi Jet Fusion | JLCPCB, Shapeways | Best overall |
| SLA BioMed Amber | SLA | Xometry | Skin-safe certified |
| PETG | FDM | Home printer | Good for prototyping |
| PLA | FDM | Home printer | Test fit only |

### Settings

| Setting | FDM | SLA | MJF |
|---------|-----|-----|-----|
| Layer height | 0.15mm | 0.05mm | 0.08mm |
| Infill | 100% | solid | solid |
| Supports | Lugs only | Minimal | None |

### Ordering online (no printer needed)

1. Export each part as STL (F6 → File → Export → STL)
2. Upload to [JLCPCB 3D Printing](https://jlcpcb.com/3d-printing) or [Shapeways](https://www.shapeways.com)
3. Select MJF Nylon PA12
4. ~$5-15 per set, 5-10 day delivery

## Assembly order

1. Place PCB on standoffs inside top shell
2. Connect battery, tuck beside PCB
3. Press-fit 4 pogo pins into bottom shell (from inside, pointing down)
4. Apply silicone RTV to O-ring groove on bottom shell top face
5. Snap top shell onto bottom shell
6. Press electrode into friction pocket (sensing face down)
7. Snap door onto bottom shell ledge
8. Attach 18mm strap through lugs
