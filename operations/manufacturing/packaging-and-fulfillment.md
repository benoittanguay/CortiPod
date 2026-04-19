# Packaging and Fulfillment

> Consumer packaging design, electrode storage requirements, shipping compliance, and fulfillment logistics.

## Product SKUs

| SKU | Contents | Target price |
|-----|----------|-------------|
| CRTPD-STARTER | Shell + 3 electrodes + cradle + strap + cable + guide | $199-249 |
| CRTPD-REFILL-3 | 3 electrode PCBs (sealed pouches) + swap guide | $29-39 |
| CRTPD-STRAP-SIL | 18mm silicone strap (replacement) | $12-15 |
| CRTPD-STRAP-FAB | 18mm fabric strap (premium) | $20-25 |
| CRTPD-CRADLE | Replacement charging cradle + cable | $19-25 |

---

## Starter kit packaging

### Box design

```
Box exterior (closed):
┌─────────────────────────────┐
│                             │
│        [Brand logo]         │
│                             │
│    Continuous Cortisol       │
│       Monitoring            │
│                             │
│   [Product hero image]      │
│                             │
│                             │
└─────────────────────────────┘
Dimensions: ~140 × 100 × 45 mm (fits all contents with foam insert)
```

### Box interior layout

```
Box interior (lid open):
┌─────────────────────────────┐
│  Quick Start Guide (card)   │  ← top layer, first thing user sees
├─────────────────────────────┤
│ ┌───────┐  ┌──┐ ┌──┐ ┌──┐ │
│ │ Shell │  │E1│ │E2│ │E3│ │  ← form-fit tray
│ │(with  │  │  │ │  │ │  │ │     shell in main compartment
│ │strap) │  └──┘ └──┘ └──┘ │     3 electrode pouches in slots
│ └───────┘                  │
├─────────────────────────────┤
│ ┌─────────┐  ┌───────────┐ │
│ │ Cradle  │  │ USB-C     │ │  ← bottom compartment
│ │         │  │ cable     │ │
│ └─────────┘  └───────────┘ │
│        Regulatory insert    │
└─────────────────────────────┘
```

### Materials

| Component | Material | Spec | Source |
|-----------|----------|------|--------|
| Outer box | 350gsm SBS (solid bleached sulfate) | Matte lamination, custom print | Packlane (100+), BoxUp (1K+) |
| Insert tray | Molded pulp or EVA foam | Form-fit to components | Custom mold ($500-2K) or die-cut foam |
| Quick start guide | 350gsm card, folded | Full color, both sides | Local print shop |
| Regulatory insert | 80gsm paper, single sheet | Required text per regulatory path | Local print shop |
| Tamper seal | Clear shrink band or sticker | "Sealed for your safety" | Amazon/Uline |

### Cost per box (materials + assembly)

| Volume | Box + print | Insert | Printed materials | Labor | Total |
|--------|-------------|--------|-------------------|-------|-------|
| 100 | $3.00 | $1.00 | $0.50 | $1.00 | $5.50 |
| 1K | $1.50 | $0.50 | $0.30 | $0.50 | $2.80 |
| 10K | $0.80 | $0.30 | $0.15 | $0.20 | $1.45 |

---

## Electrode refill packaging

### Pouch design (individual electrode)

Each electrode is sealed in a moisture-barrier foil pouch immediately after QC pass.

| Component | Specification |
|-----------|---------------|
| Pouch material | Aluminum foil laminate (PET/Al/PE), heat-sealable |
| Pouch size | 50 × 60 mm (fits 22 × 24.6mm PCB with room for desiccant) |
| Desiccant | 1g silica gel sachet (meets MIL-D-3464) |
| Humidity indicator | Color-change card (blue = dry, pink = >30% RH) |
| Label | Batch #, date of manufacture, expiry date, QC stamp |
| Seal method | Impulse heat sealer (3mm seal width) |

### Refill box design

```
Refill pack exterior:
┌──────────────────────┐
│    [Brand logo]      │
│                      │
│  Electrode Refill    │
│     3-Pack           │
│                      │
│  [Batch info area]   │
└──────────────────────┘
Dimensions: ~80 × 70 × 20 mm
```

Interior: 3 pouches stacked with a thin card insert ("How to swap your electrode").

---

## Electrode storage and shelf life

### Environmental requirements

| Parameter | Storage spec | Rationale |
|-----------|-------------|-----------|
| Temperature | 2-25°C (room temp OK, avoid heat) | MIP polymer stability |
| Humidity | <30% RH (sealed pouch maintains this) | Prevents Ag/AgCl degradation |
| Light | Opaque pouch (no light exposure) | Some MIP monomers are photosensitive |
| Orientation | Any (no liquid inside) | Sealed dry electrode |
| Stacking | Up to 10 high | Pouch protects PCB from mechanical damage |

### Shelf life determination

**Required:** Accelerated aging study before commercial launch.

| Study type | Conditions | Duration | Equivalent real-time |
|------------|-----------|----------|---------------------|
| Accelerated | 45°C / 75% RH (in sealed pouch) | 4 weeks | ~6 months at 25°C |
| Accelerated | 45°C / 75% RH | 8 weeks | ~12 months at 25°C |
| Real-time (parallel) | 25°C / 60% RH | 6-12 months | Direct measurement |

**Test at each time point (3 electrodes from stored batch):**
- EIS impedance screen (compare to day-0 baseline)
- Cortisol spike response (compare ΔI to day-0)
- Visual inspection (corrosion, discoloration, delamination)
- Humidity indicator card check (pouch integrity)

**Pass criteria:** Impedance within ±30% of day-0 batch mean AND cortisol response >70% of day-0 mean.

**Target shelf life:** 6 months minimum (enables quarterly manufacturing + 3-month buffer). 12 months ideal (enables annual production planning).

### Implications for inventory management

| Shelf life | Manufacturing cadence | Max inventory | Risk |
|------------|----------------------|---------------|------|
| 3 months | Monthly batches | 1 month supply | High — just-in-time pressure |
| 6 months | Quarterly batches | 3 month supply | Moderate — manageable |
| 12 months | Semi-annual batches | 6 month supply | Low — comfortable buffer |

**If shelf life is <6 months:** Consider on-demand manufacturing — produce electrodes only after orders are placed. Longer fulfillment time (1-2 weeks) but no expiry risk.

---

## Shipping requirements

### Battery shipping compliance (UN 38.3)

The shell contains a 60mAh LiPo battery (lithium-ion). Shipping regulations depend on battery capacity.

| Parameter | CortiPod value | Threshold | Implication |
|-----------|---------------|-----------|-------------|
| Watt-hours | ~0.22 Wh (60mAh × 3.7V) | Section II: <100 Wh | Qualifies for relaxed Section II rules |
| Lithium content | ~0.02g Li equivalent | <1g for cells | Exempt from most requirements |
| Contained in equipment? | Yes (sealed in shell) | UN 3481 PI 967 Section II | Simplified labeling |

**What's required:**
- UN 38.3 testing certificate (from battery supplier or independent lab)
- Shipping label: "Lithium Ion Battery — Contained in Equipment"
- Packaging: device must be protected from short circuit and damage
- No Dangerous Goods declaration needed (under Section II exemption)
- Air freight: allowed on passenger aircraft (under 100 Wh)

**Estimated certification cost:** $2K-5K (one-time, can often be obtained from battery supplier)

### Electrode shipping (no special requirements)

Sealed electrode PCBs contain no batteries, liquids, or hazardous materials. Standard parcel shipping.

### Shipping methods

| Market | Method | Cost (starter kit) | Transit time |
|--------|--------|-------------------|--------------|
| Canada (domestic) | Canada Post Expedited Parcel | $8-12 | 2-5 business days |
| Canada (domestic) | Purolator Express | $12-18 | 1-2 business days |
| USA | USPS First Class International (< 0.5kg) | $10-15 | 5-10 business days |
| USA | UPS/FedEx International | $18-30 | 3-5 business days |
| International | Canada Post Small Packet Air | $12-20 | 7-15 business days |

**Package weight estimate:**
- Starter kit: ~180g (well under 0.5kg postal thresholds)
- Electrode refill: ~30g

---

## Fulfillment models

### Phase 1-2: Self-fulfillment

- Store inventory at home/office
- Pack and ship manually
- Use Shopify + Canada Post integration for labels
- **Pros:** Full control, low fixed cost
- **Cons:** Time-intensive, limited hours

### Phase 2-3: Hybrid

- Store shell units (low volume, high value) — self-fulfill
- Store electrode refills (high volume, subscription) — 3PL
- **3PL options in Quebec/Ontario:**
  - ShipBob (Montreal warehouse)
  - Fulfillment by Amazon (FBA) — if selling on Amazon
  - Shipfusion (Toronto)

### Phase 3+: Full 3PL

- All inventory at 3PL warehouse
- Automated subscription fulfillment (quarterly electrode shipments)
- **Typical 3PL costs:**
  - Storage: $0.50-1.00/cubic foot/month
  - Pick + pack: $2-4/order
  - Shipping: negotiated carrier rates (30-50% below retail)

---

## Subscription fulfillment

The electrode refill subscription is the recurring revenue engine.

### Subscription model

| Plan | Frequency | Electrodes/year | Price | Savings vs one-time |
|------|-----------|-----------------|-------|---------------------|
| Quarterly | Every 3 months | 12 (4 × 3-pack) | $99-119/year | 20-25% |
| Monthly | Every month | 12 (12 × 1-pack) | $119-139/year | 10-15% |
| Annual prepay | Once per year | 12 (4 × 3-pack) | $89-99/year | 30-35% |

### Subscription logistics

1. **Order management:** Shopify Subscriptions, Recharge, or Bold Subscriptions
2. **Recurring billing:** Stripe with automatic retry on failed payments
3. **Fulfillment trigger:** Subscription platform sends order to 3PL on schedule
4. **Inventory forecasting:** subscriber_count × 3 electrodes × (1 + 10% buffer) per quarter
5. **Churn handling:** pause/cancel/skip options reduce churn; track electrode usage via app data

### Electrode expiry management

- **FIFO (First In First Out):** critical if shelf life is limited
- **Expiry labeling:** each pouch has manufacture date + expiry date
- **Buffer stock calculation:** max_inventory = quarterly_demand × 1.3 (30% buffer, within shelf life)
- **Approaching expiry:** discount or donate units within 1 month of expiry

---

## Regulatory labeling requirements

### Wellness path (minimum required)

| Label element | Where | Example |
|---------------|-------|---------|
| Product name | Box front | "CortiPod Continuous Stress Monitor" |
| Manufacturer name + address | Box back | "CortiPod Inc., Quebec, Canada" |
| Country of origin | Box back | "Assembled in Canada. PCB: China. Battery: China." |
| BLE certification marks | Box back or insert | ISED (IC), FCC (if selling in US) |
| Battery warning | Box back or insert | "Contains lithium-ion battery. Do not disassemble." |
| Intended use disclaimer | Insert | "For wellness and fitness purposes only. Not a medical device." |
| Bilingual (EN/FR) | All elements | Required for Canadian market (Consumer Packaging and Labelling Act) |

### Medical device path (additional)

| Label element | Requirement |
|---------------|-------------|
| MDL number | Health Canada Medical Device Licence number |
| Device class | "Class II Medical Device" |
| Intended use | Specific cleared indication |
| UDI barcode | Unique Device Identifier (GS1 standard) |
| Lot/serial number | Traceability requirement |
| Sterility status | "Non-sterile" (electrode is not sterile) |
| IFU (Instructions for Use) | Detailed usage document (separate from quick start guide) |

---

## Unboxing experience

First impressions matter for a premium health wearable. The unboxing should feel comparable to Whoop or Oura.

### Sequence (what the user sees)

1. **Outer sleeve** (optional at scale) — slides off to reveal box
2. **Box lid lifts** — quick start card on top with "Welcome to CortiPod" and QR code to app
3. **Shell unit visible** — strap already attached, ready to wear
4. **Electrode pouches** — labeled "1", "2", "3" (user starts with #1)
5. **Bottom layer** — cradle + cable, regulatory insert

### Quick start card content

```
Side 1: Get Started in 3 Steps

1. Download the CortiPod app [QR code]
2. Open electrode pouch #1, slide into your CortiPod
   (push from the open end until you hear a click)
3. Put on your wrist and tap "Pair" in the app

Side 2: Swap Your Electrode

When the app says "Replace electrode" (~every 2-4 weeks):
1. Slide out the old electrode
2. Open a new pouch, slide in
3. Tap "New Electrode" in the app

Questions? support@cortxbio.com
```

All text bilingual (English + French) for Canadian market.
