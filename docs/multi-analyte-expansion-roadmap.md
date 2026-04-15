# Multi-Analyte Expansion Roadmap

Platform development roadmap for expanding CortiPod beyond cortisol to a multi-analyte sweat biomarker wearable. All phases use the existing AD5941 + nRF52832 electronics — only the sensing module changes.

---

## Sweat Hormone & Steroid Feasibility Reference

### Full Analyte Assessment

| Analyte | MW (Da) | Sweat Conc. (ng/mL) | vs. Current LOD (~5 ng/mL) | MIP Feasibility | Platform Mod Required | Feasibility |
|---|---|---|---|---|---|---|
| Cortisol | 362 | 8–140 | Well above | Proven | None (current target) | **Ready** |
| Cortisone | 360 | 10–200 | Well above | Excellent — nearly identical steroid scaffold | New MIP template only | **High** |
| Corticosterone | 346 | 2–30 | Marginal-above | Good — similar C21 steroid | New MIP template | **Medium-High** |
| Testosterone | 288 | 1–10 | At/below LOD | Good — rigid steroid, good cavity | New MIP + signal amplification | **Medium** |
| DHEA | 288 | 2–20 | Marginal | Good — compact steroid | New MIP template | **Medium** |
| DHEA-S | 368 | 5–50 | Above | Good — sulfate adds selectivity handle | New MIP template | **Medium-High** |
| Androstenedione | 286 | 0.5–5 | Below LOD | Good — rigid steroid | MIP + preconcentration or DPV | **Low-Medium** |
| DHT | 290 | 0.1–2 | Below LOD | Good — similar to testosterone | MIP + amplification + DPV | **Low** |
| Androsterone | 290 | 0.5–5 | Below LOD | Good — steroid scaffold | MIP + amplification | **Low-Medium** |
| Estradiol (E2) | 272 | 0.05–0.5 | Far below | Moderate — aromatic A-ring helps | Aptamer or antibody sensor | **Low** |
| Estrone (E1) | 270 | 0.05–0.5 | Far below | Moderate | Aptamer or antibody sensor | **Low** |
| Estriol (E3) | 288 | 0.1–1 | Below LOD | Moderate | Aptamer + amplification | **Low** |
| Progesterone | 314 | 0.5–5 | Below/at LOD | Good — rigid steroid | MIP + DPV or amplification | **Low-Medium** |
| Epinephrine | 183 | 0.001–0.05 | Far below | Poor — too small/flexible for MIP | Enzymatic sensor (tyrosinase) | **Very Low** |
| Norepinephrine | 169 | 0.001–0.05 | Far below | Poor — same issue | Enzymatic sensor | **Very Low** |
| Neuropeptide Y | 4,272 | 0.001–0.01 | Far below | Poor — too large for MIP | Immunosensor (antibody-based) | **Very Low** |
| Insulin | 5,808 | 0.001–0.01 | Far below | Poor — large peptide | Immunosensor or aptamer | **Very Low** |
| C-peptide | 3,020 | 0.01–0.1 | Far below | Poor — peptide | Immunosensor | **Very Low** |
| IL-6 | 21,000 | 0.001–0.05 | Far below | Not feasible | Immunosensor array | **Very Low** |
| IL-1a | 18,000 | 0.001–0.01 | Far below | Not feasible | Immunosensor array | **Very Low** |
| TNF-a | 17,000 | 0.0005–0.01 | Far below | Not feasible | Immunosensor array | **Very Low** |
| Melatonin | 232 | 0.001–0.1 | Far below | Moderate — small heterocyclic | Aptamer + redox amplification | **Very Low** |
| T4 (Thyroxine) | 777 | 0.01–0.1 | Far below | Moderate — iodines add selectivity | Aptamer sensor | **Very Low** |
| T3 | 651 | 0.001–0.05 | Far below | Moderate | Aptamer sensor | **Very Low** |
| Adiponectin | 30,000 | 0.001–0.01 | Far below | Not feasible | Immunosensor | **Very Low** |

### Analytes Excluded From Roadmap

Catecholamines (epinephrine, norepinephrine), peptide hormones (insulin, C-peptide, neuropeptide Y), cytokines (IL-6, TNF-a, IL-1a), thyroid hormones (T3, T4), adiponectin, and melatonin all require fundamentally different sensing platforms (enzymatic biosensors, immunosensor arrays, or microfluidic immunoassay) and are not addressable with electrode-only changes.

---

## Enhancement Techniques Reference

| Enhancement | What It Does | LOD Improvement | Complexity | Cost per Electrode |
|---|---|---|---|---|
| AuNP electrodeposition | Increases effective surface area 5–20x; more MIP cavities, more signal | 3–10x | Low — HAuCl4 solution + CV deposition, same AD5941 | +$0.50 |
| oPD polymer (vs polypyrrole) | Denser, more rigid cavities; better selectivity for small steroids | 1.5–3x selectivity | Low — different monomer, same electropolymerization | +$0.20 |
| DPV/SWV mode | Pulsed techniques subtract capacitive background; better S/N than chronoamperometry | 2–5x | None — AD5941 already supports DPV/SWV in firmware | $0 |
| EIS mode | Measures impedance change from binding; extremely sensitive to surface events | 5–20x for large or conformational-change targets | Low — AD5941 has built-in EIS engine; firmware changes | $0 |
| CNT drop-cast layer | Improves electron transfer kinetics; synergizes with AuNPs | 2–5x on top of AuNP | Low — MWCNT suspension + drop-cast + dry | +$0.30 |
| Redox probe ([Fe(CN)6]) | Amplifies signal — MIP cavity blockage measured as probe current decrease | 2–5x | Low — add to measurement buffer | +$0.10/test |
| Overoxidation (extended) | Creates carboxyl/carbonyl groups; repels interferents; improves selectivity | 2–5x selectivity | None — CV parameter change only | $0 |
| Thiol SAM base layer | Ordered monolayer under aptamer; reduces non-specific adsorption | 2–3x for aptamer sensors | Medium — thiol incubation step (2–12 hrs) | +$0.40 |
| Aptamer replacement | DNA/RNA aptamer instead of MIP; better selectivity for specific targets where published sequences exist | Variable — enables analytes MIP can't reach | Medium — different functionalization protocol | +$2–5 |
| Larger WE diameter | More surface area = more recognition sites = more signal | Linear with area | Requires new electrode PCB layout | ~$0 (PCB redesign) |
| MCH backfill | 6-mercaptohexanol blocks bare gold on aptamer sensors; forces aptamers upright | 2–3x for aptamer sensors | Low — incubation step after aptamer immobilization | +$0.20 |
| PEG co-SAM | Short PEG-thiol mixed with aptamer-thiol; resists protein fouling | 1.5–2x stability improvement | Medium — co-incubation optimization | +$0.30 |
| MB redox tag | Methylene blue covalently attached to aptamer distal end; binding changes MB-to-electrode distance | 3–10x for aptamer sensors | Medium — requires labeled aptamer synthesis | +$3–8 |
| Evaporative preconcentration | Passive sweat concentration via partial evaporation before electrode contact | 5–10x concentration factor | Medium — silicone gasket + hydrophilic mesh addition | +$1–2 |

### Cumulative Enhancement Stack Example (Testosterone, 1–10 ng/mL)

**Patent-adjusted stack (no AuNP — avoids US9846137 Claim 1):**
```
Baseline chronoamperometry on bare gold MIP     LOD ~5 ng/mL
  + CNT drop-cast layer                          LOD ~2 ng/mL
  + Switch to SWV                                LOD ~0.5 ng/mL
  + oPD polymer + overoxidation                  LOD ~0.2 ng/mL
  + Redox probe amplification                    LOD ~0.1 ng/mL
  + Larger WE (10mm)                             LOD ~0.06 ng/mL
```

**Original stack (with AuNP — blocked by US9846137 Claim 1):**
```
Baseline chronoamperometry on bare gold MIP     LOD ~5 ng/mL
  + AuNP electrodeposition                      LOD ~1 ng/mL
  + CNT underlayer                               LOD ~0.5 ng/mL
  + Switch to SWV                                LOD ~0.2 ng/mL
  + oPD polymer + overoxidation                  LOD ~0.1 ng/mL
  + Redox probe amplification                    LOD ~0.05 ng/mL
```

Practical sweet spot for the platform: **CNT + oPD + DPV/SWV** yields ~10x improvement over baseline with no patent risk. AuNP adds another 3-5x but is blocked by US9846137 Claim 1 (see `patent-landscape-analysis.md` for full analysis and invalidity arguments).

> **Patent note:** AuNP electrodeposition on MIP electrodes for steroid hormones is claimed by US9846137 (Florida International University). All phases use CNT-only enhancement as the design-around. See `docs/patent-landscape-analysis.md` for the complete patent landscape analysis, claim-by-claim review, and design-around strategies per phase.

---

## Phase 1 — Cortisol + Cortisone (Sweat Corticosteroid Panel)

**Starting confidence: 90–95%**

### Sensing Changes
- New MIP template: cortisone (hydrocortisone analog) at 1 mM during electropolymerization
- oPD polymer for both cortisol and cortisone electrodes

### Enhancement Stack

| Improvement | Effect | Confidence Gain |
|---|---|---|
| oPD polymer for both (tighter cavity discrimination at C11 position) | Reduces cortisol/cortisone cross-reactivity from ~40% to ~10% | +2% |
| Dual-template validation protocol (measure each MIP against the other analyte, build rejection ratio into calibration) | Quantifies and compensates for remaining cross-talk in firmware | +1% |
| Overoxidation (3–5 CV cycles) on both electrodes | Adds negative surface charge repelling urea/lactate; improves long-term fouling resistance | +1% |
| Nafion anti-fouling membrane over both WEs | Blocks large protein interferents from sweat | +0.5% |

**Final confidence with all enhancements: 94–98%**

### Key Risk
Cross-reactivity between cortisol and cortisone — they differ only at C11 (hydroxyl vs ketone). oPD's tighter cavities help discriminate but validation protocol is essential.

### Product Value
Cortisone is cortisol's inactive metabolite. The cortisol/cortisone ratio is a clinically meaningful marker of 11β-HSD enzyme activity and tissue-level cortisol exposure — more informative than cortisol alone.

---

## Phase 2 — + DHEA-S (Sweat Steroid Stress Panel)

**Starting confidence: 80–90%**

### Sensing Changes
- New MIP template: DHEA-S at 1 mM during electropolymerization
- oPD polymer for DHEA-S electrode
- MWCNT drop-cast electrode enhancement (replaces AuNP — see patent note)
- DPV measurement mode for DHEA-S channel (AD5941 firmware config change)

### Enhancement Stack (Patent-Adjusted — No AuNP)

| Improvement | Effect | Confidence Gain |
|---|---|---|
| oPD polymer (DHEA-S template at 1 mM) | Denser cavities better accommodate the sulfate ester group | +3% |
| MWCNT drop-cast layer | 2–5x surface area improvement; improves electron transfer kinetics | +2% |
| Switch to DPV for DHEA-S channel (AD5941 firmware config) | Better S/N than chronoamperometry for this concentration range; $0 cost | +2% |
| Overoxidation (3-5 CV cycles to +1100 mV) | Adds selectivity for sulfate ester; improves fouling resistance | +1% |
| Cation-selective Nafion tuning (thicker cast, 1% solution) | DHEA-S is anionic — Nafion repels competing anions while size-excluding proteins; needs empirical thickness optimization | +1% |
| Redox probe addition ([Fe(CN)6] 5 mM in measurement buffer) | Cavity blockage measured as probe current decrease; amplifies small binding signals | +1% |

**Final confidence with all enhancements: 85–93%**

> **Patent note:** AuNP electrodeposition (+3% gain in original plan) removed to avoid US9846137 Claim 1 ("metallic nanoscopic structures + conductive polymer MIP + steroid hormone"). MWCNT (carbon, not metallic) replaces it with slightly lower but adequate gain. DHEA-S is not in Claim 3's enumerated steroid list, so the fabrication method claim does not apply. See `docs/patent-landscape-analysis.md` for full analysis.

### Key Risk
Nafion tuning — DHEA-S is itself anionic, so the membrane charge selectivity must be empirically optimized to reject interferents without blocking the analyte.

### Product Value
DHEA-S is the most abundant circulating steroid and a direct adrenal output marker. Combined with cortisol and cortisone, this creates a **sweat adrenal stress panel** — cortisol (acute stress), cortisone (cortisol metabolism), DHEA-S (adrenal reserve/chronic stress). No wearable competitor offers this. Market as "hormonal health panel" — avoid "stress" labeling (see patent marketing guidelines in `docs/patent-landscape-analysis.md`).

---

## Phase 3 — + Testosterone (Performance & Hormonal Health)

**Starting confidence: 40–70%**

### Sensing Changes
- New MIP template: testosterone at 1 mM during electropolymerization
- oPD polymer with extended overoxidation
- MWCNT drop-cast electrode enhancement (replaces AuNP — see patent note)
- SWV measurement mode

### Enhancement Stack (Patent-Adjusted — No AuNP)

| Improvement | Effect | Confidence Gain |
|---|---|---|
| MWCNT drop-cast layer | 2–5x surface area; improved electron transfer kinetics | +4% |
| oPD polymer with extended overoxidation (5 cycles to +1100 mV) | Tighter cavities for testosterone's smaller frame (288 Da vs cortisol 362 Da); carboxyl groups add H-bond selectivity | +5% |
| SWV measurement mode (AD5941 supports this natively) | Best S/N of all pulsed techniques; 3–5x improvement over chronoamperometry at low concentrations | +4% |
| Redox probe amplification ([Fe(CN)6] 5 mM) | Doubles the measurable signal change from cavity blockage | +3% |
| Larger WE diameter (10 mm instead of 8 mm, PCB redesign) | 56% more surface area = 56% more MIP cavities = proportionally more signal | +3% |
| Interference rejection calibration (cross-validate against cortisol, cortisone, DHEA-S at physiological concentrations) | Quantifies cross-reactivity matrix; firmware compensation subtracts predicted interference from co-measured analytes | +2% |
| Thiol SAM base layer (11-mercaptoundecanoic acid, 2hr incubation before polymerization) | Ordered base layer improves polymer adhesion and uniformity; reduces electrode-to-electrode variability | +2% |
| Duplicate WE pair (2x MIP + 2x NIP for testosterone, averaging) | Halves random noise via averaging; requires 6-pad electrode or second PCB | +1% |

**Final confidence with all enhancements: 60–88%**

> **Patent note — two issues in Phase 3:**
> 1. **US9846137 Claim 1** (AuNP + MIP + steroid): Avoided by using CNT-only instead of AuNP. Reduces the +8% AuNP gain to +4% CNT gain.
> 2. **US9846137 Claim 3** (electropolymerization fabrication for testosterone): Testosterone IS in the enumerated steroid list. However, this claim has the same prior art invalidity vulnerability as Claims 6-7 — electropolymerized testosterone MIP sensors were published before the 2016 filing date. The attorney opinion letter should cover this claim alongside Claims 6-7. If risk-averse, an alternative is non-electrochemical MIP fabrication (UV-initiated polymerization + drop-cast), which avoids the "electro-polymerization" claim element.
>
> See `docs/patent-landscape-analysis.md` for full analysis.

### Key Risk
Concentration is right at LOD boundary (1–10 ng/mL). Without AuNP, the enhancement stack is shallower — CNT + SWV + oPD + redox probe must compensate. Literature shows CNT-enhanced MIP testosterone sensors achieving ~0.2 ng/mL LOD, sufficient for the 1–10 ng/mL sweat range.

### Product Value
Massive consumer demand — fitness optimization, TRT monitoring, athletic performance. Combined with the stress panel (cortisol/cortisone/DHEA-S), testosterone adds a recovery and anabolic/catabolic balance dimension. The cortisol:testosterone ratio is a well-established overtraining marker in sports science. Market as "performance panel" or "hormonal balance" — avoid "stress" labeling if testosterone is included (WO2016197085 Claim 22 lists testosterone).

---

## Phase 4a — + Progesterone (Fertility & Cycle Tracking)

**Starting confidence: 30–65%**

### Sensing Changes
- Aptamer recognition instead of MIP (published 76-mer progesterone aptamer, thiol-terminated on gold)
- Label-free EIS measurement mode (AD5941 built-in impedance engine) — avoids Plaxco patent
- CNT composite electrode (no AuNP)
- Thiol SAM + MCH backfill

### Enhancement Stack (Patent-Adjusted — No AuNP, No MB Redox Tag)

**Option A: Label-free EIS approach (available now, avoids Plaxco patent)**

| Improvement | Effect | Confidence Gain |
|---|---|---|
| Aptamer recognition instead of MIP (published 76-mer progesterone aptamer, thiol-terminated on gold) | Aptamers have Kd in nM range; conformational change on binding is detectable via EIS; avoids MIP cavity-size problem for 314 Da molecule | +10% |
| MWCNT drop-cast layer | Increases aptamer loading density and electron transfer kinetics | +3% |
| EIS measurement mode (AD5941 built-in impedance engine) | Measures Rct change from aptamer folding; extremely sensitive to surface binding events without needing redox probe | +5% |
| Thiol SAM + MCH backfill (6-mercaptohexanol blocks bare gold, forces aptamers upright) | Critical for aptamer sensors — prevents non-specific adsorption and improves orientation uniformity | +4% |
| Anti-fouling PEG co-SAM (short PEG-thiol mixed with aptamer-thiol) | Resists protein fouling in complex sweat matrix; extends sensor lifetime | +2% |
| Duplicate WE pair with averaging | Noise reduction | +1% |

**Final confidence with Option A (label-free EIS): 55–88%**

**Option B: MB-tagged aptamer with SWV (available after Plaxco patent expiry ~2026-2028)**

All Option A enhancements plus:

| Improvement | Effect | Confidence Gain |
|---|---|---|
| Redox-tagged aptamer (methylene blue covalently attached to aptamer distal end) | Binding changes MB-to-electrode distance; gives faradaic signal directly proportional to analyte; gold standard for electrochemical aptamer sensors | +5% |
| SWV interrogation instead of EIS | SWV directly measures MB redox peak height change; proven technique for E-AB sensors | +2% |

**Final confidence with Option B (post-Plaxco expiry): 62–95%**

> **Patent note — two issues in Phase 4a:**
> 1. **US8,003,374 (Plaxco/Heeger):** Foundational E-AB patent covers MB-tagged aptamer on gold with conformational change detection. Filed March 2006, base expiry ~March 2026. Option A avoids this by using label-free EIS (no redox tag). Option B becomes available after patent expiry.
> 2. **US20240325001 (Gao/Caltech):** Pending application for aptamer wearable female hormone monitoring with multi-factor calibration. Monitor prosecution — if granted with broad claims, may require design-around for calibration approach.
>
> **US9846137 does NOT apply** — aptamer sensors are not "conductive polymer matrix film" MIP. All FIU claims require MIP.
>
> See `docs/patent-landscape-analysis.md` for full analysis.

### Key Risk
Transition from MIP to aptamer chemistry — different functionalization protocol, different failure modes, different shelf-life characteristics. Label-free EIS (Option A) is less sensitive than MB-tagged SWV (Option B) at low concentrations, but viable for progesterone at 0.5–5 ng/mL.

### Product Value
Progesterone tracking enables menstrual cycle phase identification and fertility window detection. Combined with cortisol, provides insight into how stress affects reproductive hormones — a highly differentiated product for women's health.

---

## Phase 4b — + Estradiol (Menopause & Reproductive Monitoring)

**Starting confidence: 10–40%**

### Sensing Changes
- Aptamer recognition (published 75-mer E2 aptamer, thiol-terminated, well-validated in literature)
- Label-free EIS or MB-tagged SWV depending on Plaxco patent status (see patent note)
- CNT + thiol SAM + MCH backfill (no AuNP)
- Evaporative preconcentration chamber

### Enhancement Stack (Patent-Adjusted — No AuNP, MB Tag Depends on Plaxco Expiry)

**Option A: Label-free EIS + preconcentration (available now)**

| Improvement | Effect | Confidence Gain |
|---|---|---|
| Aptamer recognition (published 75-mer E2 aptamer, thiol-terminated, well-validated in literature) | Best-available recognition element for E2 at sub-ng/mL; multiple groups have demonstrated pg/mL detection | +12% |
| MWCNT drop-cast layer | Increases aptamer loading density and electron transfer kinetics | +3% |
| EIS measurement mode | Measures Rct change from aptamer folding; sensitive to surface binding events | +4% |
| Thiol SAM + MCH backfill | Forces aptamers upright; prevents non-specific adsorption | +4% |
| Evaporative preconcentration chamber (passive concentrator over WE) | 5–10x concentration factor by allowing sweat to partially evaporate before reaching electrode; adds silicone gasket + hydrophilic mesh to sensor module | +6% |
| Anti-fouling PEG co-SAM | Critical for long-wear stability at these trace levels | +2% |
| Extended measurement time (300s instead of 60s, signal averaging) | Improves S/N at ultra-low concentrations; AD5941 supports arbitrary timing | +2% |
| Larger WE (12 mm diameter) + duplicate pair | More aptamer sites + noise averaging | +2% |

**Final confidence with Option A (label-free EIS): 48–78%**

**Option B: MB-tagged SWV + preconcentration (after Plaxco expiry ~2026-2028)**

All Option A enhancements plus:

| Improvement | Effect | Confidence Gain |
|---|---|---|
| Redox-tagged aptamer (methylene blue label) | Direct faradaic signal from conformational change; published LODs of 0.005–0.05 ng/mL | +8% |
| SWV interrogation instead of EIS | SWV directly measures MB redox peak height change; proven E-AB technique | +3% |

**Final confidence with Option B (post-Plaxco expiry): 53–83%**

> **Patent note — three issues in Phase 4b:**
> 1. **US8,003,374 (Plaxco/Heeger):** Same E-AB blocking as Phase 4a. Option A (label-free EIS) available now; Option B after expiry.
> 2. **US20240325001 (Gao/Caltech):** Pending — aptamer wearable for female hormones. Estradiol is a primary target. Monitor prosecution.
> 3. **WO2016197085A1 Claim 22 (Eccrine/Epicore):** Lists "estrogen" in the multi-analyte stress method claim. If cortisol + estradiol is marketed as stress assessment, this claim applies. Market as "reproductive health" instead.
>
> **US9846137 does NOT apply** — aptamer sensors are not MIP.
> **Evaporative preconcentration chamber has NO patent conflicts** — no existing patent covers passive evaporative concentration in a wearable enclosure.
>
> See `docs/patent-landscape-analysis.md` for full analysis.

### Key Risk
Sweat estradiol concentration (0.05–0.5 ng/mL) is 100x below cortisol. Label-free EIS (Option A) is less sensitive than MB-tagged SWV (Option B), making the preconcentration chamber critical in Option A. The chamber is mechanically simple but needs validation that concentration is uniform and reproducible.

### Product Value
Estradiol monitoring enables menopause transition tracking, HRT dose optimization, and fertility support. Combined with progesterone (Phase 4a), creates a comprehensive reproductive hormone panel. This is a large underserved market with no wearable solution. Market as "reproductive health" or "hormonal wellness" — avoid "stress" labeling.

---

## Phase Summary (Patent-Adjusted)

| Phase | Analytes | Panel Name | Original Confidence | Patent-Adjusted Confidence | Key Enabler | Patent Constraint | Market Positioning |
|---|---|---|---|---|---|---|---|
| 1 | Cortisol + Cortisone | Corticosteroid Panel | 94–98% | **94–98%** | oPD polymer + cross-reactivity calibration | None | Cortisol monitoring, HPA axis insight |
| 2 | + DHEA-S | Adrenal Health Panel | 90–97% | **85–93%** | CNT + DPV mode + redox probe | US9846137 Cl.1 → no AuNP | Hormonal health, adrenal balance |
| 3 | + Testosterone | Performance Panel | 68–95% | **60–88%** | CNT + SWV + larger WE | US9846137 Cl.1+3 → no AuNP, invalidity defense | Fitness, TRT, hormonal balance |
| 4a | + Progesterone | Reproductive Health Panel | 62–95% | **55–88%** (EIS) / **62–95%** (post-expiry) | Label-free EIS aptamer or MB-tagged post-2026 | Plaxco US8003374 → no MB tag until expiry | Fertility, cycle tracking |
| 4b | + Estradiol | Women's Health Panel | 53–83% | **48–78%** (EIS) / **53–83%** (post-expiry) | EIS aptamer + preconcentration or MB post-2026 | Plaxco + Gao pending + Eccrine Cl.22 → no MB, no "stress" label | Reproductive health, HRT |

> **Key design changes from patent analysis:**
> - All phases: AuNP electrodeposition replaced with CNT-only (avoids US9846137 Claim 1)
> - Phase 4a/4b: MB redox tag deferred until Plaxco patent expiry (~2026); label-free EIS as interim approach
> - All phases: "Stress" marketing language avoided (mitigates WO2016197085 Claims 20-22)
> - Full patent analysis: `docs/patent-landscape-analysis.md`

---

## Electrode Architecture Evolution (Patent-Adjusted)

### Phase 1: MIP-Only (Current Architecture)
```
Gold substrate
  └── oPD MIP layer (analyte-specific template)
        └── Nafion anti-fouling membrane
```
Electrodes per analyte: 1x MIP + 1x NIP (differential pair)

### Phase 2: MIP + CNT Enhancement
```
Gold substrate
  └── MWCNT drop-cast layer
        └── oPD MIP layer (analyte-specific template)
              └── Nafion anti-fouling membrane
```
Note: No AuNP — avoids US9846137 Claim 1. CNT provides 2-5x surface area improvement.

### Phase 3: Enhanced MIP + CNT (Patent-Adjusted — No AuNP)
```
Gold substrate
  └── MWCNT drop-cast layer
        └── Thiol SAM base layer
              └── oPD MIP layer (overoxidized)
                    └── Nafion membrane
```
Note: Original design included AuNP electrodeposition between CNT and SAM layers. Removed to avoid US9846137 Claim 1. CNT + thiol SAM + overoxidation provide adequate enhancement for testosterone detection range.

### Phase 4a–4b Option A: Label-Free Aptamer (Available Now)
```
Gold substrate
  └── MWCNT drop-cast layer
        └── Thiol SAM + unlabeled aptamer + MCH backfill + PEG co-SAM
```
Detection via EIS (charge transfer resistance change from aptamer folding). No redox label — avoids Plaxco US8,003,374.

### Phase 4a–4b Option B: MB-Tagged Aptamer (After Plaxco Expiry ~2026-2028)
```
Gold substrate
  └── MWCNT drop-cast layer
        └── Thiol SAM + MB-labeled aptamer + MCH backfill + PEG co-SAM
```
Detection via SWV (MB redox peak height change). Higher sensitivity than Option A but requires Plaxco patent to have expired. No NIP needed — aptamer sensors use a single electrode with signal-on/signal-off measurement.

---

## Multi-Analyte Electrode PCB Scaling

| Phase | Analytes | WE Pairs Needed | Electrode Count (WE + CE + RE) | Pogo Pads |
|---|---|---|---|---|
| 1 | 2 (cortisol, cortisone) | 2 MIP + 2 NIP = 4 WE | 4 WE + 1 CE + 1 RE = 6 | 6 |
| 2 | 3 (+DHEA-S) | 3 MIP + 3 NIP = 6 WE | 6 WE + 1 CE + 1 RE = 8 | 8 |
| 3 | 4 (+testosterone) | 4 MIP + 4 NIP = 8 WE | 8 WE + 1 CE + 1 RE = 10 | 10 |
| 4a | 5 (+progesterone) | 4 MIP + 4 NIP + 1 aptamer = 9 WE | 9 WE + 1 CE + 1 RE = 11 | 11 |
| 4b | 6 (+estradiol) | 4 MIP + 4 NIP + 2 aptamer = 10 WE | 10 WE + 1 CE + 1 RE = 12 | 12 |

Note: AD5941 has a built-in multiplexer supporting up to 4 WE channels. Phase 3+ requires either an external analog mux (e.g., ADG1608) or sequential measurement cycling across electrode pairs. The nRF52832 has sufficient GPIO for mux control.

---

## Bill of Materials Impact (Per Electrode, Incremental — Patent-Adjusted)

| Phase | Added Materials | Added Cost per Electrode | Patent Note |
|---|---|---|---|
| 1 | Cortisone template (Sigma), oPD monomer | +$1–2 | — |
| 2 | DHEA-S template, MWCNT suspension, K3[Fe(CN)6] redox probe | +$2–3 | HAuCl4 removed (was +$0.50) — avoids US9846137 |
| 3 | Testosterone template, MWCNT suspension, 11-MUA thiol | +$3–5 | No AuNP cost |
| 4a (Option A) | Progesterone aptamer (thiol-terminated, unlabeled), MCH, PEG-thiol | +$5–10 | No MB label — avoids Plaxco; cheaper than labeled aptamer |
| 4a (Option B) | Progesterone aptamer (thiol-MB labeled, custom synthesis) | +$8–15 | Requires Plaxco patent expiry |
| 4b (Option A) | Estradiol aptamer (thiol-terminated, unlabeled), PEG-thiol, preconcentration gasket | +$7–12 | No MB label |
| 4b (Option B) | Estradiol aptamer (thiol-MB labeled), PEG-thiol, preconcentration gasket | +$10–20 | Requires Plaxco patent expiry |

---

## Firmware Implications (Patent-Adjusted)

| Phase | AD5941 Mode Changes | nRF52832 Changes | Patent Note |
|---|---|---|---|
| 1 | None — same chronoamperometry | Additional MIP/NIP channel in measurement cycle | — |
| 2 | Add DPV mode for DHEA-S channel | DPV parameter config; updated calibration pipeline | — |
| 3 | Add SWV mode; add mux control | External mux GPIO driver; SWV signal processing; cross-reactivity matrix compensation | — |
| 4a (Option A) | Add EIS mode | EIS impedance extraction (Rct measurement); aptamer signal processing (different from MIP differential) | Label-free EIS avoids Plaxco |
| 4a (Option B) | Add SWV for MB redox peak tracking | MB peak height extraction via SWV | Requires Plaxco expiry |
| 4b (Option A) | EIS mode + extended measurement timing (300s) | EIS extraction + preconcentration timing control | Label-free EIS avoids Plaxco |
| 4b (Option B) | SWV for MB redox peak tracking + extended timing (300s) | MB peak height extraction + preconcentration timing control | Requires Plaxco expiry |

All measurement modes (chronoamperometry, DPV, SWV, EIS) are natively supported by the AD5941 — changes are firmware configuration, not hardware.

---

## Enclosure Bottom Shell Evolution

The multi-analyte expansion impacts the bottom shell because each new analyte adds working electrodes, pogo pins, and electrode board area. The current bottom shell (v1) is designed for a single cortisol differential pair.

### Current Bottom Shell (v1) — Reference Dimensions

| Feature | Value |
|---|---|
| Electrode slot | 22.4 x 22.2 mm (fits 22.0 x 22.0 mm board) |
| Skin window | ~19.8 x 16.0 mm |
| Pogo pins | 4 (WE_MIP, WE_NIP, CE, RE) |
| Pogo pitch | 8.0 mm horizontal, 6.0 mm vertical |
| Pogo bore diameter | 1.3 mm |
| Slot height | 1.0 mm (for 0.8 mm PCB) |
| Ledge height | 0.5 mm skin gap |
| Bottom shell height | 2.5 mm |
| Internal dimensions | 28.0 x 26.5 mm |
| External dimensions | ~30 x 28 mm |

### Phase-by-Phase Bottom Shell Impact

#### Phase 1 — Cortisol + Cortisone (4 WE + CE + RE = 6 pads)

**Bottom shell change: REQUIRED**

| Feature | v1 (Current) | Phase 1 Need | Delta |
|---|---|---|---|
| Pogo pins | 4 | 6 | +2 new bores through mating face |
| Pogo layout | 2x2 grid | 3x2 or 2x3 grid | New pin positions |
| Electrode PCB | 22 x 22 mm | ~26 x 22 mm | Wider to fit 4 WE in 2x2 arrangement |
| Slot width | 22.4 mm | ~26.4 mm | Grows with electrode |
| Skin window | 19.8 x 16.0 mm | ~23.8 x 16.0 mm | Wider to expose all 4 WE |
| Shell internal width | 28.0 mm | ~32.0 mm | Pod gets ~4 mm wider |
| Slot height | 1.0 mm | 1.0 mm | No change |
| Ledge height | 0.5 mm | 0.5 mm | No change |

**Smaller-WE alternative:** Reduce WE diameter from 8 mm to 6 mm to fit a 2x2 grid on the existing 22 mm board. Sacrifices ~44% surface area per WE (28.3 mm² vs 50.3 mm²), partially recovered by AuNP enhancement. Pogo pin count still increases to 6, requiring new bores in the mating face but no slot width change.

#### Phase 2 — + DHEA-S (6 WE + CE + RE = 8 pads)

**Bottom shell change: REQUIRED (incremental from Phase 1)**

| Feature | Phase 1 | Phase 2 Need | Delta |
|---|---|---|---|
| Pogo pins | 6 | 8 | +2 more bores |
| Electrode PCB | ~26 x 22 mm | ~26 x 26 mm | Taller to fit 6 WE in 3x2 arrangement |
| Slot depth | ~22.2 mm | ~26.4 mm | Grows with electrode |
| Skin window | ~23.8 x 16.0 mm | ~23.8 x 22.0 mm | Taller to expose 3rd WE row |
| Shell internal length | 26.5 mm | ~30.0 mm | Pod gets ~4 mm longer |

#### Phase 3 — + Testosterone (8 WE + CE + RE = 10 pads)

**Bottom shell change: REQUIRED**

| Feature | Phase 2 | Phase 3 Need | Delta |
|---|---|---|---|
| Pogo pins | 8 | 10 | +2 more bores |
| WE diameter | 8 mm | 10 mm (if enlarged per roadmap) or 8 mm (if kept standard) | Larger circles need more board area |
| Electrode PCB (10 mm WE) | ~26 x 26 mm | ~32 x 30 mm | Significantly larger |
| Electrode PCB (8 mm WE) | ~26 x 26 mm | ~30 x 26 mm | Moderate growth |
| Skin window | ~23.8 x 22.0 mm | ~29.8 x 26.0 mm (10 mm) or ~27.8 x 22.0 mm (8 mm) | Grows with WE count |
| Shell external | ~35 x 33 mm | ~39 x 37 mm (10 mm) or ~37 x 33 mm (8 mm) | Approaching max wrist size |
| Slot height | 1.0 mm | 1.2 mm | CNT+AuNP composite adds ~0.1–0.2 mm electrode thickness |

Note: Keeping all WEs at 8 mm and relying on AuNP/CNT for signal recovery keeps the PCB smaller and avoids the larger shell.

AD5941 multiplexing note: The AD5941 natively supports 4 WE channels. With 8 WE (4 MIP + 4 NIP), an external analog mux (ADG1608) is required on the main PCB in the top shell. The additional pogo pin wiring routes through the mating face — no bottom shell impact from the mux IC itself.

#### Phase 4a — + Progesterone (9 WE + CE + RE = 11 pads)

**Bottom shell change: MINIMAL from Phase 3**

Progesterone uses an aptamer sensor — single WE, no NIP differential pair needed. Adds only 1 WE, not 2.

| Feature | Phase 3 | Phase 4a Need | Delta |
|---|---|---|---|
| Pogo pins | 10 | 11 | +1 bore |
| Electrode PCB | ~30 x 26 mm | ~30 x 28 mm | Slightly taller |

If Phase 3 shell is designed with one spare pogo position, Phase 4a requires no shell change at all.

#### Phase 4b — + Estradiol (10 WE + CE + RE = 12 pads)

**Bottom shell change: REQUIRED — structural geometry change**

The evaporative preconcentration chamber fundamentally changes the skin window design in the estradiol WE zone.

| Feature | Phase 4a | Phase 4b Need | Delta |
|---|---|---|---|
| Pogo pins | 11 | 12 | +1 bore |
| Skin window | Open pass-through | Partially enclosed evaporation chamber over estradiol WE | Gasket rim + hydrophilic mesh pocket molded into bottom shell |
| Ledge height | 0.5 mm uniform | 0.5 mm standard + 1.5 mm chamber over E2 zone | Variable Z-height in skin window area |
| Bottom shell height | 2.5 mm | 3.0–3.5 mm (thicker at E2 preconcentration zone) | +0.5–1.0 mm locally |

The preconcentration chamber is a small pocket (~10 x 10 mm) molded into the bottom shell around the estradiol WE area:
- Silicone gasket rim contacting the skin to trap sweat
- Hydrophilic mesh insert that wicks sweat into the chamber
- Partially restricted opening that allows controlled evaporation (5–10x concentration factor)
- Rest of the skin window remains open as before

This is the only phase that changes the bottom shell's fundamental geometry rather than just scaling it.

### Shell Dimension Summary Across Phases

| Phase | Pogo Pins | Electrode PCB (mm) | Slot (mm) | Skin Window (mm) | Shell External (mm) | Shell Height (mm) |
|---|---|---|---|---|---|---|
| v1 (current) | 4 | 22 x 22 | 22.4 x 22.2 | 19.8 x 16.0 | ~30 x 28 | 2.5 |
| Phase 1 | 6 | 26 x 22 | 26.4 x 22.2 | 23.8 x 16.0 | ~34 x 28 | 2.5 |
| Phase 2 | 8 | 26 x 26 | 26.4 x 26.4 | 23.8 x 22.0 | ~34 x 33 | 2.5 |
| Phase 3 (8mm WE) | 10 | 30 x 26 | 30.4 x 26.4 | 27.8 x 22.0 | ~37 x 33 | 2.5 |
| Phase 3 (10mm WE) | 10 | 32 x 30 | 32.4 x 30.4 | 29.8 x 26.0 | ~39 x 37 | 2.5 |
| Phase 4a | 11 | 30 x 28 | 30.4 x 28.4 | 27.8 x 24.0 | ~37 x 35 | 2.5 |
| Phase 4b | 12 | 30 x 28 | 30.4 x 28.4 | 27.8 x 24.0 | ~37 x 35 | 3.0–3.5 (local) |

### Recommended Shell Strategy: Design Forward, Two Revisions

Rather than redesigning the bottom shell at every phase:

| Approach | Shell Redesigns | Trade-off |
|---|---|---|
| Redesign per phase | 4–5 redesigns | Wasted tooling, iteration fatigue |
| Design for Phase 2, redesign at Phase 3 | 2 redesigns | Good balance — Phase 1–2 shell is near-current size |
| Design for Phase 3, add preconcentration at Phase 4b | 2 redesigns | Larger initial pod, but future-proof through Phase 4a |
| Design for Phase 4b from day one | 1 redesign | Oversized pod for Phase 1, unused pogo positions, preconcentration chamber wasted for 3 phases |

**Recommended: Two-shell strategy**

**Shell v2 (Phase 1–2):** Design for Phase 2 capacity from the start.

| Feature | Shell v2 Spec |
|---|---|
| Pogo pins | 8 positions (Phase 1 electrodes leave 2 uncontacted — no pads at those back positions, open circuit) |
| Electrode slot | 26.4 x 26.4 mm |
| Skin window | 23.8 x 22.0 mm |
| Shell external | ~34 x 33 mm |
| Shell height | 2.5 mm |
| Delta from v1 | +4 mm width, +5 mm length — still easily wrist-wearable |

**Shell v3 (Phase 3–4b):** Design at Phase 3 with provisions for Phase 4a and 4b.

| Feature | Shell v3 Spec |
|---|---|
| Pogo pins | 12 positions (Phase 3 uses 10, Phase 4a uses 11, Phase 4b uses all 12) |
| Electrode slot | 30.4 x 28.4 mm |
| Skin window | 27.8 x 24.0 mm with removable preconcentration insert pocket for Phase 4b |
| Shell external | ~37 x 35 mm |
| Shell height | 2.5 mm base + optional 1.0 mm preconcentration insert (snaps into pocket, not molded-in) |
| Delta from v2 | +3 mm width, +2 mm length |

The preconcentration chamber for Phase 4b is implemented as a **snap-in insert** rather than a molded-in feature. The v3 shell includes a shallow pocket (1.0 mm deep recess) in the skin window area at the estradiol WE position. For Phase 3 and 4a, this pocket is left empty (open to skin). For Phase 4b, a silicone gasket + mesh insert snaps into the pocket. This avoids a separate shell redesign for Phase 4b.

### Impact on Other Enclosure Components

| Component | Shell v2 Impact | Shell v3 Impact |
|---|---|---|
| Top shell | Must grow to match v2 footprint; U-channel rails and pogo pin bores updated; main PCB layout may need adjustment for 8-pin routing | Grows again; ADG1608 mux added to main PCB; 12-pin pogo routing |
| Strap lugs | Reposition to new shell width; same strap compatibility | Reposition again; may need wider strap (22 mm vs 20 mm) |
| O-ring groove | Resize to new parting line perimeter | Resize again |
| Orientation key | Reposition chamfer notch for larger electrode | Same approach, new position |
| Detent mechanism | Reposition dimples for new lip geometry | Same approach, new position |
| Main PCB | Add 4 more pogo pin pads; route to AD5941 mux inputs | Add ADG1608 external mux; 12 pogo pad routing; more complex multiplexing firmware |
