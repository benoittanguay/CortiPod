# Assembly and Test Procedures

> Station-by-station assembly instructions, test protocols, and QC criteria for CortiPod production.

## Assembly overview

CortiPod final assembly is organized into **4 stations**. Stations 1-2 produce the sealed shell unit. Station 3 produces tested electrode consumables. Station 4 packages everything for the customer.

Stations 1-2 and Station 3 operate **independently** — electrode production can ramp without affecting shell assembly and vice versa.

```
Station 1             Station 2             Station 3             Station 4
Electronics     →     Shell Assembly   →                    →    Packaging
Integration           & Sealing              Electrode            & Shipping
                                             Preparation
                                             (parallel)
```

### Time targets per unit

| Phase | Station 1 | Station 2 | Station 3 | Station 4 | Total |
|-------|-----------|-----------|-----------|-----------|-------|
| Phase 1 (pilot, manual) | 10 min | 10 min | 35 min/batch of 20 | 5 min | ~25 min + batch |
| Phase 2 (fixtures) | 5 min | 5 min | 20 min/batch of 50 | 3 min | ~13 min + batch |
| Phase 3 (semi-auto) | 2 min | 3 min | Contracted out | 2 min | ~7 min |

---

## Station 1: Electronics integration

### Inputs

- Main PCBA (assembled, firmware flashed, from CM or JLCPCB)
- 4x Mill-Max 0906 pogo pins
- 60mAh LiPo battery with JST connector (or solder tabs)
- Conformal coating (if not applied at PCBA stage)

### Procedure

1. **Inspect main PCBA** — visual check for solder bridges, missing components, correct IC orientation
2. **Press-fit pogo pins** — insert 4x Mill-Max 0906 into plated through-holes on PCB underside
   - Pins should seat flush with PCB top surface
   - Verify pin tips protrude ~1.7mm below PCB bottom
   - Go/no-go: each pin compresses smoothly with spring return
3. **Solder battery leads** — connect LiPo to PCB power pads (or plug JST connector)
   - Polarity check: red = B+, black = GND
4. **Apply conformal coating** (if not done at CM) — spray or brush coat PCB top surface, avoiding pogo pin bores and BLE antenna area
5. **Run Station 1 functional test** (see below)

### Station 1 test: Electronics functional

| Test | Method | Pass criteria | Time |
|------|--------|---------------|------|
| Power on | Connect battery | LED blinks or current draw 5-15mA | 2 sec |
| BLE advertise | Scan with phone/dongle | "CortiPod-XXXX" appears within 5 sec | 5 sec |
| AD5941 respond | BLE command: `DIAG_EIS` | Returns impedance value (not timeout) | 3 sec |
| Battery voltage | BLE command: `DIAG_VBAT` | 3.3V-4.2V range | 1 sec |
| Temperature sensor | BLE command: `DIAG_TEMP` | 15-35°C (ambient) | 1 sec |
| Humidity sensor | BLE command: `DIAG_RH` | 20-80% RH (ambient) | 1 sec |
| **Total** | | All 6 pass | **~15 sec** |

**Fail action:** Tag PCB with failure mode, set aside for rework/diagnosis. Do not proceed to Station 2.

---

## Station 2: Shell assembly and sealing

### Inputs

- Tested electronics assembly (from Station 1)
- Shell (3D printed or injection molded)
- Adhesive pad for battery retention
- Seal material (UV-cure adhesive, or ultrasonic weld at scale)

### Procedure

1. **Inspect shell** — verify skin window is clear, channels are clean, no print defects blocking pogo bore holes
2. **Seat PCB on standoffs** — place main PCB assembly into shell cavity, PCB sits on 4 asymmetric standoffs
   - Verify PCB can only seat in one orientation (poka-yoke check)
   - Pogo pins should protrude through mating wall bores, tips visible from below
3. **Secure battery** — apply adhesive pad to shell wall, press battery into position above PCB
   - Route wires to avoid pinching
   - Verify battery does not interfere with shell closure
4. **Seal shell**
   - **Phase 1 (prototype):** UV-cure adhesive around the perimeter access opening, cure with UV lamp (30 sec)
   - **Phase 2+:** Ultrasonic welding on the shell top seam (if shell has weld boss features)
5. **Run Station 2 functional test** (see below)

### Station 2 test: Assembled shell

| Test | Method | Pass criteria | Time |
|------|--------|---------------|------|
| BLE through shell | Scan with phone at 1m distance | Connects within 5 sec | 5 sec |
| Pogo pin contact | Insert reference test electrode into channels | All 4 pins show <5Ω to test pads | 5 sec |
| EIS through pogo | Run EIS sweep via BLE with test electrode | Impedance magnitude within expected range | 10 sec |
| Charge test | Insert charging cradle, apply USB power | Battery voltage increasing, current >10mA | 10 sec |
| Detent click | Insert/remove test electrode 3x | Tactile click each time, smooth slide | 5 sec |
| **Total** | | All 5 pass | **~35 sec** |

### Production test fixture (Station 2)

A custom fixture that automates the shell test:

```
┌────────────────────────────────┐
│  Test fixture base             │
│  ┌──────────────────────────┐  │
│  │  Reference electrode     │  │  ← known-impedance dummy electrode
│  │  (gold-plated PCB with   │  │     with 4 contact pads and a calibrated
│  │   calibrated Randles     │  │     RC circuit on the sensing face
│  │   circuit on front)      │  │
│  └──────────────────────────┘  │
│                                │
│  Shell slides onto fixture     │
│  channels engage test electrode│
│  BLE dongle + USB power built  │
│  into fixture base             │
│                                │
│  [PASS/FAIL LED]  [LOG button] │
└────────────────────────────────┘
```

**Estimated build cost:** $500-2K (machined fixture base + reference electrode + BLE dongle + Raspberry Pi or similar for test automation)

---

## Station 3: Electrode preparation

### Inputs

- Bare electrode PCBs (from fab, stepped profile, ENIG finish)
- HAuCl4 solution (gold electrodeposition)
- Monomer solution (for MIP electropolymerization)
- Template molecule (cortisol)
- Ag/AgCl ink + stencil
- Nafion solution (optional)
- Desiccant packets
- Foil pouches (heat-sealable)
- Humidity indicator cards (HIC)

### Procedure

This station requires a **controlled environment** — not a cleanroom, but:
- Temperature: 20-25°C (±2°C)
- Humidity: <60% RH
- Clean bench or laminar flow hood for MIP steps
- ESD precautions not required (no active electronics)

#### Step 3.1: Gold electrodeposition

1. Mask non-WE areas using stencil (cortipod-stencil-gold.gbr)
2. Immerse electrode in HAuCl4 solution
3. Apply electrodeposition protocol (potential, time per existing bench protocol)
4. Rinse with DI water, air dry
5. **Visual QC:** gold film uniform on both WE pads, no delamination

#### Step 3.2: MIP electropolymerization

1. Prepare monomer + template solution (batch volume for N electrodes)
2. **Single mode:** Electropolymerize one electrode at a time using potentiostat
3. **Batch mode (Level 1.5+):** Immerse panel/multiple boards in shared bath, connect working electrodes in parallel
4. Run CV protocol (cycles, potential window per existing protocol)
5. Template removal: wash in acetic acid/methanol or ethanol/water
6. Rinse with DI water
7. **Control electrodes:** Process NIP electrodes in parallel (same procedure, no template)

#### Step 3.3: Reference electrode

1. Apply Ag/AgCl ink through stencil (cortipod-stencil-agagcl.gtp) onto RE pad
2. Cure per ink manufacturer instructions (typically 30 min at 80°C or UV cure)
3. **Visual QC:** uniform Ag/AgCl coverage, no smearing onto adjacent pads

#### Step 3.4: Nafion coating (optional)

1. Apply Nafion stencil (cortipod-stencil-nafion.gbr)
2. Drop-cast Nafion solution over sensing area
3. Air dry 30 min at room temperature
4. **Purpose:** Anti-fouling membrane, reduces interference from large proteins in sweat

#### Step 3.5: Electrode QC

**Test A — Impedance screen (every electrode, 30 seconds)**

| Measurement | Method | Pass criteria |
|-------------|--------|---------------|
| MIP WE impedance (EIS at 1kHz) | Potentiostat, 3-electrode | Rct within batch mean ±30% |
| NIP WE impedance (EIS at 1kHz) | Potentiostat, 3-electrode | Rct within batch mean ±30% |
| MIP/NIP ratio | Calculated | 0.5 < ratio < 2.0 (similar baseline) |
| CE continuity | Multimeter, CE pad to back contact | < 10Ω |
| RE potential | OCP vs Ag/AgCl reference | Within ±20mV of expected |

**Test B — Cortisol spike (3 per batch, destructive)**

| Measurement | Method | Pass criteria |
|-------------|--------|---------------|
| Baseline DPV | Scan in blank PBS | Stable, reproducible peak |
| 100nM cortisol spike | Add cortisol standard, wait 5 min, re-scan | ΔI > threshold (batch-specific) |
| MIP vs NIP differential | Compare MIP response to NIP response | MIP response > 2× NIP response |

**Fail action:**
- Test A fail: electrode rejected, record failure mode
- Test B fail: entire batch on hold, investigate root cause before continuing

#### Step 3.6: Individual packaging

1. Place passed electrode in foil pouch (moisture barrier)
2. Add desiccant packet (1g silica gel)
3. Add humidity indicator card (HIC, turns pink >30% RH)
4. Heat-seal pouch
5. Label with: batch number, date, QC pass stamp, expiry date (based on shelf life data)

---

## Station 4: Final packaging

### Box contents (starter kit)

| Item | Qty | Source |
|------|-----|--------|
| Sealed shell unit (tested) | 1 | Station 2 |
| Electrode PCB (sealed pouch) | 3 | Station 3 |
| Charging cradle | 1 | Manufacturing stream 5 |
| USB-C cable (1m) | 1 | Off-the-shelf |
| 18mm silicone strap | 1 | Off-the-shelf |
| Spring bars | 2 | Off-the-shelf |
| Quick start guide (printed card) | 1 | Print run |
| Regulatory/safety insert | 1 | Print run |

### Box contents (electrode refill pack)

| Item | Qty | Source |
|------|-----|--------|
| Electrode PCB (sealed pouch) | 3 | Station 3 |
| Quick swap guide (printed card) | 1 | Print run |

### Packaging procedure

1. **Final visual inspection** of shell unit (no cosmetic defects, strap attached cleanly)
2. Place shell in form-fit tray (EVA foam or molded pulp)
3. Place 3 electrode pouches in designated slots
4. Place cradle + cable in accessory compartment
5. Insert printed materials
6. Close box, apply tamper-evident seal
7. Apply shipping label with SKU, serial number (matching shell serial via BLE MAC)
8. **Scan barcode** — links serial number to production batch, test results, ship date in production database

---

## Traceability

Every shipped unit must be traceable back to:

| Data point | Where recorded | How linked |
|------------|---------------|------------|
| Shell serial number | BLE MAC address (burned into nRF52832) | Printed on box label |
| Main PCB batch | CM lot number | Production database |
| Electrode batch | Batch number on pouch label | Production database |
| Station 1 test results | Test log file | By PCB serial |
| Station 2 test results | Test log file | By shell serial |
| Electrode QC results | Test log file | By electrode batch + board ID |
| Ship date + customer | Fulfillment system | By shell serial |

**Why traceability matters:** If a field issue surfaces (e.g., electrodes from batch #47 consistently underperform), traceability lets you identify affected units, notify customers, and ship replacements. This is also a **regulatory requirement** for Class II medical device path.

---

## Equipment list

### Phase 1 (pilot, in-house)

| Equipment | Purpose | Cost | Source |
|-----------|---------|------|--------|
| Soldering station | Pogo pin install, battery connection | $100-300 | Hakko, Weller |
| Multimeter | Continuity checks | $50-100 | Fluke |
| UV cure lamp | Shell sealing (Phase 1 method) | $30-80 | Amazon |
| Potentiostat | MIP electropolymerization + electrode QC | $500-3K | PalmSens, Gamry |
| Heat sealer | Electrode pouch sealing | $50-200 | Amazon |
| Micrometer | Incoming PCB thickness inspection | $30-50 | Mitutoyo |
| Microscope (USB) | Visual inspection of electrodes and PCBs | $50-200 | Dino-Lite |
| BLE dongle + laptop | Functional testing | $20 + existing | Nordic nRF52840 dongle |
| **Total** | | **~$900-4K** | |

### Phase 2 (fixtures, 500+ units)

| Equipment | Purpose | Cost |
|-----------|---------|------|
| Production test fixture | Automated shell testing (Station 2) | $500-2K |
| Multi-channel potentiostat | Batch MIP + parallel electrode QC | $2K-5K |
| Label printer | Batch/serial labels for pouches and boxes | $200-500 |
| Barcode scanner | Traceability logging | $100-200 |
| **Additional** | | **~$3K-8K** |

### Phase 3 (semi-automated, 5K+ units)

| Equipment | Purpose | Cost |
|-----------|---------|------|
| Automated test system | Stations 1+2 combined, <30 sec/unit | $5K-15K |
| Pick-and-place for pogo pins | Automated pin insertion | $3K-8K |
| Ultrasonic welder | Shell sealing (replaces UV adhesive) | $5K-15K |
| Production database system | Traceability, batch management | $2K-5K (software) |
| **Additional** | | **~$15K-45K** |
