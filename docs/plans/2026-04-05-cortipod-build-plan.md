# CortiPod Build Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Whoop-style wrist-worn sensor pod that measures cortisol from passive sweat using MIP-based electrochemical sensing, streaming data over BLE to an iPhone app for computation, calibration, and display.

**Architecture:** A small sensor pod (~35x20x10mm) houses an nRF52832 SoC (MCU + BLE), an AD5941 single-chip potentiostat, environmental compensation sensors (temperature, humidity, GSR), and a swappable MIP sensor strip accessed via a cartridge slot. All signal processing, sensor fusion, calibration math, and UI lives on the iPhone. The pod collects raw ADC values and transmits them over BLE.

**Tech Stack:** nRF52832 (Zephyr RTOS or Arduino), AD5941 potentiostat AFE, MIP electrochemistry, CoreBluetooth (iOS), Swift/SwiftUI

---

## Table of Contents

1. [Phase 1: MIP Sensor Fabrication](#phase-1-mip-sensor-fabrication)
2. [Phase 2: Bench Validation](#phase-2-bench-validation)
3. [Phase 3: Electronics — Potentiostat + MCU](#phase-3-electronics)
4. [Phase 4: Environmental Compensation Sensors](#phase-4-environmental-sensors)
5. [Phase 5: Firmware](#phase-5-firmware)
6. [Phase 6: Enclosure + Mechanical](#phase-6-enclosure)
7. [Phase 7: iPhone App](#phase-7-iphone-app)
8. [Phase 8: On-Body Integration Testing](#phase-8-integration)
9. [Full BOM](#full-bom)
10. [Supplier Directory](#supplier-directory)

---

## Phase 1: MIP Sensor Fabrication

### Goal
Create polypyrrole-based molecularly imprinted polymer sensors for cortisol on commercially available screen-printed electrodes.

### Materials

| Item | Product | Supplier | Approx. Cost |
|------|---------|----------|-------------|
| Screen-printed gold electrodes | DRP-220AT (pack of 75) or DRP-C220AT | Metrohm DropSens | ~$5-8/ea (request quote) |
| Screen-printed carbon electrodes (budget) | TE100 (pack of 40) | Zensor R&D via eDAQ (ET077-40) | ~$2-4/ea |
| Pyrrole monomer | Cat. 131709, reagent grade 98%, 100 mL | Sigma-Aldrich | ~$30-50 |
| Hydrocortisone (cortisol standard) | Cat. H4001, >=98% HPLC, 1g | Sigma-Aldrich | ~$30-40 |
| PBS buffer pH 7.4 | Cat. P4417, tablets | Sigma-Aldrich | ~$15 |
| Ethanol (reagent grade) | Cat. 459844 | Sigma-Aldrich | ~$25 |
| Acetic acid (glacial) | Cat. A6283 | Sigma-Aldrich | ~$20 |
| Gold chloride (HAuCl4) for electroplating | Cat. 520918 | Sigma-Aldrich | ~$80 |
| Sulfuric acid 0.5M (for gold deposition) | Cat. 339741 | Sigma-Aldrich | ~$25 |
| Micropipettes (1-10 uL, 10-100 uL) | — | Fisher Scientific or Amazon | ~$50-100 |
| Pipette tips | — | Fisher Scientific or Amazon | ~$15 |

### Equipment Needed

| Equipment | Options | Notes |
|-----------|---------|-------|
| Potentiostat (for fabrication) | EVAL-AD5941BATZ ($205, DigiKey) OR PalmSens EmStat Pico ($250) OR CheapStat (open-source, ~$50 DIY) | Needs cyclic voltammetry (CV) and chronoamperometry capability |
| Incubator or warm plate | Amazon ~$30-50 | For controlled incubation steps |
| Deionized water | Grocery store distilled water works for prototyping | — |
| Small glass vials | Amazon, pack of 50 ~$10 | For wash solutions |
| Nitrile gloves | Amazon ~$10 | Safety |

### Task 1.1: Prepare Gold-Enhanced Electrodes

> Skip this task if using pre-made gold electrodes (DropSens DRP-220AT). Only needed if starting from carbon electrodes (Zensor TE100).

- [ ] **Step 1: Prepare gold chloride solution**
  - Dissolve HAuCl4 to make 1 mM solution in 0.5 M H2SO4
  - Use deionized water
  - Prepare 10 mL (enough for many electrodes)

- [ ] **Step 2: Electrodeposit gold nanoparticles**
  - Connect the screen-printed carbon electrode to the potentiostat
    - Working electrode: carbon working pad on SPE
    - Counter electrode: carbon counter pad on SPE
    - Reference electrode: Ag/AgCl pad on SPE
  - Immerse the electrode area in the HAuCl4 solution
  - Apply constant potential: **-0.2 V vs Ag/AgCl**
  - Duration: **120 seconds**
  - Gold nanoparticles will deposit onto the carbon surface (you should see a subtle color change to pinkish/gold)

- [ ] **Step 3: Rinse and dry**
  - Rinse electrode gently with deionized water
  - Air dry at room temperature (5 min)
  - Do NOT touch the electrode surface

- [ ] **Step 4: Repeat for batch**
  - Prepare 10-20 electrodes in one session
  - Store in a clean, dry container

### Task 1.2: Electropolymerize MIP on Electrode

- [ ] **Step 1: Prepare pre-polymerization solution**
  ```
  Solution composition:
  - 0.1 M pyrrole in PBS pH 7.4
  - 1 mM cortisol (hydrocortisone) dissolved in the same solution
  
  Preparation:
  1. Add 69 uL pyrrole per 10 mL PBS (pyrrole MW = 67.09, density = 0.967)
  2. Add 3.6 mg hydrocortisone per 10 mL PBS (cortisol MW = 362.46)
  3. Vortex or stir gently for 2 minutes
  4. Let sit for 30 minutes at room temperature
     (allows monomer-template pre-complexation)
  ```

- [ ] **Step 2: Run cyclic voltammetry to form the MIP film**
  - Connect electrode to potentiostat
  - Drop 50-100 uL of pre-polymerization solution onto the electrode surface (covering all three electrode pads)
  - CV parameters:
    ```
    Potential range: -0.2 V to +0.8 V (vs Ag/AgCl)
    Scan rate: 50 mV/s
    Number of cycles: 10
    ```
  - You should see increasing current with each cycle as polypyrrole deposits
  - The film should appear as a thin dark coating on the working electrode

- [ ] **Step 2b (optional): Overoxidation — improves selectivity and on-body fouling resistance**

  > **Why:** Overoxidation introduces carbonyl and carboxyl groups into the polypyrrole backbone, creating a negatively charged, denser film surface. This (1) repels negatively charged proteins via Donnan exclusion, extending on-body sensor life, and (2) cross-links the polymer, making cavities more rigid and selective. The trade-off is a ~10-35% reduction in absolute peak current (the film becomes more resistive), but selectivity (imprinting factor) improves by 30-50% and fouling resistance improves significantly.
  >
  > **Choose a level based on your use case:**
  > - Skip this step entirely if doing bench-only testing and maximizing raw signal.
  > - Use **Basic** for general-purpose sensors (good balance).
  > - Use **Extended** if targeting on-body wear beyond 2-3 hours.

  **Do this immediately after Step 2, while the electrode is still wet with MIP solution. Do NOT rinse first.**

  - **Basic overoxidation** (recommended starting point):
    ```
    Method: Cyclic voltammetry
    Start potential:  -200 mV
    End potential:    +1100 mV
    Scan rate:         50 mV/s
    Number of cycles:  1
    
    Effect: ~10-15% peak current reduction, ~30-50% selectivity gain
    Time added: ~26 seconds
    ```

  - **Extended overoxidation** (for on-body longevity):
    ```
    Method: Cyclic voltammetry
    Start potential:  -200 mV
    End potential:    +1100 mV
    Scan rate:         50 mV/s
    Number of cycles:  3-5
    
    Effect: ~25-35% peak current reduction, ~2x imprinting factor,
            fouling resistance roughly doubles vs no overoxidation
    Time added: ~2 minutes
    ```

  - **Aggressive overoxidation** (maximum fouling resistance):
    ```
    Method: Constant potential (chronoamperometry mode)
    Potential:  +1200 mV
    Duration:   120 seconds
    
    Effect: ~35-50% peak current reduction, strongest anti-fouling
            surface charge. Best for multi-hour on-body sessions.
    Time added: 2 minutes
    ```

  > **Important:** If using overoxidation, apply the same level to both MIP and NIP electrodes so the differential subtraction remains valid.

- [ ] **Step 3: Rinse off excess solution**
  - Gently rinse with PBS pH 7.4
  - Do NOT use organic solvents yet (cortisol template still trapped)

### Task 1.3: Template Removal (Creating the Imprints)

- [ ] **Step 1: Prepare wash solution**
  ```
  Ethanol : Acetic acid = 9:1 (v/v)
  - 9 mL ethanol + 1 mL glacial acetic acid
  - Mix in a glass vial
  ```

- [ ] **Step 2: Wash out cortisol template**
  - Immerse the MIP electrode in wash solution
  - Incubate for **15-20 minutes** with gentle agitation (manual swirling every 5 min)
  - The ethanol/acetic acid disrupts the cortisol-polymer interactions without destroying the cavity shape

- [ ] **Step 3: Final rinse**
  - Rinse thoroughly with deionized water
  - Then rinse with PBS pH 7.4
  - Air dry

- [ ] **Step 4: Store**
  - Store dry in a sealed container at room temperature
  - Shelf life: weeks to months

### Task 1.4: Fabricate NIP Control Electrode

> A non-imprinted polymer (NIP) control is essential for validating that your MIP actually works.

- [ ] **Step 1: Repeat Task 1.2 but WITHOUT cortisol**
  ```
  NIP solution:
  - 0.1 M pyrrole in PBS pH 7.4
  - NO cortisol added
  ```
  - Same CV parameters (10 cycles, -0.2 to +0.8 V, 50 mV/s)
  - If you used overoxidation (Step 2b) on the MIP, apply the **same level** here

- [ ] **Step 2: Perform the same wash step as Task 1.3**
  - Even though there's no template to remove, this ensures the NIP and MIP went through identical processing

---

## Phase 2: Bench Validation

### Goal
Confirm the MIP sensor responds to cortisol and the NIP does not, establishing a calibration curve.

### Materials

| Item | Product | Supplier | Cost |
|------|---------|----------|------|
| Cortisol standard solution | Same H4001 from Phase 1 | Sigma-Aldrich | (already purchased) |
| Synthetic sweat | DIY: 0.1% NaCl, 0.1% urea, 0.1% lactic acid in DI water, pH 6 | Lab chemicals | ~$20 |
| Home cortisol saliva test kit (for later validation) | Everlywell or ZRT Lab cortisol test | Amazon | ~$30-50 |

### Task 2.1: Calibration Curve with Known Cortisol Concentrations

- [ ] **Step 1: Prepare cortisol standards in synthetic sweat**
  ```
  Stock: 1 mg/mL cortisol in ethanol (dissolve 10 mg H4001 in 10 mL ethanol)
  
  Serial dilutions in synthetic sweat:
  - 0 ng/mL   (blank — synthetic sweat only)
  - 1 ng/mL
  - 5 ng/mL
  - 10 ng/mL
  - 25 ng/mL
  - 50 ng/mL
  - 100 ng/mL
  - 150 ng/mL
  - 200 ng/mL
  
  Physiological sweat cortisol range: 8-140 ng/mL
  ```

- [ ] **Step 2: Test MIP sensor at each concentration**
  - For each concentration (start from lowest, go to highest):
    1. Drop 10 uL of cortisol solution on the MIP electrode
    2. Wait 5 minutes (incubation — cortisol fills cavities)
    3. Run chronoamperometry:
       ```
       Step voltage: +0.15 V (150 mV)
       Duration: 60 seconds
       Record peak current
       ```
       OR run DPV:
       ```
       Scan: -0.2 V to +0.6 V
       Step: 5 mV
       Amplitude: 50 mV
       Record peak current
       ```
    4. Record the peak current value
    5. Wash with ethanol:acetic acid (9:1) for 10 minutes
    6. Rinse with PBS, then DI water
    7. Wait 5 minutes for drying
    8. Proceed to next concentration

- [ ] **Step 3: Test NIP control at same concentrations**
  - Repeat the same process on the NIP electrode
  - The NIP should show minimal or no dose-dependent response

- [ ] **Step 4: Plot calibration curve**
  - X axis: cortisol concentration (ng/mL), log scale
  - Y axis: peak current (uA or nA)
  - Plot both MIP and NIP curves
  - The MIP curve should show a clear dose-response relationship
  - The NIP curve should be relatively flat
  - The difference between MIP and NIP = your specific signal

- [ ] **Step 5: Calculate key metrics**
  ```
  Sensitivity: slope of the linear region of the calibration curve
  LOD (limit of detection): 3 * (standard deviation of blank) / sensitivity
  Linear range: the concentration range where response is proportional
  Imprinting factor: MIP response / NIP response at same concentration
  
  Target performance:
  - LOD < 5 ng/mL (below physiological minimum)
  - Linear range covering 8-150 ng/mL
  - Imprinting factor > 2 (ideally > 5)
  ```

### Task 2.2: Regeneration Cycle Testing

- [ ] **Step 1: Pick one concentration in the middle of the range (e.g., 50 ng/mL)**

- [ ] **Step 2: Run 20 consecutive measure-wash-measure cycles**
  - For each cycle:
    1. Apply 50 ng/mL cortisol, wait 5 min
    2. Measure (chronoamperometry or DPV)
    3. Record peak current
    4. Wash (ethanol:acetic acid 9:1, 10 min)
    5. Rinse, dry

- [ ] **Step 3: Plot signal vs cycle number**
  - Signal should remain within 10-15% of initial value for first 15-20 cycles
  - Note the cycle number where signal drops below 80% of initial (this is your practical sensor lifespan)

### Task 2.3: Selectivity Testing (Optional but Recommended)

- [ ] **Step 1: Test common sweat interferents**
  ```
  Test each at physiological concentration on the MIP:
  - Glucose: 100 uM
  - Uric acid: 50 uM  
  - Lactate: 10 mM
  - NaCl: 50 mM
  
  Measure the response to each — should be minimal compared 
  to cortisol at equivalent concentration
  ```

---

## Phase 3: Electronics — Potentiostat + MCU

### Goal
Build the electronic system: AD5941 potentiostat AFE controlled by nRF52832 BLE SoC.

### Components

| Item | Product | Supplier | Cost |
|------|---------|----------|------|
| nRF52832 dev board | Adafruit Feather nRF52 Bluefruit LE (#3406) | Adafruit | $24.95 |
| nRF52832 module (for final pod) | Raytac MDBT42Q-512KV2 (#4077) | Adafruit | $9.95 |
| AD5941 eval board | EVAL-AD5941BATZ | DigiKey | ~$205 |
| AD5941 bare IC (for custom PCB) | AD5941BCPZ | DigiKey | ~$15 |
| LiPo battery (prototyping) | 100 mAh LiPo with JST (#1570) | Adafruit | $5.95 |
| LiPo battery (final pod) | 50-80 mAh micro LiPo | PowerStream (powerstream.com) | ~$5-10 |
| LiPo charger | TP4056 module with protection | Amazon/AliExpress | ~$1 |
| LDO voltage regulator | AP2112K-3.3 (SOT-23-5) | DigiKey | ~$0.50 |
| Decoupling caps, resistors | 0402/0603 assortment | DigiKey/Amazon | ~$10 |
| Breadboard + jumpers | — | Amazon | ~$10 |

### Task 3.1: Bench Prototype — AD5941 Eval Board + nRF52 Feather

> Start with dev boards on a breadboard before designing a custom PCB.

- [ ] **Step 1: Set up the AD5941 eval board**
  - Unbox EVAL-AD5941BATZ
  - Install Analog Devices' AD5941 example code library from their GitHub
  - Connect to PC via USB
  - Run the built-in chronoamperometry example to verify the board works
  - Connect to a test electrode (even a simple wire in saline) to see real signals

- [ ] **Step 2: Wire AD5941 eval board to nRF52 Feather via SPI**
  ```
  AD5941 Eval Board    →    nRF52 Feather
  ─────────────────         ──────────────
  SPI MOSI (SDI)     →     Pin 24 (MOSI)
  SPI MISO (SDO)     →     Pin 23 (MISO)  
  SPI SCLK           →     Pin 25 (SCK)
  SPI CS             →     Pin 7  (any GPIO)
  INT (interrupt)    →     Pin 11 (any GPIO)
  GND                →     GND
  VCC (3.3V)         →     3.3V
  ```

- [ ] **Step 3: Port AD5941 chronoamperometry code to run on nRF52**
  - Use Arduino IDE with Adafruit nRF52 board support package
  - Port the AD5941 SPI communication layer
  - Implement a basic chronoamperometry sequence:
    ```
    1. Configure AD5941 for chronoamperometry
    2. Set step voltage: +150 mV
    3. Set duration: 60 seconds
    4. Set sample rate: 10 Hz
    5. Read current values via SPI
    6. Store peak current
    ```

- [ ] **Step 4: Validate by measuring a known cortisol concentration**
  - Use a MIP electrode from Phase 1
  - Apply 50 ng/mL cortisol
  - Run the chronoamperometry from the nRF52
  - Compare result to what you got with the standalone potentiostat in Phase 2
  - Should match within 10-15%

### Task 3.2: Add BLE Data Transmission

- [ ] **Step 1: Define BLE service and characteristics**
  ```
  Service UUID: custom (e.g., 0xCOR1)
  
  Characteristics:
  - Cortisol Raw Reading (notify): float32, uA
  - Temperature (notify): float32, degrees C
  - Humidity (notify): float32, % RH
  - GSR (notify): float32, conductance uS
  - Na+ Reference (notify): float32, mV
  - Contact Quality (notify): uint8, 0-100
  - Sensor Status (read): uint8 (0=idle, 1=measuring, 2=error)
  - Measurement Trigger (write): uint8 (1=start measurement)
  ```

- [ ] **Step 2: Implement BLE GATT server on nRF52**
  - Use Adafruit Bluefruit library for Arduino
  - Create the custom service with all characteristics
  - Implement notify for sensor data
  - Implement write handler for measurement trigger

- [ ] **Step 3: Test with nRF Connect app (free, iOS/Android)**
  - Scan for the device
  - Connect and verify all characteristics are visible
  - Trigger a measurement and verify data arrives via notify

### Task 3.3: Custom PCB Design (for final pod form factor)

> Do this AFTER bench validation is complete. Use KiCad (free, open-source).

- [ ] **Step 1: Schematic**
  ```
  Core components:
  - nRF52832 (MDBT42Q module — includes antenna, crystal, matching)
  - AD5941BCPZ (potentiostat AFE)
  - TMP117 (I2C temperature)
  - SHT40 (I2C humidity)  
  - TP4056 (LiPo charger)
  - AP2112K-3.3 (LDO regulator)
  - LiPo battery connector (JST-SH 2-pin)
  - Magnetic charging pads (2 exposed pads on PCB edge)
  - Pogo pin pads (4 pins for sensor cartridge: WE, CE, RE, GND)
  - GSR electrode pads (2 exposed pads on bottom of PCB)
  - Test points for SPI, I2C, UART debug
  
  Power budget:
  - nRF52832 (BLE active): ~8 mA
  - AD5941 (measuring): ~5 mA
  - AD5941 (sleep): ~50 uA
  - TMP117: ~3.5 uA
  - SHT40: ~0.4 uA (idle)
  - Total active: ~15 mA
  - Total sleep: ~2 mA
  - 60 mAh battery → ~4 hours active, ~30 hours mixed use
  ```

- [ ] **Step 2: PCB layout**
  ```
  Board dimensions: 35 x 20 mm, 2-layer
  Stackup: standard 1.6mm FR4 (or 0.8mm to save height)
  
  Layout priorities:
  - AD5941 analog section isolated from digital/BLE
  - Short traces from pogo pads to AD5941 inputs
  - Ground plane on bottom layer
  - MDBT42Q antenna area: NO copper pour within 5mm of antenna
  - GSR pads on bottom layer, exposed through solder mask
  - Magnetic charging pads on board edge
  ```

- [ ] **Step 3: Order PCBs**
  - Export Gerbers from KiCad
  - Upload to JLCPCB
  - Order: 5 pcs, 2-layer, 0.8mm or 1.6mm, ENIG finish (for pogo pad durability)
  - Cost: ~$2-5 for 5 boards
  - Lead time: 2-5 days production + shipping

- [ ] **Step 4: Order components and solder**
  - Create DigiKey/Mouser cart from the BOM below
  - Solder with hot air station or reflow oven
  - Alternatively: use JLCPCB SMT assembly service for automated placement (~$30-50 setup for small batches)

---

## Phase 4: Environmental Compensation Sensors

### Goal
Add temperature, humidity, galvanic skin response, and sodium reference sensors for signal compensation.

### Components

| Item | Product | Supplier | Cost |
|------|---------|----------|------|
| TMP117 breakout | Adafruit TMP117 (#4821) | Adafruit | ~$6-8 |
| SHT40 breakout | Adafruit SHT40 (#4885) | Adafruit | $5.95 |
| GSR electrodes | Two stainless steel or gold pads on caseback | Self-fabricated or from electrode supplier | ~$1-2 |
| Na+ ISE (miniature) | Nano ISE Sodium | NT Sensors (ntsensors.com) | Quote required |

> **Note on Na+ ISE:** If NT Sensors is too expensive or hard to source for prototyping, skip the Na+ ISE initially. Temperature + humidity + GSR provide significant compensation already. Add Na+ normalization in v2.

### Task 4.1: Temperature + Humidity (Dev Board Phase)

- [ ] **Step 1: Wire breakouts to nRF52 Feather**
  ```
  TMP117 + SHT40 both use I2C:
  
  Adafruit Breakout    →    nRF52 Feather
  ───────────────           ──────────────
  SDA                 →     Pin 25 (SDA)
  SCL                 →     Pin 26 (SCL)
  VIN                 →     3.3V
  GND                 →     GND
  
  TMP117 default I2C address: 0x48
  SHT40 default I2C address: 0x44
  Both can share the same I2C bus
  ```

- [ ] **Step 2: Read and transmit over BLE**
  - Read TMP117 every 30 seconds (temperature changes slowly)
  - Read SHT40 every 30 seconds
  - Update BLE characteristics with new values

### Task 4.2: Galvanic Skin Response (GSR)

- [ ] **Step 1: Build simple GSR circuit**
  ```
  Two electrode pads on the device caseback (skin contact)
         │                    │
         │     ┌─────────┐   │
         ├─────┤ 100 kOhm├───┤
         │     │ resistor │   │
         │     └─────────┘   │
         │                    │
       3.3V              ADC pin (nRF52)
  
  The skin acts as a variable resistor.
  More sweat = lower resistance = higher voltage at ADC.
  Read the ADC value → convert to conductance.
  ```

- [ ] **Step 2: Read GSR on nRF52 ADC**
  - Use nRF52 built-in 12-bit ADC
  - Sample every 10 seconds
  - Apply a simple moving average (window of 5) to smooth noise

### Task 4.3: Contact Quality Check

- [ ] **Step 1: Use GSR electrodes for impedance check**
  - Before each cortisol measurement, briefly check skin impedance
  - If impedance > threshold (device not on skin or poor contact): skip measurement, flag as "no contact"
  - If impedance in normal range: proceed with measurement
  - This is firmware logic only — no additional hardware needed

---

## Phase 5: Firmware

### Goal
Firmware for the nRF52832 that orchestrates sensor readings, manages BLE communication, and handles power management.

### Task 5.1: Firmware Architecture

```
cortipod-firmware/
├── src/
│   ├── main.c                  // Entry point, scheduler
│   ├── ble_service.c           // BLE GATT service definition
│   ├── ble_service.h
│   ├── potentiostat.c          // AD5941 SPI driver + measurement sequences
│   ├── potentiostat.h
│   ├── sensors.c               // TMP117, SHT40, GSR reads
│   ├── sensors.h
│   ├── measurement_cycle.c     // Orchestrates: contact check → measure → transmit
│   ├── measurement_cycle.h
│   ├── power_mgmt.c            // Sleep modes, wake scheduling
│   └── power_mgmt.h
├── platformio.ini              // Or Makefile for Zephyr
└── README.md
```

- [ ] **Step 1: Set up development environment**
  - Option A (simpler): Arduino IDE + Adafruit nRF52 board package
  - Option B (more capable): PlatformIO + Zephyr RTOS
  - For prototyping, Arduino is faster to get working

- [ ] **Step 2: Implement measurement cycle**
  ```
  Every MEASUREMENT_INTERVAL (default: 15 minutes):
    1. Wake from sleep
    2. Check contact impedance via GSR
       - If no contact: log "no_contact", go back to sleep
    3. Read TMP117 (temperature)
    4. Read SHT40 (humidity)
    5. Read GSR (skin conductance)
    6. Run AD5941 chronoamperometry sequence (60 seconds)
    7. Extract peak current
    8. Package all readings into BLE notification:
       {
         timestamp: uint32 (seconds since boot),
         cortisol_raw_ua: float32,
         temperature_c: float32,
         humidity_pct: float32,
         gsr_us: float32,
         contact_quality: uint8
       }
    9. Transmit via BLE notify
    10. Go back to sleep
  ```

- [ ] **Step 3: Implement BLE connection handling**
  - Advertise when not connected
  - On connection: sync time, report battery level
  - On disconnect: continue measuring, buffer up to 50 readings in RAM
  - On reconnect: flush buffered readings to phone

- [ ] **Step 4: Implement power management**
  - nRF52832 System ON sleep between measurements (~2 uA)
  - AD5941 shutdown between measurements
  - Wake via RTC timer at configured interval

### Task 5.2: Firmware Testing

- [ ] **Step 1: Test BLE throughput**
  - Verify all 6 characteristics update correctly
  - Use nRF Connect app to monitor

- [ ] **Step 2: Test measurement cycle timing**
  - Verify 15-minute wake cycle
  - Verify measurement completes in < 90 seconds total

- [ ] **Step 3: Test battery life**
  - Run continuously for 24 hours
  - Log battery voltage over time
  - Target: > 16 hours on 60 mAh battery

---

## Phase 6: Enclosure + Mechanical

### Goal
Design and fabricate a Whoop-style wrist pod with sensor cartridge slot.

### Components

| Item | Supplier | Cost |
|------|----------|------|
| 3D print: pod enclosure (MJF PA12 or SLA resin) | JLCPCB 3D Print or Shapeways | ~$5-15 |
| 3D print: skin-contact option (BioMed Amber resin) | Xometry (Formlabs BioMed Amber) | ~$20-50 |
| Pogo pins (4x) | Mill-Max 0906 series | DigiKey, ~$1-1.50/ea |
| 2-pin magnetic charging connector | Magnetic pogo pair | AliExpress, ~$2-5/pair |
| 18mm silicone quick-release strap | Generic | Amazon, ~$5-8 |
| Neodymium magnets (for charging alignment) | 5mm x 1mm disc | K&J Magnetics (kjmagnetics.com), ~$0.50/ea |
| Conformal coating for PCB | MG Chemicals 422B | Amazon/DigiKey, ~$15 |
| Silicone RTV gasket | Permatex Ultra Black 82180 | Amazon, ~$8 |

### Task 6.1: CAD Design

- [ ] **Step 1: Design pod enclosure in Fusion 360 (free for personal use) or OnShape (free, browser-based)**
  ```
  Pod dimensions: ~38 x 22 x 10 mm (rounded rectangle)
  
  Features:
  ┌─────────────────────────────────────┐
  │ TOP SHELL                           │
  │  - Snap-fit to bottom shell         │
  │  - Strap lug holes (18mm spacing)   │
  │  - Magnetic charging pad holes      │
  │  - LED status indicator hole        │
  └─────────────────────────────────────┘
  
  ┌─────────────────────────────────────┐
  │ BOTTOM SHELL (skin-contact side)    │
  │  - Sensor cartridge slot            │
  │    (slide-in from the side)         │
  │  - GSR electrode pad windows        │
  │  - O-ring groove around perimeter   │
  │  - Pogo pin holes (4x)             │
  └─────────────────────────────────────┘
  
  Cross-section:
  
  strap lug ──┐    ┌── strap lug
              │    │
        ┌─────┴────┴─────┐
        │  top shell      │  1.5 mm
        │  PCB + battery  │  5.5 mm
        │  pogo pins      │  1.5 mm
        │  bottom shell   │  1.5 mm
        └──────┬┬┬────────┘
            sensor cartridge (flush with bottom)
               ││
             skin contact
  ```

- [ ] **Step 2: Design sensor cartridge**
  ```
  A thin carrier that holds the MIP electrode strip:
  
  ┌──────────────────────┐
  │  Cartridge body      │  ~30 x 15 x 2 mm
  │  ┌────────────────┐  │
  │  │ MIP electrode   │  │  Electrode snaps in or is glued
  │  │ strip           │  │
  │  └────────────────┘  │
  │  ○ ○ ○ ○             │  ← Contact pads (align with pogo pins)
  │  ▸ slide-in tab      │  ← Guides into pod slot
  └──────────────────────┘
  ```

- [ ] **Step 3: Order prints**
  - Export STL files
  - Upload to JLCPCB 3D printing (MJF PA12 for rigidity) or Shapeways
  - Order 3-5 copies (expect to iterate)
  - Cost: ~$5-15 per set

### Task 6.2: Assembly

- [ ] **Step 1: Apply conformal coating to PCB**
  - Spray MG Chemicals 422B on both sides of populated PCB
  - Avoid coating the pogo pin pads and charging pads (mask with tape)
  - Let cure 24 hours

- [ ] **Step 2: Solder pogo pins to PCB**
  - Mill-Max 0906 through-hole pogo pins
  - Solder from the top side, pins protrude through bottom shell

- [ ] **Step 3: Install magnets for charging alignment**
  - Press-fit or glue 5mm x 1mm neodymium disc magnets into the top shell
  - Align with matching magnets in the charging cable/dock

- [ ] **Step 4: Assemble and seal**
  - Place PCB + battery in bottom shell
  - Route battery wire to PCB connector
  - Apply silicone RTV to the O-ring groove
  - Snap top shell onto bottom shell
  - Let cure 24 hours
  - Attach 18mm strap

---

## Phase 7: iPhone App

### Goal
iOS app that connects to the CortiPod via BLE, receives raw sensor data, applies calibration and compensation algorithms, and displays cortisol trends.

### Task 7.1: Project Setup

- [ ] **Step 1: Create Xcode project**
  ```
  Project: CortiPod
  Language: Swift
  UI: SwiftUI
  Target: iOS 17+
  Frameworks: CoreBluetooth, Charts (SwiftUI Charts)
  ```

- [ ] **Step 2: File structure**
  ```
  CortiPod/
  ├── App/
  │   └── CortiPodApp.swift
  ├── BLE/
  │   ├── BLEManager.swift           // CoreBluetooth central manager
  │   └── CortiPodPeripheral.swift   // Device model + characteristic parsing
  ├── Models/
  │   ├── SensorReading.swift        // Raw reading struct
  │   ├── CalibratedReading.swift    // Post-compensation reading
  │   └── CalibrationProfile.swift   // Calibration curve coefficients
  ├── Processing/
  │   ├── SensorFusion.swift         // Temperature/humidity/GSR compensation
  │   └── CalibrationEngine.swift    // Raw current → ng/mL conversion
  ├── Views/
  │   ├── DashboardView.swift        // Main screen — current level + trend
  │   ├── HistoryView.swift          // 24h / 7d / 30d charts
  │   ├── CalibrationView.swift      // Manual calibration input
  │   └── DeviceView.swift           // Connection status, battery, sensor info
  └── Storage/
      └── ReadingStore.swift         // SwiftData or Core Data persistence
  ```

### Task 7.2: BLE Connection

- [ ] **Step 1: Implement BLEManager**
  ```swift
  class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
      @Published var isConnected = false
      @Published var latestReading: SensorReading?
      
      private var centralManager: CBCentralManager!
      private var cortiPod: CBPeripheral?
      
      // Scan for CortiPod service UUID
      // Connect, discover services + characteristics
      // Subscribe to notify characteristics
      // Parse incoming data into SensorReading
  }
  ```

- [ ] **Step 2: Implement data parsing**
  ```swift
  struct SensorReading: Codable, Identifiable {
      let id = UUID()
      let timestamp: Date
      let cortisolRawUA: Float    // raw current in microamps
      let temperatureC: Float
      let humidityPct: Float
      let gsrUS: Float            // skin conductance in microsiemens
      let contactQuality: UInt8   // 0-100
  }
  ```

### Task 7.3: Sensor Fusion + Calibration Engine

- [ ] **Step 1: Implement temperature compensation**
  ```swift
  struct SensorFusion {
      // Temperature coefficient: measured during Phase 2 calibration
      // Typically ~2-3% per degree C
      static func temperatureCompensate(rawUA: Float, tempC: Float, refTempC: Float = 25.0) -> Float {
          let tempCoeff: Float = 0.025  // 2.5% per degree — calibrate this empirically
          let correction = 1.0 + tempCoeff * (tempC - refTempC)
          return rawUA / correction
      }
      
      // GSR-based sweat rate normalization
      static func sweatNormalize(rawUA: Float, gsrUS: Float, refGSR: Float) -> Float {
          // Higher GSR = more sweat = more dilute cortisol
          // Scale factor determined empirically during calibration
          return rawUA * (gsrUS / refGSR)
      }
  }
  ```

- [ ] **Step 2: Implement calibration curve**
  ```swift
  struct CalibrationEngine {
      // Coefficients from Phase 2 calibration curve (log-linear fit)
      var slope: Float      // from calibration
      var intercept: Float  // from calibration
      
      func rawToConcentration(compensatedUA: Float) -> Float {
          // log-linear model: log(concentration) = slope * current + intercept
          let logConc = slope * compensatedUA + intercept
          return pow(10, logConc)  // ng/mL
      }
  }
  ```

- [ ] **Step 3: Implement confidence scoring**
  ```swift
  struct ConfidenceScore {
      static func calculate(reading: SensorReading) -> Float {
          var score: Float = 1.0
          
          // Penalize poor skin contact
          score *= Float(reading.contactQuality) / 100.0
          
          // Penalize extreme temperatures (sensor less reliable)
          if reading.temperatureC < 20 || reading.temperatureC > 38 {
              score *= 0.7
          }
          
          // Penalize very low GSR (may indicate dry skin / no sweat)
          if reading.gsrUS < 0.5 {
              score *= 0.5
          }
          
          return score  // 0.0 to 1.0
      }
  }
  ```

### Task 7.4: UI

- [ ] **Step 1: Dashboard view**
  - Large current cortisol reading (ng/mL) with confidence indicator
  - Mini trend chart (last 4 hours)
  - Status bar: connection, battery, sensor age

- [ ] **Step 2: History view**
  - Full 24-hour chart using SwiftUI Charts
  - Overlay: expected circadian curve (reference)
  - 7-day and 30-day views with daily averages
  - Highlight stress events (rapid rises)

- [ ] **Step 3: Calibration view**
  - Input field for known cortisol value (from saliva test kit)
  - Device takes a measurement simultaneously
  - Stores the (raw_current, known_concentration) pair
  - After 3+ calibration points: recalculates calibration curve
  - Shows calibration quality (R-squared value)

- [ ] **Step 4: Device management view**
  - Scan / connect / disconnect
  - Battery level
  - Sensor strip age (days since last replacement)
  - Measurement interval setting (5 / 15 / 30 min)
  - Firmware version

---

## Phase 8: On-Body Integration Testing

### Goal
Validate the complete system on a real human subject (yourself).

### Task 8.1: First On-Body Test

- [ ] **Step 1: Calibrate using saliva test kit**
  - Take a saliva cortisol test (Everlywell or ZRT Lab kit)
  - Simultaneously take a CortiPod measurement
  - Enter the saliva result into the app's calibration view
  - Repeat at 3 different times of day (morning peak, midday, evening)

- [ ] **Step 2: 24-hour wear test**
  - Wear the device for a full waking day (16+ hours)
  - Set measurement interval to 15 minutes
  - Note activities: meals, exercise, stress events, sleep
  - Review the cortisol curve in the app

- [ ] **Step 3: Evaluate**
  ```
  Check for:
  - Morning cortisol peak (should be highest reading of the day)
  - Gradual decline through afternoon
  - Any stress-related spikes correlating with noted events
  - Contact quality scores (should be >70% for most readings)
  - Reasonable values (8-150 ng/mL range)
  
  Red flags:
  - Flat line (sensor not responding)
  - All readings at same value (saturated or not regenerated)
  - Values outside physiological range
  - Frequent "no contact" flags (mechanical issue)
  ```

### Task 8.2: Multi-Day Validation

- [ ] **Step 1: Wear for 5 consecutive days**
  - Daily manual wash each evening (ethanol:acetic acid 9:1, 10 min)
  - Track daily cortisol patterns
  - Note any signal degradation over days

- [ ] **Step 2: Compare day 1 vs day 5 readings**
  - Calibration should hold
  - If baseline drifts >20%, sensor strip needs replacement

---

## Full BOM

### Electronics

| # | Item | Part Number | Supplier | Qty | Unit Cost | Total |
|---|------|-------------|----------|-----|-----------|-------|
| 1 | nRF52832 dev board | Adafruit #3406 | Adafruit | 1 | $24.95 | $24.95 |
| 2 | nRF52832 module (final) | MDBT42Q-512KV2, Adafruit #4077 | Adafruit | 2 | $9.95 | $19.90 |
| 3 | AD5941 eval board | EVAL-AD5941BATZ | DigiKey | 1 | $205.00 | $205.00 |
| 4 | AD5941 bare IC (final PCB) | AD5941BCPZ | DigiKey | 2 | $15.00 | $30.00 |
| 5 | TMP117 breakout | Adafruit #4821 | Adafruit | 1 | $7.00 | $7.00 |
| 6 | SHT40 breakout | Adafruit #4885 | Adafruit | 1 | $5.95 | $5.95 |
| 7 | LiPo 100mAh (prototyping) | Adafruit #1570 | Adafruit | 2 | $5.95 | $11.90 |
| 8 | LiPo 60mAh (final) | Custom micro cell | PowerStream | 2 | $8.00 | $16.00 |
| 9 | TP4056 charger module | — | Amazon | 2 | $0.50 | $1.00 |
| 10 | LDO AP2112K-3.3 | AP2112K-3.3TRG1 | DigiKey | 5 | $0.50 | $2.50 |
| 11 | Passive components (assorted) | 0402/0603 kit | Amazon | 1 | $12.00 | $12.00 |
| 12 | Pogo pins | Mill-Max 0906 series | DigiKey | 20 | $1.25 | $25.00 |
| 13 | Magnetic charging connector | 2-pin pogo pair | AliExpress | 3 | $3.00 | $9.00 |
| 14 | Custom PCB (5 pcs) | 35x20mm, 2-layer, ENIG | JLCPCB | 1 lot | $5.00 | $5.00 |
| 15 | Jumper wires (M-F dupont) | 40-pin ribbon pack | Amazon | 1 | $5.00 | $5.00 |
| 16 | Breadboard | Half-size solderless | Amazon | 1 | $5.00 | $5.00 |

**Electronics subtotal: ~$385**

### Chemistry / Sensor

| # | Item | Part Number | Supplier | Qty | Unit Cost | Total |
|---|------|-------------|----------|-----|-----------|-------|
| 17 | Screen-printed gold electrodes | DRP-220AT (75-pack) | Metrohm DropSens | 1 pack | ~$400 | $400.00 |
|    | *OR budget alternative:* Carbon SPEs | TE100 (40-pack) | Zensor/eDAQ | 1 pack | $83.00 | $83.00 |
| 18 | Pyrrole monomer 100mL | Cat. 131709 | Sigma-Aldrich | 1 | $40.00 | $40.00 |
| 19 | Hydrocortisone 1g | Cat. H4001 | Sigma-Aldrich | 1 | $35.00 | $35.00 |
| 20 | PBS tablets | Cat. P4417 | Sigma-Aldrich | 1 | $15.00 | $15.00 |
| 21 | Ethanol (reagent grade) | Cat. 459844 | Sigma-Aldrich | 1 | $25.00 | $25.00 |
| 22 | Acetic acid (glacial) | Cat. A6283 | Sigma-Aldrich | 1 | $20.00 | $20.00 |
| 23 | Gold chloride HAuCl4 | Cat. 520918 | Sigma-Aldrich | 1 | $80.00 | $80.00 |
| 24 | Sulfuric acid 0.5M | Cat. 339741 | Sigma-Aldrich | 1 | $25.00 | $25.00 |
| 25 | Micropipettes (set) | — | Amazon/Fisher | 1 | $75.00 | $75.00 |
| 26 | Pipette tips (box) | — | Amazon | 1 | $15.00 | $15.00 |
| 27 | Cortisol saliva test kits | Everlywell or ZRT | Amazon | 2 | $35.00 | $70.00 |

**Chemistry subtotal: ~$480 (with budget electrodes: ~$160)**

### Mechanical / Enclosure

| # | Item | Supplier | Qty | Unit Cost | Total |
|---|------|----------|-----|-----------|-------|
| 28 | 3D printed enclosure set | JLCPCB / Shapeways | 5 | $8.00 | $40.00 |
| 29 | Silicone strap (18mm) | Amazon | 3 | $6.00 | $18.00 |
| 30 | Conformal coating | MG Chemicals 422B | 1 | $15.00 | $15.00 |
| 31 | Silicone RTV gasket | Permatex 82180 | 1 | $8.00 | $8.00 |
| 32 | Neodymium magnets | K&J Magnetics | 10 | $0.50 | $5.00 |

**Mechanical subtotal: ~$86**

### Grand Total

| Category | Budget Path | Premium Path |
|----------|------------|-------------|
| Electronics | $385 | $385 |
| Chemistry / Sensor | $160 (carbon SPEs) | $480 (gold SPEs) |
| Mechanical | $86 | $86 |
| **Total** | **~$630** | **~$950** |

---

## Supplier Directory

| Supplier | What to order | URL | Notes |
|----------|---------------|-----|-------|
| **Adafruit** | nRF52 Feather, MDBT42Q, TMP117, SHT40, LiPo batteries | adafruit.com | US shipping, great docs |
| **DigiKey** | AD5941 eval board + IC, Mill-Max pogo pins, LDO, passives | digikey.com | Huge catalog, fast shipping |
| **Sigma-Aldrich** | Pyrrole, cortisol standard, PBS, solvents, HAuCl4 | sigmaaldrich.com | May require institutional account for some chemicals |
| **Metrohm DropSens** | Gold screen-printed electrodes (DRP-220AT) | metrohm-dropsens.com | Request quote, premium but best quality |
| **Zensor R&D / eDAQ** | Budget carbon SPEs (TE100) | edaq.com | Cheaper, requires gold electrodeposition step |
| **JLCPCB** | PCB fabrication + 3D printing | jlcpcb.com | Cheapest for small batches |
| **Amazon** | Micropipettes, tips, gloves, straps, TP4056, RTV, jumper wires, breadboard, misc | amazon.com | Convenience |
| **AliExpress** | Magnetic charging connectors, small LiPo batteries | aliexpress.com | Slow shipping, budget options |
| **PowerStream** | Custom small LiPo batteries | powerstream.com | US-based, low MOQ |
| **K&J Magnetics** | Neodymium disc magnets | kjmagnetics.com | US-based, single-unit ordering |
| **NT Sensors** | Miniature Na+ ISE (optional) | ntsensors.com | Spain, request quote |
| **Pine Research** | Custom SPE fabrication | pineresearch.com | US-based, prototyping service |
| **Sterling Electrode** | Custom SPE fabrication | sterlingelectrode.com | US-based, small batch |

---

## Build Sequence Summary

```
Week 1-2:  Order all components
           Set up potentiostat + dev boards
           
Week 3:    Phase 1 — Fabricate MIP sensors (1-2 days hands-on)
           Phase 2 — Bench validation + calibration curve

Week 4:    Phase 3 — Wire up electronics on breadboard
           Phase 4 — Add compensation sensors
           Validate: MIP + electronics working together on bench

Week 5-6:  Phase 5 — Write firmware
           Phase 7 — Start iPhone app (BLE + basic UI)
           Phase 3.3 — Design custom PCB (in parallel)

Week 7:    Order PCBs, assemble
           Phase 6 — Design + print enclosure
           Phase 7 — Complete app (calibration + charts)

Week 8:    Phase 6.2 — Final assembly
           Phase 8 — On-body testing

Week 9+:   Iterate based on results
```
