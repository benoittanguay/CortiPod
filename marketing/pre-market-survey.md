# CortiPod Pre-Market Survey

> **Last updated:** 2026-04-19
>
> **Purpose:** Validate product-market fit by explicitly testing each claim made in the [investor pitch](presentation.html). Every assumption the deck asserts — the personas, the proxy-vs-direct framing, the pattern-disorder argument, the wrist form factor, the 15-minute cadence, the $250–350 price tier, the clinical-companion positioning — needs a measurable answer before we harden manufacturing tooling or commit to scaling.
>
> **Related docs:** [presentation.html](presentation.html) (the pitch this survey validates), [market-analysis.md](../docs/market-analysis.md), [operations/manufacturing/cost-analysis.md](../operations/manufacturing/cost-analysis.md), [multi-analyte-expansion-roadmap.md](../docs/multi-analyte-expansion-roadmap.md)

---

## Table of Contents

1. [Objectives](#objectives)
2. [Pitch Hypotheses Tested (H1–H16)](#pitch-hypotheses-tested)
3. [Target Respondent Profile](#target-respondent-profile)
4. [Sample Size & Channels](#sample-size--channels)
5. [Survey Structure](#survey-structure)
6. [Section A — Screener & Demographics](#section-a--screener--demographics)
7. [Section B — Current Health Tracking Behavior](#section-b--current-health-tracking-behavior)
8. [Section C — Cortisol Awareness & Beliefs (H1, H2)](#section-c--cortisol-awareness--beliefs)
9. [Section D — Current Tools & Unmet Need (H3)](#section-d--current-tools--unmet-need)
10. [Section E — Persona Self-Identification (H9, H10)](#section-e--persona-self-identification)
11. [Section F — Concept Exposure (H6, H15)](#section-f--concept-exposure)
12. [Section G — Pattern vs. Snapshot (H5)](#section-g--pattern-vs-snapshot)
13. [Section H — Proxy vs. Direct Measurement (H4, H12)](#section-h--proxy-vs-direct-measurement)
14. [Section I — Form Factor, Cadence & Wear (H7, H8)](#section-i--form-factor-cadence--wear)
15. [Section J — Clinical Companion & Doctor Loop (H11)](#section-j--clinical-companion--doctor-loop)
16. [Section K — Feature Prioritization](#section-k--feature-prioritization)
17. [Section L — Price Sensitivity: Starter Kit (Device) (H13)](#section-l--price-sensitivity-starter-kit-device)
18. [Section M — Price Sensitivity: Sensor Cartridges (Consumable) (H13)](#section-m--price-sensitivity-sensor-cartridges-consumable)
19. [Section N — Subscription vs. One-Time Purchase](#section-n--subscription-vs-one-time-purchase)
20. [Section O — Purchase Intent, Channels & Competitive Wait (H14)](#section-o--purchase-intent-channels--competitive-wait)
21. [Section P — Data, Privacy & Integrations](#section-p--data-privacy--integrations)
22. [Section Q — Open-Ended Qualitative](#section-q--open-ended-qualitative)
23. [Analysis Plan](#analysis-plan)
24. [Decision Gates & Hypothesis Scorecard](#decision-gates--hypothesis-scorecard)

---

## Objectives

The survey must produce defensible answers to:

1. **Is the pitch true?** Do respondents corroborate the claims in `presentation.html`, or do we need to reframe?
2. **Device price ceiling** — maximum starter-kit price that does not materially suppress purchase intent within our target SAM.
3. **Sensor price ceiling** — ongoing per-month / per-cartridge price compatible with retention economics.
4. **Bundle vs. unbundle** — subscription, à-la-carte refills, or hybrid.
5. **Must-have features** — deal-breakers vs. delighters; where we can cut scope to hit cost targets.
6. **Channel preference** — DTC, Amazon, Apple Store / Best Buy, pharmacy, clinician referral, corporate wellness.
7. **Persona weighting** — which of the seven pitch personas drive the largest combined demand × willingness-to-pay.
8. **Competitive displacement vs. complement** — does CortiPod replace or augment an existing wearable (Oura, Whoop, Apple Watch)?
9. **Manufacturing implications** — do responses justify color SKUs, premium enclosure finishes, alternative form factors, higher sampling cadence?

---

## Pitch Hypotheses Tested

Each question in this survey is tagged with one or more hypothesis IDs. The pitch wins if the hypotheses land; it loses if they don't.

| ID | Hypothesis (from `presentation.html`) | Where tested |
|----|---------------------------------------|--------------|
| **H1** | Cortisol / chronic stress is a **self-identified pain point** — not an abstract concern — for the target SAM. | Section C |
| **H2** | Target buyers are **cortisol-literate enough** to want to measure it specifically. | Section C |
| **H3** | Existing tools (blood/saliva/urine tests, HRV-derived stress scores) leave a real **unmet need**. | Section D, H |
| **H4** | Buyers will pay **more for direct cortisol measurement** than for HRV-inferred stress. | Section H, L |
| **H5** | The **pattern (curve) is more valuable than a snapshot** — the "pattern disorder" framing resonates. | Section G |
| **H6** | Buyers find **sweat-based cortisol measurement plausible and trustworthy**. | Section F |
| **H7** | **Wrist-worn** is the preferred form factor for this use case. | Section I |
| **H8** | A **15-minute sampling cadence** is a meaningful differentiator vs. sparser measurement. | Section I |
| **H9** | The deck's **seven personas exist at meaningful scale** within the SAM. | Section E |
| **H10** | **Clinical-adjacent segments** (steroid taper, mental-health comorbid, shift work, rare endocrine) have strong purchase intent. | Section E, J |
| **H11** | Users will **share data with a clinician**; clinicians will engage with it. | Section J |
| **H12** | Whoop / Oura / Apple Watch users see **CortiPod as filling a gap**, not as a substitute. | Section H |
| **H13** | **$250–350 / year** (device + sensors combined) is the viable price tier. | Section L, M |
| **H14** | Consumers **will not wait** for Apple/Whoop/Oura to add cortisol — they'll buy from a startup now. | Section O |
| **H15** | The **"objective biomarker, not a wellness score"** framing differentiates, and "invisible hormone, made visible" is memorable. | Section F, Q |
| **H16** | **76% stress-harm statistic** converts to personal concern — respondents place themselves in the affected majority. | Section C |

---

## Target Respondent Profile

Filter for the SAM described in `market-analysis.md`:

- Age 25–65 (broadened vs. prior draft — the pitch includes steroid-taper and shift-work populations that skew older)
- Household income US$100K+ (or Canadian equivalent) — relaxed for clinical-adjacent quotas
- Currently owns OR has considered buying a premium health wearable (Oura, Whoop, Apple Watch Ultra, Garmin, Eight Sleep, Levels / Stelo CGM, Lumen, Hone Health, etc.) OR matches a clinical-adjacent persona (chronic steroid use, diagnosed adrenal condition, diagnosed mental-health condition, shift worker)
- Reports moderate-to-high stress or active interest in longevity / biohacking / hormone health

Secondary segment to capture (smaller quota): clinicians and health coaches who might recommend or prescribe the device (n ≈ 30).

---

## Sample Size & Channels

Quotas reflect the seven pitch personas so each hypothesis gets enough power.

| Segment (pitch persona) | Target n | Channel |
|-------------------------|----------|---------|
| Biohackers / quantified-self (H14, H4) | 120 | r/Biohackers, r/QuantifiedSelf, Huberman-adjacent newsletters |
| Oura / Whoop power users (H12) | 120 | Paid Prolific panel filtered to wearable owners |
| Weight / metabolic concerns (Persona 01) | 75 | Noom, MyFitnessPal panels |
| Chronic fatigue / unexplained exhaustion (Persona 02) | 50 | r/CFS, Hashimoto's groups |
| **Steroid taper / chronic corticosteroid users (Persona 03, H10)** | 60 | r/Asthma, r/CrohnsDisease, r/LupusSupport, rheumatologist-referral panels |
| Burnout / chronic-stress professionals (Persona 04) | 100 | LinkedIn, Headspace/Calm audiences |
| Mental-health treatment-seekers (Persona 05, H10) | 60 | r/depression, r/anxiety, BetterHelp referral |
| Shift workers (Persona 06, H10) | 60 | Healthcare worker forums, nursing subreddits, firefighter groups |
| Women's health (cycle, perimenopause) | 60 | ELI Health waitlist, Flo / Natural Cycles user lists |
| Athletes & coaches | 50 | CrossFit / endurance Facebook groups, Strava influencers |
| Clinicians (endo, psych, functional med) | 30 | LinkedIn, IFM directory, AACE |
| Rare-disease patients (Cushing / Addison / CAH / NCCAH) | 25 | Advocacy groups (CSRF, NADF, CARES Foundation) |
| **Total** | **~810** | |

Minimum viable sample for Van Westendorp analysis: **n ≥ 100 per price-relevant segment**. Personas with n < 50 (steroid taper, rare disease) are directional — treat findings as hypothesis-forming, not confirmatory.

---

## Survey Structure

- Platform: Typeform or Tally (mobile-first)
- Target completion time: **10–12 minutes** (drop-off climbs steeply past 14)
- Incentive: US$5 Amazon gift card for completion OR entry into a draw for a free unit at launch
- Logic: Screener disqualifies anyone outside the SAM before collecting concept / pricing data. Clinical-adjacent respondents get a branch with additional clinical-loop questions.
- Order: screen → behavior → cortisol context → tool frustration → persona ID → concept → pattern framing → proxy framing → form factor → clinical loop → features → price → intent → demographics (demographics last to avoid fatigue bias).
- **Anti-anchoring:** price questions come AFTER concept exposure but BEFORE any pricing is mentioned. Do not show the deck's "$250–350" anchor until after Section M is complete.

---

## Section A — Screener & Demographics

> Q's marked (DQ) terminate the survey if the disqualifying answer is selected.

1. What is your age?
   - Under 25 (DQ unless explicitly recruited as youth quota)
   - 25–34 / 35–44 / 45–54 / 55–64 / 65+
2. In which country / region do you live? (free text)
3. Annual household income in USD (or local equivalent):
   - Under $50K (DQ unless in clinical-adjacent quota) / $50–$99K / $100–$149K / $150–$249K / $250K+ / Prefer not to say
4. Do you currently own, or have you owned in the last 12 months, any of the following? *(multi-select)*
   - Oura Ring / Whoop / Apple Watch (any model) / Garmin / Fitbit / Eight Sleep / Levels / Dexcom Stelo or other CGM / Lumen / Hone Health / None of the above (DQ if "None" AND no "considered" in Q5 AND not in a clinical-adjacent quota)
5. Have you considered buying but not yet purchased any of the above? *(multi-select, same list)*
6. Gender: Female / Male / Non-binary / Prefer to self-describe / Prefer not to say
7. Which best describes you? *(select one)*
   - Biohacker / optimizer
   - Athlete (recreational or competitive)
   - Managing a specific health condition
   - Professional in a high-stress job
   - Shift worker (nights or rotating)
   - Caring for aging parent(s) or child with chronic condition
   - None of the above

---

## Section B — Current Health Tracking Behavior

8. Roughly how much do you spend per year on health wearables, apps, supplements, and lab testing combined?
   - < $200 / $200–$499 / $500–$999 / $1,000–$2,499 / $2,500–$4,999 / $5,000+
9. How often do you open a health-tracking app? Daily / A few times a week / Weekly / Occasionally / Rarely
10. Which metrics do you currently track? *(multi-select)*
    - Sleep stages / HRV / Resting HR / Steps / Workouts / Glucose / Body temp / Menstrual cycle / Blood pressure / Weight / Body composition / Blood labs / Hormone panels / Other: __
11. Have you ever taken an at-home hormone test (cortisol, testosterone, thyroid, estrogen/progesterone)? Yes / No / Unsure
12. If yes, how satisfied were you with the insights? *(1–5)*

---

## Section C — Cortisol Awareness & Beliefs

> **Tests H1, H2, H16** — that stress is a self-identified pain point, that buyers are cortisol-literate, and that the pitch's 76% stat converts to personal concern.

13. On a 1–10 scale, how would you rate your average stress level over the last 30 days?
14. Do you believe your stress levels are **negatively affecting your health right now**? Yes / No / Unsure *(H16 — personal version of the deck's 76% stat)*
15. Which of the following have you personally experienced in the last 12 months that you attribute to stress? *(multi-select — H1 pain-point surface)*
    - Poor sleep / Weight gain / Weight loss / Burnout / Fatigue not relieved by rest / Brain fog / Getting sick more often / Mood changes / Missed periods or cycle irregularity / Flare of an existing condition / None of the above
16. How familiar are you with the role of cortisol in the body? *(H2)*
    - Never heard of it / Heard the term / Know the basics / Actively interested / Already manage it
17. In your own words, what does cortisol do? *(free text — unprompted knowledge check for H2)*
18. Have you ever discussed cortisol with a healthcare provider? Yes / No
19. Have you ever tried to measure your own cortisol (any method)? Yes / No
    - If yes: how? (blood, saliva kit, urine, other) Were results actionable? *(free text)*
20. How much do you agree: **"I'd like to know my cortisol levels on a regular basis."** *(1–7, H1+H2)*
21. Which of these would motivate you to start measuring cortisol? *(multi-select)*
    - Better sleep / Workout recovery / Weight management / Menstrual or perimenopause support / Fertility / Mental health / Longevity / Specific diagnosed condition / Curiosity — none of the above specifically

---

## Section D — Current Tools & Unmet Need

> **Tests H3** — that existing tools leave a real gap.

22. How well do your current tools answer the question *"is my stress actually harming my body?"* *(1–5; 1 = not at all, 5 = completely)*
23. When your wearable shows a "stress score" or "recovery score," how much do you trust it? *(1–5)*
24. How often have you felt your wearable's stress/recovery score disagrees with how you actually feel? Never / Rarely / Sometimes / Often / Always
25. If you could measure **one additional biomarker continuously**, what would it be? *(free text — H3 revealed preference)*
26. On a 1–5 scale, how frustrating are each of the following? *(matrix)*
    - Having to go to a clinic for a blood draw
    - Mailing a saliva kit and waiting 1–2 weeks for results
    - Getting only a single-point-in-time reading
    - Not knowing if your stress-management changes are working
    - Your wearable's stress/recovery score not explaining *why*

---

## Section E — Persona Self-Identification

> **Tests H9, H10** — that the pitch's seven personas exist at meaningful scale, and that clinical-adjacent segments convert at high rates. Each sub-question mirrors a pitch persona verbatim so we can measure fit per slide.

27. How strongly does each statement describe you in the last 12 months? *(1–5 matrix; 1 = not at all, 5 = exactly me)*
    - **P1 — Weight:** "I've been gaining weight and no one can tell me why."
    - **P2 — Fatigue:** "I'm exhausted no matter how much I rest."
    - **P3 — Steroid taper:** "I'm currently tapering or have recently tapered off corticosteroids (prednisone, hydrocortisone, etc.)."
    - **P4 — Burnout:** "I feel like I'm running on empty and burning out."
    - **P5 — Mental-health companion:** "I'm actively working on my mental health but can't tell if what I'm doing is working."
    - **P6 — Shift work:** "I work nights or rotating shifts and feel like my body never adjusts."
    - **P7 — Rare/diagnosed endocrine:** "I have been diagnosed with Cushing's, Addison's, CAH, or another adrenal disorder — or a family member has."
28. For any of the above you rated ≥4, which **single one** is the most important to you personally? *(single select)*
29. Have you, or a family member, been diagnosed with any of the following? *(multi-select — H10)*
    - Cushing's syndrome / Addison's disease / CAH (classic or non-classic) / Chronic adrenal insufficiency / Depression with treatment history / PTSD / Generalized anxiety / Hashimoto's / Long COVID / None of the above
30. *(Only if P3 selected)* How long is your current or planned taper? Less than 1 month / 1–3 months / 3–6 months / 6–12 months / More than 12 months
31. *(Only if P3 selected)* Would a home device that showed your natural cortisol returning as you taper be valuable? *(1–7; H10)*
32. *(Only if P6 selected)* How many years of shift work? < 1 / 1–3 / 3–5 / 5–10 / 10+
33. *(Only if P7 selected)* What does your current monitoring routine look like? *(free text)*

---

## Section F — Concept Exposure

> **Tests H6, H15** — believability of sweat-based cortisol and resonance of the pitch framing.
>
> **Show** (video OR text + image from `presentation.html`):
>
> *"CortiPod is a wrist-worn wearable that measures cortisol — your body's primary stress hormone — directly from sweat, every 15 minutes, all day long. Today, the only way to measure cortisol is a blood draw, a mailed saliva kit, or a 24-hour urine jug. All of them give you one number from one moment. Cortisol disorders — and chronic stress — are pattern disorders. You need the curve, not the snapshot. No other consumer device measures cortisol. Every 'stress score' on the market is a guess based on heart rate. CortiPod is the actual hormone. The invisible hormone, made visible."*

34. How clear was the product concept? *(1–5)*
35. How interesting is this product to you? *(1–7)*
36. How new or different is this compared to products you've seen? *(1–5)*
37. How believable is the claim that **a wrist-worn device can measure cortisol from sweat**? *(1–5, H6)*
38. What specifically makes the claim **more** or **less** believable to you? *(free text, H6)*
39. Which of these pitch phrases resonates most? *(rank — H15)*
    - "The invisible hormone, made visible"
    - "Your body has been telling you something. CortiPod lets you hear it."
    - "Direct measurement, not a proxy"
    - "A curve, not a snapshot"
    - "On your wrist, not in a lab"
    - "The first wrist-worn device that measures cortisol directly"
40. In one sentence, who do you think this product is for? *(free text — useful for positioning check)*
41. What would prove to you this actually works? *(multi-select)*
    - FDA clearance / Peer-reviewed study / Doctor endorsement (Huberman, Attia, etc.) / Hospital study / Customer reviews / Money-back guarantee / Free trial / Comparison against a lab test / Nothing would convince me

---

## Section G — Pattern vs. Snapshot

> **Tests H5** — that the "pattern disorder" framing is compelling and that continuous beats point-in-time.

42. Two imaginary products, same price. Which would you buy?
    - **A:** A single very accurate cortisol lab test, once per month.
    - **B:** A wearable that measures cortisol every 15 minutes, accurate to ±15%.
    - *(No preference / Need more info)*
43. How much do you agree: **"A curve across the whole day tells me more than a single number."** *(1–7)*
44. Given a choice between the following readings over a single day, which is most valuable to you?
    - 1 reading at 8 AM / 3 readings at 8 AM, 2 PM, 10 PM / 6 readings every 4 hours / 96 readings every 15 minutes / Continuous (every minute)
45. Would you pay more for a version that sampled every 5 minutes vs. every 15 minutes? Yes significantly / Yes a little / No / Less — slower is fine

---

## Section H — Proxy vs. Direct Measurement

> **Tests H4, H12** — willingness-to-pay premium for direct cortisol vs. HRV-inferred stress, and whether Whoop/Oura users see a complementary gap.

46. Today, most wearables estimate stress from heart rate variability (HRV). On a 1–5 scale, how much do you trust HRV as a stress measure? *(1–5)*
47. If given the choice at the **same price**, which would you prefer?
    - A device that directly measures the cortisol hormone
    - A device that infers stress from HRV and other vitals
    - No preference
48. How much **more** would you pay for direct cortisol measurement vs. an HRV-based stress score? *(H4)*
    - Nothing extra / Up to $50 more / $50–$100 more / $100–$200 more / $200+ more
49. If you already own an Oura, Whoop, Apple Watch, or Garmin, would CortiPod: *(H12)*
    - Replace it
    - Be worn alongside it
    - I'd wait until my current one integrates cortisol
    - Not interested regardless
50. What would have to be true for you to wear CortiPod **instead of** (not alongside) your current wearable? *(free text)*
51. If Apple, Whoop, or Oura announced cortisol measurement 12 months from now, would you: *(H14)*
    - Still buy CortiPod now
    - Wait for the incumbent
    - Depends on price
    - Depends on accuracy
    - Already committed to CortiPod

---

## Section I — Form Factor, Cadence & Wear

> **Tests H7, H8** — that wrist is preferred and that 15-min cadence is a meaningful differentiator.

52. Preferred wear location *(H7)*: Wrist / Upper arm (Dexcom-style patch) / Chest / Behind-ear patch / Ring / No preference
53. If wrist were not available, which would you choose?
    - Upper-arm patch / Chest patch / Ring / Would not buy
54. Preferred form: Watch-style band / Discreet patch / Ring / Clip-on / No preference
55. Would you wear it 24/7 including sleep? Yes / Only at night / Only during the day / Intermittently
56. Maximum acceptable sensor swap frequency:
    - Daily (signals product-fit problem) / Every 2–3 days / Weekly / Every 2 weeks / Monthly
57. Minimum acceptable battery life between charges: 1 day / 3 days / 7 days / 14 days / 30 days
58. Color / finish preference: Black / White / Silver / Rose gold / Titanium / Don't care
59. Water exposure expectation: Shower only / Swim (pool) / Swim (ocean) / Sauna / None of the above
60. How visible would you be comfortable with the device being? Invisible / Subtle / Visible is fine / Show it off
61. *(Only if P6 shift worker)* Would you wear it during sleep regardless of your schedule? Yes / Only during "night" / Only if it doesn't affect comfort / No

---

## Section J — Clinical Companion & Doctor Loop

> **Tests H10, H11** — that users will share data with a clinician and that clinicians will accept it. Split into consumer branch (J.1) and clinician branch (J.2).

### J.1 — Consumer branch

62. Would you share your CortiPod data with your primary care doctor? Yes / Maybe / No
63. Would you share it with a specialist (endocrinologist, psychiatrist, rheumatologist)? Yes / Maybe / No
64. If CortiPod flagged a pattern suggesting "see a doctor," how likely would you be to schedule a visit? *(1–7)*
65. If your clinician **refused** to look at the data, would you still buy the product? Yes / Yes but disappointed / No
66. Would the product be more valuable to you if it came with a **shareable PDF/clinical report**? Yes / No / Indifferent
67. Would prescription-gated cartridges (requiring a doctor's Rx) be a dealbreaker? Yes dealbreaker / No / Actually prefer it (signals legitimacy)

### J.2 — Clinician branch *(H11)*

68. What is your specialty? Endocrinology / Primary care / Psychiatry / Sleep medicine / Functional / integrative / Rheumatology / Pediatrics / Other
69. How often do you order cortisol tests per month? 0 / 1–5 / 6–20 / 21+
70. Would a **continuous cortisol curve from a patient's wearable** change how you work up suspected adrenal disorders? *(1–7)*
71. What accuracy standard would you require to act on the data clinically? *(free text)*
72. Would you recommend CortiPod to a patient for:
    - Suspected Cushing's / Suspected Addison's / CAH pediatric dosing / Steroid taper monitoring / Depression/PTSD companion / Burnout/stress coaching / None of these
73. What reimbursement path, if any, would be required for you to recommend it? *(free text)*

---

## Section K — Feature Prioritization

74. Rank from most to least important: *(drag-and-drop)*
    - Measurement accuracy vs. a lab test
    - Battery life
    - Sensor cartridge lifespan (days between swaps)
    - App insights and coaching
    - Integration with existing apps (Apple Health, Whoop, Oura)
    - Comfort / thinness of the device
    - Waterproofing (shower, swim)
    - Sleep tracking built in
    - HRV / heart rate built in
    - Additional hormones beyond cortisol (testosterone, estradiol, progesterone)
    - Shareable clinical report
    - FDA clearance
75. Which of these is a **deal-breaker** — you would not buy without it? *(multi-select, same list)*
76. If we added a second hormone at +$X per cartridge, which would you pay most for? *(single select)*
    - Testosterone / Estradiol / Progesterone / DHEA / Melatonin / Not interested in a second hormone

---

## Section L — Price Sensitivity: Starter Kit (Device)

> **Tests H13.** Starter kit = the wearable device + charging cradle + first set of sensor cartridges sufficient for ~3 weeks of use.

Van Westendorp Price Sensitivity Meter (ask all four; required):

77. At what price would you consider the starter kit **so expensive that you would not consider buying it**? *(USD, numeric)*
78. At what price would you consider the starter kit **starting to get expensive, but still worth considering**?
79. At what price would you consider the starter kit **a bargain — a great buy for the money**?
80. At what price would you consider the starter kit **so cheap that you would question the quality and not buy it**?

Follow-up (Gabor-Granger at fixed points):

81. At **$199**, how likely are you to buy? *(1 = definitely not, 5 = definitely would)*
82. At **$299**, how likely are you to buy? *(1–5)*
83. At **$399**, how likely are you to buy? *(1–5)*
84. At **$499**, how likely are you to buy? *(1–5)*

85. Price premium test *(H4)*: if HRV-based Whoop is "free device + $30/mo" and Oura is "$349 + $6/mo", how much more would you pay up-front for direct cortisol?
    - Same as Oura / +$100 / +$200 / +$300 / +$400 / Would pay less than Oura

86. Which of these comparable products have you bought, and for how much?
    - Oura Ring ($___), Whoop (free device + sub), Apple Watch ($___), Dexcom Stelo ($___/mo), Hone Health lab + trt ($___), Lumen ($___). *(anchors stated prices to revealed behavior)*

---

## Section M — Price Sensitivity: Sensor Cartridges (Consumable)

> **Tests H13.** A sensor cartridge lasts ~7 days. A typical user replaces it weekly.

Van Westendorp (repeat for **monthly cartridge supply**, i.e. ~4 cartridges):

87. Monthly cartridge cost **too expensive to buy**? *(USD)*
88. Monthly cartridge cost **getting expensive but worth considering**?
89. Monthly cartridge cost **a bargain**?
90. Monthly cartridge cost **so cheap you'd question quality**?

Direct purchase intent:

91. Would you subscribe at **$19/mo**? Yes / No / Maybe
92. Would you subscribe at **$29/mo**? Yes / No / Maybe
93. Would you subscribe at **$39/mo**? Yes / No / Maybe
94. Would you subscribe at **$49/mo**? Yes / No / Maybe
95. Would you subscribe at **$69/mo**? Yes / No / Maybe

96. Maximum you'd pay for a **single replacement cartridge** (non-subscription)?
    - $5 / $10 / $15 / $20 / $25 / $30+ / Would only buy via subscription

97. Total annual willingness-to-pay (device amortization + cartridges): $___ *(cross-check on H13's $250–350/year claim)*

---

## Section N — Subscription vs. One-Time Purchase

98. Preferred purchase model:
    - Buy device outright, buy cartridges as needed (à la carte)
    - Buy device outright, subscribe to monthly cartridge delivery
    - Whoop-style: free or cheap device, mandatory monthly subscription includes cartridges
    - Rent device monthly, cartridges included
99. Acceptable minimum subscription commitment: No commitment / 3 mo / 6 mo / 12 mo
100. If Whoop-style: how much would you pay per month, device included? $___
101. Would you pay a one-time **$50–$100** premium to **avoid** a subscription entirely? Yes / No / Maybe
102. Would insurance / HSA / FSA eligibility change your purchase decision? Yes significantly / Yes slightly / No
103. *(If P3 or P7 — clinical-adjacent)* Would you prefer a clinical channel (specialist-prescribed, possibly insurance-covered) over retail? Yes / No / Either is fine

---

## Section O — Purchase Intent, Channels & Competitive Wait

> **Tests H14.**

104. If available today at your preferred price, how likely are you to buy within 3 months? *(1–7)*
105. If **only** available as a **pre-order shipping in 6 months**, how likely are you to commit? *(1–7, H14)*
106. Preferred place to buy:
    - Brand website (DTC) / Amazon / Apple Store / Best Buy / CVS / Walgreens / Costco / Doctor's office / Through employer wellness program
107. Would you buy it for someone else as a gift? Yes / Maybe / No
108. Would you recommend it to a friend if you liked it? *(NPS 0–10)*
109. Which of these would make you more confident buying? *(multi-select)*
    - FDA clearance
    - Published peer-reviewed study
    - Endorsement by a recognizable doctor/researcher (Huberman, Attia, etc.)
    - Reviews on Amazon / Reddit
    - Money-back guarantee
    - Free trial period
    - Seeing it in a retail store
    - Corporate wellness / insurance coverage
    - Recommendation from my own doctor
110. Who do you expect will solve continuous cortisol measurement first? *(H14)*
    - A startup / Apple / Oura / Whoop / Dexcom or Abbott / No one in the next 3 years / No opinion

---

## Section P — Data, Privacy & Integrations

111. How important is integration with the following? *(rate 1–5)*
    - Apple Health / Google Fit / Oura / Whoop / Garmin / Strava / MyFitnessPal / Levels / Hone / Function Health
112. Would you consent to your anonymized data being used for research? Yes / No / Only if paid
113. How comfortable are you with cloud data storage? Fully comfortable / Comfortable with encryption / Only local on device / Unsure
114. Would an AI-coaching feature (cortisol-aware recommendations) increase your willingness to pay? Yes / No / Depends on price
115. Which third-party service, if connected, would make this product significantly more valuable to you? *(free text)*

---

## Section Q — Open-Ended Qualitative

116. What concerns, if any, do you have about this product? *(free text)*
117. What would have to be true for you to buy it tomorrow? *(free text)*
118. Who do you think of as our biggest competitor? *(free text)*
119. What should we absolutely **not** do with this product? *(free text — catches anti-patterns)*
120. In your own words, re-state what CortiPod does. *(free text — unaided recall; tests H15 framing retention)*
121. Email address for early access / follow-up interview? *(optional — flag interview willingness)*

---

## Analysis Plan

### Price Sensitivity Meter (Van Westendorp)

From Sections L and M, plot cumulative distributions and find the four intersection points:

- **Point of Marginal Cheapness (PMC)** — cheap × not-cheap. Floor price.
- **Point of Marginal Expensiveness (PME)** — expensive × not-expensive. Ceiling price.
- **Indifference Price Point (IPP)** — expensive × cheap. Median acceptable price.
- **Optimal Price Point (OPP)** — too-cheap × too-expensive. Minimizes rejection.

Output a target price band: `[PMC, PME]` with **OPP as the primary launch anchor** and IPP as the upsell tier.

### Gabor-Granger Check

Plot conversion % by price (Q81–84, Q91–95). Compare the inflection price against the Van Westendorp OPP. If they diverge by >15%, re-run with a larger sample before committing.

### Direct-vs-Proxy Premium (H4)

From Q48 and Q85, compute the willingness-to-pay premium over HRV-based wearables. A premium of < $100 collapses the "objective biomarker" thesis — the pitch needs to be reframed around clinical rather than consumer buyers.

### Persona Weighting (H9, H10)

For each P1–P7 in Q27, compute: `share rating ≥4 × mean purchase intent (Q104) × OPP (Q77–80)`. Rank personas by this composite — the top 2 define lead-segment marketing. Personas with composite < 30% of the leader get deprioritized in GTM copy.

### Pattern-vs-Snapshot Index (H5)

Simple agreement score on Q42, Q43, Q44. If <60% of target segment prefers continuous over snapshot at equal price, the pitch's entire "curve vs. photograph" narrative needs to be softened.

### Belief in Tech (H6)

Q37 + qualitative Q38. If median <3 on believability, the pitch needs to lead with proof (study, demo video, lab correlation) before any claim. Informs marketing spend on explainer content vs. aspirational content.

### Competitive-Wait Analysis (H14)

Q51 + Q110. If >30% of target segment would "wait for the incumbent," we must either: (a) ship faster, (b) build moat via clinical credentialing, or (c) price to match the wait discount.

### Feature Importance

Max-diff or rank aggregation on Q74. Cross-tabulate with Q75 deal-breakers to find features that are **high-importance AND deal-breaker** — these set the non-negotiable BOM.

### Clinical Loop (H11)

J.1 + J.2. Compare consumer willingness-to-share (Q62–63) against clinician willingness-to-engage (Q70–72). If gap > 40 points, we have a marketing problem (consumers expect doctor engagement we can't deliver) — plan clinician education campaign.

### Segmentation

Run k-means or latent class analysis on {income, current device ownership, spending, stress level, persona matches}. Expect 3–4 clusters. Price curves per cluster should drive SKU strategy.

### Manufacturing Feedback

Cross-reference Section I (form factor, cadence) with `operations/manufacturing/cost-analysis.md`:
- If <20% demand color variants → single-SKU enclosure, keep injection mold simple
- If sensor-swap preference skews to 2-week+ → bias MIP chemistry R&D toward longevity over throughput
- If battery-life demand skews 14+ days → re-evaluate 60 mAh battery sizing
- If 15-min cadence ties with 60-min cadence in Q44 → firmware/power budget can relax, reducing battery/BOM cost

---

## Decision Gates & Hypothesis Scorecard

Survey is **go / soft-go / no-go** per hypothesis. A single no-go blocks scaling investment until the pitch is revised.

| ID | Hypothesis | Metric | Go | Soft-go | No-go |
|----|-----------|--------|-----|---------|-------|
| H1 | Cortisol/stress is a self-identified pain point | Q15 ≥1 symptom + Q20 ≥5 | ≥65% of SAM | 45–65% | <45% |
| H2 | Buyers are cortisol-literate | Q16 ≥"Know the basics" | ≥70% | 50–70% | <50% |
| H3 | Existing tools leave unmet need | Q22 ≤3 AND Q26 avg ≥3.5 | Both met | One met | Neither |
| H4 | WTP premium for direct vs. proxy | Q48 ≥"+$100" | ≥50% | 30–50% | <30% |
| H5 | Pattern > snapshot resonates | Q42 = B AND Q43 ≥5 | Both met | One met | Neither |
| H6 | Tech believability | Q37 median | ≥4 | 3–4 | <3 |
| H7 | Wrist-worn preferred | Q52 = Wrist | ≥60% | 40–60% | <40% |
| H8 | 15-min cadence is a differentiator | Q44 ≥96 readings selected | ≥40% | 25–40% | <25% |
| H9 | Pitch personas exist at scale | ≥3 of 7 personas with ≥20% "exactly me" | Met | 2 personas | ≤1 persona |
| H10 | Clinical-adjacent intent | Steroid-taper/MH/shift segments Q104 ≥5 | ≥50% in ≥2 segments | 35–50% | <35% |
| H11 | Clinician engagement | Consumer share-intent ≥60% AND clinician Q70 ≥5 | Both | Consumer only | Neither |
| H12 | Complementary, not substitutive | Q49 = "alongside" | ≥50% | 35–50% | <35% |
| H13 | $250–350/yr viable | Q97 median | ≥$280 | $200–$280 | <$200 |
| H14 | Will not wait for incumbent | Q51 = "Still buy now" OR Q105 ≥5 | ≥50% | 30–50% | <30% |
| H15 | Framing resonates & is recalled | Q39 top phrase ≥30% AND Q120 unaided recall of "cortisol" and "continuous/sweat" | Both | One | Neither |
| H16 | 76% stress-harm stat is personal | Q14 = Yes | ≥65% | 50–65% | <50% |

### Output artifact

After fielding, produce a **pitch-delta doc**: each slide of `presentation.html` annotated with survey-confirmed numbers replacing / validating the claim, or a revision note if the claim failed its gate. This closes the loop between marketing narrative and empirical evidence.

---

## Open Questions (to refine before launch)

- Should we split the survey into a shorter (3-min) **acquisition** version and a longer (15-min) **committed** version for waitlist members?
- Add a conjoint analysis module for feature/price tradeoffs once the main survey stabilizes (requires n ≥ 300).
- Should concept exposure (Section F) include price anchor or stay price-blind until Section L? *Price-blind recommended to reduce anchoring; test both cells if sample permits.*
- Should we A/B test the framing phrases in Q39 as ad creative in a small paid-media run before fielding, so the survey compares proven-hot copy against unproven?
- Clinician branch (J.2) may need a separate recruitment approach (paid medical panel e.g. Sermo, M3 Global) rather than survey quota — decide before field.
