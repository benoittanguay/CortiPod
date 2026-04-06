# CortiPod Materials Guide

> Why every item is needed, explained in plain language.

---

## Table of Contents

1. [How the Sensor Works (60-Second Overview)](#how-the-sensor-works)
2. [Chemicals — What Each One Does](#chemicals)
3. [Electrodes — The Sensor Foundation](#electrodes)
4. [Electronics — The Brain and Radio](#electronics)
5. [Environmental Sensors — Error Correction](#environmental-sensors)
6. [Mechanical — The Wearable Shell](#mechanical)
7. [Tools — What You Need to Build It](#tools)

---

## How the Sensor Works

Before diving into materials, here's the 60-second version of what happens:

```
1. You wear the CortiPod on your wrist
2. A tiny amount of sweat (~5 uL) contacts the sensor strip
3. Cortisol molecules in the sweat land in specially shaped 
   "pockets" on the sensor surface (the MIP)
4. When cortisol fills a pocket, it blocks electrical current 
   from flowing through that spot
5. The potentiostat chip measures how much current is blocked
6. More blocked current = more cortisol
7. The reading is sent to your iPhone over Bluetooth
8. The app corrects for temperature, humidity, and sweat rate, 
   then converts the raw signal to a cortisol concentration (ng/mL)
```

The materials below serve one of these roles:
- **Building the sensor pockets** (MIP fabrication)
- **Reading the electrical signal** (electronics)
- **Correcting for environmental noise** (compensation sensors)
- **Making it wearable** (enclosure, strap)
- **Making sure it's accurate** (calibration)

---

## Chemicals

### Pyrrole monomer — *the building material for the pockets (Monomer Option 1)*

**What it is:** A small organic molecule (liquid, yellowish, smells faintly like ammonia).

**Why you need it:** Pyrrole is the raw material that becomes polypyrrole — the polymer film that holds the cortisol-shaped pockets. When you run electricity through a solution of pyrrole, it polymerizes (chains together) on the electrode surface, forming a thin plastic-like coating. If cortisol molecules are present during polymerization, the polymer forms *around* them, creating cavities that perfectly match cortisol's shape.

**What happens without it:** No polymer film, no pockets, no sensor. This is the core sensing material.

**Amount needed:** 69 microliters per sensor. A 100 mL bottle makes 1,400+ sensors.

---

### o-Phenylenediamine (oPD) — *a second plastic-making chemical for tighter pockets (Monomer Option 2)*

**What it is:** A fine crystalline powder (off-white to light brown) with a faint amine smell. Sigma-Aldrich [P23938](https://www.sigmaaldrich.com/US/en/product/aldrich/p23938), 99.5% flaked, ~$25-30 for 5 g.

**Why you need it:** A different plastic-making chemical (monomer) that forms tighter cortisol-shaped cavities than pyrrole, potentially giving better selectivity. Where polypyrrole forms a relatively loose, porous film, poly-oPD grows as a denser, more compact layer — the cavities it creates have higher shape fidelity to cortisol, which means fewer false signals from similarly sized molecules (like testosterone or progesterone). The trade-off is that it polymerizes more slowly, requiring more CV cycles.

**The oPD vs. pyrrole choice in plain English:** Pyrrole is faster and easier to work with; oPD is more discriminating. The CortiPod project tests both so you can compare real-world selectivity on the same sweat samples.

**What happens without it:** You can still make a working sensor using pyrrole alone. oPD is the second option, not a replacement — you'll fabricate both and run them simultaneously in the device (one MIP + one NIP for each monomer type).

**Amount needed:** ~1.1 mg per sensor (dissolved in 2 mL PBS). A 5 g bottle makes thousands of sensors.

---

### Hydrocortisone (cortisol standard) — *the mold for the pockets*

**What it is:** Synthetic cortisol, identical to what your body produces. White powder.

**Why you need it:** This is the "template" molecule. During MIP fabrication, you dissolve cortisol in the pyrrole solution. When the pyrrole polymerizes on the electrode, it wraps around these cortisol molecules. After polymerization, you wash the cortisol out, leaving behind empty cavities that are the exact shape of cortisol. It's like pressing a key into clay, then removing the key — the clay retains the shape.

You also need it to make calibration solutions — known concentrations of cortisol that you test the sensor against to build a calibration curve (translating "electrical signal" into "ng/mL").

**What happens without it:** The polymer would form but with no specific pockets. It would be a flat, featureless film with no ability to selectively bind cortisol (this is what the NIP control is — polypyrrole without the template).

**Amount needed:** 0.36 mg per sensor for fabrication, plus ~10 mg for calibration solutions. A 1g bottle lasts years.

---

### PBS (Phosphate Buffered Saline) — *the carrier liquid*

**What it is:** A salt solution that mimics the pH and salt concentration of body fluids (pH 7.4). Comes as tablets you dissolve in water.

**Why you need it:** Electrochemistry is sensitive to pH and ionic strength. PBS provides a stable, reproducible environment for:
1. Dissolving pyrrole and cortisol for MIP fabrication
2. Rinsing electrodes between steps (removing loose molecules without disturbing the MIP)
3. Baseline measurements (measuring the sensor with no cortisol present)

**What happens without it:** If you used plain water, the pH would be unpredictable and the ionic strength too low for good electrochemistry. Your signals would be noisy and irreproducible.

**Amount needed:** A few tablets per session. One pack lasts months.

---

### Ethanol (reagent grade) — *the template remover (part 1)*

**What it is:** Pure ethanol (alcohol). Same molecule as in beverages, but without water or impurities.

**Why you need it:** After polymerizing the MIP with cortisol trapped inside, you need to wash the cortisol OUT to create the empty pockets. Ethanol is a good solvent for cortisol — it dissolves and carries away the template molecules without damaging the polypyrrole film.

It's also used for ongoing sensor regeneration: after the sensor has been used and cortisol has filled the pockets, an ethanol wash removes the bound cortisol so the sensor can be used again.

**What happens without it:** The cortisol stays trapped in the polymer. No empty pockets = sensor can't bind new cortisol = doesn't work.

**Amount needed:** ~10 mL per wash. A 500 mL bottle provides ~50 washes.

---

### Acetic acid (glacial) — *the template remover (part 2)*

**What it is:** Concentrated vinegar acid (pure, undiluted).

**Why you need it:** Mixed with ethanol (9:1 ratio), it creates the wash solution for template removal and sensor regeneration. The acetic acid disrupts hydrogen bonds between cortisol and the polymer, helping the ethanol pull cortisol molecules out of the cavities more completely.

Ethanol alone works, but the ethanol + acetic acid combination removes ~95% of the template vs ~70-80% for ethanol alone. More complete removal = more available pockets = better sensitivity.

**What happens without it:** Template removal would be incomplete. Some pockets would still be blocked by residual cortisol, reducing the sensor's sensitivity and dynamic range.

**Amount needed:** ~1 mL per wash (it's the "1" in the 9:1 ethanol:acetic acid ratio). A 500 mL bottle lasts a very long time.

---

### Gold chloride (HAuCl4) — *the electrode enhancer*

> **Only needed if using carbon electrodes (budget path). Skip if buying pre-made gold electrodes.**

**What it is:** A gold salt dissolved in acid. Orange-red solution.

**Why you need it:** Carbon electrodes are cheap but have a relatively low surface area and poor electron transfer properties. By electrodepositing gold nanoparticles onto the carbon surface (running current through a gold chloride solution), you create a rough, high-surface-area gold layer. Gold is excellent for electrochemistry because:
1. It has fast electron transfer kinetics (cleaner signals)
2. It provides more surface area for the MIP film (more pockets per electrode)
3. It's chemically inert (won't corrode in sweat)

**What happens without it (on carbon electrodes):** The sensor would still work but with lower sensitivity and higher noise. The signal might not be strong enough to distinguish between close cortisol concentrations.

**Amount needed:** Tiny. You make a 1 mM solution — a few milligrams of gold chloride per batch of electrodes.

---

### Sulfuric acid (0.5 M) — *the gold deposition bath*

> **Only needed if using carbon electrodes (budget path). Skip if buying pre-made gold electrodes.**

**What it is:** Dilute sulfuric acid.

**Why you need it:** It serves as the "electrolyte bath" for gold electrodeposition. When you apply a negative voltage to the carbon electrode immersed in gold chloride + sulfuric acid, gold ions are reduced to metallic gold and deposit on the electrode. The sulfuric acid provides the ionic conductivity needed for this electrochemical process to work.

**What happens without it:** Gold won't deposit evenly or at all. The electrochemical circuit needs ions in solution to carry current.

**Amount needed:** 10 mL per batch. One bottle lasts many batches.

---

### Synthetic sweat components — *the test fluid*

**What it is:** A DIY recipe that mimics human sweat: 0.1% NaCl (salt), 0.1% urea, 0.1% lactic acid in deionized water, adjusted to pH 6.

**Why you need it:** You can't rely on your own sweat for controlled bench testing — sweat composition varies minute to minute. Synthetic sweat gives you a reproducible baseline fluid to dissolve known cortisol concentrations in. This lets you build an accurate calibration curve under controlled conditions before moving to real sweat on-body.

**What happens without it:** You could test in PBS, but that doesn't have the salts, urea, and lactic acid present in real sweat. These components can interfere with sensing, so it's better to calibrate in a realistic matrix.

**Amount needed:** A few hundred mL. Ingredients cost a few dollars from a grocery store (salt, urea from garden supply, lactic acid from brewing supply).

---

## Electrodes

### Screen-printed electrodes (SPEs) — *the sensor foundation*

**What it is:** A small plastic strip (~3 x 1 cm) with three electrode pads printed on it using conductive inks: a working electrode (where the MIP goes), a counter electrode (completes the circuit), and a reference electrode (provides a stable voltage reference).

**Why you need it:** This is the physical platform the MIP is built on. The three-electrode configuration is standard in electrochemistry — it allows precise measurement of the tiny currents generated when cortisol binds to the MIP.

Think of it like a printed circuit board, but for chemistry instead of electronics. The working electrode is where the action happens. The counter electrode lets current flow in a complete circuit. The reference electrode acts like a voltage "anchor" so measurements are consistent.

**Options:**
- **Gold SPEs (DropSens DRP-220AT):** Working electrode is already gold. No gold deposition step needed. More expensive (~$5-8 each) but saves time and complexity.
- **Carbon SPEs (Zensor TE100):** Cheaper (~$2-4 each) but you need to electrodeposit gold nanoparticles yourself (requires HAuCl4 and H2SO4 above).

**How many to buy:** Buy at least 15 electrodes — you need: 2 MIP pyrrole + 2 NIP pyrrole + 2 MIP oPD + 2 NIP oPD + ~7 spares for practice and failed attempts. Failed attempts are expected at first; plan for them up front rather than waiting for a second order.

**What happens without it:** No electrode = nowhere to build the MIP = no sensor. This is the consumable part you replace every few weeks.

---

### Why the device carries two electrodes at once — *the MIP + NIP differential concept*

The wearable CortiPod carries a **MIP electrode and a NIP electrode simultaneously**. Here is why that matters.

**The problem with a single electrode:** Sweat is a noisy fluid. Temperature changes, pH shifts, non-cortisol proteins, and even the mechanical pressure of the band on your wrist all create electrical signal changes that look exactly like "more cortisol" to a single sensor. This is called non-specific interference.

**How the NIP fixes it:** The NIP (non-imprinted polymer) is chemically identical to the MIP but has no cortisol-shaped cavities. It responds to every source of noise — temperature drift, pH changes, protein fouling — but NOT to cortisol binding (because there are no specific cavities to bind into). The MIP responds to all of that same noise PLUS the cortisol signal.

**The differential calculation:**

```
True cortisol signal = MIP reading − NIP reading
```

Any noise that affects both electrodes equally cancels out. What remains is only the portion of the MIP signal that can be attributed to cortisol filling its specific cavities. In practice this differential signal is far cleaner and more repeatable than the raw MIP reading alone — especially important during exercise when sweat rate and composition change rapidly.

**Why four electrode sets (pyrrole + oPD, each with a NIP):** The device tests both monomer types simultaneously. The pyrrole MIP minus pyrrole NIP gives one cortisol estimate; the oPD MIP minus oPD NIP gives a second, independent estimate. If they agree, you have high confidence. If they disagree, the oPD result (with its tighter cavities) is likely more selective.

---

## Electronics

### nRF52832 module (MDBT42Q or Adafruit Feather) — *the brain and radio*

**What it is:** A tiny computer chip with a built-in Bluetooth radio. ARM Cortex-M4 processor, 12-bit ADC, I2C, SPI, GPIO — all in a package smaller than a postage stamp.

**Why you need it:** It does three jobs:
1. **Controls the potentiostat** (AD5941) — tells it when to measure and reads back the results via SPI
2. **Reads the environmental sensors** (temperature, humidity, GSR) via I2C and ADC
3. **Transmits everything to your iPhone** over Bluetooth Low Energy (BLE)

The Adafruit Feather version ($25) is for development — it has USB, a LiPo charger, and Arduino compatibility for easy programming. The bare MDBT42Q module ($10) is for the final pod — just the chip and antenna, nothing extra.

**What happens without it:** No brain, no radio, no device. You'd be manually reading a potentiostat and writing down numbers.

---

### AD5941 — *the electrochemistry measurement chip*

**What it is:** A single IC from Analog Devices that contains an entire potentiostat (the instrument that measures electrochemical signals). It can apply precise voltages to the sensor and measure the resulting currents down to nanoamp levels.

**Why you need it:** The MIP sensor produces a tiny current change when cortisol binds (~microamps). Measuring this accurately requires:
- A precise voltage source (to apply the 150 mV step)
- A sensitive current amplifier (to measure the response)
- An ADC (to digitize the analog signal)
- Proper shielding and noise filtering

The AD5941 does ALL of this in one 4x4 mm chip. Without it, you'd need to build a discrete potentiostat from op-amps, DACs, ADCs, and precision resistors — which is what the original CortiWatch paper did, and it's much more complex.

**What happens without it:** You'd need ~10 individual ICs to replicate its function, taking up 5-10x more PCB space and drawing more power.

---

### LiPo battery — *power*

**What it is:** A small rechargeable lithium polymer battery.

**Why you need it:** The device needs power. A 60-80 mAh LiPo is small enough to fit in the pod and provides:
- ~15 mA during active measurement (a few minutes every 15 min)
- ~2 mA in sleep mode (between measurements)
- Estimated battery life: 16-30 hours on a charge

**Why this size:** Bigger battery = bigger device. 60-80 mAh is the sweet spot for a Whoop-sized pod with no screen. You charge it nightly, like a Whoop.

---

### TP4056 + LDO regulator — *power management*

**What it is:** TP4056 is a tiny charging chip — it safely charges the LiPo from a USB or magnetic connector. The LDO (Low Dropout Regulator, AP2112K-3.3) converts the battery voltage (3.7-4.2V) to a steady 3.3V for the electronics.

**Why you need it:** LiPo batteries need careful charging (overcharge = fire risk). The TP4056 handles this automatically. The LDO ensures the nRF52 and AD5941 get clean, stable 3.3V power regardless of battery charge level.

**What happens without it:** Unregulated battery voltage would cause measurement drift as the battery drains. No charger = can't safely recharge.

---

### Pogo pins — *the sensor cartridge connector*

**What it is:** Spring-loaded gold-plated pins that make electrical contact when pressed against a flat pad.

**Why you need it:** The MIP sensor strip is a consumable that slides into a cartridge slot. Pogo pins press against the strip's electrode pads, making a reliable electrical connection without soldering. When you swap the strip, the pogo pins automatically contact the new one.

4 pins needed: working electrode, counter electrode, reference electrode, and ground.

**What happens without it:** You'd need to solder or clip wires to each sensor strip, which is impractical for a wearable that needs regular strip changes.

---

### Magnetic charging connector — *charging without a port*

**What it is:** A 2-pin connector with embedded magnets. One half is on the device, the other on the charging cable. They snap together magnetically.

**Why you need it:** A sealed wearable can't have a USB port (water ingress). Magnetic connectors let you charge through the sealed case. The magnets align the pins automatically — no fumbling.

**What happens without it:** You'd need a USB-C port with a waterproof plug, which is harder to seal and more fragile.

---

## Environmental Sensors

### TMP117 (temperature sensor) — *corrects for temperature-dependent signal drift*

**What it is:** A tiny digital thermometer accurate to +/- 0.1 degrees C. Communicates over I2C.

**Why you need it:** Electrochemical reactions speed up when warm and slow down when cold. The current your MIP sensor produces at 35 degrees C (warm wrist) will be different from the same cortisol concentration at 20 degrees C (cold day). By measuring the exact temperature, the iPhone app applies a correction factor so the cortisol reading is accurate regardless of temperature.

**What happens without it:** On a cold day, you'd read artificially low cortisol. On a hot day, artificially high. Error could be 10-20% across the temperature range you'd encounter (18-37 degrees C).

---

### SHT40 (humidity sensor) — *corrects for sweat evaporation effects*

**What it is:** A tiny combined temperature + humidity sensor. Communicates over I2C.

**Why you need it:** If the air between the sensor and your skin is very dry, sweat evaporates faster, concentrating the cortisol on the sensor surface (reading too high). If it's humid, less evaporation occurs (reading closer to true concentration). Measuring humidity lets the app compensate for this.

**What happens without it:** Readings on a dry winter day vs a humid summer day could vary 10-30% for the same actual cortisol level.

---

### GSR electrodes (galvanic skin response) — *estimates sweat rate*

**What it is:** Two small metal pads on the back of the device that contact your skin. They measure skin conductance (how easily a tiny electrical current passes through your skin).

**Why you need it:** More sweat on the skin = higher conductance = higher GSR reading. This gives you a proxy for how much sweat is reaching the sensor. Important because:
- More sweat = more dilute cortisol = lower reading (even if your body is producing the same amount)
- Less sweat = more concentrated = higher reading
- GSR lets the app normalize for this

Also used for **contact quality detection** — if the device isn't touching skin, GSR reads near zero, and the app knows to discard that reading.

**What happens without it:** You couldn't tell if a low reading means "low cortisol" or "not enough sweat on the sensor." The app would also have no way to detect when the device is off your wrist.

**Cost:** Essentially free — just two exposed metal pads on the PCB + a single resistor.

---

## Mechanical

### 3D printed enclosure — *the wearable shell*

**Why you need it:** Houses the PCB, battery, and sensor cartridge in a waterproof, skin-safe pod. Designed as two halves (top + bottom) that snap together with an O-ring seal.

**Material options:**
- **MJF Nylon PA12** (~$5-10 per pod) — rigid, durable, smooth finish. Used in commercial fitness wearables. Fine for prototyping.
- **Formlabs BioMed Amber** (~$20-50 per pod, via Xometry) — USP Class VI biocompatible, certified for skin contact. For final/validated prototypes.

---

### Silicone strap — *holds it on your wrist*

**Why you need it:** Standard 18mm quick-release watch band. By designing the pod with standard 18mm lug spacing, you can use any off-the-shelf strap. Silicone is comfortable for all-day wear and easy to clean.

---

### Conformal coating — *waterproofs the PCB*

**Why you need it:** Sweat is corrosive (salt + acid). If any moisture gets inside the pod and contacts the bare PCB, it will corrode traces and kill the electronics. Conformal coating is a thin spray-on protective layer that seals the entire PCB surface. You mask the pogo pin pads and charging pads before spraying so those connections still work.

---

### Silicone RTV sealant — *seals the enclosure halves*

**Why you need it:** Fills the gap between the top and bottom shell of the pod, creating a waterproof seal. Think of it as a flexible gasket material that you apply as a paste and it cures to a rubbery seal.

---

### Neodymium magnets — *charging alignment*

**Why you need it:** Small disc magnets embedded in the pod and charging cable snap together, aligning the charging pins automatically. Without them, you'd have to carefully position the cable — magnets make it fool-proof.

---

## Tools

### Micropipettes — *precision liquid handling*

**Why you need them:** MIP fabrication requires dispensing specific volumes — 50-100 uL of polymer solution, 10 uL of cortisol samples, 5 uL of wash solution. Micropipettes let you measure these accurately. A 10 uL pipette and a 100 uL pipette cover all your needs.

**Cheaper alternative:** Disposable graduated transfer pipettes ($5 for a bag) work for the larger volumes (50-100 uL) but are less precise for small volumes (5-10 uL). Acceptable for early prototyping where you're learning the process, not trying to hit exact specifications.

---

### Potentiostat (for fabrication, if not using AD5941 eval board) — *drives electrochemistry*

**Why you need it:** Two uses:
1. **MIP fabrication** — runs cyclic voltammetry to polymerize pyrrole onto the electrode
2. **Sensor testing** — runs chronoamperometry to measure cortisol response

If you're building the AD5941 into the device early, you can use the device itself as the potentiostat for fabrication and testing. Otherwise, a standalone unit like the PalmSens EmStat Pico ($250) or open-source CheapStat (~$50 DIY) does the job.

---

### Calibration test kits — *the ground truth*

**Why you need them:** The CortiPod sensor gives you a current value in microamps. To convert that to "cortisol in ng/mL," you need to compare your sensor's reading against a known-accurate measurement. Home saliva cortisol test kits (Everlywell, ZRT Lab) use immunoassay — the gold standard — and give you a number you can trust. By taking a saliva test and a CortiPod reading simultaneously, you create a calibration point that links the two.

You need at least 3 calibration points (ideally at different cortisol levels — morning high, midday medium, evening low) to build a reliable calibration curve.

---

## Quick Reference: What Goes Where

```
IN THE SENSOR STRIP (consumable):
  Screen-printed electrode (x4 minimum: pyrrole MIP, pyrrole NIP, oPD MIP, oPD NIP)
  + Gold nanoparticles (if carbon base)
  + Polymer MIP film — either polypyrrole (pyrrole + cortisol template)
                       or poly-oPD (oPD + cortisol template)

IN THE POD (permanent):
  nRF52832 (brain + Bluetooth)
  AD5941 (potentiostat)
  TMP117 (temperature)
  SHT40 (humidity)
  GSR pads (skin conductance)
  LiPo battery
  TP4056 + LDO (power management)
  Pogo pins (connect to sensor strip)
  Magnetic charging pads

ON YOUR PHONE (free):
  CortiPod iPhone app
  - Sensor fusion algorithms
  - Calibration engine
  - Trend charts and alerts

ON YOUR NIGHTSTAND (for maintenance):
  Small vial of ethanol:acetic acid (9:1) wash solution
  PBS rinse
```
