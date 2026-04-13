# CortiPod CAD Files

## Design: Slide-On Enclosure (v3)

```
Exploded view (side):

        ┌──────────────────────────┐
        │        Top Shell          │  ← PCB + battery (FULLY SEALED)
        │  [lug]            [lug]  │     lugs on TOP shell (not bottom)
        │  ╔══════════════════════╗│     pogo pins press DOWN into tray
        │  ║  Main PCB + battery  ║│
        │  ║  ↓↓↓↓ pogo pins     ║│
        │  ╚══════════════════════╝│
        │  ─── slide rails ───────┤│  ← rails on inside of top shell
        └──────────────────────────┘
                    ↕ slide in/out (+X direction)
        ┌──────────────────────────┐
        │      Bottom Shell Tray   │  ← electrode tray, slides out for swap/charge
        │  ┌──────────────────────┐│
        │  │  MIP WE    NIP WE   ││←── 22x22mm dual electrode PCB drops in
        │  │  (8mm)     (8mm)    ││     sensing face DOWN through skin window
        │  │     CE frame        ││     back contacts face UP toward pogo pins
        │  └──────────────────────┘│
        └──────────────────────────┘
        ═══════════════════════════  skin
```

## v2 vs v3 Comparison

| Feature | v2 (Snap-Fit) | v3 (Slide-On) |
|---------|:-------------:|:--------------:|
| Shell attachment | Snap-fit clips | Slide-on rails + detent |
| Lug location | Bottom shell | **Top shell** |
| Electrode access | Snap apart entire pod | **Slide tray out, swap, slide back** |
| Charging | Magnetic wireless | **Pogo cradle, USB-C** |
| Sealing | O-ring at parting line | **Individual per-contact lip sealing in channels** |
| GSR sensing | GSR pads on bottom | **Removed** |
| Status LED | Present | **Removed** |

## Electrical Contact Design

Pogo pins are mounted on the underside of the main PCB, pointing DOWN into the electrode tray. Contacts are sealed individually by lips in channels rather than a single O-ring at the parting line.

```
Cross-section (assembled, looking along rail axis):

     ┌─────────────── Top Shell ────────────────┐
     │  [Battery]                                │
     │  [Main PCB ↓↓↓↓ pogo pins]              │
     │  ─────────────────── slide rails ────    │
     │  channel│lip│    │lip│channel            │
     ├──────────────────────────────────────────┤  ← rail/tray interface
     │          │back pads↑│                    │  ← electrode board on tray floor
     │          │front ↓↓↓↓│                    │     sensing face DOWN
     │          └──────────┘                    │
     │     ════════ skin window ════════        │
     └──────────────────────────────────────────┘
                          skin

     Rail detail:
     ┌──────┐     ┌──────┐
     │ rail │─────│ rail │   1.2 mm wide × 0.8 mm tall
     │      │ tray│      │   detent groove: 0.3 mm deep
     └──────┘     └──────┘
```

No flex cables. No O-ring. Electrical path: electrode back pad → pogo pin → main PCB trace → AD5941.

## Charging

The tray slides out and is replaced by a charging cradle that plugs into USB-C. The same pogo pins used for electrochemistry carry charging current.

### Pogo Pin Assignments (charging mode)

| Pin | Electrode signal | Charging role |
|-----|-----------------|---------------|
| WE_MIP | Working electrode (MIP side) | V+ |
| WE_NIP | Working electrode (NIP side) | V+ |
| CE | Counter electrode | GND |
| RE | Reference electrode | GND |

### Charging Workflow

```
1. Slide tray out  →  pull from +X end
2. Slide cradle in →  charging cradle replaces tray, same rails
3. Plug USB-C      →  into cradle
4. Charge complete →  LED on cradle indicates full
5. Slide cradle out, slide electrode tray back in
```

## Files

| File | Description | Print this? |
|------|-------------|:-----------:|
| `parameters.scad` | All dimensions — change values here, all parts update | No |
| `top_shell.scad` | Top half with lugs, rails, PCB + battery cavity | Yes |
| `bottom_shell.scad` | Electrode tray: skin window, pogo targets, detent bump | Yes |
| `charging_cradle.scad` | Charging cradle that swaps in for the tray | Yes |
| `assembly.scad` | Full assembly — 5 view modes | No (viewing only) |

## How to Swap the Electrode

```
1. Slide tray out   →  pull from +X end (detent clicks)
2. Flip tray over   →  electrode is now accessible from above
3. Drop new electrode in  →  sensing face DOWN, corner chamfer prevents MIP/NIP swap
4. Slide tray back  →  push in from +X end until detent clicks
```

No tools. No disassembly of the sealed pod. The main electronics never leave the top shell.

## How to Charge

```
1. Slide tray out       →  pull from +X end
2. Slide cradle in      →  charging cradle uses same rails
3. Plug USB-C           →  into cradle port
4. Wait for full charge →  cradle LED indicates complete
5. Slide cradle out     →  swap electrode tray back in
```

Battery stays sealed inside top shell throughout. Only the tray/cradle swaps.

## How to Use (OpenSCAD)

1. Install [OpenSCAD](https://openscad.org/downloads.html) (free)
2. Open any `.scad` file
3. **F5** = quick preview, **F6** = full render (needed before export)
4. **File > Export > STL** to save for 3D printing

### Assembly View Modes

Open `assembly.scad` and change `view_mode`:

| Mode | What it shows |
|------|---------------|
| `"assembled"` | All parts in final position |
| `"exploded"` | Parts stacked with gaps + labels + arrows |
| `"layout"` | All parts laid out flat side by side |
| `"cross"` | Assembled, sliced in half to see inside |
| `"charging"` | Charging cradle swapped in, USB-C visible |

## Key Dimensions

```
Pod (top shell):     28 x 28 x 9 mm total
Top shell:           6.5 mm thick (PCB + battery + pogo clearance)
Bottom shell (tray): 2.5 mm thick (electrode slot, convex skin face)
Electrode board:     22 x 22 mm, 0.8 mm thick (custom dual PCB, FR4)
  WE_MIP:            8 mm diameter (50.3 mm²)
  WE_NIP:            8 mm diameter (50.3 mm²)
  CE frame:          ~170 mm² (horseshoe around both WEs)
  RE:                2 mm diameter (Ag/AgCl)
Strap:               18 mm standard quick-release
Rail:                1.2 mm wide x 0.8 mm tall
Detent:              0.3 mm deep groove, bump on tray
Pogo pins:           4x (Mill-Max 0906, on main PCB)
Back contacts:       4x 1.8 mm pads (WE_MIP, WE_NIP, CE, RE)
```

## Strap Options

| Option | Description |
|--------|-------------|
| Quick-release | 18 mm standard spring-bar, any sport watch strap |
| Whoop-style sleeve | Fabric sleeve with sewn-in strap, pod slides into pocket |

Lugs are on the top shell so the strap stays attached when the electrode tray is swapped or the charging cradle is inserted.

## Printing

### What to Print

| Part | Qty | Material | Notes |
|------|-----|----------|-------|
| Top shell | 2-3 | MJF PA12 or PETG | Lugs, rails, sealed cavity |
| Electrode tray | 3-5 | MJF PA12 or PETG | More copies = faster iteration; rail fit is critical |
| Charging cradle | 1-2 | MJF PA12 or PETG | Must match rail tolerance exactly |

### Materials

| Material | Method | Where | Notes |
|----------|--------|-------|-------|
| MJF Nylon PA12 | Multi Jet Fusion | JLCPCB, Shapeways | Best overall; good rail tolerance |
| SLA BioMed Amber | SLA | Xometry | Skin-safe certified |
| PETG | FDM | Home printer | Good for prototyping; tune rail tolerance |
| PLA | FDM | Home printer | Test fit only; warps at body temp |

### Ordering Online (No Printer Needed)

1. Export each part as STL (F6 > File > Export > STL)
2. Upload to [JLCPCB 3D Printing](https://jlcpcb.com/3d-printing) or [Shapeways](https://www.shapeways.com)
3. Select MJF Nylon PA12
4. ~$3-10 per set, 5-10 day delivery

## Assembly Order

1. Mount 4 pogo pins on the main PCB underside (positions match electrode back contact pads)
2. Place PCB on standoffs inside top shell (asymmetric standoffs enforce orientation)
3. Connect battery, tuck beside PCB
4. Apply conformal coating to PCB before sealing
5. Close top shell (top shell is the sealed unit — no separate assembly step needed)
6. Drop dual electrode board into tray (sensing face down, corner chamfer aligns MIP/NIP)
7. Slide tray into top shell rails until detent clicks
8. Attach 18 mm strap through lugs on top shell

## Related Documents

- `docs/slide-on-enclosure-spec.md` — full slide-on design specification
- `docs/custom-electrode-fabrication-guide.md` — PCB electrode ordering and MIP fabrication
- `electrode-pcb/cortipod-electrode.kicad_pcb` — KiCad source for the dual electrode PCB
- `docs/enclosure-design-engineering-reference.md` — engineering principles and tolerance analysis
