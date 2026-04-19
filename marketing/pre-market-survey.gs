/**
 * CortiPod Pre-Market Survey — Google Apps Script form builder
 *
 * USAGE
 *   1. Go to https://script.google.com and click "New project"
 *   2. Delete the default Code.gs contents, paste this entire file, save (Ctrl/Cmd+S)
 *   3. Click Run. First run will prompt you to authorize the "Forms" scope — approve it.
 *   4. Open View → Executions (or Logs). The edit URL and public URL of the new form
 *      will be printed. Copy them.
 *
 * WHAT YOU GET
 *   A brand-new Google Form titled "CortiPod Pre-Market Survey" in your Drive,
 *   with all 17 sections and ~120 questions from marketing/pre-market-survey.md.
 *
 * LIMITATIONS (where Forms cannot mirror the markdown 1:1)
 *   - Rankings (Q39, Q74): Forms has no native ranking widget. Implemented as a grid
 *     with rows = items, columns = rank 1..N. Each row must have a response (enforced
 *     by setRequired) AND each column can be selected only once (enforced by
 *     requireLimitOneResponsePerColumn), giving a true unique-rank experience.
 *   - Conditional follow-ups (Q30–Q33, Q61): Forms only supports branching on
 *     multiple-choice items, not on matrix rows. These questions are rendered
 *     unconditionally and marked optional; filter in analysis by Q27 / Q7 values.
 *   - Router branch (Section J): implemented via a multiple-choice router that
 *     sends consumers to J.1 and clinicians to J.2. J.1 then skips J.2 entirely.
 *   - Multi-condition DQs (Q1 × Q3 × Q4): Forms supports only single-question skip
 *     logic. DQs should be applied at analysis time by filtering responses.
 *   - Exclusive "None of the above" on checkbox questions is not natively enforced.
 *
 * RUN TIME
 *   Typically 20–40 seconds. If it errors out near the end, re-run — the form will
 *   be recreated (old partial one can be trashed).
 */

function createCortiPodSurvey() {
  const form = FormApp.create('CortiPod Pre-Market Survey');

  form
    .setTitle('CortiPod Pre-Market Survey')
    .setDescription(
      'Thanks for helping us understand how people think about stress and cortisol. ' +
      'This survey takes about 10–12 minutes. Your answers are anonymous unless you ' +
      'choose to share your email at the end for early access. Completed responses ' +
      'are entered into a draw for a free CortiPod unit at launch.'
    )
    .setProgressBar(true)
    .setAllowResponseEdits(false)
    .setShowLinkToRespondAgain(false)
    .setCollectEmail(false);

  // ──────────────────────────────────────────────────────────────
  // Helpers
  // ──────────────────────────────────────────────────────────────
  const mc = (title, choices, required) => {
    const item = form.addMultipleChoiceItem().setTitle(title).setRequired(required !== false);
    item.setChoiceValues(choices);
    return item;
  };
  const cb = (title, choices, required) => {
    const item = form.addCheckboxItem().setTitle(title).setRequired(required !== false);
    item.setChoiceValues(choices);
    return item;
  };
  const scale = (title, lo, hi, lowLabel, highLabel, required) => {
    return form.addScaleItem()
      .setTitle(title)
      .setBounds(lo, hi)
      .setLabels(lowLabel, highLabel)
      .setRequired(required !== false);
  };
  const text = (title, required) => {
    return form.addTextItem().setTitle(title).setRequired(required !== false);
  };
  const para = (title, required) => {
    return form.addParagraphTextItem().setTitle(title).setRequired(required !== false);
  };
  const numeric = (title, required) => {
    const item = form.addTextItem().setTitle(title).setRequired(required !== false);
    const v = FormApp.createTextValidation()
      .setHelpText('Please enter a number.')
      .requireNumber()
      .build();
    item.setValidation(v);
    return item;
  };
  const grid = (title, rows, cols, required) => {
    return form.addGridItem()
      .setTitle(title)
      .setRows(rows)
      .setColumns(cols)
      .setRequired(required !== false);
  };
  const page = (title, helpText) => {
    return form.addPageBreakItem().setTitle(title).setHelpText(helpText || '');
  };
  const header = (title, helpText) => {
    return form.addSectionHeaderItem().setTitle(title).setHelpText(helpText || '');
  };

  // ──────────────────────────────────────────────────────────────
  // SECTION A — Screener & Demographics
  // ──────────────────────────────────────────────────────────────
  page('Section A — About you',
    'A few quick questions to make sure this survey is relevant to you.');

  mc('1. What is your age?',
    ['Under 25', '25–34', '35–44', '45–54', '55–64', '65+']);

  text('2. In which country / region do you live?');

  mc('3. Annual household income in USD (or local equivalent):',
    ['Under $50K', '$50–$99K', '$100–$149K', '$150–$249K', '$250K+', 'Prefer not to say']);

  cb('4. Do you currently own, or have you owned in the last 12 months, any of the following?',
    ['Oura Ring', 'Whoop', 'Apple Watch', 'Garmin', 'Fitbit', 'Eight Sleep',
     'Levels', 'Dexcom Stelo or other CGM', 'Lumen', 'Hone Health', 'None of the above']);

  cb('5. Have you considered buying but not yet purchased any of the above?',
    ['Oura Ring', 'Whoop', 'Apple Watch', 'Garmin', 'Fitbit', 'Eight Sleep',
     'Levels', 'Dexcom Stelo or other CGM', 'Lumen', 'Hone Health', 'None of the above'],
    false);

  mc('6. Gender',
    ['Female', 'Male', 'Non-binary', 'Prefer to self-describe', 'Prefer not to say']);

  mc('7. Which best describes you?',
    ['Biohacker / optimizer',
     'Athlete (recreational or competitive)',
     'Managing a specific health condition',
     'Professional in a high-stress job',
     'Shift worker (nights or rotating)',
     'Caring for aging parent(s) or child with chronic condition',
     'None of the above']);

  // ──────────────────────────────────────────────────────────────
  // SECTION B — Current tracking behavior
  // ──────────────────────────────────────────────────────────────
  page('Section B — How you track your health', '');

  mc('8. Roughly how much do you spend per year on health wearables, apps, supplements, and lab testing combined?',
    ['< $200', '$200–$499', '$500–$999', '$1,000–$2,499', '$2,500–$4,999', '$5,000+']);

  mc('9. How often do you open a health-tracking app?',
    ['Daily', 'A few times a week', 'Weekly', 'Occasionally', 'Rarely']);

  cb('10. Which metrics do you currently track?',
    ['Sleep stages', 'HRV', 'Resting HR', 'Steps', 'Workouts', 'Glucose', 'Body temp',
     'Menstrual cycle', 'Blood pressure', 'Weight', 'Body composition', 'Blood labs',
     'Hormone panels', 'Other']);

  mc('11. Have you ever taken an at-home hormone test (cortisol, testosterone, thyroid, estrogen/progesterone)?',
    ['Yes', 'No', 'Unsure']);

  scale("12. If yes to Q11, how satisfied were you with the insights? (Leave blank if you haven't taken one)",
    1, 5, 'Not at all', 'Extremely', false);

  // ──────────────────────────────────────────────────────────────
  // SECTION C — Cortisol awareness & beliefs
  // ──────────────────────────────────────────────────────────────
  page('Section C — Cortisol and stress',
    'Some background about stress and the cortisol hormone.');

  scale('13. On a 1–10 scale, how would you rate your average stress level over the last 30 days?',
    1, 10, 'Very low', 'Extreme');

  mc('14. Do you believe your stress levels are negatively affecting your health right now?',
    ['Yes', 'No', 'Unsure']);

  cb('15. Which of the following have you personally experienced in the last 12 months that you attribute to stress?',
    ['Poor sleep', 'Weight gain', 'Weight loss', 'Burnout', 'Fatigue not relieved by rest',
     'Brain fog', 'Getting sick more often', 'Mood changes', 'Missed periods or cycle irregularity',
     'Flare of an existing condition', 'None of the above']);

  mc('16. How familiar are you with the role of cortisol in the body?',
    ['Never heard of it', 'Heard the term', 'Know the basics',
     'Actively interested', 'Already manage it']);

  para('17. In your own words, what does cortisol do?');

  mc('18. Have you ever discussed cortisol with a healthcare provider?', ['Yes', 'No']);

  mc('19a. Have you ever tried to measure your own cortisol (any method)?', ['Yes', 'No']);
  para('19b. If yes — how did you measure it, and were the results actionable? (optional)', false);

  scale('20. How much do you agree: "I\'d like to know my cortisol levels on a regular basis."',
    1, 7, 'Strongly disagree', 'Strongly agree');

  cb('21. Which of these would motivate you to start measuring cortisol?',
    ['Better sleep', 'Workout recovery', 'Weight management',
     'Menstrual or perimenopause support', 'Fertility', 'Mental health',
     'Longevity', 'Specific diagnosed condition',
     'Curiosity — none of the above specifically']);

  // ──────────────────────────────────────────────────────────────
  // SECTION D — Current tools & unmet need
  // ──────────────────────────────────────────────────────────────
  page('Section D — Current tools', '');

  scale('22. How well do your current tools answer the question "is my stress actually harming my body?"',
    1, 5, 'Not at all', 'Completely');

  scale('23. When your wearable shows a "stress score" or "recovery score," how much do you trust it?',
    1, 5, 'Not at all', 'Completely');

  mc("24. How often have you felt your wearable's stress/recovery score disagrees with how you actually feel?",
    ['Never', 'Rarely', 'Sometimes', 'Often', 'Always']);

  para('25. If you could measure one additional biomarker continuously, what would it be?');

  grid('26. On a 1–5 scale, how frustrating are each of the following? (1 = not at all, 5 = extremely)',
    ['Having to go to a clinic for a blood draw',
     'Mailing a saliva kit and waiting 1–2 weeks for results',
     'Getting only a single-point-in-time reading',
     'Not knowing if your stress-management changes are working',
     "Your wearable's stress/recovery score not explaining why"],
    ['1', '2', '3', '4', '5']);

  // ──────────────────────────────────────────────────────────────
  // SECTION E — Persona self-identification
  // ──────────────────────────────────────────────────────────────
  page('Section E — Does any of this describe you?',
    "Rate each statement. Low scores are as useful as high scores — don't overthink it.");

  grid('27. How strongly does each statement describe you in the last 12 months? (1 = not at all, 5 = exactly me)',
    ["1. \"I've been gaining weight and no one can tell me why.\"",
     "2. \"I'm exhausted no matter how much I rest.\"",
     "3. \"I'm currently tapering or have recently tapered off corticosteroids (prednisone, hydrocortisone, etc.).\"",
     "4. \"I feel like I'm running on empty and burning out.\"",
     "5. \"I'm actively working on my mental health but can't tell if what I'm doing is working.\"",
     "6. \"I work nights or rotating shifts and feel like my body never adjusts.\"",
     "7. \"I have been diagnosed with Cushing's, Addison's, CAH, or another adrenal disorder — or a family member has.\""],
    ['1', '2', '3', '4', '5']);

  mc('28. For any of the above you rated 4 or 5, which single one is the most important to you personally?',
    ['Weight (statement 1)', 'Fatigue (statement 2)', 'Steroid taper (statement 3)',
     'Burnout (statement 4)', 'Mental health (statement 5)',
     'Shift work (statement 6)', 'Rare/diagnosed endocrine (statement 7)',
     'None apply strongly'],
    false);

  cb('29. Have you, or a family member, been diagnosed with any of the following?',
    ["Cushing's syndrome", "Addison's disease", 'CAH (classic or non-classic)',
     'Chronic adrenal insufficiency', 'Depression with treatment history', 'PTSD',
     'Generalized anxiety', "Hashimoto's", 'Long COVID', 'None of the above']);

  header('Follow-up questions (optional)',
    'If you matched any of statements 3, 6, or 7 above, please answer the relevant follow-ups. Otherwise leave blank.');

  mc('30. (Steroid taper only) How long is your current or planned taper?',
    ['Less than 1 month', '1–3 months', '3–6 months', '6–12 months', 'More than 12 months'],
    false);

  scale('31. (Steroid taper only) Would a home device that showed your natural cortisol returning as you taper be valuable?',
    1, 7, 'Not valuable', 'Extremely valuable', false);

  mc('32. (Shift work only) How many years of shift work?',
    ['< 1', '1–3', '3–5', '5–10', '10+'], false);

  para('33. (Diagnosed endocrine only) What does your current monitoring routine look like?', false);

  // ──────────────────────────────────────────────────────────────
  // SECTION F — Concept exposure
  // ──────────────────────────────────────────────────────────────
  page('Section F — CortiPod concept',
    'Please read the description below carefully before answering the next questions.\n\n' +
    "CortiPod is a wrist-worn wearable that measures cortisol — your body's primary stress hormone — directly from sweat, every 15 minutes, all day long. " +
    'Today, the only way to measure cortisol is a blood draw, a mailed saliva kit, or a 24-hour urine jug. ' +
    'All of them give you one number from one moment. Cortisol disorders — and chronic stress — are pattern disorders. ' +
    'You need the curve, not the snapshot. No other consumer device measures cortisol. ' +
    'Every "stress score" on the market today is a guess based on heart rate. CortiPod is the actual hormone. ' +
    'The invisible hormone, made visible.');

  scale('34. How clear was the product concept?', 1, 5, 'Very unclear', 'Very clear');
  scale('35. How interesting is this product to you?', 1, 7, 'Not at all', 'Extremely');
  scale("36. How new or different is this compared to products you've seen?",
    1, 5, 'Not new at all', 'Completely new');
  scale('37. How believable is the claim that a wrist-worn device can measure cortisol from sweat?',
    1, 5, 'Not believable', 'Completely believable');
  para('38. What specifically makes the claim more or less believable to you?');

  grid('39. Rank these pitch phrases from most to least resonant. Enter a rank 1–6 (1 = most resonant).',
    ['"The invisible hormone, made visible"',
     '"Your body has been telling you something. CortiPod lets you hear it."',
     '"Direct measurement, not a proxy"',
     '"A curve, not a snapshot"',
     '"On your wrist, not in a lab"',
     '"The first wrist-worn device that measures cortisol directly"'],
    ['1', '2', '3', '4', '5', '6'])
    .setValidation(FormApp.createGridValidation().requireLimitOneResponsePerColumn().build());

  para('40. In one sentence, who do you think this product is for?');

  cb('41. What would prove to you this actually works?',
    ['FDA clearance', 'Peer-reviewed study', 'Doctor endorsement (Huberman, Attia, etc.)',
     'Hospital study', 'Customer reviews', 'Money-back guarantee', 'Free trial',
     'Comparison against a lab test', 'Nothing would convince me']);

  // ──────────────────────────────────────────────────────────────
  // SECTION G — Pattern vs snapshot
  // ──────────────────────────────────────────────────────────────
  page('Section G — Pattern vs snapshot', '');

  mc('42. Two imaginary products, same price. Which would you buy?',
    ['A: A single very accurate cortisol lab test, once per month',
     'B: A wearable that measures cortisol every 15 minutes, accurate to ±15%',
     'No preference / Need more info']);

  scale('43. How much do you agree: "A curve across the whole day tells me more than a single number."',
    1, 7, 'Strongly disagree', 'Strongly agree');

  mc('44. Given a choice of readings over a single day, which is most valuable?',
    ['1 reading at 8 AM',
     '3 readings at 8 AM, 2 PM, 10 PM',
     '6 readings every 4 hours',
     '96 readings every 15 minutes',
     'Continuous (every minute)']);

  mc('45. Would you pay more for a version that sampled every 5 minutes vs. every 15 minutes?',
    ['Yes significantly', 'Yes a little', 'No', 'Less — slower is fine']);

  // ──────────────────────────────────────────────────────────────
  // SECTION H — Proxy vs direct
  // ──────────────────────────────────────────────────────────────
  page('Section H — Direct measurement vs. stress scores', '');

  scale('46. Today most wearables estimate stress from heart rate variability (HRV). How much do you trust HRV as a stress measure?',
    1, 5, 'Not at all', 'Completely');

  mc('47. At the same price, which would you prefer?',
    ['A device that directly measures the cortisol hormone',
     'A device that infers stress from HRV and other vitals',
     'No preference']);

  mc('48. How much more would you pay for direct cortisol measurement vs. an HRV-based stress score?',
    ['Nothing extra', 'Up to $50 more', '$50–$100 more', '$100–$200 more', '$200+ more']);

  mc('49. If you already own an Oura, Whoop, Apple Watch, or Garmin, would CortiPod:',
    ['Replace it', 'Be worn alongside it',
     "I'd wait until my current one integrates cortisol",
     'Not interested regardless',
     "I don't own any of those"]);

  para('50. What would have to be true for you to wear CortiPod instead of (not alongside) your current wearable?',
    false);

  mc('51. If Apple, Whoop, or Oura announced cortisol measurement 12 months from now, would you:',
    ['Still buy CortiPod now', 'Wait for the incumbent', 'Depends on price',
     'Depends on accuracy', 'Already committed to CortiPod']);

  // ──────────────────────────────────────────────────────────────
  // SECTION I — Form factor, cadence, wear
  // ──────────────────────────────────────────────────────────────
  page('Section I — Form factor and wear', '');

  mc('52. Preferred wear location:',
    ['Wrist', 'Upper arm (Dexcom-style patch)', 'Chest', 'Behind-ear patch', 'Ring', 'No preference']);

  mc('53. If wrist were not available, which would you choose?',
    ['Upper-arm patch', 'Chest patch', 'Ring', 'Would not buy']);

  mc('54. Preferred form:',
    ['Watch-style band', 'Discreet patch', 'Ring', 'Clip-on', 'No preference']);

  mc('55. Would you wear it 24/7 including sleep?',
    ['Yes', 'Only at night', 'Only during the day', 'Intermittently']);

  mc('56. Maximum acceptable sensor swap frequency:',
    ['Daily', 'Every 2–3 days', 'Weekly', 'Every 2 weeks', 'Monthly']);

  mc('57. Minimum acceptable battery life between charges:',
    ['1 day', '3 days', '7 days', '14 days', '30 days']);

  mc('58. Color / finish preference:',
    ['Black', 'White', 'Silver', 'Rose gold', 'Titanium', "Don't care"]);

  mc('59. Water exposure expectation:',
    ['Shower only', 'Swim (pool)', 'Swim (ocean)', 'Sauna', 'None of the above']);

  mc('60. How visible would you be comfortable with the device being?',
    ['Invisible', 'Subtle', 'Visible is fine', 'Show it off']);

  mc('61. (Shift workers only) Would you wear it during sleep regardless of your schedule?',
    ['Yes', 'Only during "night"', "Only if it doesn't affect comfort", 'No'],
    false);

  // ──────────────────────────────────────────────────────────────
  // SECTION J — Clinical companion (router → consumer / clinician)
  // ──────────────────────────────────────────────────────────────
  page('Section J — Clinical context',
    "The next set of questions splits depending on whether you're a healthcare professional.");

  const routerItem = form.addMultipleChoiceItem()
    .setTitle('J. Are you a healthcare professional (doctor, NP, PA, nurse, therapist, coach, etc.)?')
    .setRequired(true);

  // J.1 — Consumer branch
  const j1Page = page('Section J.1 — Consumer questions',
    "How you'd use cortisol data in real life.");

  mc('62. Would you share your CortiPod data with your primary care doctor?',
    ['Yes', 'Maybe', 'No']);

  mc('63. Would you share it with a specialist (endocrinologist, psychiatrist, rheumatologist)?',
    ['Yes', 'Maybe', 'No']);

  scale('64. If CortiPod flagged a pattern suggesting "see a doctor," how likely would you be to schedule a visit?',
    1, 7, 'Very unlikely', 'Very likely');

  mc('65. If your clinician refused to look at the data, would you still buy the product?',
    ['Yes', 'Yes but disappointed', 'No']);

  mc('66. Would the product be more valuable to you if it came with a shareable PDF/clinical report?',
    ['Yes', 'No', 'Indifferent']);

  mc("67. Would prescription-gated cartridges (requiring a doctor's Rx) be a dealbreaker?",
    ['Yes, dealbreaker', 'No', 'Actually prefer it (signals legitimacy)']);

  // J.2 — Clinician branch
  const j2Page = page('Section J.2 — Clinician questions',
    'Thank you for helping us understand the clinical side.');

  mc('68. What is your specialty?',
    ['Endocrinology', 'Primary care', 'Psychiatry', 'Sleep medicine',
     'Functional / integrative', 'Rheumatology', 'Pediatrics', 'Other']);

  mc('69. How often do you order cortisol tests per month?',
    ['0', '1–5', '6–20', '21+']);

  scale("70. Would a continuous cortisol curve from a patient's wearable change how you work up suspected adrenal disorders?",
    1, 7, 'Not at all', 'Significantly');

  para('71. What accuracy standard would you require to act on the data clinically?');

  cb('72. Would you recommend CortiPod to a patient for:',
    ["Suspected Cushing's", "Suspected Addison's", 'CAH pediatric dosing',
     'Steroid taper monitoring', 'Depression/PTSD companion',
     'Burnout/stress coaching', 'None of these']);

  para('73. What reimbursement path, if any, would be required for you to recommend it?');

  // ──────────────────────────────────────────────────────────────
  // SECTION K — Feature prioritization
  // ──────────────────────────────────────────────────────────────
  const kPage = page('Section K — Feature priorities', '');

  // Now wire up routing for Section J.
  //   - routerItem "No"  → J.1 page
  //   - routerItem "Yes" → J.2 page (skipping J.1)
  //   - after J.1 items → jump to K (skipping J.2)
  //   - after J.2 items → fall through naturally to K
  routerItem.setChoices([
    routerItem.createChoice("No — I'm a consumer", j1Page),
    routerItem.createChoice("Yes — I'm a healthcare professional", j2Page)
  ]);
  j1Page.setGoToPage(kPage);

  grid('74. Rank features from most to least important. Enter a rank 1–12 (1 = most important).',
    ['Measurement accuracy vs. a lab test',
     'Battery life',
     'Sensor cartridge lifespan (days between swaps)',
     'App insights and coaching',
     'Integration with existing apps (Apple Health, Whoop, Oura)',
     'Comfort / thinness of the device',
     'Waterproofing (shower, swim)',
     'Sleep tracking built in',
     'HRV / heart rate built in',
     'Additional hormones beyond cortisol (testosterone, estradiol, progesterone)',
     'Shareable clinical report',
     'FDA clearance'],
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'])
    .setValidation(FormApp.createGridValidation().requireLimitOneResponsePerColumn().build());

  cb('75. Which of these is a dealbreaker — you would not buy without it?',
    ['Measurement accuracy vs. a lab test', 'Battery life',
     'Sensor cartridge lifespan', 'App insights and coaching',
     'Integration with existing apps', 'Comfort / thinness',
     'Waterproofing', 'Sleep tracking built in',
     'HRV / heart rate built in', 'Additional hormones',
     'Shareable clinical report', 'FDA clearance', 'None of the above']);

  mc('76. If we added a second hormone at extra cost per cartridge, which would you pay most for?',
    ['Testosterone', 'Estradiol', 'Progesterone', 'DHEA', 'Melatonin',
     'Not interested in a second hormone']);

  // ──────────────────────────────────────────────────────────────
  // SECTION L — Starter kit pricing (Van Westendorp + Gabor-Granger)
  // ──────────────────────────────────────────────────────────────
  page('Section L — What would you pay? (Starter kit)',
    'The starter kit = the wearable device + charging cradle + the first set of sensor cartridges (about 3 weeks of use). ' +
    'Please answer all prices in USD.');

  numeric('77. At what price would the starter kit be SO EXPENSIVE that you would not consider buying it? (USD)');
  numeric('78. At what price would the starter kit be STARTING TO GET EXPENSIVE, but still worth considering? (USD)');
  numeric('79. At what price would the starter kit be A BARGAIN — a great buy for the money? (USD)');
  numeric('80. At what price would the starter kit be SO CHEAP that you would question the quality? (USD)');

  scale('81. At $199, how likely are you to buy?', 1, 5, 'Definitely not', 'Definitely would');
  scale('82. At $299, how likely are you to buy?', 1, 5, 'Definitely not', 'Definitely would');
  scale('83. At $399, how likely are you to buy?', 1, 5, 'Definitely not', 'Definitely would');
  scale('84. At $499, how likely are you to buy?', 1, 5, 'Definitely not', 'Definitely would');

  mc('85. If HRV-based Whoop is "free device + $30/mo" and Oura is "$349 + $6/mo", how much more would you pay up-front for direct cortisol measurement?',
    ['Same as Oura', '+$100 more', '+$200 more', '+$300 more', '+$400 more',
     'I would pay less than Oura']);

  para('86. Which of these have you bought, and for how much? (Oura, Whoop, Apple Watch, Dexcom Stelo, Hone Health, Lumen, etc.)',
    false);

  // ──────────────────────────────────────────────────────────────
  // SECTION M — Cartridge pricing
  // ──────────────────────────────────────────────────────────────
  page('Section M — What would you pay? (Sensor cartridges)',
    'A sensor cartridge lasts about 7 days. Typical users replace it weekly. The questions below ask about a MONTHLY cartridge supply (about 4 cartridges).');

  numeric('87. Monthly cartridge cost — TOO EXPENSIVE to buy? (USD)');
  numeric('88. Monthly cartridge cost — GETTING EXPENSIVE but worth considering? (USD)');
  numeric('89. Monthly cartridge cost — A BARGAIN? (USD)');
  numeric("90. Monthly cartridge cost — SO CHEAP you'd question quality? (USD)");

  mc('91. Would you subscribe at $19/month?', ['Yes', 'No', 'Maybe']);
  mc('92. Would you subscribe at $29/month?', ['Yes', 'No', 'Maybe']);
  mc('93. Would you subscribe at $39/month?', ['Yes', 'No', 'Maybe']);
  mc('94. Would you subscribe at $49/month?', ['Yes', 'No', 'Maybe']);
  mc('95. Would you subscribe at $69/month?', ['Yes', 'No', 'Maybe']);

  mc("96. Maximum you'd pay for a SINGLE replacement cartridge (non-subscription)?",
    ['$5', '$10', '$15', '$20', '$25', '$30+', 'Would only buy via subscription']);

  numeric('97. Total annual willingness-to-pay (device amortization + cartridges), in USD');

  // ──────────────────────────────────────────────────────────────
  // SECTION N — Subscription vs one-time
  // ──────────────────────────────────────────────────────────────
  page("Section N — How you'd want to buy it", '');

  mc('98. Preferred purchase model:',
    ['Buy device outright, buy cartridges as needed (à la carte)',
     'Buy device outright, subscribe to monthly cartridge delivery',
     'Whoop-style: free or cheap device, mandatory monthly subscription includes cartridges',
     'Rent device monthly, cartridges included']);

  mc('99. Acceptable minimum subscription commitment:',
    ['No commitment', '3 months', '6 months', '12 months']);

  numeric('100. If Whoop-style (device included), how much would you pay per month? (USD)');

  mc('101. Would you pay a one-time $50–$100 premium to avoid a subscription entirely?',
    ['Yes', 'No', 'Maybe']);

  mc('102. Would insurance / HSA / FSA eligibility change your purchase decision?',
    ['Yes significantly', 'Yes slightly', 'No']);

  mc('103. If you identified as clinical-adjacent (steroid taper or diagnosed endocrine disorder), would you prefer a clinical channel (specialist-prescribed, possibly insurance-covered) over retail?',
    ['Yes', 'No', 'Either is fine', 'Does not apply to me'],
    false);

  // ──────────────────────────────────────────────────────────────
  // SECTION O — Purchase intent, channels, competitive wait
  // ──────────────────────────────────────────────────────────────
  page('Section O — Would you actually buy?', '');

  scale('104. If available today at your preferred price, how likely are you to buy within 3 months?',
    1, 7, 'Very unlikely', 'Very likely');

  scale('105. If only available as a pre-order shipping in 6 months, how likely are you to commit?',
    1, 7, 'Very unlikely', 'Very likely');

  mc('106. Preferred place to buy:',
    ['Brand website (DTC)', 'Amazon', 'Apple Store', 'Best Buy', 'CVS', 'Walgreens',
     'Costco', "Doctor's office", 'Through employer wellness program']);

  mc('107. Would you buy it for someone else as a gift?', ['Yes', 'Maybe', 'No']);

  scale('108. How likely are you to recommend CortiPod to a friend if you liked it? (0–10)',
    0, 10, 'Not at all likely', 'Extremely likely');

  cb('109. Which of these would make you more confident buying?',
    ['FDA clearance', 'Published peer-reviewed study',
     'Endorsement by a recognizable doctor/researcher (Huberman, Attia, etc.)',
     'Reviews on Amazon / Reddit', 'Money-back guarantee',
     'Free trial period', 'Seeing it in a retail store',
     'Corporate wellness / insurance coverage',
     'Recommendation from my own doctor']);

  mc('110. Who do you expect will solve continuous cortisol measurement first?',
    ['A startup', 'Apple', 'Oura', 'Whoop', 'Dexcom or Abbott',
     'No one in the next 3 years', 'No opinion']);

  // ──────────────────────────────────────────────────────────────
  // SECTION P — Data, privacy, integrations
  // ──────────────────────────────────────────────────────────────
  page('Section P — Data, privacy, and integrations', '');

  grid('111. How important is integration with the following? (1 = not important, 5 = very important)',
    ['Apple Health', 'Google Fit', 'Oura', 'Whoop', 'Garmin', 'Strava',
     'MyFitnessPal', 'Levels', 'Hone', 'Function Health'],
    ['1', '2', '3', '4', '5']);

  mc('112. Would you consent to your anonymized data being used for research?',
    ['Yes', 'No', 'Only if paid']);

  mc('113. How comfortable are you with cloud data storage?',
    ['Fully comfortable', 'Comfortable with encryption', 'Only local on device', 'Unsure']);

  mc('114. Would an AI-coaching feature (cortisol-aware recommendations) increase your willingness to pay?',
    ['Yes', 'No', 'Depends on price']);

  para('115. Which third-party service, if connected, would make this product significantly more valuable to you?',
    false);

  // ──────────────────────────────────────────────────────────────
  // SECTION Q — Qualitative
  // ──────────────────────────────────────────────────────────────
  page('Section Q — Last few questions',
    'These are open-ended. Short answers are fine. Thank you for making it this far!');

  para('116. What concerns, if any, do you have about this product?', false);
  para('117. What would have to be true for you to buy it tomorrow?', false);
  para('118. Who do you think of as our biggest competitor?', false);
  para('119. What should we absolutely NOT do with this product?', false);
  para('120. In your own words, re-state what CortiPod does.', false);
  text('121. Email address for early access / follow-up interview (optional)', false);

  // ──────────────────────────────────────────────────────────────
  // Finalize and log URLs
  // ──────────────────────────────────────────────────────────────
  const editUrl = form.getEditUrl();
  const publishedUrl = form.getPublishedUrl();
  const fileId = form.getId();

  Logger.log('════════════════════════════════════════════════════════════');
  Logger.log('CortiPod Pre-Market Survey — form created.');
  Logger.log('Form ID:       ' + fileId);
  Logger.log('Edit URL:      ' + editUrl);
  Logger.log('Published URL: ' + publishedUrl);
  Logger.log('════════════════════════════════════════════════════════════');
  Logger.log('Next: open the edit URL, review, then click Send to distribute.');

  return { id: fileId, edit: editUrl, published: publishedUrl };
}
