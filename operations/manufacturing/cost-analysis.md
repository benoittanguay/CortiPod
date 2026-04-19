# Cost Analysis

> COGS breakdown at 100, 1K, and 10K unit volumes with margin analysis against target pricing.

## Starter kit COGS

The starter kit includes: shell (sealed with electronics), 3 electrode PCBs, charging cradle, strap, cable, packaging.

### Component-level breakdown

| Component | 100 units | 1K units | 10K units | Notes |
|-----------|-----------|----------|-----------|-------|
| **Main PCBA** | | | | |
| PCB bare (24×24mm, 2-layer ENIG) | $2.00 | $0.80 | $0.30 | JLCPCB → CM |
| SMT assembly | $8.00 | $5.00 | $3.00 | Turnkey → CM |
| nRF52832 module (MDBT42Q) | $7.00 | $5.50 | $3.50 | Module → raw IC at 5K+ saves $2 |
| AD5941 potentiostat IC | $10.00 | $8.00 | $6.00 | Analog Devices, volume discount |
| TMP117 + SHT40 sensors | $3.00 | $2.50 | $2.00 | |
| Passives + connectors | $1.50 | $1.00 | $0.70 | |
| *Main PCBA subtotal* | *$31.50* | *$22.80* | *$15.50* | |
| | | | | |
| **Pogo pins** | | | | |
| 4x Mill-Max 0906 | $4.00 | $2.00 | $1.00 | Volume pricing from Mill-Max |
| | | | | |
| **Battery** | | | | |
| 60mAh LiPo + protection | $5.00 | $3.00 | $2.00 | Custom cell at 1K+ |
| | | | | |
| **Shell** | | | | |
| Enclosure (MJF → injection mold) | $10.00 | $5.00 | $1.50 | MJF → silicone mold → steel mold |
| Conformal coating | $0.50 | $0.30 | $0.20 | Spray application |
| UV adhesive / weld energy | $0.50 | $0.30 | $0.10 | UV cure → ultrasonic weld |
| *Shell subtotal* | *$11.00* | *$5.60* | *$1.80* | |
| | | | | |
| **Electrode PCBs (×3)** | | | | |
| Bare PCB (stepped, depth-milled) | $12.00 | $6.00 | $1.50 | $4/ea → $2/ea → $0.50/ea |
| MIP chemistry (materials) | $9.00 | $4.50 | $1.50 | $3/ea → $1.50/ea → $0.50/ea |
| Ag/AgCl ink (amortized) | $1.50 | $0.90 | $0.30 | $0.50/ea → $0.30/ea → $0.10/ea |
| Electrode QC (labor + consumables) | $3.00 | $1.50 | $0.60 | $1/ea → $0.50/ea → $0.20/ea |
| Foil pouches + desiccant | $1.50 | $0.90 | $0.45 | $0.50/ea → $0.30/ea → $0.15/ea |
| *Electrode subtotal (3 pack)* | *$27.00* | *$13.80* | *$4.35* | |
| | | | | |
| **Charging cradle** | | | | |
| Cradle body (MJF → mold) | $5.00 | $3.00 | $1.00 | Co-mold with shell at scale |
| Cradle PCB + USB-C connector | $3.00 | $2.00 | $1.00 | Simple 2-layer PCBA |
| *Cradle subtotal* | *$8.00* | *$5.00* | *$2.00* | |
| | | | | |
| **Accessories** | | | | |
| 18mm silicone strap | $3.00 | $2.00 | $1.00 | Alibaba sourcing |
| Spring bars (×2) | $0.20 | $0.10 | $0.05 | |
| USB-C cable (1m) | $1.50 | $1.00 | $0.50 | |
| *Accessories subtotal* | *$4.70* | *$3.10* | *$1.55* | |
| | | | | |
| **Assembly labor** | | | | |
| Station 1 (electronics) | $5.00 | $3.00 | $1.00 | At $30/hr shop rate |
| Station 2 (shell assembly) | $5.00 | $3.00 | $1.00 | |
| Station 3 (electrode prep) | $3.00 | $1.50 | $0.50 | Amortized across batch |
| Station 4 (packaging) | $2.00 | $1.50 | $0.50 | |
| *Labor subtotal* | *$15.00* | *$9.00* | *$3.00* | |
| | | | | |
| **Packaging** | | | | |
| Retail box (custom printed) | $3.00 | $2.00 | $1.00 | Packlane → volume printer |
| Form-fit insert (EVA/pulp) | $1.00 | $0.50 | $0.30 | |
| Printed materials | $0.50 | $0.30 | $0.15 | Quick start guide + inserts |
| *Packaging subtotal* | *$4.50* | *$2.80* | *$1.45* | |
| | | | | |
| **Testing / QC** | | | | |
| Component inspection | $1.00 | $0.50 | $0.20 | |
| Functional testing (Stations 1+2) | $2.00 | $1.50 | $0.50 | Automated at scale |
| Electrode batch testing | $2.00 | $1.00 | $0.30 | Amortized over batch |
| *QC subtotal* | *$5.00* | *$3.00* | *$1.00* | |

### Starter kit COGS summary

| | 100 units | 1K units | 10K units |
|--|-----------|----------|-----------|
| **Total COGS** | **$115.70** | **$70.30** | **$32.65** |
| Largest cost driver | Main PCBA ($31.50) | Main PCBA ($22.80) | Main PCBA ($15.50) |
| Second largest | Electrodes 3-pack ($27.00) | Electrodes 3-pack ($13.80) | Electrodes 3-pack ($4.35) |

---

## Electrode refill COGS

The 3-pack electrode refill is the subscription consumable.

| Component | 100 packs | 1K packs | 10K packs |
|-----------|-----------|----------|-----------|
| 3x bare electrode PCB | $12.00 | $6.00 | $1.50 |
| 3x MIP chemistry | $9.00 | $4.50 | $1.50 |
| 3x Ag/AgCl ink | $1.50 | $0.90 | $0.30 |
| 3x QC | $3.00 | $1.50 | $0.60 |
| 3x foil pouch + desiccant | $1.50 | $0.90 | $0.45 |
| Packaging (small box + insert) | $1.50 | $0.80 | $0.40 |
| Assembly labor | $2.00 | $1.00 | $0.50 |
| **Total per 3-pack** | **$30.50** | **$15.60** | **$5.25** |
| **Per electrode** | **$10.17** | **$5.20** | **$1.75** |

---

## Electrode consumption model

Electrode lifetime is determined by sweat fouling, the anti-fouling membrane (if any), and the operating mode of the sensor. The v1 product ships with **overoxidized bare MIP + electropulse cleaning between measurements** — no membrane required. Membrane configurations are modeled as future improvements.

### Documented electrode lifetimes

From `docs/anti-fouling-membrane-research.md`, `docs/mip-contingency-plans.md`, and `docs/plans/2026-04-05-cortipod-build-plan.md`:

**Raw baseline (continuous exposure, no mitigations):**

| Configuration | Operational lifetime | Source |
|--------------|---------------------|--------|
| Bare MIP, continuous exposure | 4-8 hours | anti-fouling-membrane-research.md |

**v1 product operating mode adjustments:**

The raw 4-8 hour number assumes continuous electrochemical exposure in sweat. The actual v1 product operates differently:

| Factor | Effect on lifetime | Source |
|--------|-------------------|--------|
| **Overoxidation during fabrication** | ~2× fouling resistance | build-plan Step 2b: "fouling resistance roughly doubles" |
| **Intermittent measurement (every 15 min)** | ~27% duty cycle (4 min active per 15 min interval) | patent-landscape-analysis.md: "measures every 15 minutes" |
| **Electropulse cleaning between measurements** | Removes loosely adsorbed proteins each cycle | mip-contingency-plans.md, Failure 3 mitigations |

**Combined effect:** Overoxidation doubles the baseline to 8-16 hours of continuous exposure. But the electrode only accumulates ~4.3 hours of electrochemical exposure per 16-hour wear day (27% duty cycle). Each measurement window starts with a cleaning pulse that resets surface fouling. Effective electrode lifetime: **1-3 days** without any membrane.

**All configurations (v1 worst case through best case):**

| Configuration | Stack | Operational lifetime | Sensitivity (vs bare) | Source |
|--------------|-------|---------------------|-----------------------|--------|
| **v1: Overoxidized MIP + cleaning pulses** | No membrane | **1-3 days** | 65-75% (overox cost) | Combined from build plan + contingency docs |
| Nafion only (recommended next step) | 0.5% Nafion, ~0.3 μm | **3-7 days** | 70-85% | anti-fouling-membrane-research.md |
| PU only | 5% PU in THF, ~15 μm | **7-14 days** | 40-70% | anti-fouling-membrane-research.md |
| Nafion + PU dual stack | Nafion + PU overlay | **10-14 days** | 40-60% | mip-contingency-plans.md, Rung 4 |

### Consumption assumptions

| Parameter | Value | Rationale |
|-----------|-------|-----------|
| Target wear compliance | 80% | Active sensor 80% of the time (292 days/year) |
| QC reject rate | 20% | 1 in 5 electrodes fails QC |
| Active sensor days per year | 292 | 365 × 0.80 |

### Electrodes consumed per user per year — all scenarios

| Scenario | Lifetime | Electrodes consumed/yr (80% uptime) | Production needed (20% reject) | Swaps per month |
|----------|----------|-------------------------------------|--------------------------------|-----------------|
| **v1 worst case (overox + cleaning, 1 day)** | **1 day** | **292** | **365** | **~24** |
| **v1 midpoint (overox + cleaning, 2 days)** | **2 days** | **146** | **183** | **~12** |
| **v1 best case (overox + cleaning, 3 days)** | **3 days** | **97** | **122** | **~8** |
| Nafion (midpoint) | 5 days | 58 | 73 | ~5 |
| Nafion (high end) | 7 days | 42 | 52 | ~3.5 |
| PU (midpoint) | 10 days | 29 | 37 | ~2.5 |
| Nafion + PU (midpoint) | 12 days | 24 | 31 | ~2 |
| **Best case: Nafion + PU (high end)** | **14 days** | **21** | **26** | **~1.5** |

**The v1 midpoint (2-day life) is the planning baseline.** At 146 electrodes/year and ~12 swaps/month, the user experience is comparable to changing a contact lens — routine but not burdensome. The 3-day v1 best case (8 swaps/month) approaches weekly replacement cadence.

### What the v1 scenarios mean in practice

| | v1 worst (1 day) | v1 midpoint (2 days) | v1 best (3 days) |
|--|-------------------|----------------------|-------------------|
| Swaps per month | ~24 (daily) | ~12 (every other day) | ~8 (twice a week) |
| 3-pack lasts | 3 days | 6 days | 9 days |
| Monthly electrode shipment | 10 electrodes | 5 electrodes | 3 electrodes |
| User friction | High (daily habit) | Moderate (routine) | Low (weekly-ish) |
| Comparable product cadence | Daily contact lens | Biweekly contact lens | Dexcom G7 (10-day) |

### Electrode COGS per user per year

Using the per-electrode COGS from the refill section above (includes 20% QC reject overhead):

| Scenario | Electrodes produced/user/yr | COGS/user/yr (1K elec. scale) | COGS/user/yr (10K elec. scale) | COGS/user/yr (100K+ elec. scale) |
|----------|----------------------------|-------------------------------|--------------------------------|----------------------------------|
| **v1 worst (1 day)** | **365** | **$1,898** | **$639** | **$365** |
| **v1 midpoint (2 days)** | **183** | **$952** | **$320** | **$183** |
| **v1 best (3 days)** | **122** | **$634** | **$214** | **$122** |
| Nafion (5-day) | 73 | $380 | $128 | $73 |
| PU (10-day) | 37 | $192 | $65 | $37 |
| Nafion + PU (12-day) | 31 | $161 | $54 | $31 |

*COGS at 100K+ electrode scale assumes contract manufacturing at ~$1.00/electrode all-in.*

**v1 midpoint (2-day life) at scale:** $183/user/year electrode COGS at contract manufacturing volume. This is high but serviceable — comparable to Dexcom's per-user sensor cost. At 10K electrode scale ($320/user/year), it requires premium pricing to achieve positive margin, but it works.

**The path from v1 to Nafion is a 2.5× COGS reduction** ($183 → $73 at scale). Adding Nafion is the single highest-ROI manufacturing improvement after launch.

---

## Annual electrode demand projections

### Total electrodes to manufacture per year (including 20% QC rejects)

| | 100 users | 1K users | 5K users | 10K users |
|--|-----------|----------|----------|-----------|
| **v1 worst (1-day)** | **36,500** | **365,000** | **1,825,000** | **3,650,000** |
| **v1 midpoint (2-day)** | **18,300** | **183,000** | **915,000** | **1,830,000** |
| **v1 best (3-day)** | **12,200** | **122,000** | **610,000** | **1,220,000** |
| Nafion (5-day) | 7,300 | 73,000 | 365,000 | 730,000 |
| PU (10-day) | 3,700 | 37,000 | 185,000 | 370,000 |
| Nafion + PU (12-day) | 3,100 | 31,000 | 155,000 | 310,000 |

### Manufacturing capacity required (electrodes per working day, 250 days/year)

| | 100 users | 1K users | 5K users | 10K users |
|--|-----------|----------|----------|-----------|
| **v1 worst (1-day)** | **146/day** | **1,460/day** | **7,300/day** | **14,600/day** |
| **v1 midpoint (2-day)** | **73/day** | **732/day** | **3,660/day** | **7,320/day** |
| **v1 best (3-day)** | **49/day** | **488/day** | **2,440/day** | **4,880/day** |
| Nafion (5-day) | 29/day | 292/day | 1,460/day | 2,920/day |
| PU (10-day) | 15/day | 148/day | 740/day | 1,480/day |
| Nafion + PU (12-day) | 12/day | 124/day | 620/day | 1,240/day |

### Manufacturing method by capacity requirement

| Daily capacity | Method | Investment | Reference |
|---------------|--------|------------|-----------|
| <20/day | Single potentiostat, manual | $0 | Level 1 (current) |
| 20-50/day | Batch immersion | $100 | Level 1.5 |
| 50-200/day | Multi-channel potentiostat + panels | $500-2K | Level 2-3 |
| 200-500/day | Semi-automated dip-coating line | $5K-15K | Level 4 |
| 500-2,000/day | Contract manufacturing (Zimmer & Peacock) | $5K-15K NRE | Level 5 |
| 2,000+/day | Roll-to-roll or large-scale contract | $50K+ | Level 6 |

**Mapping scenarios to manufacturing methods:**

| Users | v1 midpoint (2-day) | v1 best (3-day) | Nafion (5-day) | Nafion + PU (12-day) |
|-------|---------------------|------------------|----------------|----------------------|
| 100 | Level 1.5 (73/day) | Level 1.5 (49/day) | Level 1.5 (29/day) | Level 1 (12/day) |
| 1K | Contract mfg (732/day) | Level 4 (488/day) | Level 4 (292/day) | Level 2-3 (124/day) |
| 5K | Contract mfg (3,660/day) | Contract mfg (2,440/day) | Contract mfg (1,460/day) | Contract mfg (620/day) |
| 10K | Contract mfg (7,320/day) | Contract mfg (4,880/day) | Contract mfg (2,920/day) | Contract mfg (1,240/day) |

**v1 midpoint (2-day life) is manageable at pilot scale.** 100 users requires 73 electrodes/day — achievable with a multi-channel batch setup (Level 1.5-2, $100-500 investment). At 1K users it requires contract manufacturing, which is expected for a post-launch product.

**Adding Nafion post-launch cuts manufacturing demand in half** (732/day → 292/day at 1K users), buying significant runway before contract manufacturing is required.

---

## Pricing model

### Required subscription price by scenario

Working backward from 60% target gross margin on consumables at scale (100K+ electrodes/year, ~$1.00/electrode all-in):

| Scenario | Electrodes/user/yr | Annual COGS (at scale) | Required price (60% margin) | Monthly equivalent |
|----------|--------------------|-----------------------|---------------------------------|--------------------|
| **v1 worst (1-day)** | **292** | **$365** | **$913/year** | **$76/month** |
| **v1 midpoint (2-day)** | **146** | **$183** | **$458/year** | **$38/month** |
| **v1 best (3-day)** | **97** | **$122** | **$305/year** | **$25/month** |
| Nafion (5-day) | 58 | $73 | $183/year | $15/month |
| PU (10-day) | 29 | $37 | $93/year | $8/month |
| Nafion + PU (12-day) | 24 | $31 | $78/year | $6.50/month |

### Comparables for context

| Product | Annual cost | Consumable cadence | What it measures |
|---------|-----------|-------------------|-----------------|
| Whoop 4.0 | $239/year | None (subscription only) | HRV (cortisol proxy) |
| Oura Ring | $72/year | None (subscription only) | HRV + skin temp |
| Dexcom Stelo (OTC CGM) | ~$1,100/year | Every 15 days | Glucose |
| Libre 3 | ~$1,400/year | Every 14 days | Glucose |
| ELI Health Hormometer | ~$336/year (42 tests) | Single-use saliva strip | Cortisol (snapshot) |
| **CortiPod v1 midpoint (2-day)** | **~$458/year** | **Every 2 days** | **Cortisol (continuous)** |
| **CortiPod v1 best (3-day)** | **~$305/year** | **Every 3 days** | **Cortisol (continuous)** |
| **CortiPod with Nafion** | **~$183/year** | **Every 5 days** | **Cortisol (continuous)** |
| **CortiPod with Nafion + PU** | **~$78/year** | **Every 12 days** | **Cortisol (continuous)** |

**v1 at 2-day life ($458/year) sits between Whoop and Dexcom Stelo.** More expensive than HRV-only wearables but dramatically cheaper than CGM — and it measures a biomarker nobody else offers in a wearable. At 3-day life ($305/year), it's competitive with ELI Health while offering continuous monitoring instead of single snapshots.

### Recommended pricing by launch configuration

| Plan | v1 launch (2-day) | v1 optimistic (3-day) | Post-Nafion (5-day) | Post-Nafion+PU (12-day) |
|------|--------------------|-----------------------|-----------------------|--------------------------|
| Starter kit (hw + 1 mo supply) | $249 + 15 electrodes | $249 + 10 electrodes | $199 + 6 electrodes | $199 + 3 electrodes |
| Monthly subscription | $39/mo | $27/mo | $16.99/mo | $8.99/mo |
| Annual subscription (15% off) | $399/year | $279/year | $169/year | $89/year |
| Annual prepay (25% off) | $349/year | $249/year | $149/year | $79/year |
| **Market positioning** | **Premium early adopter** | **Premium wellness** | **Mainstream wellness** | **Mass market** |

**v1 launch strategy:** Price at $249 hardware + $399/year subscription. Position as a premium biohacking tool for early adopters who value direct cortisol measurement over proxy metrics. The high price filters for committed users who provide the best feedback. As membrane improvements extend electrode life, subscription price drops and market widens.

**Price reduction roadmap:**
1. v1 launch (2-day life): $399/year — early adopter / biohacker market
2. Nafion update (5-day life): $169/year — mainstream wellness, Whoop-competitive
3. Nafion + PU (12-day life): $89/year — mass market, Oura-competitive

---

## Margin analysis

### Year 1 economics per user (hardware + subscription)

**At 1K-scale electrode COGS ($5.20/electrode):**

| | v1 midpoint (2-day) | v1 best (3-day) | Nafion (5-day) | Nafion + PU (12-day) |
|--|----------------------|------------------|----------------|----------------------|
| Starter kit revenue | $249 | $249 | $199 | $199 |
| Starter kit COGS (hw + bundled electrodes) | $167 | $141 | $119 | $104 |
| Subscription revenue (11 months) | $366 | $256 | $155 | $82 |
| Subscription electrode COGS | $700 | $467 | $278 | $117 |
| Fulfillment | $25 | $18 | $15 | $10 |
| **Year 1 total revenue** | **$615** | **$505** | **$354** | **$281** |
| **Year 1 total COGS** | **$892** | **$626** | **$412** | **$231** |
| **Year 1 gross profit** | **-$277** | **-$121** | **-$58** | **$50** |
| **Year 1 gross margin** | **-45%** | **-24%** | **-16%** | **18%** |

**At 10K-scale electrode COGS ($1.75/electrode):**

| | v1 midpoint (2-day) | v1 best (3-day) | Nafion (5-day) | Nafion + PU (12-day) |
|--|----------------------|------------------|----------------|----------------------|
| Starter kit revenue | $249 | $249 | $199 | $199 |
| Starter kit COGS | $60 | $51 | $46 | $38 |
| Subscription revenue (11 months) | $366 | $256 | $155 | $82 |
| Subscription electrode COGS | $236 | $157 | $94 | $39 |
| Fulfillment | $18 | $14 | $12 | $8 |
| **Year 1 total revenue** | **$615** | **$505** | **$354** | **$281** |
| **Year 1 total COGS** | **$314** | **$222** | **$152** | **$85** |
| **Year 1 gross profit** | **$301** | **$283** | **$202** | **$196** |
| **Year 1 gross margin** | **49%** | **56%** | **57%** | **70%** |

**Key insight:** v1 at 2-day electrode life **loses $277 per user at 1K scale** — the subscription revenue ($366) can't cover the electrode COGS ($700) at low manufacturing volume. But at 10K scale it reaches 49% margin, which is healthy. The path to profitability is: launch at premium price to early adopters → electrode volume drives COGS down → add Nafion to extend life and cut consumption → reduce subscription price to expand market.

### Year 2+ economics per user (subscription only, returning users)

**At 10K-scale electrode COGS:**

| | v1 midpoint (2-day) | v1 best (3-day) | Nafion (5-day) | Nafion + PU (12-day) |
|--|----------------------|------------------|----------------|----------------------|
| Annual subscription revenue | $399 | $279 | $169 | $89 |
| Annual electrode COGS | $256 | $170 | $102 | $42 |
| Fulfillment + packaging | $18 | $14 | $12 | $8 |
| **Annual gross profit** | **$125** | **$95** | **$55** | **$39** |
| **Gross margin** | **31%** | **34%** | **33%** | **44%** |

---

## 5-year aggregate projection

### Growth assumptions

| | Year 1 | Year 2 | Year 3 | Year 4 | Year 5 |
|--|--------|--------|--------|--------|--------|
| New users | 500 | 1,200 | 2,400 | 4,000 | 6,000 |
| Returning users (80% retention) | 0 | 400 | 1,280 | 3,040 | 6,432 |
| **Total active users** | **500** | **1,600** | **3,680** | **7,040** | **12,432** |

**Note:** The realistic product evolution is a transition. v1 launches with overoxidized bare MIP at ~2-day life, then Nafion is introduced within 6-12 months, reducing consumption per user by 2.5x. The projections below model each configuration in isolation; the real trajectory blends them.

### Scenario A: v1 launch — overoxidized MIP + cleaning pulses (2-day life)

Pricing: $249 starter kit + $399/year subscription

| | Year 1 | Year 2 | Year 3 | Year 4 | Year 5 |
|--|--------|--------|--------|--------|--------|
| Revenue | $323,000 | $877,600 | $1,913,920 | $3,562,560 | $6,161,168 |
| Electrodes manufactured | 91,500 | 292,800 | 673,440 | 1,288,320 | 2,275,056 |
| Electrodes/working day | 366 | 1,171 | 2,694 | 5,153 | 9,100 |
| Total COGS | $236,000 | $410,000 | $810,000 | $1,450,000 | $2,500,000 |
| **Gross profit** | **$87,000** | **$467,600** | **$1,103,920** | **$2,112,560** | **$3,661,168** |
| **Gross margin** | **27%** | **53%** | **58%** | **59%** | **59%** |
| Mfg method | Contract | Contract | Contract | Contract | Contract |
| Cumulative gross profit | $87,000 | $554,600 | $1,658,520 | $3,771,080 | $7,432,248 |

**v1 is profitable from year 1 at 27% margin**, growing to 59% as electrode COGS scales. Manufacturing requires contract production from launch (366 electrodes/day at 500 users), feasible with a partner like Zimmer & Peacock.

### Scenario B: Nafion upgrade — 5-day electrode life

Pricing: $199 starter kit + $169/year subscription (price drops when membrane extends life)

| | Year 1 | Year 2 | Year 3 | Year 4 | Year 5 |
|--|--------|--------|--------|--------|--------|
| Revenue | $176,875 | $503,200 | $1,098,320 | $2,000,960 | $3,431,408 |
| Electrodes manufactured | 36,500 | 116,800 | 268,640 | 513,920 | 907,536 |
| Electrodes/working day | 146 | 467 | 1,075 | 2,056 | 3,630 |
| Total COGS | $117,000 | $212,000 | $420,000 | $720,000 | $1,220,000 |
| **Gross profit** | **$59,875** | **$291,200** | **$678,320** | **$1,280,960** | **$2,211,408** |
| **Gross margin** | **34%** | **58%** | **62%** | **64%** | **64%** |
| Cumulative gross profit | $59,875 | $351,075 | $1,029,395 | $2,310,355 | $4,521,763 |

### Scenario C: Nafion + PU — 12-day electrode life

Pricing: $199 starter kit + $89/year subscription

| | Year 1 | Year 2 | Year 3 | Year 4 | Year 5 |
|--|--------|--------|--------|--------|--------|
| Revenue | $140,325 | $365,000 | $754,720 | $1,346,560 | $2,288,048 |
| Electrodes manufactured | 15,500 | 49,600 | 114,080 | 218,240 | 385,392 |
| Electrodes/working day | 62 | 198 | 456 | 873 | 1,542 |
| Total COGS | $80,000 | $130,000 | $230,000 | $380,000 | $620,000 |
| **Gross profit** | **$60,325** | **$235,000** | **$524,720** | **$966,560** | **$1,668,048** |
| **Gross margin** | **43%** | **64%** | **70%** | **72%** | **73%** |
| Cumulative gross profit | $60,325 | $295,325 | $820,045 | $1,786,605 | $3,454,653 |

### Year 5 scenario comparison

| Metric | v1 (2-day) | Nafion (5-day) | Nafion + PU (12-day) |
|--------|-----------|----------------|----------------------|
| Active users | 12,432 | 12,432 | 12,432 |
| Annual revenue | $6.2M | $3.4M | $2.3M |
| Gross margin | 59% | 64% | 73% |
| Electrodes/day | 9,100 | 3,630 | 1,542 |
| Cumulative 5-yr gross profit | $7.4M | $4.5M | $3.5M |
| Manufacturing complexity | Large contract | Contract mfg | Contract mfg |
| **Subscription price** | **$399/yr** | **$169/yr** | **$89/yr** |

**Counterintuitive finding:** v1 (2-day life) generates the most cumulative gross profit ($7.4M vs $4.5M vs $3.5M) because the higher subscription price more than compensates for higher COGS at scale. But v1 also requires the most manufacturing capacity and has the highest user friction. The tradeoff is revenue vs market accessibility.

**Realistic trajectory:** Launch v1 at $399/year (early adopters), introduce Nafion electrodes at month 9-12 and drop price to $169/year (mainstream), then Nafion + PU at $89/year (mass market). Each step trades per-user revenue for market expansion.

---

## Total electrode production — 5-year cumulative

| Scenario | Year 1 | Cumulative Year 3 | Cumulative Year 5 |
|----------|--------|--------------------|--------------------|
| v1 (2-day) | 91,500 | 1,057,740 | 4,621,116 |
| Nafion (5-day) | 36,500 | 421,940 | 1,843,396 |
| PU (10-day) | 18,500 | 213,600 | 933,820 |
| Nafion + PU (12-day) | 15,500 | 179,180 | 782,812 |

At the v1 planning baseline, **~4.6M electrodes over 5 years**. This is large-scale contract manufacturing but achievable with a single partner like Zimmer & Peacock.

---

## Key takeaway: v1 is launchable, membrane is the growth unlock

| | v1 (overox + cleaning) | With Nafion | With Nafion + PU |
|--|------------------------|-------------|------------------|
| Electrode life | 1-3 days | 3-7 days | 10-14 days |
| Electrodes/user/year | 146 (midpoint) | 58 | 24 |
| Subscription price | $399/yr | $169/yr | $89/yr |
| Year 1 margin (launch scale) | 27% | 34% | 43% |
| Year 3 margin (growth scale) | 58% | 62% | 70% |
| Mfg at 1K users | Contract mfg | Level 2-3 / Contract | Level 2-3 |
| Market positioning | Premium early adopter | Mainstream wellness | Mass market |
| **Launchable?** | **Yes** | **Yes** | **Yes** |

**v1 with overoxidation + electropulse cleaning is a viable launch product** at premium pricing ($399/year). It's profitable from year 1 at 27% gross margin, scaling to 59% by year 5. The membrane roadmap (Nafion → Nafion + PU) progressively reduces electrode consumption, enabling price drops that expand the addressable market from biohackers ($399/yr) to mainstream ($169/yr) to mass market ($89/yr).

**Priority actions:**
1. Validate v1 electrode lifetime on-body (target: 2+ days with overoxidation + cleaning pulses). This confirms the launch business case.
2. In parallel, begin Nafion membrane testing to establish the timeline for the first price reduction.

---

## Tooling investment by phase

One-time costs that don't repeat per unit.

### Phase 1: Pilot ($3K-5K production, $10K-25K parallel)

| Investment | Cost | Purpose |
|------------|------|---------|
| Electrode panel tooling (JLCPCB) | $500 | Optimized panelization |
| Batch MIP equipment | $100 | Level 1.5 batch immersion setup |
| Test fixtures (basic) | $500 | Manual test with BLE dongle |
| Packaging design | $500-1K | Box design + first print run |
| *Production subtotal* | *$1,600-2,100* | |
| Biocompatibility testing | $5K-15K | ISO 10993 (critical path) |
| Battery certification | $2K-5K | UN 38.3 transport testing |
| Provisional patent | $2K-4K | IP protection |
| *Parallel subtotal* | *$9K-24K* | |

### Phase 2: Launch ($10K-15K)

| Investment | Cost |
|------------|------|
| Production test fixture (automated) | $2K |
| Multi-channel potentiostat | $3K-5K |
| Shell bridge tooling (silicone mold) | $2K |
| Label printer + barcode system | $500 |
| Packaging volume print run | $2K |

### Phase 3: Scale ($40K-80K)

| Investment | Cost |
|------------|------|
| Injection mold tooling (shell) | $15K-40K |
| Injection mold tooling (cradle) | $5K-10K |
| Automated test system | $5K-15K |
| MIP contract manufacturing NRE | $5K-15K |
| Production database software | $2K-5K |

---

## Break-even analysis

### Phase 1 break-even (pilot)

Total investment: ~$12K-27K (production + parallel)
Gross margin at 100 units: ~$5,700 (year 1)
**Break-even:** ~2-5 years at pilot scale (not the goal — pilot is for validation)

### Phase 2 break-even (launch)

Additional investment: ~$10K-15K
Cumulative investment: ~$25K-42K
Gross margin at 1K units: ~$172K (year 1)
**Break-even:** Within year 1 of launch

### Phase 3 break-even (scale)

Additional investment: ~$40K-80K
Cumulative investment: ~$65K-122K
Gross margin at 10K units: ~$2.8M (year 1)
**Break-even:** Within first quarter of scale production

---

## Cost reduction roadmap

| Opportunity | Savings | When | How |
|-------------|---------|------|-----|
| nRF52832 raw IC (replace module) | -$2/unit | 5K+ units | Custom RF layout, re-certify |
| AD5941 volume pricing | -$2-3/unit | 1K+ units | Direct with Analog Devices |
| Steel injection mold | -$3-4/unit shell | 10K+ units | Amortize tooling over volume |
| Contract MIP production | -$1-2/electrode | 5K+ electrodes | Zimmer & Peacock or similar |
| Electrode PCB volume fab | -$1-2/electrode | 5K+ electrodes | Negotiated contract |
| Automated assembly line | -$2-3/unit labor | 10K+ units | Semi-automated stations |
| Battery direct sourcing | -$1-2/unit | 5K+ units | Direct from cell manufacturer |
| **Total potential savings** | **$12-18/unit** | At 10K+ scale | |
