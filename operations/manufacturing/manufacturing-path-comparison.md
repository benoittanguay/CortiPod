# Manufacturing Path Comparison

> Three-way comparison of electrode production strategies: manual in-house stations, automated in-house line, and Zimmer & Peacock contract manufacturing. Informed by actual invoice data (prototype-spend-tracker.md) and process timings (mip-scaling-strategies.md). All amounts in CAD.

*Last updated: 2026-04-19*

---

## Electrode demand by user base (v1, 2-day electrode life)

| Users | Electrodes/year | Electrodes/day (250 working days) |
|-------|----------------|----------------------------------|
| 500 | 91,500 | 366 |
| 1,000 | 183,000 | 732 |
| 2,000 | 366,000 | 1,464 |
| 5,000 | 915,000 | 3,660 |
| 10,000 | 1,830,000 | 7,320 |

With Nafion (5-day life), divide all electrode volumes by 2.5×.

---

## Path A: Manual in-house (Level 2+3 stations + technicians)

### How it works

Each station is a 4-channel potentiostat running batch immersion electropolymerization on 12-up panelized PCBs. One technician manages 2-3 stations with staggered batches. Panels are loaded manually, potentiostat runs CV automatically, wash and QC are manual.

### Per-station specs

| Parameter | Value |
|-----------|-------|
| Equipment | 4-channel potentiostat + 4 batch immersion baths |
| Panels per batch | 1 panel (12 electrodes) per channel |
| Batch cycle time | ~40 min (setup → CV → overox → wash → rinse → dry → snap-apart) |
| Throughput per station | 800-1,200 electrodes/day (8 hr) |
| Operator ratio | 1 technician per 2-3 stations |
| Capex per station | C$1,500 (4-ch potentiostat + baths + racks + Pt wire + Ag/AgCl ref) |
| Footprint | ~60 × 40 cm bench space |

### Scaling model

| Users | Elec/day | Stations | Techs | Facility |
|-------|----------|----------|-------|----------|
| 500 | 366 | 1 | 1 | Shared bench |
| 1,000 | 732 | 2 | 1 | Shared bench |
| 2,000 | 1,464 | 3 | 2 | Small lab (~200 sq ft) |
| 5,000 | 3,660 | 5 | 2 | Dedicated lab (~400 sq ft) |
| 10,000 | 7,320 | 10 | 4 + 1 lead | Dedicated lab (~800 sq ft) |

### Annual cost breakdown

| Cost line | 500 users | 1K | 2K | 5K | 10K |
|-----------|-----------|-----|-----|-----|------|
| **Materials + consumables** | C$51,240 | C$87,840 | C$157,380 | C$356,850 | C$640,500 |
| **Labor** | | | | | |
| Technicians (C$55K all-in each) | C$55,000 | C$55,000 | C$110,000 | C$110,000 | C$220,000 |
| Production lead (C$65K) | — | — | — | — | C$65,000 |
| **Equipment (amortized 3 yr)** | C$767 | C$1,367 | C$2,467 | C$4,667 | C$7,667 |
| **Facility** | C$7,200 | C$10,800 | C$21,000 | C$29,000 | C$44,000 |
| **Overhead** | | | | | |
| Scrap / yield loss (10-12%) | C$5,124 | C$8,784 | C$15,738 | C$35,685 | C$64,050 |
| Safety, waste, PPE | C$2,000 | C$3,000 | C$5,000 | C$8,000 | C$15,000 |
| Training | C$2,000 | C$2,000 | C$4,000 | C$4,000 | C$8,000 |
| Management (founder time at C$75/hr) | C$7,500 | C$11,250 | C$15,000 | C$18,750 | C$11,250 |
| Insurance | C$3,000 | C$5,000 | C$8,000 | C$12,000 | C$18,000 |
| **Annual total** | **C$133,831** | **C$185,041** | **C$338,585** | **C$578,952** | **C$1,093,467** |
| **Per electrode** | **C$1.46** | **C$1.01** | **C$0.93** | **C$0.63** | **C$0.60** |

### Strengths and weaknesses

| + | - |
|---|---|
| Lowest entry cost (C$1.5K/station) | Labor-intensive — headcount scales linearly with volume |
| Proven process (batch immersion is documented) | Technician quality variability |
| Flexible — add/remove stations as needed | Your management time scales with headcount |
| No automation engineering risk | 10K users = 4 techs + 1 lead = significant HR burden |

---

## Path B: Automated in-house line

### What automation replaces

The manual bottlenecks in order of automation value:

| Step | Manual time | What automation does | Time saved |
|------|------------|---------------------|------------|
| Panel loading into bath | 2-3 min | Linear actuator dips panel on command | 90% |
| Potentiostat connection | 1-2 min | Panel bus contacts auto-align to fixture | 95% |
| CV + overox monitoring | 7 min (attended) | Firmware runs cycle, alerts on fault | 100% of operator attention |
| Transfer to wash bath | 2 min | Actuator moves panel between stations | 90% |
| Wash timing | 20 min (attended for agitation) | Pump recirculation + timer | 100% of attention |
| Rinse + dry | 5 min | Automated rinse nozzle + air jet | 80% |
| QC impedance check | 3-5 min/electrode | Multi-probe fixture, batch sweep | 90% |
| Panel snap-apart | 3 min | Manual (hard to automate cheaply) | 0% |

**Net effect:** Operator goes from actively managing 2-3 stations to passively monitoring 3-5 stations — load raw panels in, remove finished electrodes out. Active time per cycle drops from ~15 min to ~3 min.

### Automation levels

#### Level A: Semi-automated station (C$15-25K each)

Each station is a self-contained electrode fabrication cell:

| Component | Cost | Function |
|-----------|------|----------|
| 16-channel potentiostat array (4× custom AD5941 PCBs with multiplexing) | C$3,000-5,000 | Runs CV on up to 4 panels (48 electrodes) simultaneously |
| Linear actuator + stepper motor (panel dip mechanism) | C$500-1,000 | Raises/lowers panel rack between solution baths |
| 3-position bath carousel (MIP → wash → rinse) | C$1,000-2,000 | Rotary platform or linear track, baths on slides |
| Peristaltic pump system (wash solution circulation) | C$500-1,000 | Fresh wash recirculation, extends solution life |
| Multi-probe QC fixture (12-up impedance check) | C$1,500-3,000 | Pogo-pin array contacts full panel, automated pass/fail |
| Controller (Raspberry Pi / STM32 + custom firmware) | C$500-1,000 | Orchestrates: dip → CV → wash → rinse → dry → QC |
| Air-jet dryer | C$200-500 | Compressed air nozzle for rapid drying |
| Frame + enclosure + wiring | C$1,500-3,000 | Lab bench footprint ~80 × 60 cm |
| Software development (one-time, shared across all stations) | C$3,000-8,000 | Amortized: C$1K-2K per station at 3-5 stations |
| **Total per station** | **C$12,000-23,000** | |

**Throughput per station:**

```
Cycle: load panel → dip into MIP → CV 7 min → lift → dip into wash 20 min → lift → rinse 2 min → dry 2 min → QC 2 min → unload
                                                       ↑
                     While wash runs, load next panel and start its CV
                     (potentiostat has 4 independent channels)

With 4 channels pipelined:
  - Panel finishes every ~8 min
  - = 12 electrodes per 8 min = 90 electrodes/hour
  - 8-hour day: ~720 electrodes
  - 16-hour day (2 shifts): ~1,440 electrodes
```

| Parameter | Value |
|-----------|-------|
| Electrodes/hour | ~90 |
| Electrodes/day (8 hr) | ~720 |
| Electrodes/day (16 hr, 2 shifts) | ~1,440 |
| Operator ratio | 1 technician per 3-4 stations (loads panels, monitors faults) |
| Scrap rate | ~8% (more consistent than manual) |

#### Level B: Fully automated carousel (C$60-120K each)

A single machine with continuous-flow processing:

| Component | Cost | Function |
|-----------|------|----------|
| 8-position rotary carousel with panel fixtures | C$8,000-15,000 | Panels rotate through processing stations |
| 32-64 channel potentiostat array | C$8,000-15,000 | 4-8 panels processing simultaneously |
| Automated panel loader/unloader | C$5,000-10,000 | Magazine feed of raw panels, output tray |
| Solution management system (pumps, heaters, sensors) | C$3,000-6,000 | Maintains bath chemistry, auto-replenish |
| Inline QC (impedance scanner) | C$5,000-10,000 | Tests every electrode, auto-sorts pass/fail |
| Environmental enclosure (fume hood + temp control) | C$5,000-10,000 | Solvent vapors, consistent temperature |
| PLC / industrial controller + HMI touchscreen | C$3,000-6,000 | Production monitoring, data logging, alarms |
| Custom mechanical fabrication + assembly | C$15,000-30,000 | Frame, plumbing, electrical, commissioning |
| Software + integration engineering | C$8,000-15,000 | One-time development |
| **Total per machine** | **C$60,000-117,000** | |

**Throughput per machine:**

```
Carousel cycle: 8 panel positions, each holds 1 panel (12 electrodes)
  Position 1: Load panel
  Position 2: Dip into MIP solution
  Position 3: CV electropolymerization (7 min dwell)
  Position 4: Overoxidation (2 min dwell)
  Position 5: Wash bath (dwell 10 min — shorter with pump agitation)
  Position 6: Rinse + dry
  Position 7: QC impedance scan
  Position 8: Unload / reject sort

  Index time: ~4-5 min per rotation
  Pipeline: a finished panel exits every 4-5 min
  = 12 electrodes per 4-5 min = 144-180 electrodes/hour
```

| Parameter | Value |
|-----------|-------|
| Electrodes/hour | ~150 |
| Electrodes/day (8 hr) | ~1,200 |
| Electrodes/day (16 hr) | ~2,400 |
| Electrodes/day (24 hr, lights-out) | ~3,600 |
| Operator ratio | 1 tech per 2-3 machines (panel magazine loading, fault recovery) |
| Scrap rate | ~6% (tightest process control) |

### Scaling model — automated

| Users | Elec/day | Path B-A (semi-auto) | Path B-B (carousel) |
|-------|----------|---------------------|---------------------|
| 500 | 366 | 1 station (8 hr) | Overkill |
| 1,000 | 732 | 1 station (16 hr) or 2 (8 hr) | 1 machine (8 hr) |
| 2,000 | 1,464 | 2 stations (16 hr) | 1 machine (16 hr) |
| 5,000 | 3,660 | 3 stations (16 hr) | 2 machines (16 hr) |
| 10,000 | 7,320 | 6 stations (16 hr) | 3 machines (16 hr) |

### Annual cost breakdown — semi-automated (Path B-A)

| Cost line | 500 users | 1K | 2K | 5K | 10K |
|-----------|-----------|-----|-----|-----|------|
| **Materials + consumables** | C$51,240 | C$87,840 | C$157,380 | C$356,850 | C$640,500 |
| **Labor** | | | | | |
| Technicians | C$27,500 (0.5 FTE) | C$55,000 | C$55,000 | C$82,500 (1.5) | C$137,500 (2.5) |
| **Equipment (amortized 5 yr)** | C$4,000 | C$8,000 | C$16,000 | C$24,000 | C$48,000 |
| **Facility** | C$6,000 | C$9,000 | C$15,000 | C$20,000 | C$30,000 |
| **Overhead** | | | | | |
| Scrap (8%) | C$4,099 | C$7,027 | C$12,590 | C$28,548 | C$51,240 |
| Maintenance + spare parts (10% of equip/yr) | C$2,000 | C$4,000 | C$8,000 | C$12,000 | C$24,000 |
| Safety, waste, PPE | C$1,500 | C$2,500 | C$4,000 | C$6,000 | C$10,000 |
| Training | C$1,500 | C$2,000 | C$2,500 | C$3,000 | C$5,000 |
| Management (founder time) | C$5,000 | C$7,500 | C$10,000 | C$12,000 | C$8,000 |
| Insurance | C$3,000 | C$5,000 | C$7,000 | C$10,000 | C$15,000 |
| **Annual total** | **C$105,839** | **C$187,867** | **C$287,470** | **C$554,898** | **C$969,240** |
| **Per electrode** | **C$1.16** | **C$1.03** | **C$0.79** | **C$0.61** | **C$0.53** |

### Annual cost breakdown — fully automated carousel (Path B-B)

| Cost line | 500 users | 1K | 2K | 5K | 10K |
|-----------|-----------|-----|-----|-----|------|
| **Materials + consumables** | C$51,240 | C$87,840 | C$157,380 | C$356,850 | C$640,500 |
| **Labor** | | | | | |
| Technicians | C$27,500 (0.5) | C$27,500 (0.5) | C$55,000 | C$55,000 | C$82,500 (1.5) |
| **Equipment (amortized 5 yr)** | C$18,000 | C$18,000 | C$18,000 | C$36,000 | C$54,000 |
| **Facility** | C$8,000 | C$9,000 | C$12,000 | C$18,000 | C$28,000 |
| **Overhead** | | | | | |
| Scrap (6%) | C$3,074 | C$5,270 | C$9,443 | C$21,411 | C$38,430 |
| Maintenance + spare parts (12% of equip/yr) | C$10,800 | C$10,800 | C$10,800 | C$21,600 | C$32,400 |
| Safety, waste, PPE | C$1,500 | C$2,000 | C$3,000 | C$5,000 | C$8,000 |
| Management (founder time) | C$5,000 | C$5,000 | C$7,500 | C$7,500 | C$5,000 |
| Insurance | C$4,000 | C$5,000 | C$6,000 | C$8,000 | C$12,000 |
| **Annual total** | **C$129,114** | **C$170,410** | **C$279,123** | **C$529,361** | **C$900,830** |
| **Per electrode** | **C$1.41** | **C$0.93** | **C$0.76** | **C$0.58** | **C$0.49** |

**Note:** Path B-B has higher fixed costs (equipment + maintenance) that make it more expensive than Path B-A below ~1K users. Above 1K, the lower headcount and tighter scrap rate make it the cheapest option.

---

## Path C: Zimmer & Peacock contract manufacturing

### How it works

Z&P (Norway, ISO 13485) produces custom MIP electrodes to your specification. You pay NRE to transfer the electrode design and MIP protocol, then purchase electrodes on a per-unit basis. They handle all production, QC, and ship finished electrodes to you.

### Cost structure

| Cost line | 500 users | 1K | 2K | 5K | 10K |
|-----------|-----------|-----|-----|-----|------|
| **NRE (year 1 only)** | C$16,500 | C$16,500 | C$16,500 | C$16,500 | C$16,500 |
| **Production** | | | | | |
| Per-electrode (€ → CAD) | C$274,500 | C$439,200 | C$695,400 | C$1,372,500 | C$2,196,000 |
| *(unit rate)* | *(C$3.00)* | *(C$2.40)* | *(C$1.90)* | *(C$1.50)* | *(C$1.20)* |
| **Logistics** | | | | | |
| Shipping (Norway → Canada) | C$3,000 | C$5,000 | C$8,000 | C$12,000 | C$18,000 |
| Customs (~3%) + brokerage | C$10,635 | C$16,176 | C$24,862 | C$46,175 | C$71,880 |
| **Your overhead** | | | | | |
| Incoming QC / inspection | C$3,000 | C$5,000 | C$8,000 | C$12,000 | C$15,000 |
| Vendor management | C$3,750 | C$5,625 | C$7,500 | C$7,500 | C$7,500 |
| Inventory + warehousing | C$2,000 | C$3,000 | C$5,000 | C$8,000 | C$12,000 |
| **Annual total (yr 2+)** | **C$296,885** | **C$474,001** | **C$748,762** | **C$1,458,175** | **C$2,320,380** |
| **Per electrode** | **C$3.24** | **C$2.59** | **C$2.05** | **C$1.59** | **C$1.27** |

---

## Three-way comparison: landed cost per electrode

| Users | Elec/yr | Path A: Manual | Path B-A: Semi-auto | Path B-B: Carousel | Path C: Z&P |
|-------|---------|---------------|--------------------|--------------------|-------------|
| 500 | 91.5K | C$1.46 | **C$1.16** | C$1.41 | C$3.24 |
| 1,000 | 183K | C$1.01 | C$1.03 | **C$0.93** | C$2.59 |
| 2,000 | 366K | C$0.93 | C$0.79 | **C$0.76** | C$2.05 |
| 5,000 | 915K | C$0.63 | C$0.61 | **C$0.58** | C$1.59 |
| 10,000 | 1.83M | C$0.60 | C$0.53 | **C$0.49** | C$1.27 |

### Annual total spend

| Users | Path A: Manual | Path B-A: Semi-auto | Path B-B: Carousel | Path C: Z&P |
|-------|---------------|--------------------|--------------------|-------------|
| 500 | C$134K | **C$106K** | C$129K | C$297K |
| 1,000 | C$185K | C$188K | **C$170K** | C$474K |
| 2,000 | C$339K | C$287K | **C$279K** | C$749K |
| 5,000 | C$579K | C$555K | **C$529K** | C$1,458K |
| 10,000 | C$1,093K | C$969K | **C$901K** | C$2,320K |

### Annual savings vs. Z&P

| Users | Path A saves | Path B-A saves | Path B-B saves |
|-------|-------------|----------------|----------------|
| 500 | C$163K (55%) | **C$191K (64%)** | C$168K (57%) |
| 1,000 | C$289K (61%) | C$286K (60%) | **C$304K (64%)** |
| 2,000 | C$410K (55%) | C$462K (62%) | **C$470K (63%)** |
| 5,000 | C$879K (60%) | C$903K (62%) | **C$929K (64%)** |
| 10,000 | C$1,227K (53%) | C$1,351K (58%) | **C$1,419K (61%)** |

---

## Headcount comparison

| Users | Path A: Manual | Path B-A: Semi-auto | Path B-B: Carousel | Path C: Z&P |
|-------|---------------|--------------------|--------------------|-------------|
| 500 | 1 tech | 0.5 tech | 0.5 tech | 0 |
| 1,000 | 1 tech | 1 tech | 0.5 tech | 0 |
| 2,000 | 2 techs | 1 tech | 1 tech | 0 |
| 5,000 | 2 techs | 1.5 techs | 1 tech | 0 |
| 10,000 | 4 techs + 1 lead | 2.5 techs | 1.5 techs | 0 |

**Automation halves the headcount at every scale.** Path B-B (carousel) at 10,000 users needs 1.5 techs vs. Path A's 5 people. That's C$147,500/year in labor savings alone.

---

## Capex comparison (total equipment investment)

| Users | Path A: Manual | Path B-A: Semi-auto | Path B-B: Carousel | Path C: Z&P (NRE) |
|-------|---------------|--------------------|--------------------|---------------------|
| 500 | C$2.3K | C$20K | C$90K | C$16.5K |
| 1,000 | C$4.6K | C$40K | C$90K | C$16.5K |
| 2,000 | C$7.4K | C$60K | C$90K | C$16.5K |
| 5,000 | C$14K | C$75K | C$180K | C$16.5K |
| 10,000 | C$30K | C$120K | C$270K | C$16.5K |

Path B-B has the highest upfront investment but the lowest annual operating cost at scale. The capex pays back in labor savings within 1-2 years at 2K+ users.

### Capex payback: Path B-B vs Path A (manual baseline)

| Users | Extra capex (B-B vs A) | Annual savings (B-B vs A) | Payback period |
|-------|----------------------|--------------------------|----------------|
| 500 | C$87.7K | C$4.7K | 18.7 years — not viable |
| 1,000 | C$85.4K | C$14.6K | 5.8 years — marginal |
| 2,000 | C$82.6K | C$59.5K | **1.4 years** |
| 5,000 | C$166K | C$49.6K | **3.3 years** |
| 10,000 | C$240K | C$192.6K | **1.2 years** |

**The carousel pays for itself in 1.2-1.4 years at 2K+ users.** Below 1K users, semi-auto (Path B-A) or manual is more capital-efficient.

### Capex payback: Path B-A (semi-auto) vs Path A (manual)

| Users | Extra capex | Annual savings | Payback period |
|-------|------------|----------------|----------------|
| 500 | C$17.7K | C$28.0K | **7.6 months** |
| 1,000 | C$35.4K | -C$2.8K | Never (slightly more expensive) |
| 2,000 | C$52.6K | C$51.1K | **1.0 year** |
| 5,000 | C$61K | C$24.1K | **2.5 years** |
| 10,000 | C$90K | C$124.2K | **8.7 months** |

Semi-auto is the sweet spot at 500 users — it pays back in under 8 months because it halves your tech headcount to 0.5 FTE.

---

## What prevents horizontal scaling of in-house production?

Short answer: almost nothing. The practical constraints:

| Constraint | Impact | Mitigation |
|-----------|--------|------------|
| **Operator bandwidth** | 1 person can manage 2-3 manual stations or 3-5 semi-auto stations | Hire another tech (C$55K/yr) |
| **Lab space** | Each station is ~60×40 cm; 10 stations need ~6 m of bench | Rent more bench space (C$500-3K/month) |
| **Solution prep** | Each batch uses 50 mL MIP solution; 20 batches/day at high volume | Pre-prepare solution in morning (20 min); or stock in glass vials |
| **Reagent supply** | Pyrrole 25 mL = ~72 batches. Need to reorder at ~1K electrodes | Sigma-Aldrich 100 mL for ~C$50; hydrocortisone 5 g for ~C$150 |
| **Wash capacity** | 20 min per batch; wash stations need to keep up with CV output | Add more wash baths (C$5 each); use orbital shaker (C$40) |
| **QC bottleneck** | Manual QC is 3-5 min/electrode; at 3,660/day (5K users) this is 180-300 hours — impossible | Semi-auto QC jig (12-up impedance sweep, 30 sec/panel) solves this |
| **Electrical power** | Negligible — AD5941 draws milliwatts | Non-issue |
| **Waste disposal** | Ethanol + acetic acid waste accumulates at high volume | Licensed waste pickup; or ethanol evaporation + acetic acid neutralization |
| **Quality consistency** | Human variability across techs and shifts | Automated stations eliminate variability; batch QC with SPC |

**QC is the first real bottleneck to address with automation.** At 1K+ users, manual electrode-by-electrode QC is unsustainable. A multi-probe QC fixture (C$2-3K) that impedance-tests an entire panel in 30 seconds is the minimum viable automation investment.

---

## Recommended path by stage

| Stage | Users | Revenue | Recommended path | Capex | Why |
|-------|-------|---------|-----------------|-------|-----|
| **Pilot** | 0-75 | Pre-revenue | Path A: 1 manual station (eval board) | C$0 | Already purchased; validate process |
| **Beta** | 75-500 | C$19K-125K | Path B-A: 1 semi-auto station | C$20K | Halves operator time; 8-month payback |
| **Launch** | 500-2K | C$125K-650K | Path B-A: 2-3 semi-auto stations + 1 tech | C$40-60K | Revenue covers capex in 2-3 months |
| **Growth** | 2K-5K | C$650K-1.6M | Path B-B: 1-2 carousel machines + 1 tech | C$90-180K | 1.4-yr payback; frees founder from production |
| **Scale** | 5K-10K | C$1.6M-3.2M | Path B-B: 2-3 carousel machines + 1.5 techs | C$180-270K | C$1.4M/yr savings vs Z&P; initiate Z&P NRE as backup |
| **Maturity** | 10K+ | C$3.2M+ | Hybrid: in-house primary + Z&P for ISO 13485 regulatory batches | C$270K + C$16.5K NRE | Dual-source for resilience; Z&P for regulatory compliance |

### The automation investment ladder

```
Revenue:    C$0      C$125K     C$325K      C$650K       C$1.6M        C$3.2M
            │         │          │            │             │              │
Capex:    C$0      C$20K      C$40-60K    C$90-180K    C$180-270K    +C$16.5K NRE
            │         │          │            │             │              │
Path:     Manual → Semi-auto → 2-3 semi → Carousel → 2-3 carousel → + Z&P backup
            │         │        stations      │          machines         │
Techs:      0       0.5 FTE    1 FTE       1 FTE       1.5 FTE       1.5 FTE
            │         │          │            │             │           + Z&P
Users:      75       500       1,000        2,000        5,000        10,000
```

Each capex step is funded by the previous stage's revenue. No step requires external capital — the business self-funds its automation ladder.

---

## Key insight: why in-house automation beats Z&P at every scale

The electropolymerization step (CV on each electrode) is an inherently time-bound electrochemical process. Z&P can't make it faster than you can — the physics is the same. Their advantage is supposed to be scale and infrastructure, but:

1. **A C$20K semi-auto station matches Z&P's throughput** per operator-hour
2. **Your electrode substrate (JLCPCB ENIG panels) is cheaper** than Z&P's screen-printed gold ink
3. **You don't pay Z&P's margin** — their per-electrode price includes their profit, facility, and ISO overhead
4. **Horizontal scaling is trivial** — each additional station is a copy of the last, not a new engineering project
5. **Running 16-hour shifts doubles output** without doubling equipment — Z&P already runs shifts but charges you for it

The only scenario where Z&P wins is when you need **ISO 13485 certified manufacturing for regulatory submission** — and even then, a hybrid model (in-house for volume + Z&P for certified batches) is cheaper than full Z&P.
