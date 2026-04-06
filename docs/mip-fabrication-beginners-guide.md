# MIP Sensor Fabrication — Complete Beginner's Guide

> This guide assumes you have never worked in a chemistry lab. Every step is explained as if you're doing it for the first time. Nothing is skipped.

---

## Table of Contents

1. [What You're Actually Doing (Plain English)](#what-youre-doing)
2. [Shopping List (Exactly What to Buy, With Links)](#shopping-list)
3. [Setting Up Your Workspace](#workspace-setup)
4. [Safety](#safety)
5. [Day 1: Preparing Your Solutions](#day-1)
6. [Day 2: Making the Sensor (Pyrrole MIP + NIP)](#day-2)
7. [Day 2 Alternative: Making oPD-Based MIP Sensors](#day-2-alternative-making-opd-based-mip-sensors)
8. [Day 3: Testing If It Worked](#day-3)
9. [Troubleshooting](#troubleshooting)
10. [Storage and Shelf Life](#storage)
11. [Glossary](#glossary)

---

## What You're Actually Doing

Here's the whole process in plain English, no jargon:

You're going to take a small plastic strip with metal pads on it (the electrode). You're going to coat one of those metal pads with a thin layer of plastic that has cortisol-shaped holes in it. When cortisol from your sweat lands on that surface, the molecules fall into those holes like puzzle pieces. Your electronics can detect when the holes are filled because it changes how electricity flows through the surface.

That's it. The "MIP" is just plastic with specially shaped holes.

**The three-step process:**

```
Step 1: COAT
  Take the electrode strip
  Dip it in a solution of plastic-making liquid + cortisol
  Run electricity through it
  → A thin plastic film forms on the metal pad, 
    with cortisol molecules trapped inside

Step 2: WASH
  Soak the coated electrode in a cleaning solution
  → The cortisol molecules dissolve and wash away
  → The plastic film stays, but now has empty holes 
    where the cortisol used to be

Step 3: TEST
  Drop a known amount of cortisol onto the sensor
  Measure the electrical signal
  → If the signal changes, the holes are catching cortisol
  → Your sensor works!
```

The entire hands-on time is about 3-4 hours spread over 2-3 days (with waiting time in between).

---

## Shopping List

### Where to buy everything

I've organized this into three orders so you're not dealing with 10 different suppliers.

---

### Order 1: Amazon.ca (~$100-170 CAD, arrives in 1-2 days)

These are common items. All links go to Amazon.ca (Canada).

| Item | Link | Approx. price (CAD) | Why you need it |
|------|------|---------------------|-----------------|
| Micropipette set (0.5-10, 10-100, 100-1000 µL) + tips | [Huwazine Kit on Amazon.ca](https://www.amazon.ca/dp/B0B8165PTL) — includes 3 pipettes, stand, 288 tips | ~$170 | Precision liquid handling — the single most important tool for consistent MIP fabrication |
| Disposable transfer pipettes, graduated, 3 mL | [Search Amazon.ca](https://www.amazon.ca/graduated-pipette/s?k=graduated+pipette) | ~$10 for 100 | Backup for rough volume transfers. The micropipettes above handle the critical measurements. |
| Nitrile gloves, medium (or your size) | [Kirkland 200-pack on Amazon.ca](https://www.amazon.ca/Kirkland-Signature-Nitrile-Gloves-Medium/dp/B08TQRC3F6) | ~$18 for 200 | Protects your hands from chemicals and keeps oils off the electrodes |
| Small glass vials with lids, 20 mL | [Search Amazon.ca](https://www.amazon.ca/s?k=glass+vials+20ml+screw+cap) | ~$15 for 20 | To hold your solutions. Glass won't react with the chemicals. |
| Distilled water, 4 L | Any grocery store or pharmacy (e.g., Shoppers Drug Mart) | ~$3 | Pure water for rinsing. Do NOT use tap water — minerals in tap water interfere with the sensor. |
| Plastic tweezers (non-metallic) | [Search Amazon.ca](https://www.amazon.ca/s?k=plastic+tweezers) | ~$8 | To handle electrodes without scratching them or introducing metal contamination |
| Small plastic container with lid | Any dollar store | ~$2 | For the wash step (soaking the electrode) |
| Permanent marker (fine tip) | You probably have one | — | To label your vials |
| Paper towels | You probably have these | — | For drying |
| Timer (or use your phone) | — | — | For timing the steps |
| Aluminum foil | You probably have this | — | To cover solutions and protect from light |
| Small fan or just a spot with good airflow | — | — | For drying electrodes |

**Optional but helpful:**

| Item | Link | Approx. price (CAD) | Why |
|------|------|---------------------|-----|
| Jeweler's loupe or magnifying glass (10x) | [Search Amazon.ca](https://www.amazon.ca/s?k=jewelers+loupe+10x) | ~$10 | To see the thin film on the electrode — helpful for knowing if the coating step worked |
| Plastic wrap (cling film) | You probably have this | — | To cover vials during incubation |

---

### Order 2: DigiKey Canada (~$330 CAD, arrives in 2-5 days)

The potentiostat is the instrument that runs electricity through the electrode. You need this for both fabrication AND for the final device. DigiKey Canada ships free on orders over $100 CAD.

| Item | Where | Link | Price (CAD) |
|------|-------|------|-------------|
| AD5941 evaluation board | DigiKey Canada | [EVAL-AD5941BATZ on DigiKey.ca](https://www.digikey.ca/en/products/detail/analog-devices-inc/EVAL-AD5941BATZ/10820316) | ~$319 |
| Alligator clip test leads | Amazon.ca | [Search Amazon.ca](https://www.amazon.ca/s?k=alligator+clip+test+leads) | ~$8 |
| USB Micro-B cable | Amazon.ca | [Search Amazon.ca](https://www.amazon.ca/s?k=USB+micro+B+cable) | ~$7 (if you don't have one) |

> **Why the eval board?** This is your potentiostat — the machine that does the electrochemistry. It comes with software you can run on your computer to control it. You'll use it to: (1) coat the electrode with the MIP, (2) wash verification, and (3) test the sensor. Later, the AD5941 chip goes into the wearable device itself.

---

### Order 3: Specialty chemicals + electrodes (~$250-400 CAD, arrives in 3-10 days)

These are the science-specific items. They sound intimidating but they're just liquids and powders.

**Electrodes:**

| Option | Product | Where to buy | Price | Easiest? |
|--------|---------|-------------|-------|----------|
| **Option A (easiest)** | Pre-made gold electrodes, DropSens DRP-220AT (gold WE + gold CE + silver REF on ceramic) | [Metrohm DropSens DRP-220AT](https://metrohm-dropsens.com/products/electrodes/screen-printed-electrodes/screen-printed-gold-electrode-high-temperature-ink-220at/) (request a quote, ask for smallest pack — standard is 75 units) | ~$7-12 CAD each | Yes — ready to use out of the box |
| **Option B (cheaper)** | Carbon electrodes, Zensor TE100 (pack of 40) | [eDAQ ET077-40](https://www.edaq.com/ET077-40) | ~$115 CAD for 40 | No — requires an extra gold-coating step |

**How many to buy:** Get at least 15 DRP-220AT electrodes. You'll make 4 sets: pyrrole MIP, pyrrole NIP, oPD MIP, and oPD NIP — and you'll need spares for learning. Failed first attempts are normal; plan for them rather than re-ordering mid-project.

**I strongly recommend Option A for your first attempt.** The gold is already on the electrode. One less thing to worry about. Email DropSens at info@dropsens.com and say:

> "Hi, I'd like to purchase a small quantity of DRP-220AT gold screen-printed electrodes for a research prototype. Could you provide pricing for 15-25 units with shipping to Canada? Thank you."

**Chemicals:**

All Sigma-Aldrich products ship to Canada. Go to [sigmaaldrich.com](https://www.sigmaaldrich.com) and switch to the Canada region (CA) at the top of the page. Prices below are approximate CAD.

| Item | Product number | Buy here | Price (CAD) | What it actually is |
|------|---------------|----------|-------------|---------------------|
| Pyrrole, 100 mL | Cat. 131709 | [Sigma-Aldrich CA](https://www.sigmaaldrich.com/CA/en/product/aldrich/131709) | ~$155 | A yellowish liquid that turns into the plastic coating when you run electricity through it. Smells slightly like ammonia. (Monomer Option 1). 100 mL is the smallest size — makes 1,400+ sensors. |
| o-Phenylenediamine (oPD), 5 g | Cat. P23938 | [Sigma-Aldrich CA](https://www.sigmaaldrich.com/CA/en/product/aldrich/p23938) | ~$35-40 | Off-white powder. A second plastic-making chemical that forms tighter cortisol-shaped cavities than pyrrole, potentially giving better selectivity. (Monomer Option 2) |
| Hydrocortisone, 1 g | Cat. H4001 | [Sigma-Aldrich CA](https://www.sigmaaldrich.com/CA/en/product/sigma/h4001) | ~$50 | Synthetic cortisol. A white powder. This is the same cortisol your body makes. |
| PBS (phosphate buffered saline) | — | [Search Amazon.ca](https://www.amazon.ca/s?k=phosphate+buffered+saline) | ~$15-20 | Salt solution that mimics body fluid pH. Buy the smallest bottle of ready-made 1X PBS liquid, or tablets (each makes 100mL). You only need ~50mL total. |
| Ethanol, denatured, 200 proof, 950 mL | Duda Energy eth950 | [Amazon.ca](https://www.amazon.ca/Duda-Energy-eth950-Denatured-200-Proof/dp/B06Y18DSND) | ~$25-35 | 90% ethanol, denatured. Used for the wash step. Ships directly from Amazon.ca. 950 mL is way more than you need (~50mL used total). |
| Acetic acid (glacial), 100 mL | Cat. A6283 | [Sigma-Aldrich CA](https://www.sigmaaldrich.com/CA/en/product/sigald/a6283) | ~$30 | Concentrated vinegar acid. Used in the wash solution. |

> **Sigma-Aldrich Canada ordering note:** Visit [sigmaaldrich.com](https://www.sigmaaldrich.com) and select **Canada** as your region at the top-right. You may need to create an account. When asked for an institution, you can say "independent research" or "personal research project." Sigma-Aldrich ships to Canadian residential addresses. If you have trouble ordering, try [Fisher Scientific Canada](https://www.fishersci.ca) for the same chemicals.

> **Alternative for ethanol (easiest Canadian option):** Buy **Everclear** (190 proof / 95% ethanol) at your provincial liquor store (LCBO in Ontario, SAQ in Quebec, BCL in BC). It's ~$30-40 CAD for 750 mL. Not as pure as reagent-grade but works perfectly for MIP template wash. This avoids the hassle of ordering lab-grade ethanol, which can have shipping restrictions in Canada.

> **Alternative for acetic acid:** White vinegar from any Canadian grocery store is ~5% acetic acid. Glacial acetic acid is 100%. For the wash solution, grocery store white vinegar will work — just use it straight (undiluted) instead of the 9:1 ethanol:acetic acid ratio. It's less effective but functional for a first attempt. Costs ~$3 at any grocery store.

---

### Total cost summary (CAD)

| Order | Items | Cost (CAD) |
|-------|-------|-----------|
| Amazon.ca | Micropipette kit, gloves, vials, misc | ~$200-230 |
| DigiKey Canada | AD5941 eval board + cables | ~$335 |
| Specialty (Sigma-Aldrich CA, DropSens, Fisher CA) | Electrodes + chemicals (both monomers) | ~$250-400 |
| **Total** | | **~$785-965 CAD** |

> **Budget path:** Use Everclear instead of reagent ethanol (~save $25), white vinegar instead of glacial acetic acid (~save $30), and skip oPD for now (~save $40). Brings total to **~$690-870 CAD**.

---

## Setting Up Your Workspace

You don't need a lab. A clean kitchen counter or desk works fine. Here's how to set it up:

```
YOUR WORKSPACE LAYOUT:

    ┌─────────────────────────────────────────────────────┐
    │                                                       │
    │   [Computer]          [Paper towels]                 │
    │   with AD5941                                         │
    │   software            [Glass vials with solutions]   │
    │                       labeled: "PBS" "PYR" "WASH"    │
    │                                                       │
    │   [AD5941 eval       [Electrode]    [Gloves]         │
    │    board + clips]     on clean       [Pipettes]      │
    │                       paper towel    [Tweezers]       │
    │                                                       │
    │   [Distilled water   [Small container               │
    │    bottle]            for wash step]                  │
    │                                                       │
    └─────────────────────────────────────────────────────┘
```

**Rules for your workspace:**

1. **Clean the surface** with a damp paper towel before starting. Dust and grease are the enemy.
2. **No food or drinks** near your workspace while working with chemicals.
3. **Good ventilation** — open a window or work near a fan. Pyrrole has a mild smell.
4. **Good lighting** — you need to see what you're doing on these small electrodes.
5. **Flat, stable surface** — you don't want to bump the electrode while it's being coated.

---

## Safety

None of these chemicals are particularly dangerous in the small quantities you're using, but basic precautions:

**Always wear:**
- Nitrile gloves (not latex — pyrrole can penetrate latex)
- Regular clothes you don't mind getting a small stain on (pyrrole turns brown/black on contact with air and stains permanently)

**Chemical-specific notes:**

| Chemical | Hazard level | Notes |
|----------|-------------|-------|
| Pyrrole | Low | Mild irritant. Smells like mothballs/ammonia. Turns brown when exposed to air (this is normal — it's oxidizing). Keep the bottle capped when not using it. |
| o-Phenylenediamine (oPD) | Low | Mild irritant — same precautions as pyrrole. Wear gloves and work with ventilation. Avoid creating dust when weighing the powder. |
| Hydrocortisone | Very low | It's literally cortisol. Your body makes this. Safe to handle with gloves. |
| PBS | None | It's salt water. |
| Ethanol | Low | Flammable. Don't use near open flames. |
| Acetic acid (glacial) | Moderate | Strong vinegar smell. Avoid breathing the fumes directly. Can irritate skin — wear gloves. If using grocery store vinegar instead, essentially no hazard. |

**If you spill something:**
- Wipe it up with a paper towel
- Rinse the area with water
- If you get acetic acid on your skin, rinse with lots of water

**Disposal:**
- All solutions can be poured down the sink with running water (the quantities are tiny — milliliters)
- Used electrodes go in regular trash

---

## Day 1: Preparing Your Solutions

**Time needed:** 30 minutes of work + overnight waiting

Today you're going to prepare all the solutions you'll need tomorrow. Making them the day before lets the PBS dissolve completely and lets you verify everything looks right.

### Step 1.1: Make PBS solution

PBS is the "carrier liquid" for everything. It's basically salt water that matches your body's pH.

```
What you need:
  - 1 PBS tablet
  - Distilled water
  - A clean glass vial (20 mL) or a clean glass/cup

Instructions:
  1. Put on your gloves
  2. Drop 1 PBS tablet into the vial
  3. Add distilled water to the 10 mL mark on the vial
     (or about 2 teaspoons if your vial isn't graduated)
  4. Swirl gently until the tablet dissolves
     (this may take 5-10 minutes — swirl occasionally)
  5. The solution should be clear and colorless
  6. Label the vial "PBS" with your marker
  7. Cap it and set aside
```

**What it should look like:** Clear, colorless liquid. If it's cloudy, keep swirling — the tablet isn't fully dissolved yet.

### Step 1.2: Make the wash solution

This is what you'll use to remove the cortisol template from the MIP.

```
What you need:
  - Ethanol (or Everclear)
  - Acetic acid (or white vinegar)
  - A clean glass vial (20 mL)

Instructions:
  IF USING REAGENT-GRADE CHEMICALS:
    1. Using a transfer pipette, add 9 mL of ethanol to the vial
    2. Add 1 mL of acetic acid
       (that's about 20 drops from a transfer pipette)
    3. Swirl gently to mix
    4. Label "WASH 9:1"

  IF USING EVERCLEAR + WHITE VINEGAR:
    1. Add 9 mL of Everclear to the vial
    2. Add 1 mL of white vinegar
    3. Swirl gently
    4. Label "WASH (everclear)"

  IF USING ONLY WHITE VINEGAR (simplest):
    1. Pour about 10 mL of white vinegar into the vial
    2. Label "WASH (vinegar)"
    3. Note: this is less effective but still works
```

**What it should look like:** Clear, colorless liquid with a vinegar smell.

### Step 1.3: Make the cortisol stock solution

You need a concentrated cortisol solution that you'll dilute later for testing.

```
What you need:
  - Hydrocortisone powder (from Sigma)
  - Ethanol (or Everclear)
  - A clean glass vial (20 mL)
  - A transfer pipette

Instructions:
  1. Open the hydrocortisone container
  2. Using the VERY TIP of a dry transfer pipette or a toothpick,
     scoop out a TINY amount of powder — about the size of a 
     single grain of table salt
     
     You're aiming for roughly 1 milligram. An exact amount isn't 
     critical for your first test. The point is: very, very little.
     
  3. Drop it into a clean glass vial
  4. Add 1 mL of ethanol (about 20 drops from a transfer pipette)
  5. Swirl until the powder dissolves (should dissolve easily)
  6. Label "CORTISOL STOCK"
  7. Cap and store at room temperature

  This gives you approximately a 1 mg/mL cortisol stock solution.
```

**What it should look like:** Clear liquid. Hydrocortisone dissolves easily in ethanol.

### Step 1.4: Set up the AD5941 eval board

While your PBS is dissolving, get the electronics ready.

```
1. Unbox the EVAL-AD5941BATZ
2. Connect it to your computer via the USB cable
3. Go to: [github.com/analogdevicesinc/ad5940-examples](https://github.com/analogdevicesinc/ad5940-examples)
   (Note: the repo says "ad5940" but it covers both the AD5940 and AD5941 chips — same code)
4. Download the repository (green "Code" button then "Download ZIP")
5. Unzip it on your computer
6. Follow the README to install the software for your operating system

The eval board comes with a companion app that lets you:
  - Select "Chronoamperometry" or "Cyclic Voltammetry" mode
  - Set voltage and duration parameters
  - See a live graph of the electrical signal
  - Export data

If you get stuck on software setup:
  - Analog Devices has tutorial videos on YouTube
  - Search "AD5941 eval board setup tutorial"
  - The eval board user guide PDF is at:
    [analog.com/EVAL-AD5941](https://www.analog.com/en/resources/evaluation-hardware-and-software/evaluation-boards-kits/EVAL-AD5941.html)
```

### Day 1 done!

You now have:
- [ ] PBS solution (clear, in a labeled vial)
- [ ] Wash solution (clear, in a labeled vial)
- [ ] Cortisol stock solution (clear, in a labeled vial)
- [ ] AD5941 eval board connected to your computer and software working

Set everything aside in a clean, dry spot. Pyrrole stays in its original bottle — you'll open it fresh tomorrow.

---

## Day 2: Making the Sensor

**Time needed:** About 2 hours (with 30 minutes of hands-on work and 90 minutes of waiting)

Today is the main event. You're going to coat the electrode with the MIP.

### Step 2.1: Prepare the MIP coating solution

```
What you need:
  - PBS solution (from yesterday)
  - Pyrrole bottle (still sealed)
  - Cortisol stock solution (from yesterday)
  - A CLEAN glass vial (new, unused)
  - Transfer pipettes

IMPORTANT: Pyrrole oxidizes (goes bad) when exposed to air.
Work quickly once you open the bottle. The liquid should be 
PALE YELLOW or nearly colorless. If it's dark brown or black,
it has oxidized too much and won't work — you'll need fresh pyrrole.

Instructions:
  1. Put on fresh gloves
  2. Transfer 2 mL of PBS into the clean vial
     (use a fresh transfer pipette — about 40 drops)
  
  3. Open the pyrrole bottle
  4. Using a FRESH transfer pipette, add 1 SMALL DROP of pyrrole 
     to the PBS vial
     
     How much is one drop? About 0.015 mL (15 microliters).
     A single drop from a transfer pipette is roughly this amount.
     If you accidentally add 2 drops, that's okay — it's not critical 
     to be exact for a first prototype.
     
  5. IMMEDIATELY re-cap the pyrrole bottle
     (minimize air exposure)
  
  6. Add 2 DROPS of your cortisol stock solution to the same vial
     (this adds cortisol as the template molecule)
  
  7. Gently swirl the vial for 30 seconds to mix everything
  
  8. Label this vial "MIP SOLUTION"
  
  9. Set a timer for 30 MINUTES and leave the vial alone
     (this lets the pyrrole molecules arrange themselves 
     around the cortisol molecules — called "pre-complexation")
     
     Cover the vial with aluminum foil to protect from light.

While waiting: proceed to Step 2.2 (connecting the electrode).
```

**What it should look like:** Slightly yellowish, clear solution. If it turns dark brown immediately, your pyrrole is too oxidized — use fresher pyrrole.

### Step 2.2: Connect the electrode to the AD5941

While the MIP solution is pre-complexing (30 min wait), set up the electronics.

```
Look at your electrode strip. It has three pads:

  ┌─────────────────────────────────┐
  │                                   │
  │    ┌─────┐                       │
  │    │ REF │  ← Reference electrode│
  │    │(Ag) │     (usually silver)  │
  │    └─────┘                       │
  │                                   │
  │    ┌─────┐      ┌─────┐         │
  │    │ WE  │      │ CE  │         │
  │    │(Au) │      │     │         │
  │    └─────┘      └─────┘         │
  │    Working       Counter          │
  │    electrode     electrode        │
  │    (gold)                         │
  └─────────────────────────────────┘
  
  (Your specific electrode may have a different layout — 
   check the datasheet that came with it. The pads are labeled
   WE, CE, and RE or similar.)

Using alligator clips:
  1. Connect the RED clip from the AD5941 eval board to the WE pad
     (WE = Working Electrode — this is where the MIP will form)
     
  2. Connect the BLACK clip to the CE pad
     (CE = Counter Electrode — completes the circuit)
     
  3. Connect the WHITE/GREEN clip to the REF pad
     (REF = Reference Electrode — voltage reference point)

  IMPORTANT: The clips should touch ONLY the metal contact pads 
  at the END of the strip (the connector area), NOT the sensing 
  pads in the middle. Most SPEs have contact pads specifically 
  designed for alligator clips.

  IMPORTANT: Make sure the clips don't touch each other. 
  If two clips short together, the measurement won't work.
```

### Step 2.3: Run the coating (Cyclic Voltammetry)

This is where the MIP actually forms on the electrode. You're going to run electricity through the pyrrole solution, which causes it to polymerize (solidify) onto the gold electrode surface.

```
1. Confirm the 30-minute pre-complexation time is up

2. Place the electrode strip flat on your work surface
   (sensing pads facing UP)

3. Using a transfer pipette, carefully place 3-4 DROPS of 
   MIP solution directly onto the sensing area of the electrode
   
   The liquid should cover all three pads (WE, CE, REF).
   Don't flood it — just enough to form a thin puddle over the pads.
   
   This is about 0.1 mL (100 microliters).

4. On the AD5941 software on your computer, set up 
   Cyclic Voltammetry (CV) with these settings:

   ┌──────────────────────────────────┐
   │  MODE: Cyclic Voltammetry        │
   │                                    │
   │  Start potential:   -200 mV       │
   │  End potential:     +800 mV       │
   │  Scan rate:          50 mV/s      │
   │  Number of cycles:   10           │
   │                                    │
   │  (If asked for "step size": 5 mV) │
   └──────────────────────────────────┘

5. Click START (or RUN)

6. WATCH THE SCREEN
   
   You should see a graph that looks like a loop or figure-eight 
   shape. With each cycle, the loop should get SLIGHTLY BIGGER.
   This is normal — it means the polypyrrole film is getting 
   thicker with each cycle.
   
   What this looks like:
   
   Current (µA)
       ^
       |    ╭──╮
       |   ╭┤  ├╮        Cycle 1 (small loop)
       |  ╭┤│  │├╮       Cycle 5 (medium loop)
       | ╭┤││  ││├╮      Cycle 10 (largest loop)
       ──┼─┼┼──┼┼─┼──→ Voltage (mV)
       | ╰┤││  ││├╯   -200        +800
       |  ╰┤│  │├╯
       |   ╰┤  ├╯
       |    ╰──╯
   
   Each run takes about 30 seconds per cycle × 10 cycles = 
   roughly 5 minutes total.
   
   IF THE GRAPH IS FLAT (no loops): 
     Something is wrong — check your clip connections.
   
   IF THE CURRENT IS HUGE (off-scale):
     Clips may be touching each other. Separate them.

7. When all 10 cycles are done, the software will stop automatically.

8. DO NOT MOVE THE ELECTRODE YET — proceed immediately to the Overoxidation step below.
```

**What just happened:** Electricity flowed through the pyrrole solution, causing pyrrole molecules to link together into a polymer chain (polypyrrole) that deposited on the gold surface. The cortisol molecules got trapped inside this polymer film as it formed. You now have a gold electrode coated with a thin dark film of polypyrrole + cortisol.

### Step 2.3a: Overoxidation (do this immediately after CV coating, before rinsing)

This step makes the polymer more rigid, improving selectivity by 30-50%. Do it while the electrode is still wet with the MIP solution — do NOT rinse first.

```
WITHOUT removing the solution from the electrode:

1. On the AD5941 software, set up ONE additional CV cycle 
   with a slightly higher upper voltage:

   ┌──────────────────────────────────┐
   │  MODE: Cyclic Voltammetry        │
   │                                    │
   │  Start potential:   -200 mV       │
   │  End potential:     +1100 mV      │  ← higher than the +800 mV above
   │  Scan rate:          50 mV/s      │
   │  Number of cycles:   1            │  ← just ONE cycle
   │                                    │
   └──────────────────────────────────┘

2. Click START

3. This takes about 26 seconds.

4. When done, DO NOT MOVE THE ELECTRODE YET — proceed to Step 2.4 (rinse).
```

**What just happened:** The brief excursion to +1100 mV slightly oxidizes the outer surface of the polypyrrole film. This "overoxidation" makes the polymer chains cross-link more tightly, resulting in stiffer, better-defined cavities. The trade-off (minimal loss of current) is worth the 30-50% improvement in selectivity — fewer false positives from non-cortisol molecules. This step applies to both pyrrole and oPD sensors.

### Step 2.4: Rinse off the excess solution

```
1. Using a transfer pipette, gently squirt PBS solution over the 
   electrode surface to wash away the leftover MIP solution
   
   Use about 1 mL (20 drops) — just enough to rinse the surface.
   
   Let the rinse liquid run off the side onto a paper towel.
   Don't rub or touch the sensing surface!

2. Look at the working electrode pad with your magnifying glass 
   (if you have one)
   
   You should see a thin, slightly dark coating on the gold WE pad.
   It might look slightly brownish or grayish compared to the 
   uncoated areas. It's very thin — don't worry if you can barely 
   see it.
   
   If you see NO change at all, the coating may not have worked.
   That's okay — try again with a fresh electrode.

3. Set the electrode on a clean paper towel to dry for 5 minutes.
```

### Step 2.5: Remove the cortisol template (THE KEY STEP)

This is where you create the cortisol-shaped holes. You're washing out the cortisol molecules that are trapped in the polypyrrole film.

```
1. Pour about 5 mL of your WASH solution into the small plastic 
   container (enough to submerge the sensing area of the electrode)

2. Place the electrode strip in the container so the sensing pads 
   are submerged in the wash solution
   
   You can lean it against the side of the container.
   Make sure the contact pads (where the clips attach) stay DRY 
   and above the liquid level.

3. Set a timer for 20 MINUTES

4. Every 5 minutes, gently swirl the container
   (just pick it up and rock it back and forth a few times)
   
   This helps the ethanol/acetic acid penetrate the film and 
   dissolve the cortisol out of the cavities.

5. When 20 minutes is up, remove the electrode with tweezers

6. Rinse by squirting distilled water over the sensing surface
   (about 1 mL — 20 drops)

7. Then rinse with PBS solution (about 1 mL — 20 drops)

8. Set on a clean paper towel to air dry completely
   (10-15 minutes, or use a gentle fan)
```

**What just happened:** The ethanol dissolved the cortisol molecules and carried them out of the polymer film. The polypyrrole itself is resistant to ethanol, so it stays intact. You now have a polypyrrole film with empty, cortisol-shaped cavities. This is your MIP sensor.

### Step 2.6: Make a control electrode (NIP)

A NIP (non-imprinted polymer) is the same coating process but WITHOUT cortisol. It is the other half of the differential measurement — the device compares the MIP signal to the NIP signal in real time to extract the true cortisol-specific response. Make one NIP for every MIP you make.

```
1. Take a FRESH electrode strip (second one)

2. Make a NIP solution:
   - 2 mL PBS
   - 1 drop pyrrole
   - NO CORTISOL (this is the only difference)
   - Wait 5 minutes (no need for 30 min pre-complexation 
     since there's no cortisol to complex with)

3. Repeat Steps 2.2 through 2.5 exactly as before
   (same CV settings, same overoxidation step, same wash, same rinse)

4. Label this electrode "NIP-PY" (pyrrole NIP, tiny mark on the back)
5. Label your MIP electrode "MIP-PY" (pyrrole MIP)
```

### Day 2 done! (Pyrrole sensors)

You now have:
- [ ] One MIP-PY electrode (polypyrrole with cortisol-shaped holes)
- [ ] One NIP-PY control electrode (polypyrrole with NO holes)
- [ ] Both dry and ready for testing

Store them in a clean, dry container (a ziplock bag works) at room temperature overnight.

If you plan to also make oPD sensors (recommended), read the next section before Day 3. The oPD sensors can be made on the same day as pyrrole sensors, or on a separate day — whichever fits your schedule.

---

## Day 2 Alternative: Making oPD-Based MIP Sensors

**Time needed:** About 2 hours (same as pyrrole). Can be done the same day as pyrrole, or on a separate day.

oPD (o-phenylenediamine) is a second monomer option that forms denser, tighter cavities than pyrrole. The process is nearly identical to the pyrrole protocol above — read Day 2 first, then note the differences below.

### Differences from pyrrole fabrication

**Monomer and solution:**

```
Instead of:  1 drop pyrrole in 2 mL PBS

Use:         5 mM oPD + 1 mM cortisol in PBS pH 7.4

How to prepare the oPD solution:
  1. Put on gloves
  2. Using the very tip of a dry transfer pipette or a toothpick,
     weigh out approximately 1.1 mg of oPD powder into a clean 
     glass vial (about the size of 1-2 grains of table salt)
  3. Add 2 mL of PBS
  4. Swirl until fully dissolved (oPD dissolves slowly — 
     swirl for 2-3 minutes. The solution will be pale yellow 
     or almost colorless)
  5. Add 2 drops of your cortisol stock solution
  6. Swirl gently to mix
  7. Label "oPD MIP SOLUTION"
  
Pre-complexation wait: 30 minutes (same as pyrrole)
```

**CV parameters (different from pyrrole):**

```
   ┌──────────────────────────────────┐
   │  MODE: Cyclic Voltammetry        │
   │                                    │
   │  Start potential:   -200 mV       │
   │  End potential:     +800 mV       │  ← same upper limit as pyrrole
   │  Scan rate:          50 mV/s      │
   │  Number of cycles:   20           │  ← 20 cycles (vs 10 for pyrrole)
   │                                    │
   └──────────────────────────────────┘

Why 20 cycles? oPD polymerizes more slowly than pyrrole. 
It needs twice as many CV cycles to build the same film thickness.
Each cycle takes ~26 seconds → 20 cycles takes about 9 minutes total.
```

**What the film looks like:**

The oPD film is brownish-orange rather than the dark gray/black of polypyrrole. This color difference is normal — it reflects the different chemistry of the polymer. If the film looks pale or invisible, proceed anyway and check at the testing stage.

**Overoxidation step (identical to pyrrole):**

After the 20 CV cycles, run the same overoxidation cycle:

```
  Start potential:   -200 mV
  End potential:     +1100 mV
  Number of cycles:   1

Same as pyrrole — do this while the solution is still on the electrode, 
before rinsing.
```

**Wash step (identical to pyrrole):**

Same ethanol:acetic acid 9:1 wash, 20 minutes, with gentle swirling every 5 minutes.

**NIP for oPD:**

Make a NIP-oPD exactly the same way as above, but omit the cortisol stock. No cortisol = no pre-complexation needed, so the wait time drops to 5 minutes. Run the same 20 CV cycles + overoxidation + wash.

Label the electrodes:
- MIP sensor: "MIP-oPD"
- NIP sensor: "NIP-oPD"

**Safety note:** oPD is a mild irritant — same precautions as pyrrole. Wear gloves and work with ventilation. Avoid breathing the powder when weighing it.

### oPD Day 2 done!

You now have (or will have after both days):
- [ ] MIP-PY (pyrrole MIP)
- [ ] NIP-PY (pyrrole NIP)
- [ ] MIP-oPD (oPD MIP)
- [ ] NIP-oPD (oPD NIP)
- [ ] All four dry and stored in a labeled ziplock bag

---

## Day 3: Testing If It Worked

**Time needed:** About 2 hours

Today you'll find out if your sensor actually detects cortisol.

### Step 3.1: Prepare cortisol test solutions

You need solutions with known amounts of cortisol to test against.

```
What you need:
  - Cortisol stock solution (from Day 1)
  - PBS solution
  - 4 clean glass vials
  - Transfer pipettes

You're making 4 test solutions: zero, low, medium, and high cortisol.

VIAL 1: "ZERO" (no cortisol — this is your baseline)
  - 2 mL PBS, nothing else
  - Label "0"

VIAL 2: "LOW" (~10 ng/mL — evening/resting cortisol level)
  - 2 mL PBS
  - Dip a toothpick into your cortisol stock and swirl it in the PBS
  - This adds a tiny, unmeasured amount — we're being approximate 
    here, which is fine for a first test
  - Label "LOW"

VIAL 3: "MEDIUM" (~50 ng/mL — midday cortisol level)
  - 2 mL PBS
  - Add 1 DROP of cortisol stock
  - Swirl to mix
  - Label "MED"

VIAL 4: "HIGH" (~150 ng/mL — morning peak cortisol level)
  - 2 mL PBS
  - Add 3 DROPS of cortisol stock
  - Swirl to mix
  - Label "HIGH"

These concentrations are APPROXIMATE. For a first test, you just 
want to see that the sensor responds differently to "more cortisol" 
vs "less cortisol." Exact numbers come later with proper calibration.
```

### Step 3.2: Connect the MIP electrode and take a baseline reading

```
1. Connect the MIP electrode to the AD5941 eval board
   (same clip connections as Day 2: red=WE, black=CE, white=REF)

2. On the AD5941 software, switch to CHRONOAMPEROMETRY mode:

   ┌──────────────────────────────────┐
   │  MODE: Chronoamperometry         │
   │                                    │
   │  Step voltage:     +150 mV        │
   │  Duration:          60 seconds    │
   │  Sample rate:       10 Hz         │
   │  Pre-step voltage:   0 mV        │
   │  Pre-step time:      5 seconds   │
   └──────────────────────────────────┘

3. Place 3-4 DROPS of the "ZERO" solution (plain PBS) onto the 
   sensing area

4. Wait 2 minutes (let the liquid settle and the surface stabilize)

5. Click START

6. Watch the graph for 60 seconds
   
   You'll see a current spike at the beginning that quickly decays.
   This is called the "charging current" — it's normal.
   
   RECORD the peak current value (the highest point in the first 
   1-2 seconds). Write it down:
   
   Baseline peak current: _______ µA

7. This is your BASELINE — the signal with zero cortisol.
```

### Step 3.3: Test each cortisol concentration

Now you'll test each concentration from lowest to highest.

```
FOR EACH SOLUTION (LOW, then MED, then HIGH):

  a. WASH the sensor between tests:
     - Squirt wash solution over the sensing area (about 10 drops)
     - Then rinse with PBS (about 10 drops)  
     - Then rinse with distilled water (about 10 drops)
     - Wait 2 minutes for the surface to dry slightly

  b. Place 3-4 DROPS of the test solution onto the sensing area

  c. Wait 5 MINUTES
     (this is the incubation time — cortisol is diffusing into 
     the MIP cavities and binding)

  d. Click START on the AD5941 software
     (same chronoamperometry settings as before)

  e. RECORD the peak current:
     
     LOW:  _______ µA
     MED:  _______ µA
     HIGH: _______ µA
```

### Step 3.4: Test the NIP control

```
Repeat Steps 3.2 and 3.3 with the NIP electrode instead of the MIP.

Record the NIP results:
  Baseline: _______ µA
  LOW:      _______ µA
  MED:      _______ µA
  HIGH:     _______ µA
```

### Step 3.4a: Calculate the differential signal

After testing both the MIP and NIP at each concentration, calculate the differential:

```
DIFFERENTIAL SIGNAL = MIP reading − NIP reading at each concentration

Example:
                    MIP (µA)    NIP (µA)    Differential (µA)
  Baseline (0):      65          62             3
  LOW:               63          61             2       ← small change
  MED:               60          61            -1       ← wait, that's backwards?
  HIGH:              56          62            -6       ← strong dose-response

The differential is your TRUE cortisol-specific signal.

Key insight: The NIP reading stays roughly flat because it has no specific 
cavities — the small fluctuations in NIP readings are noise and non-specific 
effects (temperature, pH, proteins in the solution). When you subtract those 
fluctuations from the MIP reading, you isolate the portion of the MIP signal 
that is specifically due to cortisol filling cavities.

A GOOD RESULT looks like:
  - The differential becomes more negative (or more positive, depending 
    on your setup) as cortisol concentration increases
  - The differential shows a clear dose-response even if the raw MIP 
    readings look slightly noisy
  - The differential is more consistent run-to-run than the raw MIP reading

Record your differential results:
  Baseline differential:  _______ µA
  LOW differential:       _______ µA
  MED differential:       _______ µA
  HIGH differential:      _______ µA
```

**If you made both pyrrole and oPD sensors:** Repeat this entire sequence (Steps 3.2 through 3.4a) for the oPD MIP and oPD NIP pair. Record the differentials for both monomer types side by side — this comparison is the core data that tells you which monomer gives better selectivity for your application.

### Step 3.5: Interpret your results

```
WHAT YOU WANT TO SEE:

MIP electrode:
  The peak current should DECREASE as cortisol concentration 
  increases:
  
  Baseline (0):    highest current  (e.g., 65 µA)
  LOW:             slightly lower   (e.g., 63 µA)
  MED:             lower            (e.g., 60 µA)
  HIGH:            lowest           (e.g., 56 µA)
  
  The current decreases because cortisol molecules filling the 
  cavities block the flow of electricity through the surface.

NIP electrode:
  The peak current should stay roughly THE SAME regardless of 
  cortisol concentration:
  
  Baseline (0):    e.g., 62 µA
  LOW:             e.g., 61 µA
  MED:             e.g., 62 µA
  HIGH:            e.g., 61 µA
  
  Since the NIP has no cortisol-shaped cavities, cortisol has 
  nowhere specific to bind, and the signal barely changes.

IF YOUR MIP SHOWS A DOSE RESPONSE (current decreases with 
more cortisol) AND YOUR NIP IS FLAT:
  
  ★ CONGRATULATIONS — YOUR SENSOR WORKS! ★
  
  The MIP is specifically detecting cortisol.

IF THE RAW MIP READINGS ARE NOISY BUT THE DIFFERENTIAL 
(MIP − NIP) SHOWS A CLEAR DOSE-RESPONSE:
  
  ★ THIS IS ALSO A GOOD RESULT ★
  
  The differential signal is doing its job — it's filtering out the 
  noise that affected both electrodes equally, leaving behind the 
  true cortisol-specific signal. This is normal behavior, especially 
  in complex fluids like synthetic sweat.

IF BOTH MIP AND NIP SHOW SIMILAR RESPONSES:
  The signal is non-specific (cortisol is just sticking to the 
  surface, not binding in specific cavities). See Troubleshooting.

IF NOTHING CHANGES FOR EITHER:
  The sensor isn't detecting cortisol at all. See Troubleshooting.
```

### Step 3.6: Record everything

Write down all your results. You'll need them for calibrating the device later.

```
Date: ___________
Electrode type: DropSens DRP-220AT / Zensor TE100 (circle one)
Pyrrole condition: pale yellow / brownish (circle one)
CV cycles (pyrrole): 10  |  CV cycles (oPD): 20
Overoxidation step performed: yes / no (circle one)
Wash time: 20 minutes
Wash solution: ethanol:acetic acid 9:1 / vinegar (circle one)

PYRROLE RESULTS:
                    MIP-PY (µA)    NIP-PY (µA)    Differential (µA)
  Baseline (0):     _______        _______         _______
  LOW:              _______        _______         _______
  MED:              _______        _______         _______
  HIGH:             _______        _______         _______

oPD RESULTS:
                    MIP-oPD (µA)   NIP-oPD (µA)   Differential (µA)
  Baseline (0):     _______        _______         _______
  LOW:              _______        _______         _______
  MED:              _______        _______         _______
  HIGH:             _______        _______         _______

Signal change (Baseline - HIGH), Differential:
  Pyrrole:  _______ µA
  oPD:      _______ µA

Imprinting factor (MIP change / NIP change): _______
  (Should be > 2 for a working sensor)

Notes:
_________________________________________________
_________________________________________________
```

---

## Troubleshooting

### "The CV graph was flat — no loops at all"

**Most likely:** Bad electrical connection. 
- Check that all three alligator clips are firmly on the contact pads
- Check that no clips are touching each other
- Check that the MIP solution is covering all three sensing pads
- Try a fresh electrode — the pads may have been scratched

### "The CV loops didn't grow — they stayed the same size"

**Most likely:** Pyrrole didn't polymerize.
- Your pyrrole may be too oxidized (old/brown). Use fresh pyrrole.
- The solution may be too dilute. Try adding 2 drops of pyrrole instead of 1.

### "I can't see any film on the electrode"

The MIP film is VERY thin — often invisible to the naked eye. Use a magnifying glass. Even if you can't see it, it may still be there and working. Proceed to testing.

### "The MIP and NIP give the same response"

**Most likely:** Template removal was incomplete — cortisol is still stuck in the cavities.
- Repeat the wash step for 30-40 minutes instead of 20
- Use fresh wash solution
- Swirl more aggressively during the wash

### "The current doesn't change at all with cortisol"

**Most likely:** Either no MIP film formed, or all cavities are still blocked.
- Check that the CV step worked (you saw growing loops)
- Try a longer wash (40 minutes)
- Try more cortisol in your test solutions (double the drops)
- Try a longer incubation time (10 minutes instead of 5)

### "My readings are all over the place (noisy)"

- Make sure the electrode is completely still during measurement
- Check for vibrations (air conditioning, walking near the table)
- Make sure the alligator clips have a solid connection
- Try measuring in a quieter location
- Shield from electrical noise: turn off nearby motors, fans, fluorescent lights

### "I accidentally touched the sensing surface"

That electrode is probably contaminated. Use a fresh one. Oils from your skin will interfere with the MIP.

### "My pyrrole turned dark brown in the bottle"

Pyrrole oxidizes in air over time. If the liquid is dark brown:
- You can still try it, but it may give weaker results
- For best results, buy fresh pyrrole
- Store pyrrole in the fridge with the cap tightly sealed
- Some people add a small piece of aluminum foil to the pyrrole bottle to slow oxidation

---

## Storage

### Storing your MIP electrodes

| Storage method | Shelf life |
|---------------|------------|
| Dry, in a sealed ziplock bag at room temperature | 2-4 weeks |
| Dry, in a sealed bag in the fridge (4°C) | 1-3 months |
| Dry, in a sealed bag with a silica gel desiccant packet | 2-4 months |

**Do NOT** store in liquid. **Do NOT** freeze. **Do NOT** leave exposed to air or direct sunlight.

### Storing your chemicals

| Chemical | Storage | Shelf life once opened |
|----------|---------|----------------------|
| Pyrrole | Fridge, tightly capped, wrapped in foil | 3-6 months (watch for browning) |
| o-Phenylenediamine (oPD) | Room temperature, dry, sealed | 1-2 years (powder is stable; discard if it darkens significantly) |
| Hydrocortisone | Room temperature, dry | Years |
| PBS tablets | Room temperature, dry | Years |
| Ethanol | Room temperature, capped | Years |
| Acetic acid | Room temperature, capped | Years |
| PBS solution (mixed) | Fridge | 2 weeks |
| Cortisol stock solution | Fridge | 1 month |
| Wash solution | Room temperature, capped | Months |

---

## Glossary

| Term | Plain English meaning |
|------|----------------------|
| **MIP** | Molecularly Imprinted Polymer — plastic with molecule-shaped holes in it |
| **NIP** | Non-Imprinted Polymer — the same plastic but WITHOUT holes (used as a comparison/control) |
| **Electrode** | A small strip with metal pads that conduct electricity |
| **SPE** | Screen-Printed Electrode — an electrode made by printing conductive ink onto plastic (like printing on paper, but with metal ink) |
| **WE** | Working Electrode — the pad where the action happens (where the MIP goes) |
| **CE** | Counter Electrode — the pad that completes the electrical circuit |
| **REF** | Reference Electrode — provides a stable voltage reference point |
| **Potentiostat** | An instrument that applies precise voltages and measures tiny currents. The AD5941 chip is a potentiostat on a chip. |
| **Cyclic Voltammetry (CV)** | A technique where you sweep the voltage up and down repeatedly. Used to coat the electrode with polypyrrole. |
| **Chronoamperometry** | A technique where you suddenly step the voltage and watch how the current responds. Used to detect cortisol. |
| **Pyrrole** | A small molecule that, when given electricity, links together into a chain (polymer) called polypyrrole |
| **Polypyrrole** | The plastic-like film that forms on the electrode. Made from linked pyrrole molecules. |
| **oPD (o-Phenylenediamine)** | A second monomer option. Polymerizes into poly-oPD, a denser film than polypyrrole, producing tighter cortisol cavities and potentially better selectivity. |
| **Poly-oPD** | The plastic-like film that forms when oPD is electropolymerized. Brownish-orange in color. |
| **Overoxidation** | A brief extra CV cycle at a higher voltage (+1100 mV) run immediately after MIP coating. Makes the polymer film more rigid and improves selectivity by 30-50%. |
| **Differential signal** | MIP reading minus NIP reading. Cancels out noise that affects both electrodes equally, leaving only the cortisol-specific signal. |
| **Template** | The cortisol molecule that you trap inside the polymer during fabrication, then wash out to leave holes |
| **Incubation** | Waiting time — letting the cortisol soak into the sensor and bind to the holes |
| **PBS** | Phosphate Buffered Saline — salt water that matches your body's pH (7.4) |
| **Calibration** | The process of testing your sensor against known concentrations to build a translation table |
| **Baseline** | The signal you get with zero cortisol — your starting point for comparison |
| **µA (microamps)** | A unit of electrical current. One millionth of an amp. The tiny currents your sensor produces. |
| **ng/mL** | Nanograms per milliliter — the unit for cortisol concentration. One billionth of a gram per milliliter. |
| **Dose response** | When the signal changes proportionally to the amount of cortisol. More cortisol = more signal change. This is what you want to see. |
