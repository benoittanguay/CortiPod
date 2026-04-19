# CortiPod Business Plan — Canadian Market (v1 Launch)

> Business plan for launching the v1 CortiPod in Canada as a wellness-positioned continuous cortisol monitor. Based on v1 electrode economics (2-day overoxidized MIP + electropulse cleaning, $249 hardware + $399/year subscription).

---

## 1. Executive summary

CortiPod is the first wrist-worn wearable that directly measures cortisol from passive sweat. No other commercial product offers continuous, real-time cortisol monitoring in a wearable form factor. The v1 product launches in Canada under wellness positioning (no medical device licence required), priced at $249 hardware + $39/month electrode subscription.

**Canadian addressable market:** 135,000-515,000 patients with cortisol-dependent clinical conditions (Tier 1), 1.6-4.2 million with cortisol-linked health conditions (Tier 2), 11-25 million stressed/burned-out adults (Tier 3).

**v1 pricing:** $249 starter kit (shell + 15 electrodes + cradle + strap) + $399/year subscription ($39/month for electrode refills). Competitive with ELI Health ($336/year for saliva snapshots) and cheaper than CGM ($1,100-1,400/year).

**5-year target (Canada only):** 12,400 active subscribers generating $6.2M/year at 59% gross margin, with cumulative gross profit of $7.4M.

**Competitive moat:** No competing continuous cortisol wearable exists on the market. EnLiSense (Corti) has been delayed 2+ years past announced launch. ELI Health offers saliva snapshots, not continuous monitoring. Every HRV-based wearable (Whoop, Oura, Apple Watch, Garmin) measures a proxy, not cortisol directly.

---

## 2. Company overview

| | |
|--|--|
| **Company** | CortiPod Inc. (to be incorporated in Quebec) |
| **Location** | Quebec, Canada |
| **Founder** | Benoit Tanguay |
| **Product** | Wrist-worn continuous cortisol monitor (wearable + consumable electrode) |
| **Stage** | Prototype development (pre-revenue) |
| **Regulatory pathway** | Phase 1: General Wellness (no MDL); Phase 2: Health Canada Class II (parallel) |
| **IP status** | Provisional patent planned — dual MIP/NIP differential, humidity-based evaporation correction, transport lag model, stepped PCB with integrated mounting |

---

## 3. Problem

**73% of Canadian adults report that stress negatively affects their health.** Chronic cortisol dysregulation is linked to depression, anxiety, cardiovascular disease, metabolic syndrome, immune dysfunction, and accelerated aging. Yet there is no way to measure cortisol outside a lab. Every consumer wearable on the market (Whoop, Oura, Apple Watch, Garmin) infers stress from heart rate variability — an indirect proxy that measures autonomic nervous system activity, not the hormone itself.

### Specific unmet needs

**Steroid taper patients (125,000-500,000 Canadians):** When patients stop taking corticosteroids (prednisone, dexamethasone), their adrenal glands need 6-12 months to restart cortisol production. During that window, they are functionally adrenal insufficient with no at-home way to track recovery. The only current option is repeated lab visits for cosyntropin stimulation tests. A wearable that shows the return of the morning cortisol peak would guide taper speed — faster when recovering, slower when not.

**Cushing's diagnosis (3,000-5,000 Canadians):** Average time from first symptoms to Cushing's diagnosis is 3-6 years. Cyclic Cushing's evades single-point lab tests because cortisol surges intermittently. A continuous monitor would catch what scheduled lab visits miss.

**Mental health treatment monitoring (1.0-1.6 million Canadians):** 17.4% of Canadians meet criteria for depression; 40-60% show measurable cortisol dysregulation. Psychiatrists currently have no objective biomarker to track whether a treatment (medication, therapy, lifestyle change) is actually reducing the patient's cortisol burden. CortiPod would provide this for the first time.

**Shift workers (590,000-2.4 million Canadians):** Night shift work is classified as a Group 2A probable carcinogen by IARC due to circadian disruption. A cortisol monitor would quantify the degree of circadian disruption and help workers and occupational health teams optimize shift schedules.

---

## 4. Product

### Hardware

| Component | Description |
|-----------|-------------|
| Shell | Single-piece enclosure (28×28×9mm), houses nRF52832 BLE SoC, AD5941 potentiostat, 60mAh LiPo battery, temperature + humidity + GSR sensors |
| Electrode PCB | 2.0mm stepped FR4 with depth-milled ledges, slides into shell channels. Carries MIP (cortisol) + NIP (control) working electrodes, counter electrode, Ag/AgCl reference electrode |
| Charging cradle | Same channel interface as electrode, USB-C charging |
| Strap | 18mm quick-release silicone strap |

### Consumable model

The electrode PCB is a **disposable sensor** replaced every 2 days (v1, overoxidized bare MIP + electropulse cleaning). The user slides the old electrode out and a new one in — 5 seconds, no tools.

### Software

- **iOS companion app** (SwiftUI, CoreBluetooth)
- 8-step signal processing pipeline: temperature compensation, humidity correction, physics-based sweat rate estimation, dilution correction, calibration, transport lag estimation, confidence scoring
- Personal calibration using saliva cortisol test kit (3-7 points over 2-3 days)
- Dashboard: current cortisol (ng/mL), confidence indicator, trend chart with lag-corrected timeline
- History: 24-hour circadian overlay, 7/30-day views, stress event detection

### Electrode evolution roadmap

| Version | Electrode life | Subscription price | Timeline |
|---------|---------------|--------------------|----------|
| **v1: Overox MIP + cleaning** | **2 days** | **$399/year** | **Launch** |
| v1.5: + Nafion membrane | 5 days | $169/year | 6-12 months post-launch |
| v2: + Nafion + PU stack | 12 days | $89/year | 18-24 months post-launch |

Each electrode version uses the same hardware shell and app. The subscription price drops as electrode life extends, expanding the addressable market.

---

## 5. Market

### Canadian market sizing

| Tier | Description | Population | Penetration (5-yr) | Users | Revenue potential |
|------|-------------|------------|---------------------|-------|-------------------|
| 1 | Clinical necessity (Cushing's, Addison's, steroid taper, CAH) | 135K-515K | 5-10% | 6,750-51,500 | $3.4M-$51.5M/yr |
| 2 | Clinical wellness (depression/anxiety with cortisol dysregulation, shift work) | 1.6M-4.2M | 1-3% | 16K-126K | $3.2M-$50.4M/yr |
| 3 | Consumer wellness (stress/burnout, biohackers) | 11M-25M | 0.1-0.5% | 11K-125K | $2.2M-$43.8M/yr |

### v1 beachhead: steroid taper patients

**Why start here:**
- Largest Tier 1 group (125K-500K Canadians)
- Acute unmet need with no at-home monitoring alternative
- Endocrinologist can prescribe/recommend — clinical channel, not consumer marketing
- Patient is highly motivated (recovering from adrenal suppression, wants to know if HPA axis is coming back)
- Clear value proposition: "see your cortisol rhythm return during taper"
- Supports premium pricing ($399/year is justified by clinical value)

### Competitive landscape (Canada)

| Competitor | Product | Format | Measures | Price | CortiPod advantage |
|------------|---------|--------|----------|-------|--------------------|
| **ELI Health** (Montreal) | Hormometer | Saliva test + phone camera | Cortisol (snapshot) | ~$8/test ($336/yr at 42 tests) | Continuous vs snapshot; wearable vs saliva kit |
| **EnLiSense** | Corti | Wearable sweat sensor | Cortisol + melatonin | Not yet available | CortiPod can ship first; 2+ years past announced launch |
| **Whoop** | Whoop 5.0 | Wrist/body band | HRV (proxy only) | $239-359/yr | Direct cortisol measurement vs proxy |
| **Oura** | Ring Gen 4 | Ring | HRV + skin temp (proxy) | $419-569 + $72/yr | Direct cortisol vs proxy; wrist form factor |
| **Dexcom** | Stelo | Arm patch (CGM) | Glucose (not cortisol) | ~$1,100/yr | Different biomarker; proves consumable sensor model works |

---

## 6. Revenue model

### Pricing (v1 launch)

| SKU | Contents | Price (CAD) |
|-----|----------|-------------|
| Starter kit | Shell + 15 electrodes (1 month) + cradle + strap + cable | $249 |
| Monthly subscription | ~15 electrodes (sealed pouches) | $39/month |
| Annual subscription (15% off) | ~180 electrodes | $399/year |
| Annual prepay (25% off) | ~180 electrodes | $349/year |
| Electrode refill (one-time) | 15 electrodes | $45 |

### Revenue per user

| | Year 1 (new user) | Year 2+ (returning) |
|--|-------------------|---------------------|
| Hardware revenue | $249 | $0 |
| Subscription revenue | $399 (11 months pro-rated: $366) | $399 |
| **Total revenue** | **$615** | **$399** |

### Unit economics at scale (10K+ electrode production)

| Metric | Value |
|--------|-------|
| Hardware COGS (starter kit) | $60 |
| Annual electrode COGS per user (146 electrodes at $1.75) | $256 |
| Annual fulfillment per user | $18 |
| **Annual COGS per user (year 2+)** | **$274** |
| **Annual subscription revenue** | **$399** |
| **Gross profit per user per year** | **$125** |
| **Gross margin** | **31%** |

### Lifetime value (LTV)

| Assumption | Value |
|------------|-------|
| Annual churn rate | 20% (80% retention) |
| Average customer lifetime | 5 years (1 / churn rate) |
| Annual gross profit | $125 (year 2+, at scale) |
| Year 1 gross profit (incl. hardware) | $301 (at 10K electrode scale) |
| **LTV (gross profit)** | **$301 + 4 × $125 = $801** |

---

## 7. Go-to-market strategy

### Phase 1: Beta (months 0-6) — 50-100 users

**Channel:** Direct outreach to endocrinologists and biohacker communities in Quebec/Ontario.

| Activity | Detail |
|----------|--------|
| Clinical advisors | Recruit 2-3 endocrinologists as clinical advisors. They refer steroid taper patients to the beta program |
| Biohacker outreach | Reddit (r/Biohackers, r/QuantifiedSelf), Canadian biohacker meetups, Whoop/Oura user groups |
| Pricing | Cost price (~$150 all-in) for beta testers in exchange for structured feedback |
| Data collection | Sweat vs saliva correlation data, electrode lifetime validation, UX feedback |
| Regulatory | File provisional patent. Request Health Canada pre-submission meeting |

**Goal:** Validate on-body performance (r > 0.75), confirm 2-day electrode life, collect testimonials.

### Phase 2: Limited launch (months 6-12) — 500 users

**Channel:** Direct-to-consumer (Shopify) + clinical referral network.

| Activity | Detail |
|----------|--------|
| Website + e-commerce | Shopify store with Canadian fulfillment (self-fulfillment or ShipBob Montreal) |
| Clinical channel | Endocrinologist referral program: doctor recommends CortiPod, patient buys direct. No B2B sales or insurance billing (too early) |
| Content marketing | Blog: "What your cortisol curve says about your stress," SEO for "cortisol monitor Canada" |
| PR | Pitch to Canadian health/tech media: BetaKit, The Logic, CBC health segment |
| Social | Instagram/TikTok: "my cortisol curve" — users share daily cortisol charts (anonymized) |
| Wellness positioning | All claims: "track stress patterns," "understand your cortisol rhythm." No medical claims |

**Goal:** 500 paying subscribers, positive unit economics at subscription level, NPS > 40.

### Phase 3: Growth (months 12-24) — 2,000-5,000 users

**Channel:** Expand clinical referral + workplace wellness + consumer brand.

| Activity | Detail |
|----------|--------|
| Workplace wellness | Pilot with 2-3 employers: "measure workplace stress objectively." Shift-work industries (mining, oil sands, healthcare) are ideal targets in Canada |
| Naturopath/integrative medicine | Naturopaths in Canada are licensed and prescriptive. Cortisol is a key biomarker in functional medicine. Partner with naturopathic clinics |
| Subscription price reduction | Introduce Nafion electrode (5-day life), drop subscription to $169/year. Announce price drop publicly — drives new sign-ups and media coverage |
| Expand to US | File FDA General Wellness positioning. Cross-border e-commerce via Shopify |

### Phase 4: Scale (months 24-36) — 5,000-12,000+ users

**Channel:** Mass consumer + clinical medical device pathway.

| Activity | Detail |
|----------|--------|
| Health Canada Class II MDL | Submit application (built in parallel during Phase 2-3). Enables medical claims, physician prescribing, potential insurance coverage |
| Pharmacy distribution | Partner with Shoppers Drug Mart / Rexall for in-store visibility. Electrode refills available at pharmacy counter |
| Insurance reimbursement | Once MDL obtained, lobby provincial health plans for coverage for steroid taper monitoring (strongest clinical case) |
| Nafion + PU electrode | 12-day life, $89/year subscription. Mass-market pricing enables aggressive growth |

---

## 8. Regulatory strategy

### Wellness launch (Phase 1-2)

| Requirement | Status | Cost | Timeline |
|-------------|--------|------|----------|
| ISED BLE certification | Pre-certified via MDBT42Q module | $0 | Done |
| Privacy compliance (PIPEDA + Quebec Law 25) | Legal review needed | $5,000-15,000 | 4-8 weeks |
| Biocompatibility (ISO 10993) | Testing needed | $5,000-15,000 | 8-12 weeks |
| Battery certification (UN 38.3) | Testing needed | $2,000-5,000 | 6-8 weeks |
| **Total wellness launch cost** | | **$12,000-35,000** | **2-4 months** |

### Medical device pathway (Phase 3-4, parallel)

| Requirement | Cost | Timeline |
|-------------|------|----------|
| QMS build + MDSAP certification | $22,000-83,000 | 9-14 months |
| IEC 60601 safety + EMC testing | $15,000-40,000 | 2-4 months |
| Clinical validation study | $50,000-300,000 | 6-12 months |
| Software verification (IEC 62304) | $5,000-20,000 | 2-3 months |
| Regulatory consultant + MDL submission | $20,000-76,000 | Ongoing |
| **Total Class II cost** | **$145,000-615,000** | **2.5-3 years** |

**Strategy:** Wellness revenue (Phase 1-2) funds the Class II pathway (Phase 3-4). The ELI Health precedent in Montreal validates the wellness-first approach for cortisol devices in Canada.

---

## 9. Financial projections (Canada only)

### v1 pricing: $249 starter kit + $399/year subscription

### Year-by-year projection

| | Year 1 | Year 2 | Year 3 | Year 4 | Year 5 |
|--|--------|--------|--------|--------|--------|
| **Users** | | | | | |
| New users | 500 | 1,200 | 2,400 | 4,000 | 6,000 |
| Returning users (80% retention) | 0 | 400 | 1,280 | 3,040 | 6,432 |
| Total active users | 500 | 1,600 | 3,680 | 7,040 | 12,432 |
| | | | | | |
| **Revenue** | | | | | |
| Starter kit ($249 × new users) | $124,500 | $298,800 | $597,600 | $996,000 | $1,494,000 |
| Subscriptions (active × $399/yr, pro-rated Y1) | $198,500 | $578,800 | $1,316,320 | $2,566,560 | $4,667,168 |
| **Total revenue** | **$323,000** | **$877,600** | **$1,913,920** | **$3,562,560** | **$6,161,168** |
| | | | | | |
| **COGS** | | | | | |
| Hardware COGS | $83,500 | $72,000 | $84,000 | $120,000 | $180,000 |
| Electrode COGS | $127,750 | $292,800 | $673,440 | $1,158,720 | $2,050,000 |
| Fulfillment + packaging | $24,750 | $45,200 | $52,560 | $71,280 | $120,000 |
| Assembly + QC | — | — | — | $100,000 | $150,000 |
| **Total COGS** | **$236,000** | **$410,000** | **$810,000** | **$1,450,000** | **$2,500,000** |
| | | | | | |
| **Gross profit** | **$87,000** | **$467,600** | **$1,103,920** | **$2,112,560** | **$3,661,168** |
| **Gross margin** | **27%** | **53%** | **58%** | **59%** | **59%** |

### Operating expenses

| | Year 1 | Year 2 | Year 3 | Year 4 | Year 5 |
|--|--------|--------|--------|--------|--------|
| Salaries (founder + 1 technician) | $80,000 | $150,000 | $250,000 | $400,000 | $600,000 |
| Regulatory (wellness launch + Class II start) | $25,000 | $50,000 | $100,000 | $50,000 | $25,000 |
| Patent (provisional + PCT) | $4,000 | $15,000 | $10,000 | $5,000 | $5,000 |
| Marketing + customer acquisition | $15,000 | $50,000 | $150,000 | $300,000 | $500,000 |
| App development + hosting | $10,000 | $25,000 | $40,000 | $60,000 | $80,000 |
| Manufacturing tooling (one-time) | $5,000 | $12,000 | $15,000 | $40,000 | $20,000 |
| Office / workspace | $0 | $12,000 | $24,000 | $36,000 | $48,000 |
| Insurance + legal | $5,000 | $10,000 | $15,000 | $20,000 | $25,000 |
| **Total OpEx** | **$144,000** | **$324,000** | **$604,000** | **$911,000** | **$1,303,000** |

### Net operating income

| | Year 1 | Year 2 | Year 3 | Year 4 | Year 5 |
|--|--------|--------|--------|--------|--------|
| Gross profit | $87,000 | $467,600 | $1,103,920 | $2,112,560 | $3,661,168 |
| Operating expenses | $144,000 | $324,000 | $604,000 | $911,000 | $1,303,000 |
| **Net operating income** | **-$57,000** | **$143,600** | **$499,920** | **$1,201,560** | **$2,358,168** |
| **Net margin** | **-18%** | **16%** | **26%** | **34%** | **38%** |
| Cumulative NOI | -$57,000 | $86,600 | $586,520 | $1,788,080 | $4,146,248 |

**Break-even: month 18 (mid Year 2).** The business is cash-flow positive from Year 2 and accumulates $4.1M in net operating income over 5 years from the Canadian market alone.

---

## 10. Funding requirements

### Pre-revenue investment needed

| Item | Amount | Purpose |
|------|--------|---------|
| Prototype completion (electronics + firmware + app) | $5,000-10,000 | BOM, PCB fab, dev tools |
| Biocompatibility + battery certification | $7,000-20,000 | ISO 10993, UN 38.3 |
| Regulatory (privacy, wellness positioning) | $5,000-15,000 | Legal review, PIPEDA compliance |
| Patent (provisional) | $2,000-4,000 | IP protection before public disclosure |
| Initial inventory (100 starter kits) | $12,000-15,000 | First production batch |
| Marketing (website, content, beta outreach) | $3,000-5,000 | Shopify, design, content |
| **Total seed capital needed** | **$34,000-69,000** | |

### Funding options (Canada)

| Source | Amount | Stage | Notes |
|--------|--------|-------|-------|
| **Self-funded / friends & family** | $30K-70K | Now | Covers seed needs entirely |
| **NRC IRAP** | Up to $150K (non-dilutive) | Prototype / early revenue | Canada's best grant for tech startups. Covers salary + subcontractors |
| **BDC / Futurpreneur** | $20K-60K loan | Early stage | Low-interest startup loans |
| **SR&ED tax credits** | 35% refundable (CCPC) | Retroactive on R&D spend | Applies to MIP chemistry, firmware, electrode fabrication R&D |
| **MITACS** | Salary subsidy | Prototype | If partnering with university lab |
| **Quebec InnovExport** | $50K-100K | Growth | Export development funding |
| **Angel / VC (Series Seed)** | $250K-1M | Post-validation | BDC Capital's Thrive Fund invested in ELI Health — same thesis |

**Recommended path:** Self-fund the $34K-69K seed stage. Apply for NRC IRAP immediately (2-3 month approval, covers $150K of salary + development). Apply for SR&ED credits on all R&D from day one (35% back on qualifying expenditure). Defer angel/VC until post-validation (Phase 2) when the product is shipping and unit economics are proven.

---

## 11. Key milestones

| Milestone | Target date | Success criteria |
|-----------|-------------|------------------|
| Bench validation complete | Month 3 | MIP cortisol dose-response curve, R² > 0.95, LOD < 10 ng/mL |
| On-body validation (N=5) | Month 5 | Within-subject sweat-saliva correlation r > 0.75, electrode life ≥ 2 days |
| Provisional patent filed | Month 4 | Claims covering dual MIP/NIP, transport lag model, stepped PCB |
| Health Canada pre-submission meeting | Month 6 | Written confirmation of wellness pathway viability |
| Beta launch (50-100 users) | Month 6 | Beta units shipping, feedback collection active |
| Biocompatibility + battery cert complete | Month 7 | ISO 10993 + UN 38.3 passed |
| Shopify store live (limited launch) | Month 9 | 500 target users, first subscription revenue |
| Break-even (monthly cash flow positive) | Month 18 | Revenue exceeds COGS + OpEx |
| Nafion electrode validated | Month 12 | 5-day on-body life confirmed, subscription drops to $169/year |
| 1,000 active subscribers | Month 15 | Product-market fit confirmed |
| QMS + MDSAP certification | Month 24 | ISO 13485 compliant |
| Class II MDL submitted | Month 30 | Full application to Health Canada |
| 5,000 active subscribers | Month 30 | Growth trajectory confirmed |
| Class II MDL approved | Month 33 | Medical device claims enabled |
| 10,000 active subscribers | Month 48 | Scale economics achieved |

---

## 12. Team requirements

### Now (Phase 1, 0-6 months)

| Role | Who | Focus |
|------|-----|-------|
| Founder / CEO | Benoit Tanguay | Product development, MIP chemistry, hardware, business development |
| Clinical advisor (part-time) | Endocrinologist (Quebec/Ontario) | Steroid taper use case validation, clinical credibility, referral network |
| Regulatory advisor (contract) | Regulatory affairs consultant | Wellness positioning review, Health Canada pre-submission |

### Phase 2 (6-18 months)

| Role | Hire timing |
|------|-------------|
| Technician / manufacturing associate | Month 6 — electrode production, assembly, QC |
| iOS developer (contract or part-time) | Month 4 — app polish, calibration UI, App Store submission |

### Phase 3 (18-36 months)

| Role | Hire timing |
|------|-------------|
| Operations / supply chain manager | Month 18 — contract manufacturing oversight, inventory, fulfillment |
| Marketing / growth lead | Month 18 — content, social, clinical channel development |
| Regulatory / quality manager | Month 20 — QMS build, IEC 60601 testing coordination, MDL submission |
| Data scientist (part-time) | Month 24 — kinetic model development, calibration algorithm improvement |

---

## 13. Risk summary

| Risk | Impact | Mitigation | Reference |
|------|--------|------------|-----------|
| Electrode life < 2 days | Can't launch at $399/year | Validate overox + cleaning on-body before manufacturing investment | critical-risks-and-mitigations.md |
| Sweat-cortisol correlation too low | Product value proposition collapses | MIP/NIP differential + personal calibration + lag correction targets r > 0.75 | sweat-cortisol-correlation-factors.md |
| Health Canada blocks wellness pathway | Must wait 2.5-3 years for Class II | Pre-submission meeting gets answer in writing; ELI Health precedent de-risks | regulatory-commercialization-guide.md |
| EnLiSense ships Corti before us | First-mover advantage lost | Corti is 2+ years delayed; CortiPod's stepped PCB consumable model is differentiated | market-analysis.md |
| MIP manufacturing can't scale | Can't fulfill subscriptions | Contract to Zimmer & Peacock at 1K users; Level 1.5 batch process handles pilot | mip-scaling-strategies.md |
| Patent infringement | Legal challenge | Phase 1 (cortisol + cortisone) is clear of blocking patents; provisional patent protects CortiPod innovations | patent-landscape-analysis.md |

---

## 14. Why now, why Canada, why CortiPod

**Why now:**
- The MIP sensing technology has matured to the point where a wearable implementation is feasible
- CGM (Dexcom Stelo) proved consumers will pay $1,000+/year for a continuous biomarker wearable
- ELI Health proved consumers will pay for direct cortisol data (not just HRV proxy)
- EnLiSense's 2+ year delay leaves the continuous cortisol wearable market wide open
- The 2025 kinetic modeling paper (r = 0.95) proves the correlation ceiling is high enough for clinical utility

**Why Canada:**
- Health Canada's 15-day review cycle is faster than FDA's 6-12 month timeline
- No formal wellness exemption means risk, but the ELI Health precedent (Montreal, selling without MDL) validates the approach
- NRC IRAP provides up to $150K in non-dilutive R&D funding
- SR&ED tax credits refund 35% of qualifying R&D expenditure
- 42 million population with universal healthcare drives high awareness of health monitoring
- Bilingual (EN/FR) market positions for expansion to France/EU
- Quebec has strong electrochemistry and sensor research community (university partnerships)

**Why CortiPod:**
- Only product with MIP/NIP differential measurement (built-in control electrode on every sensor)
- Stepped PCB design eliminates the tray, reducing assembly to 2 parts
- Consumable electrode model means the device improves over time (new electrode chemistry, same hardware)
- Full 8-step signal processing pipeline with transport lag correction — no competitor has this
- Open architecture: firmware updates can add new calibration models, new analytes (cortisone in Phase 1, DHEA-S in Phase 2), without hardware changes

---

## Related documents

| Document | Location |
|----------|----------|
| Manufacturing pipeline | `operations/manufacturing/manufacturing-pipeline-overview.md` |
| Cost analysis (detailed) | `operations/manufacturing/cost-analysis.md` |
| Assembly and test | `operations/manufacturing/assembly-and-test.md` |
| Packaging and fulfillment | `operations/manufacturing/packaging-and-fulfillment.md` |
| Critical risks | `operations/manufacturing/critical-risks-and-mitigations.md` |
| Regulatory guide | `docs/regulatory-commercialization-guide.md` |
| Market analysis | `docs/market-analysis.md` |
| Patent landscape | `docs/patent-landscape-analysis.md` |
| Correlation factors | `docs/sweat-cortisol-correlation-factors.md` |
| Multi-analyte roadmap | `docs/multi-analyte-expansion-roadmap.md` |
| Disease value propositions | `marketing/value-proposition-diseases.md` |
| Calibration guide | `docs/calibration-guide.md` |
| Build plan | `docs/plans/2026-04-05-cortipod-build-plan.md` |
