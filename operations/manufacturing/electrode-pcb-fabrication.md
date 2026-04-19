# Electrode PCB Fabrication

> Manufacturing specifications for the stepped electrode PCB — from JLCPCB prototypes to volume production.

## Design overview

The electrode PCB is a **2.0mm FR4 board with depth-controlled milling** that creates integrated mechanical mounting features. This eliminates the need for a separate electrode tray.

### Stepped profile

```
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

### Dimensions

| Parameter | Value | Tolerance |
|-----------|-------|-----------|
| Total footprint (X × Y) | 22.0 × 24.6 mm | ±0.15mm (routing) |
| Sensing area (thick zone) | 22.0 × 18.0 mm | — |
| Full thickness | 2.0 mm | ±0.2mm (board thickness) |
| Ledge thickness (after milling) | 0.8 mm | ±0.1mm (depth milling) |
| Step height (protrusion) | 1.2 mm | Derived from above |
| Ledge width (each ±Y side) | 3.3 mm | — |
| Orientation chamfer | 1.5 mm × 45° | One corner of sensing zone |
| Detent notch | 1.7mm dia × 0.4mm deep | In each ±Y ledge edge |

### Layer stack

| Layer | Content |
|-------|---------|
| F.Cu (front / skin side) | WE_MIP pad (8mm circle), WE_NIP pad (8mm circle), CE frame, RE pad |
| B.Cu (back / pogo side) | 4 contact pads (1.8mm circles) at defined XY positions, connected by vias |
| F.Mask | Open on electrode pads (WE, CE, RE), closed on ledge areas |
| B.Mask | Open on contact pads, closed elsewhere |
| Edge.Cuts | Board outline (22.0 × 24.6mm with chamfer) |
| User.1 | **Depth milling boundary** — defines the full-thickness zone |

### Vias

4 vias connecting front electrode pads to back contact pads, routed through the **full-thickness zone only**. Via specifications:

| Parameter | Value |
|-----------|-------|
| Via diameter | 0.6 mm (finished hole) |
| Via pad | 1.0 mm |
| Via type | Plated through-hole |
| Board thickness at via | 2.0 mm (full) |

No vias in the milled ledge areas.

---

## Fabrication specifications

### JLCPCB order parameters (prototype / pilot)

| Parameter | Setting |
|-----------|---------|
| Board thickness | 2.0 mm |
| Layers | 2 |
| Material | FR4 (TG 155+) |
| Surface finish | ENIG (Hard Gold if available for electrode pads) |
| ENIG thickness | 2-3 μin Au minimum |
| Copper weight | 1 oz (35 μm) |
| Min trace/space | 6/6 mil |
| Solder mask | Both sides, green (or matte black for aesthetics) |
| Silkscreen | Back side only (front is sensing face) |
| Special process | **Depth-controlled milling** |
| Panelization | V-score or tab-route (existing 4×3 panel design) |

### Depth milling specification

Include as a fabrication note and on the User.1 mechanical layer:

```
DEPTH MILLING SPECIFICATION
───────────────────────────
Side:               Front (component side / F.Cu)
Zone:               OUTSIDE the boundary marked on User.1 layer
Milling depth:      1.2 mm from front surface
Remaining thickness: 0.8 mm (±0.1 mm)
Surface:            Machine-finished FR4 (no plating needed on milled surface)

NOTE: ENIG finish is applied BEFORE depth milling. The milled ledge
surfaces will be bare FR4. This is intentional — ledge areas are
structural only, no electrical function.
```

### KiCad implementation

1. **Board outline** on Edge.Cuts: full 22.0 × 24.6mm profile with chamfer corner
2. **Milling boundary** on User.1: rectangle defining the full-thickness zone (22.0 × 18.0mm, centered in Y)
3. **Copper** only within the milling boundary (no traces on ledge areas)
4. **Fabrication note** on Cmts.User: depth milling specification text
5. **Detent notches** on User.2: two circles (1.7mm dia) on ±Y ledge edges at detent position

### ENIG vs Hard Gold considerations

| Finish | ENIG (standard) | Hard Gold (selective) |
|--------|------------------|-----------------------|
| Gold thickness | 0.05-0.1 μm | 0.5-1.0 μm |
| Cost (JLCPCB) | Standard | +$10-20/panel |
| Electrochemistry suitability | **Not suitable** — nickel leaches through thin gold | Better, but still needs gold electrodeposition |
| Why it doesn't matter | Both require gold electrodeposition from HAuCl4 to seal pores and create proper electrode surface | — |

**Conclusion:** Order standard ENIG. The gold electrodeposition step (part of MIP sensor chemistry) creates the actual electrode surface regardless of the base finish.

---

## Panelization

### Current design: 4×3 panel (12 boards)

| Parameter | Value |
|-----------|-------|
| Panel size | ~100 × 88 mm (fits JLCPCB standard) |
| Boards per panel | 12 (4 columns × 3 rows) |
| Separation | V-score (preferred) or mouse bites |
| Breakaway rails | 3 mm on each edge |

### Scaling to larger panels

| Volume | Panel layout | Boards/panel | Panel size | Panels needed |
|--------|-------------|--------------|------------|---------------|
| 100 | 4×3 | 12 | 100×88 mm | 9 panels |
| 500 | 6×5 | 30 | 150×140 mm | 17 panels |
| 1K | 8×6 | 48 | 200×165 mm | 21 panels |
| 5K | 8×6 | 48 | 200×165 mm | 105 panels |

At 1K+ units, negotiate per-panel pricing rather than per-board pricing with the fab house.

---

## Incoming quality control

### Sample inspection (every batch)

| Check | Method | Accept criteria | Sample size |
|-------|--------|-----------------|-------------|
| Board thickness (full zone) | Micrometer | 2.0 ±0.2 mm | 3 per panel |
| Ledge thickness (milled zone) | Micrometer | 0.8 ±0.1 mm | 3 per panel |
| Step height | Depth gauge or micrometer differential | 1.2 ±0.15 mm | 3 per panel |
| ENIG coverage (sensing area) | Visual under microscope | No exposed copper, no pitting | 100% visual |
| Via continuity | Multimeter, front pad to back pad | < 1Ω | 100% |
| Board dimensions | Caliper | ±0.15 mm | 3 per panel |
| Chamfer present | Visual | Correct corner | 100% |
| Detent notch depth | Pin gauge or go/no-go | 0.3-0.5 mm | 3 per panel |

### Reject criteria (entire panel rejected)

- Any board with ledge thickness outside 0.7-0.9 mm range
- Missing or displaced milling boundary (wrong zone milled)
- Discontinuous vias (open circuit front-to-back)
- ENIG voids on electrode pad areas > 0.5mm

---

## Supplier qualification

Before committing to a fab house for volume production, qualify with a test order:

### Qualification protocol

1. **Order 5 panels** (60 boards) with depth milling specification
2. **Measure** ledge thickness on every board (build a histogram)
3. **Verify** milling boundary alignment to copper features
4. **Test** via continuity on every board
5. **Run** electrodeposition on 5 sample boards (verify ENIG is receptive to gold plating)
6. **Score** the supplier:
   - Ledge thickness Cpk ≥ 1.33 (process capability)
   - Zero open vias
   - Zero milling alignment errors
   - Gold electrodeposition adhesion passes tape test

### Supplier candidates

| Supplier | Location | Depth milling? | Notes |
|----------|----------|----------------|-------|
| JLCPCB | China (Shenzhen) | Yes (special process) | Lowest cost, good for <1K units |
| PCBWay | China (Shenzhen) | Yes | More flexible on custom processes |
| Fineline (Eurocircuits) | EU (Germany/Belgium) | Yes | Higher cost, tighter tolerances |
| Advanced Circuits | USA (Colorado) | Yes | Domestic option, 2-3x cost |
| PCBCart | China | Yes | Mid-range, good for 1K-10K |

**Recommendation:** Start with JLCPCB for prototype and pilot. Qualify PCBWay as backup. At 5K+ units, evaluate Fineline or a domestic option for supply chain resilience.

---

## Cost projection

| Volume | Bare PCB cost | Depth milling adder | ENIG adder | Total per board |
|--------|---------------|---------------------|------------|-----------------|
| 10-50 | $1.50 | $2.00 | $0.50 | $4.00 |
| 50-100 | $0.80 | $1.50 | $0.30 | $2.60 |
| 100-500 | $0.50 | $1.00 | $0.20 | $1.70 |
| 500-1K | $0.30 | $0.50 | $0.15 | $0.95 |
| 1K-5K | $0.20 | $0.30 | $0.10 | $0.60 |
| 5K+ | $0.10 | $0.15 | $0.05 | $0.30 |

*Costs are per individual board, assuming appropriate panel sizes at each volume.*

The depth milling is the dominant cost adder at low volumes but amortizes quickly as the fab house optimizes their process for your specific board.

---

## Transition checklist

### Before moving from JLCPCB prototype to volume production

- [ ] Depth milling tolerance verified (Cpk ≥ 1.33 across 3+ batches)
- [ ] Via reliability confirmed (0 failures in 100+ boards)
- [ ] Gold electrodeposition validated on the fab's ENIG surface
- [ ] MIP sensor performance equivalent on fab boards vs lab reference
- [ ] Panelization optimized for target volume
- [ ] Backup supplier qualified (second source)
- [ ] Incoming QC protocol documented and trained
- [ ] Electrode shelf life data available (accelerated aging complete)
- [ ] Part number and revision control system in place
