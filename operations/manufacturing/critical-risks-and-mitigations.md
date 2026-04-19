# Critical Risks and Mitigations

> The things that will bite you — ranked by impact and likelihood, with concrete mitigations.

## Risk matrix

| # | Risk | Impact | Likelihood | Severity | Phase |
|---|------|--------|------------|----------|-------|
| 1 | MIP electrode reproducibility too low | Critical | High | **Critical** | Prototype → Pilot |
| 2 | Electrode shelf life too short | High | Medium | **High** | Pilot → Launch |
| 3 | Sweat variability defeats calibration | Critical | Medium | **High** | Prototype → Launch |
| 4 | Biocompatibility test failure | High | Low | **Medium** | Pilot |
| 5 | Depth-milled PCB tolerance drift | Medium | Medium | **Medium** | Pilot → Scale |
| 6 | AD5941 supply disruption | High | Low | **Medium** | Launch → Scale |
| 7 | Battery certification delays | Medium | Medium | **Medium** | Pilot |
| 8 | MIP sensor fouling on-body | High | Medium | **High** | Prototype → Launch |
| 9 | Regulatory pathway blocked | Critical | Low | **Medium** | Launch |
| 10 | Patent infringement claim | High | Low | **Medium** | Launch → Scale |
| 11 | Cold chain / storage failures | Medium | Medium | **Medium** | Launch → Scale |
| 12 | User electrode swap failures | Medium | Medium | **Medium** | Launch |

---

## Risk 1: MIP electrode reproducibility too low

**What happens:** Batch-to-batch and electrode-to-electrode variation in MIP sensitivity exceeds ±30%, making calibration unreliable and QC reject rates too high.

**Why it's likely:** Electropolymerization is inherently sensitive to temperature, monomer concentration, electrode surface condition, and scan rate. Small variations compound. Published MIP literature commonly reports 10-30% CV in lab settings; manufacturing conditions add more.

**Impact:** If >30% of electrodes fail QC, effective COGS per electrode nearly doubles. If sensitivity varies >30% between passing electrodes, per-user calibration becomes mandatory (adds complexity to app and first-use experience).

**Mitigations:**
- **Process control:** Tightly control solution temperature (±1°C), monomer concentration (weigh to ±0.1mg), and CV scan rate. Document every parameter.
- **Pre-conditioning:** Standardize electrode surface preparation before MIP deposition (electrochemical cleaning cycle in H2SO4 eliminates surface variability).
- **Statistical process control (SPC):** Track impedance and sensitivity of every electrode from batch 1. Build control charts. Detect drift before it becomes a reject spike.
- **Per-electrode calibration:** Design the firmware/app to perform a 2-point calibration on each new electrode (blank + known cortisol standard). This turns electrode variability from a manufacturing problem into a user experience problem (adds 2 min to first use).
- **Accept and price it:** Budget for 20-30% reject rate in COGS. If yield improves, it's margin upside.

**Metric to track:** Coefficient of variation (CV) of cortisol sensitivity within and across batches. Target: <20% CV within batch, <30% across batches.

---

## Risk 2: Electrode shelf life too short

**What happens:** Sealed electrodes degrade in storage. After 2-3 months, sensitivity drops below acceptable threshold. Can't stockpile inventory, can't ship internationally (transit time eats into shelf life).

**Why it's likely:** MIP polymers can slowly cross-link or degrade. Ag/AgCl reference electrodes are moisture-sensitive. ENIG gold is porous (even with electrodeposition, long-term oxidation possible).

**Impact:** If shelf life <3 months — can only manufacture-to-order, 1-2 week fulfillment delay, no inventory buffer, subscription model breaks. If 3-6 months — manageable with quarterly production. If 6-12 months — comfortable.

**Mitigations:**
- **Start accelerated aging NOW** — seal 20 electrodes in foil pouches today, store at 45°C/75% RH, test 3 every 2 weeks. Results in 8 weeks.
- **Parallel real-time study** — seal 20 more, store at room temp, test monthly. Validates accelerated results.
- **Desiccant + nitrogen flush** — fill pouches with dry nitrogen before sealing ($0.10/pouch for N2, significant moisture reduction).
- **Parylene coating** — conformal parylene coating over the MIP surface acts as a diffusion barrier while being thin enough to not block analyte. $1-2/electrode at batch scale.
- **Design for short shelf life** — if shelf life is truly short, pivot to a "fresh electrode" model where electrodes ship within 2 weeks of manufacture. Premium positioning: "freshly made sensors, not warehouse stock."

**Metric to track:** % sensitivity retention vs days since manufacture, in sealed pouch at 25°C.

---

## Risk 3: Sweat variability defeats calibration

**What happens:** Cortisol concentration in sweat varies wildly between individuals, body sites, hydration levels, exercise state, and ambient temperature. The correlation between sweat cortisol and blood/saliva cortisol is too weak for meaningful measurement.

**Why it's concerning:** Published sweat-cortisol literature shows correlations of r = 0.4-0.85 with serum. The lower end is not useful. Sweat rate, pH, salt concentration, and protein content all affect electrochemical measurements. This is a fundamental science risk, not a manufacturing risk.

**Impact:** If sweat cortisol doesn't reliably track systemic cortisol, the product's core value proposition collapses. No amount of manufacturing excellence fixes bad science.

**Mitigations:**
- **MIP/NIP differential measurement** — the NIP (non-imprinted polymer) control electrode on every board cancels out non-specific interference. This is already in the design and is the strongest mitigation.
- **Environmental compensation** — TMP117 (temperature) and SHT40 (humidity) sensors enable algorithmic correction for sweat rate and evaporation effects.
- **Trend over absolute** — position the product as tracking cortisol *trends* (rising, falling, circadian rhythm) rather than absolute concentrations. Trends are more robust to inter-individual variation.
- **Personal baseline calibration** — first 3-7 days establish each user's baseline pattern. All subsequent readings are relative to *their* baseline, not a universal scale.
- **Validation study design** — N ≥ 20 subjects, simultaneous sweat + saliva sampling, 4 time points across the day (morning, noon, afternoon, evening). Statistical target: within-subject correlation r > 0.7.

**Decision gate:** If the prototype validation study shows within-subject correlation r < 0.5, **stop and re-evaluate** before investing in manufacturing.

---

## Risk 4: Biocompatibility test failure

**What happens:** ISO 10993 cytotoxicity or sensitization testing shows that a material in skin contact (FR4 edge, ENIG gold, MIP polymer, Ag/AgCl, shell material) causes adverse reaction.

**Why it's possible (but unlikely):** FR4 and ENIG are widely used in medical devices. MIP polymers (polypyrrole, polyaniline) are generally biocompatible but not universally tested in wearable configurations. Ag/AgCl is a standard biomedical electrode material.

**Impact:** Fail requires material substitution and re-testing. Adds 3-6 months to timeline.

**Mitigations:**
- **Test early** — submit materials for ISO 10993-5 (cytotoxicity, $2K-5K) and ISO 10993-10 (sensitization, $3K-8K) during Phase 1, not Phase 2.
- **Use established materials** — FR4, ENIG gold, Ag/AgCl ink, PA12 (MJF) are all commonly used in skin-contact devices. The novel material is the MIP polymer.
- **MIP polymer literature review** — polypyrrole and polyaniline have published biocompatibility data for implantable and skin-contact applications. Compile this as supporting evidence.
- **Fallback:** If MIP polymer fails, consider a thin Nafion or Parylene barrier layer between the MIP and skin. Both are established biocompatible materials.

**Testing labs (Canada):**
- Nelson Laboratories (Salt Lake City — closest major lab)
- NAMSA (Northwood, Ohio)
- SGS (various locations)

---

## Risk 5: Depth-milled PCB tolerance drift

**What happens:** The PCB fab house's depth milling tolerance degrades over time or between operators. Ledge thickness varies from 0.6-1.0mm instead of the specified 0.8 ±0.1mm. Boards don't fit channels properly.

**Impact:** Too thin (0.6mm) — ledge is fragile, may crack during insertion. Too thick (1.0mm) — doesn't fit in channel slot, won't slide. Either way, field failures or manufacturing rejects.

**Mitigations:**
- **Incoming inspection** — measure ledge thickness on 3+ boards per panel at receiving. This is a 2-minute check with a micrometer.
- **Dual-source** — qualify two fab houses. If one drifts, switch to backup.
- **Go/no-go gauge** — machined aluminum block with a 1.0mm slot. If the ledge fits, it passes. If it doesn't, reject. Takes 5 seconds per board.
- **Specification tightening** — if tolerance drift is a recurring issue, tighten the spec from ±0.1mm to ±0.05mm (available from higher-tier fabs at moderate cost premium).

---

## Risk 6: AD5941 supply disruption

**What happens:** Analog Devices has a lead time spike, allocation, or end-of-life notice for the AD5941 potentiostat IC.

**Impact:** No AD5941 = no main PCBA = no product. 3-6 month disruption.

**Mitigations:**
- **Safety stock** — maintain 3-6 months of AD5941 inventory at all times (at $8-10/unit, 100 units = $800-1000 in buffer stock).
- **Alternate source** — AD5940 is pin-compatible. Validate firmware compatibility and keep it as a qualified second source.
- **Long-term:** At 10K+ units, engage Analog Devices directly as a design-in customer. They prioritize allocation for design-in customers.

---

## Risk 7: Battery certification delays

**What happens:** UN 38.3 testing takes longer than expected, or the battery cell fails a test. Can't legally ship the product until certification is complete.

**Impact:** 2-4 month delay to launch.

**Mitigations:**
- **Start early** — submit battery for UN 38.3 testing during Phase 1 prototype development, not Phase 2 launch prep.
- **Use a pre-certified cell** — some battery suppliers (e.g., Renata, Ultralife) sell cells with UN 38.3 certificates included. Costs more per cell but eliminates certification timeline.
- **Small cell advantage** — at 0.22 Wh, the CortiPod battery is well under the 100 Wh threshold. Most transport regulations have simplified requirements for cells this small.

---

## Risk 8: MIP sensor fouling on-body

**What happens:** After 1-3 days of continuous wear, sweat proteins, dead skin cells, and skin oils foul the electrode surface. Sensitivity drops, baseline drifts, readings become unreliable.

**Why it's likely:** Every continuous sweat sensor faces fouling. It's a question of *when*, not *if*. Published literature reports electrode fouling in sweat within 24-72 hours without mitigation.

**Impact:** Determines electrode replacement interval. If fouling happens in <24 hours, the product is impractical. If 1-2 weeks, the electrode is a consumable replaced biweekly. If 4+ weeks, monthly replacement (ideal for subscription cadence).

**Mitigations:**
- **Nafion membrane** — thin Nafion coating acts as a size-exclusion membrane, blocking large proteins while allowing small cortisol molecules through. Extends sensor life 2-5x in published studies.
- **Intermittent measurement** — instead of continuous sensing, measure every 15-30 minutes with a brief cleaning pulse (anodic stripping) between measurements. Reduces cumulative fouling exposure.
- **User cleaning protocol** — instruct users to rinse the sensor face with water daily. Simple but effective for removing surface debris.
- **Hydrogel interface** — a thin agarose or PVA hydrogel layer between skin and electrode pre-filters sweat. Adds manufacturing step but dramatically reduces fouling.
- **Design for replacement** — the slide-in/slide-out electrode design already assumes the electrode is a consumable. If fouling limits life to 1-2 weeks, price the subscription accordingly.

**Metric to track:** Days of continuous wear before sensitivity drops below 70% of initial value.

---

## Risk 9: Regulatory pathway blocked

**What happens:** Health Canada or FDA determines the product is a medical device (not wellness) based on marketing claims, and requires full Class II or De Novo clearance before sale.

**Impact:** 2-3 year delay, $145K-615K additional cost.

**Mitigations:**
- **Marketing language discipline** — never claim to diagnose, treat, or monitor a disease. Use: "stress tracking," "wellness insights," "cortisol trends." Avoid: "cortisol level," "Cushing's," "adrenal insufficiency."
- **Follow the ELI Health precedent** — ELI Health (Montreal) sells a cortisol test under General Wellness without an MDL. Study their marketing claims and regulatory filings.
- **Pre-submission meeting** — before launch, request a pre-submission meeting with Health Canada ($0, they do this). Present the product and ask: "Is this a medical device in your view?" Get the answer in writing.
- **Parallel path** — build wellness launch (fast) while preparing Class II submission (slow) in parallel. Revenue from wellness sales funds the medical device pathway.

See: [../../docs/regulatory-commercialization-guide.md](../../docs/regulatory-commercialization-guide.md)

---

## Risk 10: Patent infringement claim

**What happens:** A patent holder (e.g., Florida International University for US9846137, or Plaxco for US8003374) sends a cease-and-desist or files suit.

**Impact:** Legal costs ($50K-500K to defend), possible injunction stopping sales, settlement/license fees.

**Mitigations:**
- **Patent landscape analysis** — already completed (see docs/patent-landscape-analysis.md). Phase 1 (cortisol + cortisone) is clear of blocking patents.
- **Design-arounds implemented** — CNT instead of AuNP for Phase 2+, label-free EIS instead of MB-tagged aptamers for Phase 4.
- **Provisional patent** — file before any public disclosure. Establishes priority date for CortiPod-specific innovations (dual MIP/NIP differential, humidity-based evaporation correction, etc.).
- **Freedom-to-operate opinion** — $1.5K-2.5K for attorney opinion letter on the most relevant patents. Strong defense if challenged.
- **Patent insurance** — available from companies like RPX or Unified Patents. $5K-15K/year for coverage.

---

## Risk 11: Cold chain / storage failures

**What happens:** Electrode pouches are exposed to heat during shipping (summer, warehouse) or storage (user leaves in car). MIP degrades. Electrode arrives dead.

**Impact:** Customer receives non-functional electrode. Refund/replacement cost. Negative reviews.

**Mitigations:**
- **Temperature indicator** — add a small temperature indicator sticker inside the pouch (turns red if exposed to >40°C). $0.05-0.10/unit. User can see if electrode was compromised before opening.
- **Thermal stability testing** — include 40°C/24h and 50°C/4h exposure in the shelf life study. If electrodes survive these spikes, summer shipping is safe.
- **Insulated mailers** — for summer months, use insulated bubble mailers ($0.50-1.00/shipment). Keeps package below 40°C for 24-48 hours in transit.
- **Storage instructions** — clear labeling: "Store at room temperature. Do not leave in direct sunlight or hot vehicles."

---

## Risk 12: User electrode swap failures

**What happens:** Users struggle to slide the electrode in/out. The detent doesn't click. Electrode is inserted backwards (MIP/NIP swapped). Pogo pins don't make contact. User thinks product is broken.

**Impact:** Support tickets, returns, negative word-of-mouth. This is a UX risk, not a manufacturing risk — but manufacturing determines the mechanical tolerances that drive the experience.

**Mitigations:**
- **Orientation key** — corner chamfer on the electrode prevents 180° insertion error. Already in the design.
- **Generous channel clearance** — 0.2mm clearance per side. Enough for easy slide, tight enough for stability.
- **Tactile feedback** — detent click confirms full seating. User guide says "push until you hear/feel a click."
- **App feedback** — when a new electrode is inserted, the app detects impedance change and confirms "New electrode detected" or "Check electrode — no contact detected."
- **Beta tester UX study** — during Phase 1 pilot, ask every beta tester to swap electrodes while observed. Note any hesitation, confusion, or failure. Iterate on the channel geometry if needed.
- **Video guide** — 15-second "how to swap" video in the app (autoplay on first swap event).

---

## Risk summary: what to do now

### Before investing in manufacturing (Phase 0 actions)

| Action | Cost | Time | Addresses risk(s) |
|--------|------|------|--------------------|
| Run on-body validation study (N=5+) | $500 (supplies) | 2-4 weeks | #3 (sweat variability) |
| Start accelerated aging study | $200 (pouches, desiccant, oven) | 8 weeks | #2 (shelf life) |
| Characterize MIP batch yield (20+ electrodes) | $300 (materials) | 2 weeks | #1 (reproducibility) |
| Submit biocompatibility samples | $5K-15K | 8-12 weeks | #4 (biocompat) |
| File provisional patent | $2K-4K | 2-4 weeks | #10 (IP) |
| Order UN 38.3 battery cert | $2K-5K | 6-8 weeks | #7 (battery) |
| Request Health Canada pre-sub meeting | $0 | 4-8 weeks (scheduling) | #9 (regulatory) |

**Total pre-manufacturing investment: ~$10K-25K**
**Timeline: 8-12 weeks (most items run in parallel)**

These actions retire the highest-risk unknowns before committing to manufacturing infrastructure.
