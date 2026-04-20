# Prototype Spend Tracker

> Actual materials purchased to date for CortiPod prototype development, cataloged from invoices. All amounts in CAD unless noted. Per-electrode consumption figures sourced from the build plan and materials guide.
>
> **Related:** See `manufacturing-path-comparison.md` for the three-way comparison of manual in-house, automated in-house, and Z&P contract manufacturing at 500-10K users — informed by the actual costs in this document.

*Last updated: 2026-04-19*

---

## Invoice register

| # | Date | Supplier | Invoice # | Items | Pre-tax | Shipping | Tax | Total Paid |
|---|------|----------|-----------|-------|---------|----------|-----|------------|
| 1 | 2026-04-17 | JLCPCB | 1235521…568951 | 3x solder paste stencils (gold, agagcl, mipwell) | C$55.86 | C$53.35 | — | **C$109.21** |
| 2 | 2026-04-17 | JLCPCB | 1235521…438673 | 5x bare 2-layer electrode PCB panels (12 electrodes/panel) | C$78.17 | C$9.14 | C$14.07 (import 18%) | **C$86.09** |
| 3 | 2026-04-11 | Amazon | CA647C2YQPPI | 1x solderless breadboard 400-point | C$4.99 | C$3.99 | C$1.35 | **C$10.33** |
| 4 | 2026-04-11 | Amazon | CA6ZPB9RQ6I | 1x IZOKEE 240pc jumper wires | C$12.99 | — | C$1.95 | **C$14.94** |
| 5 | 2026-04-10 | Amazon | CA624OQLNC4I | 1x ultra-pure ethanol 500 mL | C$19.99 | C$14.95 | C$5.23 | **C$40.17** |
| 6 | 2026-04-11 | Amazon | CA66TYFL8X5I | 1x glass vials 20 mL (12 pcs) | C$11.99 | — | C$1.80 | **C$13.79** |
| 7 | 2026-04-11 | Amazon | CA63XIB37D2I | 1x alligator clip test leads (10 pcs) | C$9.99 | — | C$1.50 | **C$11.49** |
| 8 | 2026-04-11 | Amazon | CA64JU67G7UI | 1x PBS 1X buffer 500 mL | C$29.69 | — | C$4.45 | **C$34.14** |
| 9 | 2026-04-10 | Amazon | CA61JVUMF8I | 1x micropipette kit (3 pipettes + stand + tips) | C$151.27 | — | — | **C$151.27** |
| 10 | 2026-04-17 | Cedarlane Labs | 2468716 | 1x hydrocortisone 1 g + 1x pyrrole 25 mL | C$143.00 | C$44.99 | C$9.40 | **C$197.39** |
| 11 | 2026-04-14 | Nanochemazone | NCZ26U1311 | 1x Ag/AgCl paste 10 g | C$165.00 | C$40.00 | C$30.70 | **C$235.70** |
| 12 | 2026-04-10 | Prolab Scientific | 24015 | 1x acetic acid 500 mL | C$65.80 | C$21.29 | C$16.03 | **C$123.12** |
| 13 | 2026-04-11 | DigiKey | 98580743 | 1x Feather nRF52 Bluefruit LE + 1x EVAL-AD5941BATZ | C$357.76 | — | C$53.58 | **C$411.34** |

**Note:** One item on Amazon order 701-6792633-0493839 (lint cleaner, C$6.43) was excluded as non-project.

### Total spend: **C$1,438.98**

---

## Material yield analysis

The ordered PCB batch is **5 panels × 12 electrodes/panel = 60 electrodes**. Per-electrode consumption from the build plan and materials guide:

| Material | Purchased | Per electrode | Batch of 60 | Total yield from purchase | % used by batch |
|----------|-----------|-------------|-------------|---------------------------|-----------------|
| Pyrrole | 25 mL (25,000 µL) | 6.9 µL | 414 µL | **~3,600 electrodes** | **1.7%** |
| Hydrocortisone | 1 g (1,000 mg) | 0.36 mg | 21.6 mg | **~2,780 electrodes** | **2.2%** |
| Acetic acid (wash) | 500 mL | 1 mL | 60 mL | **~500 electrodes** | **12%** |
| Ag/AgCl paste | 10 g (10,000 mg) | ~10 mg (screen print) | ~600 mg | **~1,000 electrodes** | **6%** |
| PBS buffer | 500 mL | ~10 mL (batch dilution + rinse) | ~100 mL | **~50 batches** | **20%** |
| Ethanol (wash) | 500 mL | 9 mL | 540 mL | **~55 electrodes** | **~100%** |

**Ethanol is the only material that runs out.** The 500 mL bottle is just barely enough for 60 electrodes (assuming individual 9:1 ethanol:acetic acid template-removal washes). If washes are batched (immersing multiple electrodes in a shared wash solution), the bottle stretches further.

**Everything else has massive surplus** — pyrrole and hydrocortisone alone are enough for thousands of electrodes. The high purchase costs are dominated by minimum order sizes, shipping, and surcharges, not by per-electrode consumption.

---

## Actual per-electrode cost for this 60-electrode batch

Allocating the cost of each material proportionally to what the batch of 60 actually consumes:

| Material | Total paid | Consumed by 60 electrodes | Cost allocated | Per electrode |
|----------|-----------|--------------------------|----------------|---------------|
| Bare PCBs (5 panels × 12) | C$86.09 | 100% (all 5 panels) | C$86.09 | **C$1.43** |
| Ag/AgCl paste (0.6 g of 10 g) | C$235.70 | 6% | C$14.14 | **C$0.24** |
| Pyrrole (414 µL of 25 mL) | C$93.92* | 1.7% | C$1.56 | **C$0.03** |
| Hydrocortisone (21.6 mg of 1 g) | C$103.47* | 2.2% | C$2.23 | **C$0.04** |
| Ethanol — wash (540 mL of 500 mL) | C$40.17 | ~100% | C$40.17 | **C$0.67** |
| Acetic acid — wash (60 mL of 500 mL) | C$123.12 | 12% | C$14.77 | **C$0.25** |
| PBS buffer (100 mL of 500 mL) | C$34.14 | 20% | C$6.83 | **C$0.11** |
| **Total materials** | | | **C$165.79** | **C$2.76** |

*Cedarlane invoice (C$197.39) split proportionally: pyrrole C$68/C$143 = 47.6% → C$93.92; hydrocortisone C$75/C$143 = 52.4% → C$103.47.*

### Per-electrode cost: C$2.76

This is the **actual marginal material cost** to produce one electrode from this batch. It's already below the projected 100-unit COGS of C$8.50/electrode from cost-analysis.md — because the expensive reagents yield thousands of electrodes each.

---

## Remaining material inventory after 60-electrode batch

| Material | Purchased | Used | Remaining | % remaining | Additional electrodes possible |
|----------|-----------|------|-----------|-------------|-------------------------------|
| Pyrrole 25 mL | 25,000 µL | 414 µL | **24,586 µL** | 98.3% | ~3,560 more |
| Hydrocortisone 1 g | 1,000 mg | 21.6 mg | **978.4 mg** | 97.8% | ~2,720 more |
| Acetic acid 500 mL | 500 mL | 60 mL | **440 mL** | 88.0% | ~440 more |
| Ag/AgCl paste 10 g | 10,000 mg | 600 mg | **9,400 mg** | 94.0% | ~940 more |
| PBS buffer 500 mL | 500 mL | 100 mL | **400 mL** | 80.0% | several hundred |
| Ethanol 500 mL | 500 mL | 540 mL | **~0 mL** | ~0% | **need to reorder** |

**Total remaining material value: C$550.82** (87% of consumable spend survives the first batch)

**Bottleneck for next batch: ethanol.** A second C$40.17 bottle covers another ~55 electrodes. Every other material is stocked deep.

---

## Spend breakdown: what this batch actually cost vs. what's in the bank for future batches

| | Amount | Purpose |
|--|--------|---------|
| **Materials consumed by 60 electrodes** | **C$165.79** | Bare PCBs + proportional share of chemistry |
| **Material inventory remaining** | **C$550.82** | Reagents + Ag/AgCl paste stockpiled for future batches |
| **Reusable tooling + equipment** | **C$708.58** | Stencils, micropipettes, dev boards, prototyping supplies |
| **Lab consumables (glass vials)** | **C$13.79** | Storage and soaking containers |
| **Total spent** | **C$1,438.98** | |

Only **12% of total spend** (C$165.79) goes directly into the first 60 electrodes. The rest is inventory, tooling, and lab equipment that persists.

### Equipment breakdown

| Item | Cost | Type |
|------|------|------|
| EVAL-AD5941BATZ potentiostat eval board | C$366.89 | Electropolymerization + impedance testing |
| Micropipette kit (3 pipettes + stand + tips) | C$151.27 | Precise chemical dispensing |
| Solder paste stencils (3x) | C$109.21 | Screen printing tooling (100+ prints) |
| Adafruit Feather nRF52 Bluefruit LE | C$44.45 | BLE firmware development |
| Prototyping supplies (breadboard, wires, clips) | C$36.76 | Circuit prototyping |
| **Total equipment + tooling** | **C$708.58** | |

The AD5941 eval board (C$366.89) is the single largest purchase. It doubles as both a development tool and the core potentiostat for prototype electrode fabrication and readout — it's not just a dev kit, it's the actual measurement hardware for the prototype device.

---

## Prototype cost vs. projected COGS (corrected)

| Cost element | This batch (per electrode) | Projected 100 units | Projected 1K units | Projected 10K units |
|--------------|---------------------------|---------------------|--------------------|---------------------|
| Bare PCB | **C$1.43** | C$4.00 | C$2.00 | C$0.50 |
| Ag/AgCl paste | **C$0.24** | C$0.50 | C$0.30 | C$0.10 |
| MIP chemistry (pyrrole + hydrocortisone) | **C$0.07** | C$3.00 | C$1.50 | C$0.50 |
| Template wash (ethanol + acetic acid) | **C$0.92** | (included above) | (included above) | (included above) |
| PBS buffer | **C$0.11** | (included above) | (included above) | (included above) |
| **Total per electrode** | **C$2.76** | **C$8.50** | **C$4.30** | **C$1.30** |

The actual per-electrode material cost (C$2.76) is **already below the 100-unit projection** (C$8.50). The cost-analysis.md estimates were conservative — they baked in labor, QC overhead, and packaging that don't apply to a bare prototype run. At the raw material level, even prototype-scale purchasing comes in under the projections.

**Why the PCB is cheaper than projected:** The cost-analysis.md estimated C$4.00/electrode PCB at 100 units based on individual boards. But panelized ordering (12-up panels) at JLCPCB gives C$1.43/electrode even at qty 5 panels (60 electrodes). The panelization strategy is working better than projected.

---

## Where the money went (Pareto)

| Rank | Item | Cost | Cumulative % | Note |
|------|------|------|-------------|------|
| 1 | DigiKey dev boards (AD5941 + nRF52) | C$411.34 | 29% | Reusable — potentiostat + BLE dev board |
| 2 | Ag/AgCl paste 10 g | C$235.70 | 45% | 94% remains after batch — enough for ~940 more electrodes |
| 3 | Cedarlane reagents (hydrocortisone + pyrrole) | C$197.39 | 59% | 98% remains — enough for ~2,700+ more electrodes |
| 4 | Micropipette kit | C$151.27 | 69% | Reusable lab capex |
| 5 | Acetic acid 500 mL | C$123.12 | 78% | 88% remains — enough for ~440 more electrodes |
| 6 | Solder paste stencils | C$109.21 | 85% | Reusable tooling (100+ prints) |
| 7 | Bare PCBs (60 electrodes) | C$86.09 | 91% | Fully consumed by this batch |
| 8 | Everything else | C$124.86 | 100% | Ethanol, PBS, breadboard, wires, clips, vials |

**The top 6 items (85% of spend) are either reusable equipment or bulk materials with 88-98% remaining.** The only items fully consumed by this batch are the bare PCBs and the ethanol.

---

## Cost-analysis validation notes

1. **Ag/AgCl paste: cost-analysis is validated.** At ~10 mg/electrode from screen printing, the C$165/10 g purchase = C$0.17/electrode raw material. Projected C$0.50/electrode at 100 units includes waste and QC rejects — reasonable.

2. **MIP chemistry: cost-analysis was conservative.** Pyrrole at 6.9 µL/electrode and hydrocortisone at 0.36 mg/electrode are tiny quantities. The projected C$3.00/electrode for chemistry at 100 units has large overhead baked in. Actual raw material is C$0.07/electrode. The gap is likely labor, wash solvents, and batch overhead.

3. **Template wash solvents dominate chemistry cost.** The ethanol (9 mL/electrode) and acetic acid (1 mL/electrode) cost more per electrode (C$0.92) than the actual MIP reagents (C$0.07). At scale, ethanol and acetic acid are commodity chemicals — ~C$0.05/electrode total. The prototype premium is the small-bottle pricing and minimum-order surcharges (C$20 in surcharges on the C$65.80 acetic acid alone).

4. **PCB panelization is a cost win.** 12-up panels at JLCPCB yield C$1.43/electrode even at qty 5 panels. The cost-analysis projected C$4.00/electrode at 100 units assuming individual boards. With panelization, even small orders beat the projection.

5. **Shipping was 15% of total spend** (C$211.60 across all invoices). This is the prototype tax — at production volumes it amortizes to near-zero per unit.

6. **AD5941 eval board validates the potentiostat cost.** The C$319.02 (pre-tax) purchase price for the eval board is development tooling, not per-unit cost. The AD5941 IC itself costs ~C$13-14 at qty 100 from Analog Devices. The eval board premium pays for the reference design, which informs the custom PCBA layout.

---

## Complete standalone prototype — full BOM projection

The prototype uses dev boards (Feather nRF52 + AD5941 eval board) rather than a custom PCBA, but still needs all the mechanical, power, and enclosure components to be a wearable standalone device.

### Already purchased

| Component | Item | Cost | Per-unit or shared |
|-----------|------|------|--------------------|
| Potentiostat | EVAL-AD5941BATZ | C$366.89 | Per-unit (IS the prototype device) |
| BLE MCU | Feather nRF52 Bluefruit LE | C$44.45 | Per-unit |
| Electrode PCBs | 5 panels × 12 = 60 electrodes | C$86.09 | Per-unit: C$1.43/electrode |
| Ag/AgCl paste | 10 g | C$235.70 | Shared — 94% remains after batch |
| MIP reagents | Hydrocortisone 1 g + pyrrole 25 mL | C$197.39 | Shared — 98% remains after batch |
| Wash solvents | Ethanol 500 mL + acetic acid 500 mL | C$163.29 | Shared — ethanol runs out, acetic acid 88% remains |
| Lab buffer | PBS 1X buffer 500 mL | C$34.14 | Shared — 80% remains |
| Lab equipment | Micropipette kit (3 pipettes + stand + tips) | C$151.27 | Tool (reusable) |
| Stencils | 3x solder paste stencils (gold, Ag/AgCl, MIP well) | C$109.21 | Tool (reusable, 100+ prints) |
| Lab supplies | Glass vials 12 pcs | C$13.79 | Tool (reusable) |
| Prototyping | Breadboard + jumper wires + alligator clips | C$36.76 | Tool (reusable) |
| **Subtotal purchased** | | **C$1,438.98** | |

### Still needed — electronics + power

| Component | Est. cost (CAD) | Supplier | Notes |
|-----------|-----------------|----------|-------|
| LiPo battery (60-100 mAh) | C$10-15 | Adafruit / Amazon | Adafruit #1570 or similar micro cell |
| TP4056 LiPo charger module | C$5-10 | Amazon (pack of 5-10) | Handles safe charging |
| AP2112K-3.3 LDO regulator | C$2-5 | DigiKey | Clean 3.3 V for nRF52 + AD5941 |
| Pogo pins (4x Mill-Max 0906) | C$5-8 | DigiKey | Electrode cartridge contact |
| JST-SH 2-pin connector (battery) | C$2-3 | DigiKey / Amazon | Battery connection |
| Passive components (resistors, caps) | C$5-10 | DigiKey / Amazon | Supporting circuitry |
| Solder paste | C$15-25 | Amazon / DigiKey | For stencil printing Ag/AgCl + assembly |
| Magnetic charging connector pair | C$3-5 | AliExpress | Pod-to-cradle alignment + contact |
| Conformal coating (MG Chemicals 422B) | C$15-20 | Amazon / DigiKey | Sweat protection for electronics |
| **Subtotal electronics** | **C$62-101** | | |

### Still needed — enclosure + mechanical

| Component | Est. cost (CAD) | Supplier | Notes |
|-----------|-----------------|----------|-------|
| 3D-printed shell (top + bottom, MJF PA12) | C$15-25 | JLCPCB 3D printing | ~44 × 26 × 10 mm pod enclosure |
| Silicone O-ring / RTV sealant | C$8-12 | Amazon | Perimeter seal between shells |
| 18 mm silicone quick-release strap | C$8-12 | Amazon | Standard watch strap |
| Spring bars (2x, 18 mm) | C$3-5 | Amazon | Strap attachment |
| Neodymium disc magnets (4x, 5×1 mm) | C$2-4 | Amazon / K&J Magnetics | Charging alignment |
| **Subtotal enclosure** | **C$36-58** | | |

### Still needed — charging cradle

| Component | Est. cost (CAD) | Supplier | Notes |
|-----------|-----------------|----------|-------|
| Cradle body (3D-printed MJF PA12) | C$10-15 | JLCPCB 3D printing | Holds pod for charging |
| Cradle PCB + USB-C connector | C$5-10 | JLCPCB | Simple 2-layer PCB with contact pads |
| USB-C cable (1 m) | C$5-10 | Amazon | |
| **Subtotal cradle** | **C$20-35** | | |

### Still needed — calibration + consumables

| Component | Est. cost (CAD) | Supplier | Notes |
|-----------|-----------------|----------|-------|
| Cortisol standard solution | C$50-100 | Cedarlane / Sigma-Aldrich | Known-concentration solution for sensor calibration |
| Ultra-pure ethanol (reorder) | C$40 | Amazon | First bottle consumed by 60-electrode batch |
| Nitrile gloves | C$18 | Amazon | Lab safety |
| Kapton tape | C$10-15 | Amazon | Masking during fabrication |
| Nafion 5% solution | C$50-80 | Sigma-Aldrich | Anti-fouling membrane (future improvement) |
| **Subtotal calibration + consumables** | **C$168-253** | | |

### Full prototype cost projection

| | Low estimate | High estimate |
|--|-------------|---------------|
| Already purchased | C$1,438.98 | C$1,438.98 |
| Electronics + power | C$62 | C$101 |
| Enclosure + mechanical | C$36 | C$58 |
| Charging cradle | C$20 | C$35 |
| Calibration + consumables | C$168 | C$253 |
| **Total to one complete standalone prototype** | **C$1,725** | **C$1,886** |

### What that total actually buys

The C$1,725-1,886 is misleading as a "per-device" cost because most of the spend is shared inventory and reusable tools. Here's the breakdown for what goes INTO one prototype unit vs. what sits on the shelf:

| | Amount | % of total |
|--|--------|-----------|
| **In the device** (electronics + enclosure + strap + cradle + 3 electrodes) | ~C$520-560 | 30% |
| **Shared consumable inventory** (reagents, paste, solvents — enough for 100s-1000s more electrodes) | ~C$700-750 | 40% |
| **Reusable tools + equipment** (micropipettes, stencils, prototyping supplies) | ~C$310 | 17% |
| **Calibration + lab consumables** (gloves, tape, standard solution) | ~C$195-265 | 13% |

### Cost of the device itself (what's physically in the first prototype unit)

| Component | Cost |
|-----------|------|
| EVAL-AD5941BATZ eval board | C$366.89 |
| Feather nRF52 Bluefruit LE | C$44.45 |
| LiPo battery | C$12 |
| TP4056 + LDO + passives + connectors | C$15 |
| Pogo pins (4x) | C$6 |
| Magnetic charging connector | C$4 |
| Conformal coating (portion) | C$2 |
| 3D-printed shell (top + bottom) | C$20 |
| O-ring / sealant | C$10 |
| Strap + spring bars | C$15 |
| 3 electrodes (materials) | C$8.28 |
| Charging cradle (body + PCB + cable) | C$25 |
| **Total in-device cost** | **~C$528** |

**C$411 of that C$528 (78%) is the two dev boards.** In production these become ICs on a custom PCBA: the AD5941 IC (~C$14) + MDBT42Q module (~C$10) + custom PCB + assembly = ~C$31.50 total. That single substitution drops the device cost from ~C$528 to **~C$148** — which aligns closely with the cost-analysis.md projection of C$115.70 at 100 units (the gap is the 3D-printed enclosure being more expensive than injection molding at scale).

### Prototype vs. production cost bridge

| Component | Prototype | Production (100 units) | Why the difference |
|-----------|-----------|----------------------|-------------------|
| Main electronics | C$411.34 (dev boards) | C$31.50 (custom PCBA) | Dev board → integrated IC + custom PCB |
| Enclosure | C$20 (MJF 3D print) | C$11.00 (MJF → silicone mold) | Same process at prototype, mold at scale |
| Electrode 3-pack | C$8.28 (materials only) | C$27.00 (incl. QC, labor, packaging) | Materials are cheaper; labor/QC adds overhead |
| Battery + power | C$27 (modules) | C$5.00 (custom cell) | Module → bare cell + integrated charger |
| Pogo + magnets | C$10 | C$4.00 | Volume pricing |
| Strap + spring bars | C$15 | C$3.20 | Alibaba bulk vs. Amazon retail |
| Cradle | C$25 | C$8.00 | 3D print → mold; simple PCB scales |
| Assembly labor | C$0 (DIY) | C$15.00 | You're free; shop labor isn't |
| Packaging + QC | C$0 (none) | C$9.50 | Retail box, inserts, testing |
| **Total** | **~C$528** | **C$115.70** | **4.6x prototype-to-production ratio** |

The 4.6x ratio is typical for a hardware prototype where dev boards stand in for custom ICs. The electronics dominate prototype cost; at production, enclosure and labor become the larger shares.

### Revised electrode cost per unit (unchanged)

The electrode materials cost remains **C$2.76/electrode** as calculated above. Adding projected QC and packaging overhead at prototype scale:

| | Per electrode | Per 3-pack |
|--|---------------|-----------|
| Materials (PCB + chemistry + Ag/AgCl) | C$2.76 | C$8.28 |
| QC labor (est. 5 min at C$30/hr) | C$2.50 | C$7.50 |
| Foil pouch + desiccant (est.) | C$0.50 | C$1.50 |
| **Fully loaded prototype electrode** | **C$5.76** | **C$17.28** |

This is still well below the cost-analysis projection of C$30.50/3-pack at 100 units, confirming the electrode economics are more favorable than originally modeled.

---

## Small-batch production projection: 25 / 50 / 75 units

At 25+ units, the dev boards (C$411/unit) are no longer viable. The projection below assumes a **custom PCBA via JLCPCB turnkey assembly** with the AD5941 IC + MDBT42Q module, which is the natural step from prototype to pilot run.

### Per-unit BOM (custom PCBA path)

#### Main PCBA

| Component | 25 units | 50 units | 75 units | Source |
|-----------|----------|----------|----------|--------|
| PCB bare (24×24 mm, 2L ENIG) | C$4.00 | C$3.00 | C$2.50 | JLCPCB |
| SMT assembly | C$10.00 | C$8.00 | C$7.00 | JLCPCB turnkey |
| AD5941BCPZ potentiostat IC | C$18.00 | C$16.00 | C$14.00 | DigiKey (qty break at 25/100) |
| MDBT42Q-512KV2 BLE module | C$10.00 | C$9.00 | C$8.50 | DigiKey / Mouser |
| TMP117 temp sensor | C$4.00 | C$3.50 | C$3.00 | DigiKey |
| SHT40 humidity sensor | C$3.00 | C$2.50 | C$2.50 | DigiKey |
| Passives + connectors | C$2.00 | C$1.50 | C$1.25 | JLCPCB parts library |
| Pogo pins (4x Mill-Max 0906) | C$6.00 | C$5.00 | C$4.50 | DigiKey |
| *PCBA subtotal* | *C$57.00* | *C$48.50* | *C$43.25* | |

#### Battery + power

| Component | 25 units | 50 units | 75 units |
|-----------|----------|----------|----------|
| LiPo 60 mAh micro cell | C$8.00 | C$6.00 | C$5.00 |
| *(TP4056 charger + LDO integrated on PCBA)* | — | — | — |
| *Power subtotal* | *C$8.00* | *C$6.00* | *C$5.00* |

#### Shell + mechanical

| Component | 25 units | 50 units | 75 units |
|-----------|----------|----------|----------|
| 3D shell top + bottom (MJF PA12) | C$15.00 | C$10.00 | C$8.00 |
| Conformal coating (per unit share) | C$1.00 | C$0.50 | C$0.30 |
| O-ring / RTV sealant | C$3.00 | C$2.00 | C$1.50 |
| Magnetic connector pair (pod + cradle) | C$4.00 | C$3.00 | C$2.50 |
| *Shell subtotal* | *C$23.00* | *C$15.50* | *C$12.30* |

#### Electrode 3-pack (starter kit bundle)

| Component | 25 units (75 elec.) | 50 units (150 elec.) | 75 units (225 elec.) |
|-----------|---------------------|----------------------|----------------------|
| Bare PCB (panelized 12-up) | C$4.29 (C$1.43×3) | C$3.30 (C$1.10×3) | C$2.70 (C$0.90×3) |
| Ag/AgCl paste (10 mg × 3) | C$0.72 | C$0.72 | C$0.72 |
| MIP chemistry — pyrrole + hydrocortisone (×3) | C$0.21 | C$0.21 | C$0.21 |
| Template wash — ethanol + acetic acid (×3) | C$2.76 | C$2.40 | C$2.10 |
| PBS buffer (×3) | C$0.33 | C$0.33 | C$0.33 |
| Electrode QC labor (5 min/ea × 3 at C$30/hr) | C$7.50 | C$7.50 | C$7.50 |
| Foil pouch + desiccant (×3) | C$1.50 | C$1.20 | C$1.00 |
| *Electrode 3-pack subtotal* | *C$17.31* | *C$15.66* | *C$14.56* |

#### Charging cradle

| Component | 25 units | 50 units | 75 units |
|-----------|----------|----------|----------|
| Cradle body (MJF PA12) | C$10.00 | C$7.00 | C$5.00 |
| Cradle PCB + USB-C connector | C$5.00 | C$3.50 | C$3.00 |
| USB-C cable (1 m) | C$5.00 | C$3.00 | C$2.00 |
| *Cradle subtotal* | *C$20.00* | *C$13.50* | *C$10.00* |

#### Accessories

| Component | 25 units | 50 units | 75 units |
|-----------|----------|----------|----------|
| 18 mm silicone strap | C$8.00 | C$5.00 | C$4.00 |
| Spring bars (2x) | C$1.00 | C$0.50 | C$0.30 |
| *Accessories subtotal* | *C$9.00* | *C$5.50* | *C$4.30* |

#### Assembly labor

Hand assembly at C$30/hr shop rate. Time per unit decreases with jig development and practice.

| Task | 25 units | 50 units | 75 units |
|------|----------|----------|----------|
| Electronics integration + programming | C$15.00 (30 min) | C$12.00 (24 min) | C$10.00 (20 min) |
| Shell assembly + sealing + cure | C$10.00 (20 min) | C$7.50 (15 min) | C$6.00 (12 min) |
| Electrode fabrication (batch, amortized per unit) | C$7.50 (15 min) | C$6.00 (12 min) | C$5.00 (10 min) |
| QC — functional test + BLE pairing + impedance | C$7.50 (15 min) | C$6.00 (12 min) | C$5.00 (10 min) |
| *Labor subtotal* | *C$40.00* | *C$31.50* | *C$26.00* |

### Per-unit summary

| Category | 25 units | 50 units | 75 units |
|----------|----------|----------|----------|
| Main PCBA | C$57.00 | C$48.50 | C$43.25 |
| Battery + power | C$8.00 | C$6.00 | C$5.00 |
| Shell + mechanical | C$23.00 | C$15.50 | C$12.30 |
| Electrode 3-pack | C$17.31 | C$15.66 | C$14.56 |
| Charging cradle | C$20.00 | C$13.50 | C$10.00 |
| Accessories | C$9.00 | C$5.50 | C$4.30 |
| Assembly labor | C$40.00 | C$31.50 | C$26.00 |
| **Per-unit COGS** | **C$174.31** | **C$136.16** | **C$115.41** |

### Batch costs

| | 25 units | 50 units | 75 units |
|--|----------|----------|----------|
| **Per-unit × quantity** | C$4,358 | C$6,808 | C$8,656 |
| | | | |
| **NRE + one-time costs** | | | |
| JLCPCB SMT setup fee | C$40 | C$40 | C$40 |
| Cortisol calibration standard | C$75 | C$75 | C$75 |
| Conformal coating (bottle) | C$15 | C$15 | C$15 |
| Sealant / RTV tube | C$8 | C$8 | C$8 |
| Foil pouches + desiccant (bulk pack) | C$15 | C$15 | C$15 |
| *NRE subtotal* | *C$153* | *C$153* | *C$153* |
| | | | |
| **Additional shared materials** | | | |
| Electrode PCB panels (beyond 60 on hand) | C$86 (5 panels = 60 more) | C$170 (10 panels = 120 more) | C$250 (15 panels = 180 more) |
| Ethanol reorders (bottles beyond first) | C$80 (2 bottles) | C$160 (4 bottles) | C$200 (5 bottles) |
| PBS reorder (if needed) | — | — | C$34 |
| *Additional materials subtotal* | *C$166* | *C$330* | *C$484* |
| | | | |
| **New spend total** | **C$4,677** | **C$7,291** | **C$9,293** |

### Total program cost (including already invested C$1,439)

| | 25 units | 50 units | 75 units |
|--|----------|----------|----------|
| Already invested (tools, dev boards, materials on hand) | C$1,439 | C$1,439 | C$1,439 |
| New spend | C$4,677 | C$7,291 | C$9,293 |
| **Total program cost** | **C$6,116** | **C$8,730** | **C$10,732** |
| **Fully loaded per unit (total / qty)** | **C$244.64** | **C$174.60** | **C$143.09** |

The "fully loaded" cost amortizes your existing C$1,439 investment (dev boards for testing, tools, materials inventory) across the production run. The "new spend per unit" (what you'd actually pay going forward) is lower:

| | 25 units | 50 units | 75 units |
|--|----------|----------|----------|
| New spend per unit | C$187.08 | C$145.82 | C$123.91 |

### What the existing inventory covers

Your C$1,439 already purchased covers these materials for the production run — no additional purchase needed:

| Material | On hand | Consumed by 75 units (225 electrodes) | Remaining after 75 units |
|----------|---------|---------------------------------------|--------------------------|
| Ag/AgCl paste 10 g | 10,000 mg | 2,250 mg (22.5%) | 7,750 mg (77.5%) |
| Pyrrole 25 mL | 25,000 µL | 1,553 µL (6.2%) | 23,447 µL (93.8%) |
| Hydrocortisone 1 g | 1,000 mg | 81 mg (8.1%) | 919 mg (91.9%) |
| Acetic acid 500 mL | 500 mL | 225 mL (45%) | 275 mL (55%) |
| Electrode PCBs (first 60) | 60 | 60 (100%) | 0 |
| Stencils (3x) | 3 | reusable | 3 |
| Micropipettes | 1 set | reusable | 1 set |
| Glass vials | 12 | reusable | 12 |

Even at 75 units, the pyrrole (94% left), hydrocortisone (92%), and Ag/AgCl paste (78%) are barely touched. These materials were the most expensive purchases and they're essentially a rounding error in the production run.

### Cost comparison vs. cost-analysis.md projections

| | 25 units (actual) | 50 units (actual) | 75 units (actual) | 100 units (projected) |
|--|-------------------|-------------------|--------------------|----------------------|
| Main PCBA | C$57.00 | C$48.50 | C$43.25 | C$31.50 |
| Battery + power | C$8.00 | C$6.00 | C$5.00 | C$5.00 |
| Shell + mechanical | C$23.00 | C$15.50 | C$12.30 | C$11.00 |
| Electrode 3-pack | C$17.31 | C$15.66 | C$14.56 | C$27.00 |
| Charging cradle | C$20.00 | C$13.50 | C$10.00 | C$8.00 |
| Accessories | C$9.00 | C$5.50 | C$4.30 | C$4.70 |
| Assembly labor | C$40.00 | C$31.50 | C$26.00 | C$15.00 |
| Packaging + QC | — | — | — | C$9.50 |
| **Per-unit COGS** | **C$174.31** | **C$136.16** | **C$115.41** | **C$115.70** |

**At 75 units, the per-unit COGS (C$115.41) is essentially identical to the cost-analysis.md 100-unit projection (C$115.70).** The electrode 3-pack is cheaper than projected (C$14.56 vs C$27.00) but assembly labor is higher (C$26 vs C$15) — these roughly cancel out.

### Pricing at each quantity

Using the planned C$249 starter kit price from cost-analysis.md:

| | 25 units | 50 units | 75 units |
|--|----------|----------|----------|
| Revenue per unit | C$249 | C$249 | C$249 |
| COGS per unit | C$174.31 | C$136.16 | C$115.41 |
| **Gross profit per unit** | **C$74.69** | **C$112.84** | **C$133.59** |
| **Gross margin** | **30%** | **45%** | **54%** |
| | | | |
| **Total batch revenue** | C$6,225 | C$12,450 | C$18,675 |
| **Total COGS (new spend)** | C$4,677 | C$7,291 | C$9,293 |
| **Batch gross profit** | **C$1,548** | **C$5,159** | **C$9,382** |

At 25 units, 30% gross margin is tight but positive. At 50+, margins are healthy. The C$249 price point works even at very small batches — you don't need to reach 100 units to be profitable on hardware.

### Electrode refill economics at each quantity

| | 25 units (75 elec.) | 50 units (150 elec.) | 75 units (225 elec.) |
|--|---------------------|----------------------|----------------------|
| Materials per electrode | C$2.76 | C$2.34 | C$1.94 |
| + QC + pouch per electrode | C$3.17 | C$2.90 | C$2.84 |
| **Fully loaded per electrode** | **C$5.93** | **C$5.24** | **C$4.78** |
| **Per 3-pack** | **C$17.79** | **C$15.72** | **C$14.34** |
| Subscription price (C$39/mo) | C$39 | C$39 | C$39 |
| **Margin per 3-pack shipment** | **C$21.21 (54%)** | **C$23.28 (60%)** | **C$24.66 (63%)** |

The electrode subscription is margin-positive from the very first batch. At C$39/month and ~C$15-18 COGS per 3-pack shipment, the consumables business delivers 54-63% gross margin even at 25-75 user scale.
