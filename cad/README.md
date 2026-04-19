# CortiPod CAD Files

## Design: Single-Shell Enclosure with Stepped Electrode PCB (v4)

```
Exploded view (side):

        ┌──────────────────────────┐
        │        Shell (one piece)  │  ← PCB + battery (FULLY SEALED)
        │  [lug]            [lug]  │     lugs on shell (not removable)
        │  ╔══════════════════════╗│
        │  ║  Main PCB + battery  ║│
        │  ║  ↓↓↓↓ pogo pins     ║│
        │  ╚══════════════════════╝│
        │  ─── mating wall ───────┤│  ← pogo bores through this wall
        │  ─── channels ──────────┤│  ← ±Y slots capture PCB ledges
        │     ═══ skin window ═══  │  ← sensing area exposed to skin
        └──────────────────────────┘
                    ↕ slide in/out (+X direction)
        ┌──────────────────────────┐
        │   Stepped Electrode PCB  │  ← 2.0mm FR4, depth-milled ±Y ledges
        │  ┌──┐──────────────┌──┐ │
        │  │  │  MIP    NIP  │  │ │     thin ledges slide into channels
        │  │  │  (8mm)  (8mm)│  │ │     thick center protrudes to skin
        │  │  │    CE frame  │  │ │     back contacts face UP → pogo pins
        │  └──┘──────────────└──┘ │
        └──────────────────────────┘
                                          ← sensing face at skin level
        ═══════════════════════════  skin
```

## v3 vs v4 Comparison

| Feature | v3 (Slide-On Tray) | v4 (Stepped PCB) |
|---------|:------------------:|:-----------------:|
| Parts below shell | Tray + electrode PCB (3 total) | **Electrode PCB only (2 total)** |
| Electrode retention | Tray pocket + ledges | **PCB ledges in shell channels** |
| Tray required | Yes (3D printed) | **No — PCB IS the sliding element** |
| Electrode thickness | 0.8mm (standard FR4) | **2.0mm (JLCPCB max, depth-milled)** |
| Skin contact | Via tray skin window | **Direct — sensing area protrudes 1.2mm** |
| Assembly steps | Drop electrode into tray, slide tray in | **Slide electrode in (one step)** |
| Shell structure | Top shell + bottom shell | **Single unified shell** |

## Stepped Electrode PCB Design

The electrode PCB has a stepped profile created by depth-controlled milling:

```
Cross-section (Y-Z plane):

  Back (pogo pin side) — FLAT across full board
  ═══════════════════════════════════════════════
  │  ledge  │                          │ ledge │   ← 0.8mm (milled from front)
  │ (thin)  │     full 2.0mm thick     │(thin) │
  └─────────┘     sensing area         └───────┘
                  with electrodes
                  on bottom face
                       ↓
                  protrudes 1.2mm to skin
```

- **Full thickness (2.0mm)**: center sensing zone, 22mm × 18mm. ENIG gold on front, contact pads on back. Vias connect through.
- **Thin ledges (0.8mm)**: ±Y perimeter extensions (~3.3mm each side). Bare FR4 after milling. Slide into shell channels.
- **Total PCB footprint**: 22mm × ~24.6mm

## Electrical Contact Design

Pogo pins mounted on the main PCB point DOWN through bores in the mating wall to contact the electrode back pads.

```
Cross-section (assembled, Y-Z plane):

     ┌─────────────── Shell ────────────────────┐
     │  [Battery]                                │  Z = 9.0
     │  [Main PCB ↓↓↓↓ pogo pins]              │  Z = 4.5
     │  ────── mating wall (pogo bores) ────────│  Z = 3.2
     │  channel│ledge│    │ledge│channel         │  Z = 2.2
     │  ───────└─────┘    └─────┘────────────── │  Z = 1.2 (step)
     │          │ back contacts ↑│               │  Z = 2.0
     │          │ electrodes ↓↓↓│               │
     │          └────────────────┘               │  Z = 0.0
     │     ════════ skin window ════════         │
     └───────────────────────────────────────────┘
                          skin
```

No flex cables. No tray. Electrical path: electrode back pad → pogo pin → main PCB → AD5941.

## Charging

The electrode PCB slides out and a charging cradle slides in. Same channel interface.

### Pogo Pin Assignments (charging mode)

| Pin | Electrode signal | Charging role |
|-----|-----------------|---------------|
| WE_MIP | Working electrode (MIP side) | V+ |
| WE_NIP | Working electrode (NIP side) | V+ |
| CE | Counter electrode | GND |
| RE | Reference electrode | GND |

### Charging Workflow

```
1. Slide electrode out →  pull from +X end (detent clicks)
2. Slide cradle in     →  charging cradle, same channels
3. Plug USB-C          →  into cradle (+X face)
4. Charge complete     →  LED on cradle indicates full
5. Slide cradle out, slide electrode back in
```

## Files

| File | Description | Print/Fab? |
|------|-------------|:----------:|
| `parameters.scad` | All dimensions — change values here, all parts update | No |
| `top_shell.scad` | Unified shell: cavity, channels, skin window, lugs | Yes (3D print) |
| `electrode_pcb.scad` | Stepped electrode PCB visualization | No (PCB fab) |
| `charging_cradle.scad` | Charging cradle that swaps in for the electrode | Yes (3D print) |
| `assembly.scad` | Full assembly — 5 view modes | No (viewing only) |
| `bottom_shell.scad` | **DEPRECATED** — old tray design, kept for reference | No |

## How to Swap the Electrode

```
1. Slide electrode out →  pull from +X end (detent releases)
2. Slide new electrode in →  push from +X, corner chamfer prevents MIP/NIP swap
3. Push until detent clicks →  pogo pins engage automatically
```

One step, no tools, no tray.

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
Pod (shell):         28 x 28 x 9 mm total
Shell:               Single piece, full 9 mm height
Electrode PCB:       22 x 24.6 mm (ledge-to-ledge)
  Sensing area:      22 x 18 mm, 2.0 mm thick
  Ledges (±Y):       3.3 mm wide, 0.8 mm thick (depth-milled)
  Step height:       1.2 mm (protrusion toward skin)
  WE_MIP:            8 mm diameter (50.3 mm²)
  WE_NIP:            8 mm diameter (50.3 mm²)
  CE frame:          ~170 mm² (horseshoe around both WEs)
  RE:                2 mm diameter (Ag/AgCl)
Mating wall:         1.0 mm thick (pogo bores through)
Channel slot:        1.0 mm high (fits 0.8 mm ledge + clearance)
Strap:               18 mm standard quick-release
Detent:              0.3 mm bump in channel + notch in PCB edge
Pogo pins:           4x (Mill-Max 0906, on main PCB)
Back contacts:       4x 1.8 mm pads (WE_MIP, WE_NIP, CE, RE)
```

## Z-Stack (from skin to top)

```
Z = 0.0   sensing face (skin contact)
Z = 1.2   electrode step / channel floor
Z = 2.0   electrode back (contact pads)
Z = 2.2   mating wall bottom (channel ceiling)
Z = 3.2   mating wall top / cavity bottom
Z = 3.7   main PCB bottom (on standoffs)
Z = 4.5   main PCB top
Z = 7.2   battery top
Z = 9.0   shell top
```

## Printing & Fabrication

### 3D Printed Parts

| Part | Qty | Material | Notes |
|------|-----|----------|-------|
| Shell | 2-3 | MJF PA12 or PETG | Channels, skin window, strap lugs |
| Charging cradle | 1-2 | MJF PA12 or PETG | Must match channel tolerance |

### PCB Fabricated Parts

| Part | Qty | Fabrication | Notes |
|------|-----|-------------|-------|
| Electrode PCB | 5+ | JLCPCB 2.0mm FR4, ENIG, depth milling | Mark milling zone on User.1 layer |

## Assembly Order

1. Mount 4 pogo pins on the main PCB underside
2. Place PCB on standoffs inside shell (asymmetric standoffs enforce orientation)
3. Connect battery, tuck beside PCB
4. Apply conformal coating to PCB before sealing
5. Seal shell (the shell is one piece — internal access via top only during assembly)
6. Slide electrode PCB into shell from +X end until detent clicks
7. Attach 18 mm strap through lugs

## Related Documents

- `docs/superpowers/specs/2026-04-13-slide-on-enclosure-design.md` — original slide-on spec
- `docs/custom-electrode-fabrication-guide.md` — PCB electrode ordering and MIP fabrication
- `electrode-pcb/cortipod-electrode.kicad_pcb` — KiCad source for the dual electrode PCB
- `docs/enclosure-design-engineering-reference.md` — engineering principles and tolerance analysis
