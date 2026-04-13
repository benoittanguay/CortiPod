# CortiPod Slide-On 2-Piece Enclosure Design Spec

## Overview

Redesign the CortiPod enclosure from a snap-together top/bottom shell into a **slide-on 2-piece system** where:

- **Top shell** contains all electronics, battery, and pogo pins. Strap attaches here.
- **Bottom shell** is a minimal electrode tray that slides into the top shell via U-channel rails.
- **Charging** reuses the same 4 pogo pins via a dedicated charging cradle that substitutes for the bottom shell.

Reference design language: similar to wearable devices where a sensor pod slides/clicks onto a strap-mounted base (e.g., Hyperice-style lateral slide).

---

## Architecture

```
        STRAP <------------------------------> STRAP
        +-------------------------------------+
        |            TOP SHELL                |
        |  +-------------------------------+  |
        |  |  Battery (18x12x2.5mm)        |  |
        |  |  Main PCB (24x24x0.8mm)       |  |
        |  |  nRF52832 + AD5941            |  |
        |  |  TMP117, SHT40               |  |
        |  |  TP4056 + LDO                |  |
        |  +-------------------------------+  |
        |  ||||  4 pogo pins                  |
  +-----#=================================#-----+  <- U-channel rails (+/-Y)
  +-----#  BOTTOM SHELL (electrode tray)  #-----+
        |  +-------------------------------+  |
        |  |  22x22mm electrode PCB        |  |
        |  |  (sensing face DOWN)          |  |
        |  +-------------------------------+  |
        +-------------| SKIN |----------------+
```

### Removed from current design

- LED light pipe and hole
- Magnetic charging pads (2x 5mm) and neodymium magnets
- GSR pads (2x 4mm stainless steel) — skin contact inferred via electrode impedance using AD5941 EIS
- O-ring seal and groove — replaced by individually sealed shells
- Snap-fit clips and alignment pins — replaced by channel rail slide mechanism

---

## Top Shell

### Exterior

- **Dimensions:** 28 x 28 x 6.5 mm
- **Corner radius:** 3.0 mm
- **Wall thickness:** 1.5 mm
- **Material:** MJF Nylon PA12 (prototype), injection-molded PC/ABS (production)

### Strap lugs

- **Location:** +/-X ends of the top shell
- **Width (strap slot):** 18.0 mm (standard quick-release)
- **Lug extension:** 3.0 mm beyond pod perimeter
- **Lug height:** 3.0 mm
- **Lug thickness:** 2.5 mm

### Internal cavity

Contains (stacked from bottom to top):

| Layer | Component | Z range (from pod bottom) |
|-------|-----------|---------------------------|
| Pogo pin mount | 4x Mill-Max 0906, soldered to PCB underside | 2.5 - 3.7 mm |
| Main PCB | 24x24x0.8mm, nRF52832 + AD5941 + TMP117 + SHT40 + TP4056 + LDO | 3.7 - 4.5 mm |
| Gap | Clearance for components | 4.5 - 5.3 mm |
| Battery | 18x12x2.5mm LiPo, ~60 mAh | 5.8 - 8.3 mm |
| Ceiling clearance | Air gap to top wall | 8.3 - 9.0 mm |

### Pogo pin pass-throughs

- **Number:** 4
- **Hole diameter:** 1.3 mm (for 0.98mm pin body + clearance)
- **Location:** Underside of top shell, matching electrode back contact positions
- **Pin protrusion below shell:** 1.0 mm
- **Pin positions (relative to shell center):**
  - WE_MIP: X = -4.0 mm, Y = -2.0 mm
  - WE_NIP: X = +4.0 mm, Y = -2.0 mm
  - CE: X = -4.0 mm, Y = +4.0 mm
  - RE: X = +4.0 mm, Y = +4.0 mm

### Sealing

- Top shell is a fully sealed box — no external openings on top, sides, or strap lugs
- Internal electronics protected by conformal coating (MG Chemicals 422B)
- Only openings: 4 pogo pin holes on the underside (inherently sealed by spring-loaded pin bodies in tight-tolerance holes)

### U-channel rails

- **Location:** Inner walls of top shell underside, along +/-Y sides
- **Channel width:** 1.2 mm
- **Channel depth (overhang):** 0.8 mm
- **Channel length:** Full +/-Y extent of the underside (~26 mm usable)
- **Rail wall thickness:** 1.0 mm
- **Entry:** Open at +Y end (insertion side)
- **Hard stop:** Closed at -Y end (defines fully-seated position)
- **Detent bump:** 0.3 mm raised dimple on channel floor, positioned 3 mm from the -Y hard stop
- **Matching detent recess:** 0.3 mm dimple on bottom shell lip, clicks into bump when fully inserted

---

## Bottom Shell (Electrode Tray)

### Exterior

- **Dimensions:** 24.4 x 26 x 2.5 mm (nests inside top shell rail cavity)
- **Material:** MJF Nylon PA12 (prototype), same as top shell (production)

### Lips (rail engagement)

- **Location:** +/-Y edges of the tray
- **Lip thickness:** 1.0 mm
- **Lip height:** 0.8 mm (matches channel depth)
- **Detent recess:** 0.3 mm dimple on each lip, 3 mm from the leading edge (-Y side when inserted)

### Electrode pocket

- **Pocket dimensions:** 22.4 x 22.2 x 1.0 mm (22mm electrode + 0.2mm clearance per side)
- **Support ledges:** 1.0 mm inward protrusion from pocket walls, 0.5 mm height
- **Skin window:** 19.8 x 16.0 mm opening through the bottom face (exposes electrode sensing face to skin)
- **Orientation key:** Corner notch matching the electrode board's 1.5mm 45-degree chamfer — electrode only fits one way

### Electrode retention

- Electrode drops into the pocket from above (sensing face down)
- No clips, adhesive, or retention mechanism in the tray
- The pogo pins from the top shell press down on the electrode back contacts when assembled, holding the electrode firmly against the support ledges
- Gravity alone holds the electrode in the tray when not assembled (sufficient for the swap workflow)

### Skin-contact face

- Skin window exposes electrode sensing face for sweat contact
- No ventilation grooves needed (electrode surface is the sweat interface)
- Tray bottom face is smooth and flat for comfortable skin contact

---

## Slide Mechanism

### Insertion direction

- Bottom shell slides into top shell from the **+Y end** (perpendicular to the strap axis)
- Strap runs along +/-X, so the slide direction doesn't interfere with either lug

### Insertion sequence

1. Align bottom shell lips with U-channel rail entries at the +Y end of the top shell
2. Push bottom shell toward -Y (toward the opposite end of the top shell)
3. Lips ride in channels; pogo pins begin engaging electrode back contacts
4. At full insertion, detent bump clicks into detent recess — tactile feedback
5. Bottom shell contacts the -Y hard stop — fully seated

### Removal

1. Apply lateral force in the +Y direction (pull bottom shell out)
2. Detent releases with mild force (~1-2 N, tunable via bump height)
3. Bottom shell slides free

### Tolerances

| Feature | Nominal | Tolerance | Process |
|---------|---------|-----------|---------|
| Channel width | 1.2 mm | +/- 0.15 mm | MJF |
| Lip thickness | 1.0 mm | +/- 0.15 mm | MJF |
| Channel-to-lip clearance | 0.2 mm total | — | Derived |
| Detent bump height | 0.3 mm | +/- 0.1 mm | MJF |
| Rail length | 26 mm | +/- 0.25 mm | MJF |
| Electrode pocket width | 22.4 mm | +/- 0.2 mm | MJF |

---

## Charging Cradle

### Purpose

Replaces the bottom shell during charging. Same outer profile slides into the same U-channel rails. USB-C power is delivered to the main PCB through the 4 pogo pins.

### Dimensions

- **Same as bottom shell:** 24.4 x 26 x 2.5 mm with matching lips and detent recess
- **USB-C port:** Recessed into the +Y face (the exposed end when cradle is inserted)

### Contact pads

- 4 gold-plated spring contact pads at the same positions as electrode back contacts
- Flush with the cradle top surface (pogo pins press down onto them)

### Pin assignment

| Pogo pin | Electrode function | Charging function |
|----------|-------------------|-------------------|
| WE_MIP (X=-4, Y=-2) | Working electrode MIP | V+ (USB 5V) |
| WE_NIP (X=+4, Y=-2) | Working electrode NIP | V+ (USB 5V) |
| CE (X=-4, Y=+4) | Counter electrode | GND |
| RE (X=+4, Y=+4) | Reference electrode | GND |

Two pins carry V+, two carry GND — provides redundancy and distributes current.

### Power routing on main PCB

- **Voltage detection:** Schottky diode + MOSFET switch on the WE lines
- **Logic:** If WE lines see >4V, the MOSFET routes power to the TP4056 LiPo charger input and disconnects the AD5941 analog front-end
- **Charging detection:** Firmware measures impedance on the WE lines at startup/wake — no electrode impedance (open circuit on CE/RE with voltage on WE) = cradle attached, enter charging mode
- **Safety:** TP4056 handles LiPo charge management (CC/CV, overcharge protection, thermal shutdown)

### Cradle PCB

- Simple 2-layer PCB inside the cradle body
- USB-C receptacle on one edge
- 4 contact pads on top face
- Traces: USB VBUS -> 2x V+ pads, USB GND -> 2x GND pads
- ESD protection diode on VBUS (TVS, e.g., USBLC6-2SC6)

---

## Strap Compatibility

### Option 1: 18mm quick-release band (primary)

- Standard 18mm silicone quick-release strap threads through the top shell lugs
- Same mechanism as conventional watch bands
- Strap stays attached to the top shell at all times
- Bottom shell slides in/out without affecting the strap

### Option 2: Whoop-style sleeve strap

- Fabric or knit band with an integrated pocket sized to the top shell body (28x28mm)
- Pod sits inside the pocket, bottom shell facing skin
- Sleeve stretches over the lug bumps — lugs provide anti-rotation keying inside the pocket
- Sleeve can be open-ended (pod slides in from one side) or have a flap closure
- **No modifications to the top shell required** — same shell works with both strap types

---

## Electrode Swap Workflow

1. Slide bottom shell out of top shell (pull +Y direction)
2. Flip tray over — old electrode falls out (or lift it out with fingers)
3. Drop new electrode into tray, sensing face down, chamfer corner aligned with pocket notch
4. Slide tray back into top shell until detent clicks
5. Pogo pins engage electrode back contacts automatically

**Orientation protection:** The electrode board's 1.5mm corner chamfer only matches one corner of the pocket. If inserted rotated 180 degrees, the board won't seat flush and the tray won't slide fully into the top shell (electrode corner protrudes past the pocket edge, blocking rail entry).

---

## Z-Stack (Full Assembly)

```
Z = 9.0 mm  -- top shell ceiling
Z = 8.3 mm  -- battery top surface
Z = 5.8 mm  -- battery bottom surface
Z = 5.3 mm  -- gap / component clearance
Z = 4.5 mm  -- PCB top surface
Z = 3.7 mm  -- PCB bottom surface (pogo pin solder joints)
Z = 2.5 mm  -- top shell underside / rail interface / parting line
Z = 1.5 mm  -- pogo pin tip (unloaded, 1.0mm protrusion below shell)
Z = 1.3 mm  -- electrode back contacts (0.5mm ledge + 0.8mm PCB thickness)
Z = 0.5 mm  -- electrode front surface (sensing face) / support ledge top
Z = 0.0 mm  -- bottom shell skin face
```

**Pogo pin compression:** 1.5 - 1.3 = 0.2 mm compression into 0.5 mm available stroke. Provides reliable contact force with margin for tolerance stack-up.

---

## Removed Components (vs. Current Design)

| Component | Reason removed |
|-----------|---------------|
| LED + light pipe | Not needed for prototype; status via phone app |
| Magnetic charging pads (2x) | Replaced by pogo pin charging cradle |
| Neodymium magnets (10x) | No longer needed (were for charging alignment) |
| GSR pads (2x stainless steel) | Skin contact inferred via AD5941 electrode impedance |
| O-ring (1.0mm CS silicone) | Each shell individually sealed; no parting line seal needed |
| O-ring groove | Removed with O-ring |
| Snap-fit clips (4x) | Replaced by channel rail slide mechanism |
| Alignment pins (2x asymmetric) | Replaced by rail + detent engagement |
| Ventilation grooves | Not needed on bottom shell skin face |

---

## BOM Impact

### Added

| Item | Qty | Est. cost |
|------|-----|-----------|
| Charging cradle (3D printed shell + simple PCB + USB-C) | 1 | ~$10 |
| Schottky diode + MOSFET (charge routing on main PCB) | 1 set | ~$1 |
| TVS ESD diode (cradle) | 1 | ~$0.50 |

### Removed

| Item | Qty | Savings |
|------|-----|---------|
| Neodymium magnets | 10 | ~$5 |
| Magnetic charging connector pair | 3 | ~$9 |
| O-ring silicone 1.0mm CS | - | ~$2 |
| GSR pad material | 2 | ~$3 |

**Net BOM change:** Roughly +$10 for the charging cradle, offset by ~$19 in removed components. Net savings of ~$9.

---

## Manufacturing Notes

### Prototype (MJF PA12)

- Top shell prints as one piece including lugs and channel rails
- Bottom shell prints as one piece including lips and electrode pocket
- Charging cradle prints as one piece; USB-C port epoxied into slot
- Detent bump/recess may need tuning after first print — start with 0.3mm and adjust
- Channel clearance (0.2mm total) may need adjustment for MJF shrinkage — test with calipers

### FDM prototyping (PLA/PETG for quick iteration)

- Print top shell upside-down (rails face up) for clean channel surfaces
- Print bottom shell right-side up (skin window faces down on build plate)
- Increase channel clearance to 0.3mm total for FDM tolerance (+/-0.4mm)
- Detent bump may not print reliably below 0.4mm on FDM — increase to 0.4mm
