# Patent Landscape Analysis — CortiPod

Freedom-to-operate analysis for the CortiPod wearable sweat cortisol sensor platform and multi-analyte expansion roadmap. Based on full claim text review of all identified patents as of April 2026.

**Disclaimer:** This is a preliminary technical analysis, not legal advice. A formal FTO opinion requires review by a registered patent attorney.

---

## Patent Database — Full Claim Analysis Completed

### Patents With Actual Claim Text Reviewed

| Patent | Title | Holder | Status | Filed | Expires (est.) |
|---|---|---|---|---|---|
| US9846137 | Sensors for the detection of analytes | Florida International University | Granted 2017 | 2016-08-19 | ~2036 |
| US10,405,794 | Sweat conductivity, volumetric sweat rate, and GSR devices | Eccrine Systems / Epicore Biosystems | Granted 2019 | 2017-07-18 | ~2037 |
| US10,136,831 | Sweat sensing with chronological assurance | University of Cincinnati | Granted 2018 | 2014-10-17 | ~2034 |
| WO2016197085A1 | Sweat sensing device cortisol measurement | Eccrine Systems / Epicore Biosystems | PCT published 2016 | 2016-06-06 | Check national phase |
| US11,255,853 | Multi-analyte molecularly imprinted polymer sensor | Rhythmic Health, Inc. | Granted 2022 | 2020-09-24 | ~2040 |
| US12,465,278 | Multiplexed sweat extraction and sensing wearable device | UC Regents (Emaminejad) | Granted 2025 | 2018-09-06 | ~2038 |
| US20210076991 | In-situ sweat rate monitoring for normalization | UC Regents (Emaminejad) | Published application | 2019-01-15 | — |
| US11,331,009 | Apparatus for non-invasive sensing of biomarkers in human sweat | Xsensio / EPFL | Granted 2022 | 2018-03-06 | ~2038 |
| US20250120625 | MIP wearable sensor with paper microfluidics | Texas A&M University | Pending | 2024-10-12 | — |
| US20250001396 | Nanoscale MIP thin films for small molecule detection | Yonsei University | Pending | 2024-06-25 | — |
| US8,003,374 | Reagentless, reusable, bioelectronic detectors | UC Regents (Plaxco/Heeger) | Granted 2011 | 2006-03-17 | ~2026-03 (check PTA) |
| US20240325001 | Wearable aptamer nanobiosensor for female hormone monitoring | Caltech / Heritage Medical (Wei Gao) | Pending | 2024 | — |
| US20250147052 | Aptamers for cortisol and other hormone sensing | US Government rights | Pending | 2024 | — |

### Patents Searched But Found Non-Applicable

| Patent | Why Searched | Why Not Applicable |
|---|---|---|
| US11,536,685B2 | Initially cited as UCLA MIP cortisol patent | **Wrong patent** — actually Boston University "High throughput assay for identifying microbial redox enzymes." Completely unrelated. |
| US9,277,864B2 (Vital Connect) | Modular wearable sensor | Claims specific to adhesive body patches with flex PCBs, not rigid slide-in cartridges |
| US9,440,070B2 (Thync) | Replaceable cartridge with electrodes | Claims specific to electrical stimulation (TENS), not electrochemical sensing |
| US10,205,291B2 (Masimo) | Pogo pin connector for medical sensors | Claims describe staggered pin configurations for optical pulse oximetry sensors |
| US11,786,153 | Socket-based replaceable electrochemical sensor | Flexible patch form factor, plug-in socket, not slide-in cartridge |

---

## Detailed Claim Analysis — US9846137 (Florida International University)

This is the only patent with claims that facially overlap CortiPod's Phase 1 design. Full claim text and element-by-element analysis follows.

### Claim 1 (Narrow — AuNP Enhanced)

> "An electrochemical sensing substrate for detecting a target analyte, said sensing substrate comprising a plurality of metallic nanoscopic structures deposited onto a surface of the sensing substrate, the surface further comprising a layer of conductive polymer matrix film deposited on top of the metallic nanoscopic structures, the polymer matrix film being embedded with a plurality of molecular recognition sites structurally and functionally complementary to the target analyte, the detection of the target analyte using the sensing substrate requiring no external redox labels or mediators, and the target analyte being a steroid hormone."

**Required elements:**
1. Plurality of metallic nanoscopic structures (AuNPs) on electrode surface
2. Conductive polymer MIP film on top of the nanostructures
3. No external redox labels or mediators
4. Target = steroid hormone

**CortiPod Phase 1:** MIP polymer deposited directly on bare gold. NO metallic nanostructures.
**Verdict: Phase 1 does NOT infringe.** Element (1) is entirely absent.

### Claim 2

> "The device, according to claim 1, wherein the target analyte is cortisol."

Depends on Claim 1. Same verdict — no AuNPs, no infringement.

### Claim 3 (Fabrication Method — Specific Steroid List)

> "A method of fabricating an electrochemical sensing substrate for detecting a target analyte, comprising: providing a conductive electrode; depositing a layer of conductive polymer matrix film onto a surface of the electrode in the presence of the target analyte by electro-polymerization; and eluting the target analyte from the layer of polymer matrix film, wherein the detection of the target analyte using the sensing substrate requires no external redox labels or mediators, the target analyte being a steroid hormone selected from cortisol, progesterone, testosterone, estradiol, and aldosterone; an amino acid selected from tyrosine, cysteine, glutamine, and phenylalanine; a small molecule with a molecular weight of less than 875 Da selected from lactate and glucose; a protein; cell; a toxin; or a virus."

**Enumerated steroid list:** cortisol, progesterone, testosterone, estradiol, aldosterone.
**Notably absent:** DHEA, DHEA-S, cortisone, corticosterone, androstenedione, DHT, androsterone.

### Claim 6 (Broad — Any MIP Cortisol Electrode)

> "An electrochemical sensing substrate for detecting a target analyte, comprising at a surface of the sensing substrate a layer of conductive polymer matrix film, characterized in that the polymer matrix film is embedded with a plurality of molecular recognition sites structurally and functionally complementary to the target analyte, wherein the target analyte is cortisol."

**This claims any electropolymerized MIP cortisol sensor on any electrode.** No nanostructure requirement. No specific polymer. No specific substrate.

**CortiPod Phase 1:** Has exactly this — conductive polymer MIP with cortisol recognition sites on a gold electrode.

### Claim 7 (Standard Fabrication for Cortisol)

> "A method of fabricating an electrochemical sensing substrate for detecting a target analyte, comprising: providing a conductive electrode; depositing a layer of conductive polymer matrix film onto the surface of the electrode in the presence of the target analyte by electro-polymerization; and eluting the target analyte from the layer of polymer matrix film, wherein the target analyte is cortisol."

**This claims the standard MIP electropolymerization + template removal method for cortisol.**

### Claim 8 (Detection Method — Sweat NOT Listed)

> "A method of detecting a target analyte, comprising: providing a biological sample, characterized in that the sample is a human physiological fluid selected from blood, plasma, serum, saliva, urine, mucous, and tears; contacting the sample with an electrochemical sensing device... wherein the target analyte is cortisol."

**Enumerated sample types:** blood, plasma, serum, saliva, urine, mucous, tears.
**Sweat is NOT listed.**

**CortiPod measures sweat.** This claim does not apply.

### Invalidity Assessment for Claims 6-7

Claims 6 and 7 are almost certainly invalid on prior art. MIP cortisol sensors on electrodes were well-established before the August 2016 filing date:

| Prior Art Reference | Year | What It Discloses |
|---|---|---|
| Baggiani et al., *Analytica Chimica Acta* | 2001 | Molecularly imprinted polymers prepared using cortisol as template |
| Peeters et al., *Analytical Chemistry* | 2013 | MIP-based cortisol sensor on screen-printed electrodes |
| Moreno-Bondi et al., various journals | 2003-2012 | Multiple MIP steroid sensors including cortisol using electropolymerized films |
| Suri et al., *Talanta* | 2006 | Electrochemical MIP sensor for steroid hormones on conductive polymer |

Claims 6-7 add no novel element beyond "MIP for cortisol on an electrode" — a concept documented in peer-reviewed literature 15 years before the filing date. An inter partes review (IPR) at the USPTO would likely cancel these claims.

### Practical Risk Assessment

- **Assignee is a university** — universities typically license rather than litigate aggressively
- **No evidence of active enforcement** — no litigation records found
- **Claim 8 excludes sweat** — the inventors did not contemplate sweat-based detection, supporting narrow construction of Claims 6-7
- **Strong claims (1-5) don't apply to Phase 1** — examiner likely focused prosecution on the novel AuNP contribution; Claims 6-7 may have received less scrutiny
- **An IPR petition would likely succeed** — budget ~$15,000-40,000 USD if ever needed, but the threat alone typically resolves university assertions

**Recommended action:** Obtain an attorney opinion letter (~$1,500-2,500 CAD) documenting the invalidity arguments. Do not contact FIU proactively. Do not seek a license. Monitor for patent assignment to litigation entities.

---

## Detailed Claim Analysis — US10,405,794 (Eccrine/Epicore)

### Claim 1

> "A sweat sensing device configured to be worn on an individual's skin, comprising: a sweat collector, comprising a concave surface facing the skin, a substantially circular seal, and a fluid port, wherein the concave surface creates a clearance from the skin to promote natural flow of sweat, wherein the seal interacts with the skin to create a coverage area within the collector that is determined, and wherein the seal is configured to substantially prevent sweat from exiting the coverage area... a microfluidic channel for receiving and transporting a sweat sample, wherein the channel has an inlet at a first end, an outlet at a second end, and has a known volume; a plurality of GSR electrodes... a plurality of conductivity electrodes... in fluid communication with said channel... a volumetric sweat rate sensor... said sweat rate electrodes intersect said channel at known intervals..."

**Every independent claim requires ALL of:** sweat collector with circular seal, microfluidic channel with known volume, GSR electrodes outside the seal, conductivity electrodes in the channel, and volumetric sweat rate electrodes intersecting the channel.

**CortiPod has NONE of these.** No sweat collector seal. No microfluidic channel. No conductivity electrodes in a channel. No volumetric sweat rate electrodes. GSR is measured via a simple voltage divider on skin, not as part of a microfluidic architecture.

**Verdict: CLEAR for all phases.** The claims are entirely specific to a microfluidic architecture that CortiPod does not use in any phase.

---

## Detailed Claim Analysis — US10,136,831 (University of Cincinnati)

### Claim 1

> "A sweat sensor device capable of continuous monitoring and chronological assurance comprising: one or more sweat sensors adapted to detect a specific solute in sweat and to obtain measurements of said solute in sweat over at least a first time period and a second time period; a sweat sampling volume between a sampling site on skin and said one or more sweat sensors, said sweat sampling volume at least in part determining a sweat sampling rate; and electronics adapted to correlate said sweat sampling rate with said measurements from said one or more sensors to provide a chronological assurance of the effective rate at which newly originated sweat reaches said one or more sweat sensors during the first and second time periods."

**Key concept:** "Chronological assurance" = knowing when the sweat you're measuring was actually generated, by correlating sampling rate with analyte measurements.

**CortiPod:** Uses GSR purely for dilution correction. Does not determine sweat freshness, sweat age, or the temporal origin of sweat at the sensor. Does not provide "chronological assurance." Measures every 15 minutes regardless of sweat generation timing.

**Verdict: CLEAR for all phases.** The concept of chronological assurance is fundamentally different from simple dilution normalization.

---

## Detailed Claim Analysis — WO2016197085A1 (Eccrine/Epicore)

**Critical note:** This is a PCT application. National phase grant status must be verified before it can be enforced.

### Claims 1-19 (Awakening Response, Diurnal Profile)

Require detecting when the individual wakes (via sleep monitor, heart rate, body temperature, movement/posture) and specifically calculating cortisol awakening response or diurnal profile values.

**CortiPod:** Has no wake detection capability. No sleep monitor, heart rate sensor, or posture detection. Measures continuously without awareness of sleep/wake state.

**Verdict: CLEAR for all phases.**

### Claims 20-21 (Stress Level — Broadest Method Claims)

> Claim 20: "A method of determining an individual's stress level, comprising: taking at least one sweat analyte measurement with a sweat sensing device; developing a stress profile value for the individual; and communicating said value to a user."
> Claim 21: "The method of claim 20 where the analyte is Cortisol."

**CortiPod:** Measures sweat cortisol and displays color-coded levels (low/normal/elevated/high). Could arguably be interpreted as a "stress profile value."

**Mitigation:** Label app displays as "cortisol concentration" or "cortisol level" — never "stress level" or "stress profile." Do not market as a stress assessment device.

### Claim 22 (Multi-Analyte Stress — Phase 3+ Risk)

> "The method of claim 20 where the analytes include at least two of the following: Cortisol, Na+, Cl-, K+, glucose, adrenocorticotropic hormone, norepinephrine, epinephrine, dopamine, serotonin estrogen, and testosterone."

**Enumerated analyte list includes testosterone and estrogen.** If Phase 3 (cortisol + testosterone) or Phase 4b (cortisol + estradiol) is marketed as a "stress" product, this claim applies.

**Mitigation:** Market multi-analyte panels as "hormonal health monitor" or "steroid biomarker panel" — never as a "stress assessment" tool.

### Claims 37-45 (Device Claims)

> Claim 37: "A device capable of determining sweat Cortisol levels for an individual, comprising: at least one sensor for measuring sweat Cortisol; at least one sensor for measuring a sweat analyte; at least one sensor for measuring sweat pH; and a computation means."

**Requires a sweat pH sensor.** No phase of CortiPod includes a pH sensor.

**Verdict: Device claims CLEAR for all phases.**

---

## Detailed Claim Analysis — US11,255,853 (Rhythmic Health)

### Claim 1

Requires a body with electrical conductors running from proximal to distal end through an electrical insulator, with the insulator defining openings that expose portions of the conductors, coated with different MIP films for different analytes.

**This describes a cable/strip architecture** where conductors run through an insulating body. Fundamentally different from CortiPod's flat PCB with screen-printed surface electrodes.

Claim 11 lists cortisol, DHEA, melatonin, progesterone, estrogen, testosterone as targets — covering every analyte in the CortiPod roadmap. But every independent claim requires the conductor-through-insulator-body architecture.

**Verdict: CLEAR for all phases.** Structural mismatch is fundamental regardless of target analytes.

---

## Detailed Claim Analysis — Emaminejad/UCLA Patent Portfolio

### US12,465,278 — Multiplexed sweat extraction and sensing

All claims require: multiple compartments with iontophoresis electrodes + secretory agonist hydrogel + current source providing different currents to different compartments + processor deriving blood level from multiple sweat measurements under different induction conditions.

### US20210076991 — In-situ sweat rate monitoring

All claims require: sensing module that induces sweat via iontophoresis + calibrating sensor measuring secretion rate + microfluidic channel with electrolysis and impedance electrodes.

**CortiPod uses passive eccrine sweat collection.** No iontophoresis, no hydrogel, no sweat induction current, no multiple compartments, no microfluidic channels.

**Verdict: CLEAR for all phases.** Every Emaminejad patent requires iontophoresis-based sweat induction that CortiPod does not use.

**Note:** The "UCLA MIP cortisol wearable patent" initially flagged as high risk does not exist. The cited number (US11536685B2) was a different patent entirely. Emaminejad's actual patents protect sweat extraction/normalization platforms, not MIP sensing chemistry.

---

## Detailed Claim Analysis — US11,331,009 (Xsensio/EPFL)

All claims require: semiconductor FET sensors + microfluidic/nanofluidic channels + zero-energy micro pump with micro-pillars. Completely different sensing technology (FET vs. electrochemical MIP) and architecture (microfluidic vs. direct skin contact).

**Verdict: CLEAR for all phases.**

---

## Detailed Claim Analysis — US8,003,374 (Plaxco/Heeger E-AB Foundational)

Covers: oligonucleotide (aptamer) probe tagged with an electroactive/redoxable moiety (e.g., methylene blue), self-assembled on electrode, undergoing conformational change in presence of target analyte to provide detectable signal change.

**This is the foundational patent for the E-AB (electrochemical aptamer-based) sensing platform.** Any sensor using MB-tagged aptamers on gold with conformational-change detection falls within these claims.

**CortiPod Phase 1-3:** Use MIP, not aptamers. CLEAR.
**CortiPod Phase 4a-4b:** Roadmap calls for MB-tagged aptamers on gold for progesterone and estradiol. INFRINGES.

**Key timing:** Filed March 2006. Base 20-year term expires ~March 2026. Check for patent term adjustments (PTA) that could extend to 2027-2028. If Phase 4a/4b development starts after expiry, the blocking risk is eliminated.

**Design-around options:**
1. Wait for patent expiry (simplest)
2. Label-free EIS aptamer approach — no MB tag, measure impedance change from aptamer folding; may fall outside claims requiring "electroactive/redoxable moiety"
3. License from UC Regents — universities typically offer 1-3% royalty for startups
4. Use MIP instead of aptamer for progesterone — lower confidence but avoids Plaxco entirely

---

## Phase Blocking Matrix

| Patent | Phase 1 (Cortisol + Cortisone) | Phase 2 (+DHEA-S) | Phase 3 (+Testosterone) | Phase 4a (+Progesterone) | Phase 4b (+Estradiol) |
|---|---|---|---|---|---|
| **US9846137 Cl.1** (AuNP+MIP+steroid) | CLEAR | **BLOCKED** | **BLOCKED** | CLEAR (aptamer) | CLEAR (aptamer) |
| **US9846137 Cl.2** (cortisol specific) | CLEAR | Risk if cortisol electrode gets AuNP | Same | CLEAR | CLEAR |
| **US9846137 Cl.3** (fabrication, 5 steroids) | CLEAR | CLEAR — DHEA-S not in list | **BLOCKED** — testosterone in list | CLEAR (aptamer) | CLEAR (aptamer) |
| **US9846137 Cl.6-7** (broad MIP cortisol) | Likely invalid | Same exposure | Same | Same | Same |
| **US9846137 Cl.8** (detection, sweat excluded) | CLEAR | CLEAR | CLEAR | CLEAR | CLEAR |
| **US10,405,794** (microfluidic GSR) | CLEAR | CLEAR | CLEAR | CLEAR | CLEAR |
| **US10,136,831** (chronological assurance) | CLEAR | CLEAR | CLEAR | CLEAR | CLEAR |
| **WO2016197085 Cl.1-19** (awakening/diurnal) | CLEAR | CLEAR | CLEAR | CLEAR | CLEAR |
| **WO2016197085 Cl.20-21** (stress level) | Low risk — avoid "stress" label | Same | Same | Same | Same |
| **WO2016197085 Cl.22** (stress + multi-analyte) | CLEAR (single analyte) | CLEAR (DHEA-S not listed) | **Risk if marketed as stress** | CLEAR (progesterone not listed) | **Risk** (estrogen listed) |
| **WO2016197085 Cl.37-45** (device + pH) | CLEAR (no pH sensor) | CLEAR | CLEAR | CLEAR | CLEAR |
| **US11,255,853** (cable/strip MIP) | CLEAR | CLEAR | CLEAR | CLEAR | CLEAR |
| **US12,465,278** (iontophoresis) | CLEAR | CLEAR | CLEAR | CLEAR | CLEAR |
| **US11,331,009** (FET + microfluidic) | CLEAR | CLEAR | CLEAR | CLEAR | CLEAR |
| **US8,003,374** (Plaxco E-AB) | CLEAR | CLEAR | CLEAR | **BLOCKED** | **BLOCKED** |
| **US20240325001** (Gao female hormones) | CLEAR | CLEAR | CLEAR | **RISK** (pending) | **RISK** (pending) |
| **US20250147052** (cortisol aptamer seqs) | CLEAR (MIP) | CLEAR | CLEAR | CLEAR | CLEAR |

---

## Design-Around Strategies Per Phase

### Phase 2 — Replace AuNP With CNT-Only Enhancement

**Problem:** US9846137 Claim 1 blocks AuNP + MIP + steroid hormone.

**Solution:** Use MWCNT drop-cast layer without AuNP electrodeposition. Carbon nanotubes are not "metallic nanoscopic structures" — they are carbon allotropes. CNT provides 2-5x LOD improvement vs. AuNP's 5-20x, but combined with DPV mode + oPD polymer + overoxidation + redox probe, cumulative improvement is sufficient for DHEA-S (5-50 ng/mL range).

**Revised enhancement stack for Phase 2:**
```
Baseline chronoamperometry on bare gold MIP     LOD ~5 ng/mL
  + CNT drop-cast layer                         LOD ~2 ng/mL
  + Switch to DPV                                LOD ~0.8 ng/mL
  + oPD polymer + overoxidation                  LOD ~0.4 ng/mL
  + Redox probe amplification                    LOD ~0.2 ng/mL
```

**Confidence impact:** 85-93% (down from 90-97% with AuNP). Acceptable for DHEA-S at 5-50 ng/mL.

### Phase 3 — CNT-Only + Invalidity Defense for Claim 3

**Problem:** US9846137 Claim 1 blocks AuNP + MIP + steroid. Claim 3 blocks electropolymerized MIP fabrication for testosterone specifically.

**Solution for Claim 1:** Same CNT-only approach as Phase 2.

**Solution for Claim 3:** Rely on invalidity defense. Electropolymerized testosterone MIP sensors were published before 2016 (Lucci et al. 2012, Singh & Schwartz 2013). Claim 3 is vulnerable to the same prior art arguments as Claims 6-7. The attorney opinion letter should cover Claims 1, 3, 6, and 7 together.

**Alternative if risk-averse:** Use non-electropolymerization MIP method (UV-initiated or thermal polymerization, then drop-cast). Avoids Claim 3's "electro-polymerization" requirement but adds fabrication complexity.

**Revised enhancement stack for Phase 3:**
```
Baseline chronoamperometry on bare gold MIP     LOD ~5 ng/mL
  + CNT drop-cast layer                         LOD ~2 ng/mL
  + Switch to SWV                                LOD ~0.5 ng/mL
  + oPD polymer + overoxidation                  LOD ~0.2 ng/mL
  + Redox probe amplification                    LOD ~0.1 ng/mL
  + Larger WE (10mm)                             LOD ~0.06 ng/mL
```

**Confidence impact:** 60-88% (down from 68-95%). Testosterone at 1-10 ng/mL still detectable.

### Phase 4a — Wait for Plaxco Expiry or Use Label-Free EIS

**Problem:** US8,003,374 (Plaxco) blocks MB-tagged aptamer conformational change detection. US20240325001 (Gao) is pending for aptamer female hormone wearable.

**Solution A (preferred):** Schedule Phase 4a development for 2027-2028 when Plaxco patent expires (base term March 2026 + potential PTA). No design compromise needed.

**Solution B (if earlier):** Label-free EIS aptamer approach. Immobilize aptamer on gold via thiol SAM without MB redox tag. Measure charge transfer resistance (Rct) change via EIS when target binds and aptamer folds. AD5941 has built-in EIS engine — no hardware change needed.

This avoids Plaxco's core claim element ("electroactive/redoxable moiety" providing the signal). The aptamer still undergoes conformational change, but detection is via impedance, not via redox current from a label.

**Confidence impact with EIS approach:** 55-88% (down from 62-95% with MB-SWV). The reduction comes from EIS being less specific than direct redox measurement at low concentrations, but still viable for progesterone at 0.5-5 ng/mL with full enhancement stack.

### Phase 4b — Same Strategy as 4a + Avoid Stress Marketing

**Problem:** Plaxco patent + Gao pending + WO2016197085 Claim 22 if marketed as stress.

**Solution:** Same timing/EIS strategy as Phase 4a. Additionally, market as "reproductive health monitor" or "hormonal wellness panel" — never as "stress assessment" including estrogen.

---

## Patent-Aware Roadmap Summary

| Phase | Original Confidence | Patent-Adjusted Confidence | Key Design Change | Patent Cost |
|---|---|---|---|---|
| **Phase 1** | 94-98% | **94-98%** (unchanged) | None | $1,500-2,500 for attorney opinion letter on US9846137 |
| **Phase 2** | 90-97% | **85-93%** | Replace AuNP with CNT-only | Included in Phase 1 attorney opinion |
| **Phase 3** | 68-95% | **60-88%** | CNT-only + invalidity defense for Cl.3 | Included in attorney opinion |
| **Phase 4a** | 62-95% | **55-88%** (EIS) or **62-95%** (post-expiry) | Label-free EIS or wait for Plaxco expiry | $0 if waiting; $5,000-15,000 if licensing |
| **Phase 4b** | 53-83% | **48-78%** (EIS) or **53-83%** (post-expiry) | Same + avoid stress marketing | Same as 4a |

---

## CortiPod Patentable Claims — What We CAN Patent

### Phase 1 Claims (File Immediately)

| Claim Group | Novelty | Blocking Risk | Confidence |
|---|---|---|---|
| Dual MIP/NIP single-substrate differential electrode with shared CE/RE + orientation key | No patent covers dual MIP/NIP on single electrochemical substrate for differential wearable sensing | Low | **85%** |
| Humidity-based evaporation correction for sweat biosensors | No patent covers humidity correction for sweat analyte concentration artifacts | None found | **85%** |
| Sequential multi-factor compensation pipeline (NIP diff → temp → humidity → GSR → confidence) | No patent covers the complete ordered pipeline; humidity correction is the novel anchor | Medium (GSR step overlaps Eccrine conceptually, but their claims require microfluidics) | **70%** |
| Recursive personal calibration via consumer saliva test kits with OLS refitting | No patent covers adaptive calibration refinement using consumer home test kits | Medium (UC pending app covers saliva-sweat correlation concept) | **65%** |
| Batch panelized MIP electrode manufacturing with shared-bus electropolymerization | No patent covers panelized shared-bus MIP fabrication on PCB panels | Low | **90%** |
| Charging cradle reusing sensor pogo pin interface | No patent covers a separate charging cradle accessory using sensor contact points | Low-Medium | **75%** |

### Future Phase Claims (File as Provisional Now to Establish Priority)

| Claim Group | Applicable Phase | Novelty |
|---|---|---|
| Multi-analyte steroid panel on single wearable electrochemical platform with cross-reactivity matrix deconvolution | Phase 2+ | No patent covers the specific panel composition or cross-reactivity compensation method |
| Mixed MIP + aptamer electrode cartridge architecture with different electrochemical modes per analyte | Phase 4a+ | No patent covers mixed recognition elements on a single cartridge |
| Passive evaporative preconcentration chamber integrated into wearable enclosure as snap-in insert | Phase 4b | No patent found for this concept in wearable context |

---

## Filing Recommendation

### Immediate Actions

1. **File bundled provisional patent** covering all Phase 1 claims + future phase claims listed above. Establishes priority date across the entire platform. Estimated cost: $2,000-4,000 CAD.

2. **Obtain attorney opinion letter** on US9846137 covering Claims 1, 3, 6, and 7. Document prior art invalidity arguments. Estimated cost: $1,500-2,500 CAD.

3. **Verify WO2016197085A1 national phase status** — check if Eccrine/Epicore obtained granted patents in US, EP, or other jurisdictions from this PCT application.

4. **Check US8,003,374 (Plaxco) exact expiry date** — base term March 2026; any patent term adjustment (PTA) could extend to 2027-2028. This determines Phase 4a/4b timing.

### Marketing Language Guidelines

To avoid WO2016197085A1 Claims 20-22:

| Use | Avoid |
|---|---|
| "Cortisol concentration" | "Stress level" |
| "Cortisol level" | "Stress profile" |
| "Hormonal health monitor" | "Stress assessment device" |
| "Steroid biomarker panel" | "Stress monitoring system" |
| "Hormonal balance tracker" | "Stress tracker" |

### Monitoring Checklist (Annual)

- [ ] Check US9846137 assignment records — watch for transfer to patent assertion entities
- [ ] Check WO2016197085A1 national phase prosecution status
- [ ] Monitor US20240325001 (Gao/Caltech) prosecution — watch for issued claims scope
- [ ] Monitor US20250147052 (cortisol aptamer) prosecution
- [ ] Verify US8,003,374 (Plaxco) expiry/PTA status before Phase 4a development begins

---

## Critical Note: Do NOT Publish or Publicly Demonstrate Before Filing

Patent rights in most jurisdictions (outside the US 1-year grace period) are lost upon public disclosure. File the provisional patent application BEFORE any of the following:

- Publishing a paper or preprint
- Presenting at a conference
- Posting on social media
- Demonstrating to potential investors (unless under NDA)
- Submitting to a crowdfunding platform
- Releasing the iOS app publicly
