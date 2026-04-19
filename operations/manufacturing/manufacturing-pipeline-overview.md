# Manufacturing Pipeline Overview

> From validated prototype to boxed product — the complete manufacturing pipeline for CortiPod.

## Design summary

CortiPod is a wrist-worn continuous cortisol sensor. The assembled product consists of:

- **Shell** (single 3D-printed/injection-molded enclosure) housing electronics and battery
- **Electrode PCB** (2.0mm stepped FR4, consumable) carrying MIP sensors, slides into shell channels
- **Charging cradle** (3D-printed/molded) with USB-C, shares the same channel interface
- **Strap** (18mm quick-release, off-the-shelf)
- **Companion app** (iOS/Android, BLE connection)

The electrode is a **consumable** — users swap it by sliding the old one out and a new one in. This drives a hardware + subscription business model.

---

## Six manufacturing streams

Everything converges at final assembly. Each stream can be developed and scaled independently.

```
Stream 1: Electrode PCB fabrication ──────────┐
                                               │
Stream 2: MIP sensor chemistry ────────────────┤
                                               │
Stream 3: Main electronics PCBA ───────────────┤
                                               ├──→ Final Assembly ──→ Packaging ──→ Ship
Stream 4: Shell manufacturing ─────────────────┤
                                               │
Stream 5: Charging cradle manufacturing ───────┤
                                               │
Stream 6: Strap + accessories sourcing ────────┘
```

### Stream 1 — Electrode PCB fabrication

The stepped electrode PCB is the most unusual component. 2.0mm FR4 with depth-controlled milling from the front (skin) side, creating 0.8mm thin ledges on the ±Y edges.

| Volume | Method | Unit cost | Lead time | Supplier |
|--------|--------|-----------|-----------|----------|
| 10-100 | Standard order, depth milling | $3-5/board | 7-10 days | JLCPCB |
| 100-1K | Dedicated panel tooling | $1-2/board | 5-7 days | JLCPCB / PCBWay |
| 1K-10K | Contract PCB house, negotiated | $0.50-1/board | 3-5 days | Fineline / PCBWay |
| 10K+ | Dedicated tooling, AOI | $0.20-0.50/board | Continuous | Qualified supplier |

**Key actions:**
- Qualify 2-3 fab houses for depth milling tolerance (±0.1mm required)
- Establish incoming inspection protocol (measure ledge thickness on sample)
- Panelization (current 4x3 panel design scales to larger panels at volume)

See: [electrode-pcb-fabrication.md](electrode-pcb-fabrication.md)

### Stream 2 — MIP sensor chemistry

The molecular imprinting process is the **critical bottleneck** and the core IP. This is where lab process meets manufacturing.

| Volume | Method | Throughput | Unit cost | Investment |
|--------|--------|------------|-----------|------------|
| 10-50 | Single electrode electropolymerization | 2/hour | $5-8 | $0 (existing potentiostat) |
| 50-200 | Batch immersion (Level 1.5) | 20/batch in 35 min | $2-3 | $45-100 |
| 200-1K | Multi-channel potentiostat + panels (Level 2-3) | 100-200/day | $1-2 | $500-2K |
| 1K-5K | Semi-automated dip-coating line | 500+/day | $0.50-1 | $5K-15K |
| 5K+ | Contract to Zimmer & Peacock or equivalent | 1000+/day | $0.30-0.50 | $5K-15K NRE |

**Key actions:**
- Validate batch immersion process (does batch MIP match single-electrode MIP performance?)
- Characterize yield rate (what % of electrodes pass QC?)
- Accelerated aging study (electrode shelf life in sealed packaging)
- Evaluate contract manufacturing partners (Zimmer & Peacock, Sterling Electrode)

See: [docs/mip-scaling-strategies.md](../../docs/mip-scaling-strategies.md)

### Stream 3 — Main electronics PCBA

Standard surface-mount assembly. nRF52832 BLE SoC + AD5941 potentiostat + TMP117 + SHT40 + power management on a 24x24mm 2-layer PCB.

| Volume | Method | Unit cost (assembled) | Lead time | Supplier |
|--------|--------|-----------------------|-----------|----------|
| 10-50 | Turnkey SMT assembly | $15-25 | 7-10 days | JLCPCB |
| 50-500 | Turnkey SMT, panel pricing | $10-15 | 5-7 days | JLCPCB / PCBWay |
| 500-5K | Contract manufacturer, ICT tested | $6-10 | 2-3 weeks | Local CM or Jabil |
| 5K+ | CM with firmware flash + functional test | $4-7 | Continuous | Qualified CM |

**Key actions:**
- Design production test jig (pogo-pin bed-of-nails for main PCB)
- Qualify BLE module (MDBT42Q for pilot; evaluate raw nRF52832 for 5K+ cost savings)
- Establish AD5941 alternate source (AD5940 is pin-compatible backup)
- Firmware signing and OTA update infrastructure

### Stream 4 — Shell manufacturing

Single-piece enclosure with integrated electrode channels, skin window, strap lugs.

| Volume | Method | Unit cost | Tooling cost | Notes |
|--------|--------|-----------|--------------|-------|
| 10-100 | MJF PA12 (JLCPCB 3D printing) | $5-15 | $0 | Current approach |
| 100-500 | MJF PA12 bulk order | $3-8 | $0 | Volume discount, 5-7 day lead |
| 500-2K | Silicone mold / urethane cast | $2-5 | $1K-3K | Bridge tooling, 10K shot life |
| 2K-10K | Aluminum soft tool injection mold | $1-3 | $5K-15K | 10K-50K shot life |
| 10K+ | Steel injection mold (PC/ABS or PA) | $0.30-0.80 | $15K-40K | 500K+ shot life |

**DFM changes needed before injection molding:**
- Uniform wall thickness (currently 1.0-1.5mm — standardize to 1.2mm)
- Draft angles on vertical surfaces (1-2°)
- Fillet all internal corners (0.5mm min radius)
- Gate location planning (edge gate at +X insertion opening)
- Channel undercuts may need side-pull actions or collapsible cores

### Stream 5 — Charging cradle

Same manufacturing path as the shell, simpler geometry. Lower volume needed (1 cradle per user, not consumable).

| Volume | Method | Unit cost | Notes |
|--------|--------|-----------|-------|
| 10-500 | MJF PA12 | $3-8 | Same order as shell |
| 500+ | Co-mold with shell tooling | $1-3 | Share injection mold cycle |

**Additional components:**
- Cradle PCB (simple 2-layer, USB-C connector + 4 contact pads): $2-5 assembled
- USB-C cable (off-the-shelf, sourced from Alibaba): $0.50-1.50

### Stream 6 — Strap + accessories

All off-the-shelf, no custom manufacturing.

| Item | Source | Unit cost | MOQ |
|------|--------|-----------|-----|
| 18mm quick-release strap (silicone) | Alibaba / AliExpress | $1-3 | 50-100 |
| 18mm quick-release strap (premium fabric) | Barton Watch Bands or similar | $5-12 | 25 |
| Spring bars (for strap attachment) | Amazon / Alibaba | $0.10-0.20 | 100 |

---

## Assembly sequence

See [assembly-and-test.md](assembly-and-test.md) for detailed station procedures and test protocols.

```
Station 1: Electronics Integration
  ├── Main PCBA (pre-assembled, firmware flashed, tested at CM)
  ├── Press-fit 4x pogo pins into main PCB through-holes
  ├── Solder battery leads to PCB
  └── Functional test: BLE advertise, AD5941 responds, battery voltage

Station 2: Shell Assembly
  ├── Place main PCB on standoffs inside shell
  ├── Route battery wire, secure battery with adhesive pad
  ├── Apply conformal coating to PCB (if not done at PCBA fab)
  ├── Seal shell (UV-cure adhesive or ultrasonic weld at scale)
  └── Power-on test: BLE connects, pogo pins verified via test fixture

Station 3: Electrode Preparation (separate controlled area)
  ├── Bare electrode PCBs from fab (stepped, ENIG finish)
  ├── Gold electrodeposition on WE pads (from HAuCl4)
  ├── MIP electropolymerization (batch process)
  ├── Ag/AgCl reference electrode deposition (stencil + ink cure)
  ├── Nafion membrane coating (optional, anti-fouling)
  ├── QC: 30-second impedance screen per electrode
  ├── QC: batch sample cortisol spike test (3 per batch)
  └── Individual packaging: sealed foil pouch + desiccant + HIC

Station 4: Final Packaging
  ├── Shell unit (sealed, tested, with strap attached)
  ├── 3x electrode PCBs (individually sealed pouches)
  ├── Charging cradle (with USB-C cable)
  ├── Quick start guide (printed card)
  ├── Regulatory insert (if required)
  └── Retail box
```

**Key insight:** The shell and electrodes are manufactured and tested independently. They only meet at the user's wrist. This decoupled architecture means:
- Electrode production can ramp independently of electronics
- Failed electrodes don't waste assembled shells
- Electrode refill packs ship separately (subscription fulfillment)

---

## Phased scaling plan

### Phase 0 — Prototype validation (current → 3 months)

**Goal:** Prove MIP cortisol detection works on-body in sweat.

- No manufacturing investment
- Hand-built prototypes (5-10 units)
- Commercial SPEs or hand-fabricated electrode PCBs
- 3D printed shells (MJF PA12)
- Focus: chemistry validation, not manufacturing

**Gate to Phase 1:** On-body cortisol measurement correlates with saliva ELISA (r > 0.7, N ≥ 5 subjects).

### Phase 1 — Pilot batch (months 3-9)

**Goal:** 50-100 units for beta testers.

| Stream | Method | Investment |
|--------|--------|------------|
| Electrode PCB | JLCPCB panels, depth-milled | ~$500 |
| MIP chemistry | Batch immersion (Level 1.5) | ~$100 |
| Electronics | JLCPCB turnkey PCBA | ~$1,500 |
| Shell | MJF PA12 3D printing | ~$750 |
| Assembly | In-house, manual | Labor only |
| **Total** | | **~$3K-5K** (excl. labor) |

**Parallel workstreams:**
- Biocompatibility testing (ISO 10993 cytotoxicity + sensitization): $5K-15K
- Battery transport testing (UN 38.3): $2K-5K
- BLE final product filing with ISED: $500-1K (paperwork, pre-certified module)
- Provisional patent filing: $2K-4K
- Accelerated aging study on sealed electrodes

**Deliverable:** 50-100 beta units sold/gifted at cost (~$100-150 each). User feedback on comfort, electrode swap UX, app pairing, sensor accuracy.

### Phase 2 — Limited launch (months 9-18)

**Goal:** 500-2,000 units, first revenue.

| Stream | Method | Investment |
|--------|--------|------------|
| Electrode PCB | Dedicated panel tooling (PCBWay) | ~$1K |
| MIP chemistry | Multi-channel batch line (Level 2-3) | ~$2K |
| Electronics | Contract PCBA with test jig | ~$2K (jig) |
| Shell | Silicone mold (bridge tooling) | ~$2K |
| Assembly | In-house with fixtures, 1-2 technicians | Labor |
| Packaging | Custom retail box (Packlane or similar) | ~$2K |
| **Total** | | **~$10K-15K** |

**Pricing:** $199-249 starter kit (shell + 3 electrodes + cradle + strap). $29-39 electrode 3-pack refill.

**Regulatory:** Wellness pathway filing complete. Marketing claims limited to "stress tracking" (not medical diagnosis).

### Phase 3 — Scale (months 18-36)

**Goal:** 5,000-20,000+ units/year.

| Stream | Method | Investment |
|--------|--------|------------|
| Electrode PCB | Contract fab, negotiated volume | ~$5K (qualification) |
| MIP chemistry | Contract to Zimmer & Peacock or equivalent | $5K-15K NRE |
| Electronics | CM with programmed + tested | ~$3K (test infrastructure) |
| Shell | Injection mold tooling | $15K-40K |
| Assembly | CM or semi-automated line | $5K-10K (fixtures) |
| Packaging | Volume packaging (10K+ MOQ) | $3K |
| **Total** | | **~$40K-80K** |

**Parallel:** Class II medical device pathway (if pursuing) — QMS build, clinical study design, MDL submission ($145K-615K over 2.5-3 years).

---

## Key metrics to track from day one

| Metric | Why it matters | Target |
|--------|---------------|--------|
| Electrode QC yield | Directly impacts COGS | >80% pass rate |
| Electrode batch variance | MIP reproducibility | <20% CV in sensitivity |
| Electrode shelf life | Inventory planning, subscription timing | >6 months sealed |
| Assembly time per unit | Labor cost at scale | <15 min Phase 1, <5 min Phase 2 |
| Field failure rate | Warranty cost, user trust | <5% first-use failures |
| BLE pairing success rate | User experience | >95% first-attempt success |
| Sensor correlation to ELISA | Product credibility | r > 0.8 (wellness), r > 0.9 (medical) |

---

## Related documents

- [electrode-pcb-fabrication.md](electrode-pcb-fabrication.md) — Stepped PCB manufacturing details
- [assembly-and-test.md](assembly-and-test.md) — Assembly stations and test protocols
- [cost-analysis.md](cost-analysis.md) — COGS breakdown at scale
- [packaging-and-fulfillment.md](packaging-and-fulfillment.md) — Box contents, shipping, electrode storage
- [critical-risks-and-mitigations.md](critical-risks-and-mitigations.md) — Things that will bite you
- [../../docs/mip-scaling-strategies.md](../../docs/mip-scaling-strategies.md) — MIP chemistry scaling (existing)
- [../../docs/regulatory-commercialization-guide.md](../../docs/regulatory-commercialization-guide.md) — Regulatory pathways (existing)
- [../../docs/patent-landscape-analysis.md](../../docs/patent-landscape-analysis.md) — IP landscape (existing)
- [../../docs/market-analysis.md](../../docs/market-analysis.md) — Market sizing and pricing (existing)
