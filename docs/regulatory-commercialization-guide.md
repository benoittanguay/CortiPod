# CortiPod Regulatory Commercialization Guide

> **Last updated:** 2026-04-11
>
> **Disclaimer:** This document is a research summary, not legal advice. Consult a regulatory affairs specialist before making commercialization decisions.

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Competitor Analysis: ELI Health](#competitor-analysis-eli-health)
3. [Regulatory Pathway Options](#regulatory-pathway-options)
4. [Path A: General Wellness (No Medical Device Licence)](#path-a-general-wellness)
5. [Path B: Health Canada Class II Medical Device](#path-b-health-canada-class-ii-medical-device)
6. [Quality Management System (ISO 13485 / MDSAP)](#quality-management-system)
7. [Electrical Safety and Standards Testing](#electrical-safety-and-standards-testing)
8. [ISED Radio Certification (BLE)](#ised-radio-certification)
9. [Privacy and Data Compliance (PIPEDA)](#privacy-and-data-compliance)
10. [Clinical Evidence Requirements](#clinical-evidence-requirements)
11. [Post-Market Requirements](#post-market-requirements)
12. [US FDA Pathway (Dual-Market Strategy)](#us-fda-pathway)
13. [Timeline and Cost Estimates](#timeline-and-cost-estimates)
14. [Recommended Strategy](#recommended-strategy)

---

## Executive Summary

CortiPod is a wearable electrochemical sensor that measures cortisol from passive sweat via MIP-based sensing. In Canada, any device that measures a biomarker for health monitoring purposes is regulated as a **medical device** under the *Food and Drugs Act* and *Medical Devices Regulations* (SOR/98-282).

There are two viable commercialization pathways:

| Pathway | Regulatory burden | Market claims | Risk |
|---------|------------------|---------------|------|
| **General Wellness** | Low (no MDL required) | Limited to lifestyle/stress awareness only | High -- Canada has no formal wellness exemption; enforcement risk |
| **Class II Medical Device** | Moderate (MDL, MDSAP, IEC 60601) | Full biomarker monitoring claims | Low -- clear regulatory standing |

A key competitor, **ELI Health** (Montreal), has successfully commercialized a saliva-based cortisol test under the **FDA General Wellness Policy** without obtaining medical device clearance. They are also selling in Canada without a confirmed Health Canada Medical Device Licence, likely under similar wellness positioning.

---

## Competitor Analysis: ELI Health

### Company Overview

- **Founded:** 2019, Montreal, Quebec
- **Founders:** Marina Pavlovic Rivas (CEO, data scientist), Thomas Cortina (CTO)
- **Team:** ~20 people
- **Funding:** ~$20M USD total ($3.6M seed + $12M Series A led by BDC Capital's Thrive Venture Fund)
- **Manufacturing:** Entirely in-house at Montreal facility (~$3M invested in proprietary lab/manufacturing)

### Product: Hormometer

A single-use saliva test cartridge paired with a smartphone app:

1. User places a test stick in mouth for 60 seconds to collect saliva
2. Pulls a tab to initiate lateral-flow development (~20 minutes, similar to a COVID rapid test)
3. User photographs the cartridge with their phone camera
4. App uses AI-powered image analysis to read results and display hormone levels

**Available tests:**
| Analyte | Status | Claimed accuracy |
|---------|--------|-----------------|
| Cortisol | Commercially available (Sept 2025) | 97% correlation with ELISA gold standard |
| Progesterone | Shipping Q1 2026 | 94% correlation with FDA-registered method |
| Testosterone | Shipping Q1 2026 | TBD |

**Pricing:** ~$8-8.25/test, bundles at $99/8 tests, ~$300/year subscription

### ELI Health's Regulatory Strategy

This is the most important finding for CortiPod. ELI Health uses a **dual regulatory strategy by analyte:**

**Cortisol test -- FDA General Wellness Policy:**
- NOT FDA-cleared or FDA-approved
- Marketed under the FDA's General Wellness Policy (2016 guidance, updated 2019 and January 2026)
- "FDA-registered" means only that the company registered its establishment and listed the device -- this is a mandatory administrative step, not an approval
- No 510(k), De Novo, or PMA was obtained

**Progesterone test -- FDA Class I, 510(k)-Exempt:**
- Classified as Class I 510(k)-exempt (ovulation detection fits an existing product classification)
- Requires establishment registration, device listing, general controls compliance, but NO premarket submission

**Health Canada:**
- As of mid-2025, ELI Health stated they "hope to achieve Health Canada approval later this year"
- No confirmed Health Canada MDL found in the Medical Devices Active Licence Listing (MDALL)
- They ARE selling in Canada, likely under wellness positioning without an MDL
- No CE mark or European sales

### ELI Health's Wellness Positioning (Verbatim)

From their product pages:

> "The Eli Hormometer is intended for informational and educational purposes only. It is not a diagnostic tool or medical device, and the information provided by Eli should not be considered a substitute for professional medical advice, diagnosis, or treatment."

> "This test is a wellness device and is not intended to diagnose, treat, cure, prevent, or manage any disease or medical condition, including adrenal disorders such as Addison's disease, Cushing's syndrome, or medication management. It provides lifestyle and wellness insights only."

**Claims they make (wellness framing):**
- Stress management and tracking
- Sleep optimization
- Workout recovery optimization
- Metabolism insights
- Fertility tracking (progesterone)

**Claims they carefully avoid:**
- Diagnosing Cushing's, Addison's, or any condition
- Replacing clinical lab testing
- Any therapeutic or treatment claims

### Key Takeaways from ELI Health

1. **The General Wellness pathway is proven and commercially viable for cortisol** -- ELI Health has set the precedent
2. **Wellness framing requires extreme discipline** -- every piece of marketing must disclaim medical use
3. **No lab involvement** -- fully self-contained consumer product
4. **They preserved optionality** -- plan to layer in clinical claims later as evidence accumulates
5. **Saliva was chosen partly for regulatory reasons** -- patches and wearables face harder classification
6. **They are selling in Canada without a confirmed MDL** -- precedent, but also a risk to monitor

---

## Regulatory Pathway Options

### The Intended Use Decision

The single most important factor in the regulatory pathway is the **intended use statement**. This determines everything:

| Intended use claim | Regulatory classification |
|-------------------|--------------------------|
| "Tracks your stress biomarker trends for lifestyle awareness" | Possibly not a medical device (wellness) |
| "Monitors cortisol levels to help you manage stress" | Grey zone -- could be either |
| "Measures cortisol to detect abnormal cortisol patterns" | Medical device (diagnostic claim) |
| "Monitors cortisol for adrenal disorder management" | Definitely a medical device |

---

## Path A: General Wellness

### What It Means

Market CortiPod as a wellness/lifestyle device with no medical claims. This avoids the need for a Medical Device Licence in Canada and FDA clearance in the US.

### Requirements

1. **ISED radio certification** for the BLE radio (still required regardless of medical device status)
2. **PIPEDA compliance** for health data collection
3. **Consumer product safety** under the *Canada Consumer Product Safety Act*
4. **Electrical safety** (may still need basic safety compliance, though IEC 60601 would not be mandatory)
5. **FDA establishment registration and device listing** (if selling in the US)

### Claim Restrictions

Every touchpoint -- packaging, app UI, website, social media, support emails -- must be carefully worded:

**Allowed:**
- "Track your body's stress biomarker"
- "Understand your daily cortisol rhythm"
- "Optimize your recovery and sleep"
- "Lifestyle and wellness insights"

**Not allowed:**
- Any mention of Cushing's, Addison's, adrenal insufficiency, or any disease
- "Diagnose," "detect," "monitor" (in a clinical context), "treat," "manage"
- Comparison to clinical lab results (implies diagnostic equivalence)
- Any claim that could be interpreted as medical advice

### Risks

**Canada has no formal General Wellness exemption.** Unlike the US FDA, which published explicit guidance in 2016 (updated 2019, January 2026), Health Canada assesses medical device status case-by-case based on the manufacturer's intended use. There is no published safe harbor.

- Health Canada could determine CortiPod is a medical device regardless of wellness claims, based on the overall product context
- ELI Health is operating under this same ambiguity -- they may be the test case
- Enforcement risk is real but uncertain
- A pre-submission meeting with Health Canada is strongly recommended to get written confirmation

### Estimated Cost and Timeline

| Item | Cost | Timeline |
|------|------|----------|
| ISED certification (pre-certified module) | $0 (included in module) | N/A |
| ISED certification (custom RF design) | $1,200-$3,400 | 4-6 weeks |
| Privacy compliance (legal review) | $5,000-$15,000 | 4-8 weeks |
| Basic safety testing | $5,000-$15,000 | 4-8 weeks |
| **Total** | **$10,000-$35,000** | **2-4 months** |

---

## Path B: Health Canada Class II Medical Device

### Why Class II

Under Schedule 1, Part 1 of the Medical Devices Regulations:

- **Rule 10(1):** An active diagnostic device that supplies energy for monitoring physiological processes is Class II
- CortiPod is an active device (battery-powered, applies electrochemical potentials) that monitors a physiological biomarker (cortisol)
- Erroneous cortisol readings would not result in immediate danger (unlike glucose for insulin-dependent diabetics), so it does not escalate to Class III under Rule 10(2)

**Note:** If Health Canada classifies the sensor as an in vitro diagnostic device (measuring an analyte in a body fluid), different classification rules in Part 2 of Schedule 1 could apply. A pre-submission meeting is essential to confirm.

### Step-by-Step Process

#### Step 1: Pre-Submission Meeting with Health Canada

- Request a meeting with the Medical Devices Directorate
- Confirm device classification (Class II vs. III, non-IVD vs. IVD)
- Discuss intended use claims and clinical evidence expectations
- Get written confirmation of classification decision

#### Step 2: Build Quality Management System (see QMS section below)

- Implement ISO 13485:2016 compliant QMS
- Obtain MDSAP certification (mandatory since January 1, 2019 for Class II+)

#### Step 3: Complete Design and Development Under QMS

- Design controls per ISO 13485 Section 7.3
- Risk management per ISO 14971
- Software lifecycle per IEC 62304
- Usability engineering per IEC 62366

#### Step 4: Conduct Required Testing

- IEC 60601-1 electrical safety
- IEC 60601-1-2 EMC
- IEC 60601-1-11 home healthcare (body-worn)
- ISO 10993 biocompatibility (skin contact)
- Analytical/bench performance validation
- Clinical validation study

#### Step 5: Obtain ISED Certification for BLE Radio

#### Step 6: Prepare MDL Application

Since November 2025, Health Canada uses the IMDRF Table of Contents (ToC) format. Required documentation:

- Cover letter and application form
- Device name, identifier, classification rationale
- Intended use statement and indications for use
- Device description (technology, materials, components, software)
- Complete device labelling (package labels, instructions for use)
- Attestation of objective evidence of safety and effectiveness
- Declaration of conformity to recognized standards
- MDSAP certificate
- Risk management file summary (ISO 14971)
- Essential performance and safety testing summaries
- Biocompatibility evaluation (ISO 10993)
- Electrical safety testing (IEC 60601-1)
- EMC testing (IEC 60601-1-2)
- Software documentation (IEC 62304)
- Cybersecurity documentation (BLE-connected device)

#### Step 7: Submit Application and Pay Fees

| Fee | Amount (as of April 2025) |
|-----|---------------------------|
| Class II MDL application review | CAD $632 |
| Annual right to sell (Class II) | CAD $452/year (due November 1) |

#### Step 8: Health Canada Review

- Service standard: **15 calendar days** for Class II
- This is a screening review -- verifies completeness, classification, and attestation
- Health Canada does NOT conduct detailed scientific evidence review for Class II (unlike Class III/IV)
- Deficiency letters reset the clock

#### Step 9: Obtain MDEL (if importing/distributing)

If the company also imports components or uses a separate distribution entity:
- Application form: FRM-0292
- Fee: **CAD $5,426** (initial and annual renewal)
- Processing time: **120 calendar days**

---

## Quality Management System

### MDSAP Requirement

Since January 1, 2019, all Class II+ manufacturers must hold a valid **MDSAP (Medical Device Single Audit Program) certificate** to obtain or maintain an MDL in Canada. Standalone ISO 13485 certification is not sufficient.

MDSAP covers five markets in a single audit: Canada, United States, Australia, Brazil, and Japan.

### Building a QMS from Scratch

| Phase | Duration | Cost |
|-------|----------|------|
| Gap analysis | Weeks 1-4 | $2,000-$5,000 |
| QMS design and documentation (quality manual, ~25-40 procedures, forms, work instructions) | Weeks 5-16 | $8,000-$25,000 |
| Implementation and staff training | Weeks 17-28 | $2,000-$8,000 |
| QMS operation and evidence collection | Weeks 29-44 | Ongoing |
| Internal audit and management review | Weeks 45-50 | Included |
| MDSAP certification audit (Stage 1 + Stage 2) | Weeks 51-56 | $4,000-$11,000 |
| **Total** | **9-14 months** | **$22,000-$83,000** |

### Ongoing QMS Costs

| Item | Annual cost |
|------|------------|
| Surveillance audits | $2,000-$5,000 |
| Recertification (every 3 years) | $4,000-$10,000 |
| Internal maintenance | $3,000-$8,000 |

### Recognized Auditing Organizations

BSI, TUV SUD, SGS, Intertek, and others listed on the MDSAP website.

---

## Electrical Safety and Standards Testing

### Applicable Standards

| Standard | Scope |
|----------|-------|
| IEC 60601-1:2005+A1+A2 (Ed. 3.2) | General safety and essential performance |
| IEC 60601-1-2 | EMC (immunity and emissions) |
| IEC 60601-1-6 | Usability |
| IEC 60601-1-11:2015 | Home healthcare / body-worn devices |
| CAN/CSA C22.2 No. 60601-1 | Canadian national adoption (identical to IEC) |

### Key Considerations for CortiPod

- Battery-powered, body-worn device -- IEC 60601-1-11 applies
- BLE radio near sensitive analog electrochemistry requires careful EMC design
- IP rating for sweat/moisture ingress protection
- Biocompatibility of skin-contact materials per ISO 10993-5 (cytotoxicity) and ISO 10993-10 (irritation/sensitization)

### Testing Cost

Full IEC 60601-1 + EMC testing: **$15,000-$40,000**

Testing and certification bodies: CSA Group, UL Solutions, TUV Rheinland, Intertek.

---

## ISED Radio Certification

The nRF52832 BLE radio (2.4 GHz ISM band) falls under:
- **RSS-247** (Issue 4, effective July 24, 2025): Digital Transmission Systems, Frequency Hopping Systems, and Licence-Exempt LAN Devices
- **RSS-Gen**: General Requirements for Compliance of Radio Apparatus
- **ICES-003**: Information Technology Equipment (unintentional emissions)

### Option A: Pre-Certified Module (Recommended)

Several nRF52832-based modules are already ISED-certified:
- **Raytac MDBT42Q-512KV2** (FCC/IC/CE certified)
- **I-SYST BLYST Nano**

Using a pre-certified module means NO full RF testing is needed. Must comply with the module manufacturer's integration guidelines (antenna, ground plane, shielding).

**Cost:** $0 additional (included in module price)

### Option B: Custom RF Design

If using the bare nRF52832 chip with custom antenna/RF layout:
- Testing at an accredited lab to RSS-247 and RSS-Gen
- Cost: **$1,200-$3,400**
- Timeline: **4-6 weeks**
- FCC and ISED testing can often be done simultaneously

The ISED certification number (IC: XXXXX-YYYYYYYYY) must appear on the device or via electronic labelling (e-labelling permitted for small devices).

---

## Privacy and Data Compliance

### PIPEDA Applicability

Cortisol levels are **sensitive personal health information** under PIPEDA. The 10 Fair Information Principles apply:

1. **Accountability** -- Designate a privacy officer
2. **Identifying Purposes** -- State why cortisol data is collected before or at time of collection
3. **Consent** -- Obtain **express consent** (required for health data, not implied)
4. **Limiting Collection** -- Collect only data necessary for stated purposes
5. **Limiting Use/Disclosure/Retention** -- Use only for stated purposes; establish retention schedules
6. **Accuracy** -- Keep data accurate and up to date
7. **Safeguards** -- Encryption in transit and at rest for health data
8. **Openness** -- Make privacy policies readily available
9. **Individual Access** -- Allow users to access and correct their data
10. **Challenging Compliance** -- Provide a mechanism for users to challenge compliance

### Key Requirements

- **Data breach notification:** Report breaches with "real risk of significant harm" to affected individuals and the Privacy Commissioner "as soon as feasible"; maintain breach records for 24 months
- **Cross-border transfers:** If data is stored on US servers, PIPEDA still applies; must inform users of jurisdictions where data is processed
- **Quebec Law 25:** Additional requirements including privacy impact assessments and privacy by design. Penalties up to **$25 million or 4% of global turnover**
- **On-device processing:** Consider minimizing cloud storage of raw health data

### Penalties

- Federal (PIPEDA): Up to **$100,000** per violation
- Quebec (Law 25): Up to **$25 million or 4% of global turnover**

---

## Clinical Evidence Requirements

### Class II Evidence Standard

Health Canada requires an **attestation** that the manufacturer has objective evidence of safety and effectiveness. For Class II, Health Canada does NOT routinely review the clinical evidence during MDL application -- they verify that you attest to having it.

### Required Evidence

**Analytical/Bench Performance:**
- Sensitivity, specificity, limit of detection, linear range
- Precision (repeatability and reproducibility)
- Accuracy vs. reference method (LC-MS/MS for cortisol)
- Interference testing (common sweat constituents, medications, skin care products)
- Stability and shelf life testing
- Environmental performance (temperature, humidity effects)

**Biocompatibility:**
- ISO 10993-5 (cytotoxicity) and ISO 10993-10 (irritation/sensitization) for skin-contact materials

**Electrical/Software:**
- IEC 60601 testing results
- Software verification and validation per IEC 62304

**Clinical Performance:**
- Method comparison study: CortiPod sweat cortisol vs. gold-standard measurement (serum or salivary cortisol by immunoassay or LC-MS/MS)
- Typical study: 30-50+ subjects, paired measurements, Bland-Altman analysis, across expected cortisol range
- Not a full RCT -- analytical validation study is typically sufficient for Class II

**Risk Management:**
- ISO 14971 risk management file
- IEC 62366 usability engineering file

### Novel Technology Warning

CortiPod is a novel technology class with no established predicates. Even though Class II normally requires only attestation, Health Canada may request supporting clinical data during or after review.

---

## Post-Market Requirements

### Mandatory Problem Reporting

Manufacturers must report incidents to Health Canada:

| Incident type | Reporting deadline |
|--------------|-------------------|
| Death or serious health deterioration | **10 days** from awareness |
| Potential for death/serious harm if recurrence | **30 days** from awareness |

### Additional Obligations

- **Complaint handling system** with documented procedures
- **Distribution records** for effective recalls
- **Recall procedures** -- ability to remove or correct devices in the field
- **Annual licence maintenance** -- pay $452/year right-to-sell fee
- **Trend reporting** -- monitor for patterns indicating safety issues
- **Post-market surveillance plan** (expanding under regulatory amendments)

### Recall Classifications

- **Type I:** Reasonable probability of serious adverse health consequences or death
- **Type II:** May cause temporary or medically reversible adverse health consequences
- **Type III:** Not likely to cause adverse health consequences

---

## US FDA Pathway

### De Novo Classification (Most Likely Pathway)

CortiPod is a novel device with no predicate -- no existing FDA classification for a wearable sweat cortisol monitor.

| Parameter | Details |
|-----------|---------|
| Pathway | De Novo Classification Request |
| Expected result | Class II with special controls |
| FDA review goal | 150 review days |
| User fee (FY2026) | ~$173,782 (standard) |
| Small business fee | ~$43,446 (<$100M revenue) |

### FDA General Wellness Alternative

The FDA's "General Wellness: Policy for Low Risk Devices" guidance (updated January 2026) may apply if:
- Product makes only general wellness claims (stress awareness, lifestyle optimization)
- Product is non-invasive and low-risk
- No diagnostic, therapeutic, or disease-related claims

This is the pathway ELI Health uses for their cortisol test.

### Dual-Market Strategy Efficiencies

| Shared work | Benefit |
|-------------|---------|
| MDSAP audit | Covers both Health Canada and FDA QMS requirements |
| IEC 60601 testing | Recognized by both regulators |
| Clinical data | Can serve both submissions (FDA may require larger study) |
| RF certification | FCC and ISED testing done simultaneously at same lab |

**Canada-first launch:** Health Canada's Class II review (15 days) is dramatically faster than FDA De Novo (150+ days). Many companies launch in Canada while FDA De Novo is under review.

### Relevant Precedent: Biolinq

Biolinq received FDA De Novo classification for a needle-free wearable biosensor for continuous glucose monitoring -- the closest precedent for a wearable electrochemical biosensor measuring biomarkers transdermally.

---

## Timeline and Cost Estimates

### Path A: General Wellness

| Phase | Duration | Cost |
|-------|----------|------|
| ISED certification (if custom RF) | 4-6 weeks | $0-$3,400 |
| Privacy compliance (legal review) | 4-8 weeks | $5,000-$15,000 |
| Basic safety testing | 4-8 weeks | $5,000-$15,000 |
| **Total** | **2-4 months** | **$10,000-$35,000** |

### Path B: Class II Medical Device (Canada)

| Phase | Duration | Cumulative | Cost |
|-------|----------|-----------|------|
| Pre-submission meeting with Health Canada | 2-3 months | Month 3 | $0 |
| QMS build + MDSAP certification | 9-14 months | Month 14-17 | $22,000-$83,000 |
| Biocompatibility testing (ISO 10993) | 3-4 months | Month 17-20 | $5,000-$25,000 |
| IEC 60601 testing (safety + EMC) | 2-4 months | Month 19-22 | $15,000-$40,000 |
| Software verification/validation (IEC 62304) | 2-3 months | Month 19-22 | $5,000-$20,000 |
| Clinical validation study | 6-12 months | Month 19-28 | $50,000-$300,000 |
| ISED certification | 1-2 months | Month 22-24 | $0-$3,400 |
| Usability engineering (IEC 62366) | 2-3 months | Month 22-25 | $10,000-$30,000 |
| Cybersecurity assessment | 1-2 months | Month 24-26 | $5,000-$15,000 |
| Risk management documentation | 1-2 months | Month 24-26 | $5,000-$15,000 |
| MDL application preparation and submission | 1-2 months | Month 27-29 | $1,084 (fees) |
| Health Canada review | 15 days | Month 29-30 | -- |
| Regulatory consultant (throughout) | Ongoing | -- | $20,000-$75,000 |
| **Total** | **~2.5-3 years** | | **$145,000-$615,000** |

### Path B + US FDA De Novo (Dual Market)

Add approximately:
- $43,000-$174,000 in FDA user fees
- $50,000-$150,000 in additional regulatory preparation
- 12-18 months of parallel FDA review time

---

## Recommended Strategy

### Phase 1: Validate and Position (Now)

1. **Complete sensor validation** -- demonstrate analytical performance (LOD, precision, accuracy vs. LC-MS/MS)
2. **Request a Health Canada pre-submission meeting** to confirm classification before committing to a pathway
3. **Study ELI Health's trajectory** -- monitor whether they obtain an MDL and whether Health Canada takes enforcement action on wellness-positioned cortisol devices

### Phase 2: Launch as Wellness Device (6-12 months)

4. **Launch under wellness positioning** following the ELI Health model
5. Craft all claims as lifestyle/stress awareness only -- no medical language anywhere
6. Use a pre-certified BLE module to avoid ISED complexity
7. Implement PIPEDA-compliant data handling from day one
8. Begin collecting real-world performance data and user feedback

### Phase 3: Build Toward Medical Device (12-30 months, parallel)

9. **Start QMS implementation** immediately -- longest lead-time item
10. Begin design controls, risk management, and software lifecycle documentation
11. Plan and execute clinical validation study
12. Schedule IEC 60601 and biocompatibility testing
13. Obtain MDSAP certification

### Phase 4: Obtain Medical Device Licence (30-36 months)

14. Submit Class II MDL application to Health Canada
15. Transition marketing from wellness to medical device claims
16. Simultaneously pursue FDA De Novo for US market

### Why This Phased Approach

- **Revenue while regulating:** Wellness launch generates revenue and market validation during the 2.5-3 year medical device pathway
- **De-risked clinical study:** Real-world data from wellness users informs clinical study design
- **ELI Health precedent:** A funded, Montreal-based competitor is already selling cortisol tests without an MDL
- **Preserved optionality:** Can adjust pathway based on Health Canada's evolving posture toward wellness cortisol devices
- **Canada-first advantage:** Faster Health Canada review allows market entry while FDA De Novo proceeds

---

## Sources

### Health Canada
- [Medical Devices Overview](https://www.canada.ca/en/health-canada/services/drugs-health-products/medical-devices.html)
- [Medical Devices Regulations SOR/98-282](https://laws-lois.justice.gc.ca/eng/regulations/sor-98-282/fulltext.html)
- [Classification Guidance for Non-IVDDs](https://www.canada.ca/en/health-canada/services/drugs-health-products/medical-devices/application-information/guidance-documents/guidance-document-guidance-risk-based-classification-system-non-vitro-diagnostic.html)
- [Clinical Evidence Requirements](https://www.canada.ca/en/health-canada/services/drugs-health-products/medical-devices/application-information/guidance-documents/clinical-evidence-requirements-medical-devices.html)
- [IMDRF ToC for Applications](https://www.canada.ca/en/health-canada/services/drugs-health-products/medical-devices/application-information/guidance-documents/international-medical-device-regulators-forum.html)
- [Class II Application Content](https://www.canada.ca/en/health-canada/services/drugs-health-products/medical-devices/application-information/guidance-documents/international-medical-device-regulators-forum/class-ii-licence-application-content-classifications.html)
- [Medical Device Licensing](https://www.canada.ca/en/health-canada/services/licences-authorizations-registrations-drug-health-products/licence-authorization-registration-forms-drug-health-products/medical-device-licensing.html)
- [MDEL Guidance GUI-0016](https://www.canada.ca/en/health-canada/services/drugs-health-products/compliance-enforcement/establishment-licences/directives-guidance-documents-policies/guidance-medical-device-establishment-licensing-0016.html)
- [Medical Device Fees](https://www.canada.ca/en/health-canada/services/drugs-health-products/medical-devices/fees.html)
- [MDSAP Transition](https://www.canada.ca/en/health-canada/services/drugs-health-products/medical-devices/activities/international/transition-medical-device-single-audit-program.html)
- [Mandatory Problem Reporting](https://www.canada.ca/en/health-canada/services/drugs-health-products/medeffect-canada/adverse-reaction-reporting/mandatory-medical-device-problem-reporting-form-industry-adverse-reaction-reporting.html)

### ISED
- [RSS-247](https://ised-isde.canada.ca/site/spectrum-management-telecommunications/en/devices-and-equipment/radio-equipment-standards/radio-standards-specifications-rss/rss-247-digital-transmission-systems-dtss-frequency-hopping-systems-fhss-and-licence-exempt-local)

### US FDA
- [General Wellness Policy for Low Risk Devices](https://www.fda.gov/regulatory-information/search-fda-guidance-documents/general-wellness-policy-low-risk-devices)
- [De Novo Classification Request](https://www.fda.gov/medical-devices/premarket-submissions-selecting-and-preparing-correct-submission/de-novo-classification-request)

### ELI Health
- [Official Website](https://eli.health/)
- [Cortisol Product Page](https://eli.health/products/cortisol)
- [Science Page](https://eli.health/pages/science)
- [BetaKit: $17M CAD Series A](https://betakit.com/eli-health-closes-17-million-cad-series-a-to-fuel-launch-of-hormone-monitoring-tech/)
- [Medsider Interview with Marina Pavlovic Rivas](https://www.medsider.com/interviews/marina-pavlovic-rivas-eli-health)

### Standards
- [ISO 13485:2016](https://www.iso.org/standard/59752.html)
- [IEC 60601-1-11:2015](https://www.iso.org/standard/65529.html)
- [PIPEDA Overview](https://www.priv.gc.ca/en/privacy-topics/privacy-laws-in-canada/the-personal-information-protection-and-electronic-documents-act-pipeda/pipeda_brief/)
