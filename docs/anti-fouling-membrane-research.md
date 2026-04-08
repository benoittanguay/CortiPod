# Anti-Fouling Membranes for MIP-Based Wearable Cortisol Sensors

> Researched 2026-04-07. Context: The CortiPod uses a polypyrrole (or poly-oPD) MIP on a gold electrode (DRP-220AT or MicruX IDE) to detect cortisol in sweat. Sweat contains proteins, lipids, shed keratinocytes, urea, lactic acid, and salts that foul the electrode surface over hours. An anti-fouling membrane placed OVER the MIP layer can extend sensor lifetime from hours to days. This document evaluates all candidate membrane materials.

---

## Table of Contents

1. [Why Anti-Fouling Matters](#why-anti-fouling-matters)
2. [Membrane Materials — Detailed Profiles](#membrane-materials)
3. [Compatibility with MIP Polypyrrole on Gold](#compatibility-with-mip-polypyrrole)
4. [Nafion Deep Dive](#nafion-deep-dive)
5. [Polyurethane Deep Dive](#polyurethane-deep-dive)
6. [Impact on Sensor Performance](#impact-on-sensor-performance)
7. [Recommended Protocol for CortiPod](#recommended-protocol-for-cortipod)
8. [Comparison Table](#comparison-table)
9. [User-Applied vs Factory-Applied](#user-applied-vs-factory-applied)
10. [Sources](#sources)

---

## Why Anti-Fouling Matters

Sweat is not clean water. It contains:

- **Proteins** (albumin, immunoglobulins, dermcidin): MW 10,000-150,000 Da. Adsorb non-specifically to electrode surfaces, blocking MIP cavities and reducing signal.
- **Lipids and sebaceous oils**: Hydrophobic films from skin sebum coat the electrode, forming an insulating barrier that disrupts electrical contact.
- **Shed keratinocytes**: Dead skin cells physically block the sensor surface.
- **Small-molecule interferents**: Uric acid (168 Da), ascorbic acid (176 Da), lactic acid (90 Da), glucose (180 Da). These can adsorb or undergo redox reactions that create false signals.

Without protection, a bare MIP electrode in continuous skin contact loses 30-70% of its signal within 4-8 hours due to biofouling. The CortiPod targets multi-day wear between electrode swaps, so an anti-fouling strategy is essential.

The ideal membrane for CortiPod must:
- **Pass cortisol** (MW 362.5 Da, neutral, hydrophobic steroid)
- **Block proteins** (MW >5,000 Da)
- **Block lipids and cellular debris**
- **Not interfere with MIP binding** (no chemical interaction with polypyrrole or the imprinted cavities)
- **Be thin enough** for fast response time (<5 minutes diffusion delay)
- **Be mechanically stable** under skin-contact conditions for 3-7 days

---

## Membrane Materials

### 1. Nafion (perfluorosulfonic acid polymer)

**What it is:** A perfluorinated polymer with sulfonate (-SO3-) side chains, manufactured by Chemours. The gold standard anti-fouling coating in electrochemical biosensors. Used in thousands of published papers.

**Mechanism:** Dual-mode protection.
- **Size exclusion:** The hydrophobic PTFE backbone and hydrophilic sulfonate channels create nanoscale (~4 nm) water-filled pores. Large proteins cannot enter these pores.
- **Charge exclusion (Donnan exclusion):** The negatively charged sulfonate groups repel anions (e.g., ascorbate, urate) while allowing cations to pass freely.

**What it blocks:** Proteins (albumin, immunoglobulins), anionic interferents (ascorbic acid, uric acid), lipids, large organic molecules (MW >1,000 Da).

**What it lets through:** Cations freely. Small neutral molecules pass via partitioning into the hydrophobic PTFE regions and/or diffusing through water channels. Cortisol (362.5 Da, neutral, moderately hydrophobic) does permeate through Nafion — its hydrophobic character actually facilitates partitioning into the fluorocarbon backbone regions. Published cortisol sensors using Nafion-modified electrodes confirm cortisol reaches the sensing surface.

**Application methods:**
- **Drop-casting** (most common for SPEs): Pipette 2-10 uL of diluted Nafion onto the working electrode area. Air dry.
- **Dip-coating:** Dip the entire electrode tip into dilute Nafion solution for 5-10 seconds, withdraw, dry. Repeat for multiple layers.
- **Spin-coating:** 5 uL at 2000-4000 RPM for 30 seconds. More uniform but requires a spin-coater.

**Typical concentration:** 0.5-5 wt% in ethanol or isopropanol (diluted from commercial 5% or 20% Nafion dispersion). Most biosensor papers use 0.5-2% for drop-casting and 5% for dip-coating.

**Thickness:** 0.1-2 um per layer (drop-cast from dilute solution). Thicker coatings (>5 um) dramatically increase diffusion delay and hysteresis.

**Durability:** Chemically stable for weeks to months in aqueous environments. Mechanically adherent to gold and carbon surfaces. Not degraded by sweat components.

**Cost:** ~$50-80 for 100 mL of 5% Nafion dispersion (Sigma-Aldrich, cat. 510211). Makes hundreds of electrodes.

---

### 2. Polyurethane (PU)

**What it is:** A block copolymer with alternating hydrophobic (polyether or polycarbonate) and hydrophilic (polyethylene oxide, PEO) segments. The membrane material in Dexcom CGM sensors.

**Mechanism:** Size-selective diffusion through hydrophilic microdomains. The hydrophobic matrix blocks large molecules. Small molecules diffuse through the PEO-rich channels. The ratio of hydrophobic to hydrophilic segments controls the molecular weight cutoff and diffusion rate.

**What it blocks:** Proteins, lipids, cellular debris. The Dexcom membrane achieves a 200:1 oxygen-to-glucose permeability ratio, demonstrating strong protein exclusion with excellent small-molecule transport.

**What it lets through:** Glucose (180 Da), oxygen, water, electrolytes. Cortisol (362.5 Da) would permeate through the hydrophilic channels — it is slightly larger than glucose but still well below the protein cutoff. The hydrophobic character of cortisol may also allow partitioning through the hydrophobic matrix domains.

**Application method (research/prototyping):**
- **Solvent casting:** Dissolve medical-grade PU (e.g., Tecoflex SG-80A or Chronoflex AR) in THF or DMAC at 2-10 wt%. Drop-cast 5-20 uL onto electrode. Dry at 40-60 C for 1-2 hours.
- **Dip-coating:** Dip electrode into 2-5 wt% PU solution in THF, withdraw slowly, dry at room temperature 2-4 hours or at 50 C for 30 minutes.

**Thickness:** 5-50 um (Dexcom targets ~38 um / 0.0015 inch). For a wearable sweat sensor, 5-15 um is appropriate — thinner than implantable sensors because sweat contact is intermittent and less aggressive than blood.

**Durability:** Excellent. PU membranes last 10-14 days in Dexcom CGMs under subcutaneous conditions. In sweat contact, easily 7+ days.

**Cost:** Medical-grade PU is expensive in small quantities ($100-300 for 25g). Tecoflex SG-80A from Lubrizol or Chronoflex AR from AdvanSource. For prototyping, generic biomedical-grade PU from Sigma-Aldrich works (cat. 81367, polyurethane from MDI/PTMEG).

---

### 3. Poly(ethylene glycol) (PEG) and PEG-based coatings

**What it is:** A hydrophilic polymer that forms a dense hydration layer on surfaces, sterically repelling protein adsorption. Used as surface coatings (grafted PEG brushes) or as crosslinked hydrogel networks (PEG-DGE, PEG-diacrylate).

**Mechanism:** The "water barrier" effect — PEG chains bind water molecules tightly, creating a hydration shell that proteins cannot displace. Proteins approaching the surface encounter an entropic penalty and are repelled.

**What it blocks:** Proteins (BSA adsorption reduced by 85-95%), lipids, cells.

**What it lets through:** Small molecules diffuse freely through the hydrated PEG network. Cortisol would pass easily — the hydrated mesh has an effective pore size of 1-10 nm, far larger than cortisol (~1 nm).

**Application methods:**
- **Surface grafting:** Requires surface activation (plasma treatment or chemical linker). Not practical for post-MIP application — would damage the polypyrrole.
- **Crosslinked hydrogel overlay:** Mix PEG-diglycidyl ether (PEGDE, 100 mg) with water (990 uL) and glycerol (10 uL). Drop-cast 5-10 uL. Cure at 55 C for 2 hours. This method is compatible with MIP layers.

**Thickness:** 1-10 um (crosslinked hydrogel).

**Durability:** Limited. PEG is susceptible to oxidative degradation. In biological fluids, PEG coatings lose effectiveness within 1-2 weeks. In cell culture studies, PEG-based coatings lost signal within one week. For sweat applications, expect 3-7 days.

**Cost:** Cheap. PEGDE (Sigma, cat. 475696) ~$30 for 100 mL.

---

### 4. Zwitterionic Polymers (pCBMA, pSBMA, pMPC)

**What it is:** Polymers bearing both positive and negative charges on the same monomer unit (e.g., sulfobetaine, carboxybetaine, phosphorylcholine). The strongest known anti-fouling materials — superior to PEG.

**Mechanism:** Electrostatically induced hydration. Zwitterionic surfaces bind water even more tightly than PEG through ionic solvation, creating an impenetrable hydration barrier. Proteins are repelled with >99% efficiency in some studies.

**What it blocks:** Proteins, lipids, bacteria, cells. Zwitterionic coatings have been shown to resist fouling in undiluted blood serum and 100% bovine serum.

**What it lets through:** Small molecules pass freely. The zwitterionic layer has high ionic conductivity, so it does not impede electrochemical measurements. Cortisol would permeate with minimal resistance.

**Application methods:**
- **Electropolymerization of zwitterionic monomers** (e.g., SBMA) onto the electrode surface. This deposits the coating directly but requires the electrode to be exposed to the monomer solution AFTER MIP fabrication — potential risk of damaging the MIP.
- **Surface-initiated polymerization** from anchored initiators. Requires surface chemistry not compatible with post-MIP application.
- **Drop-cast pre-polymerized zwitterionic hydrogel.** Most compatible with the CortiPod workflow: synthesize the hydrogel separately, dissolve/suspend, drop-cast over the MIP.

**Thickness:** 10-100 nm (grafted brushes) or 1-10 um (hydrogel overlay).

**Durability:** Excellent chemical stability (no oxidative degradation like PEG). In implantable sensors, zwitterionic coatings have demonstrated anti-fouling efficacy for 30+ days. In sweat: conservatively 7-14 days.

**Cost:** Moderate. Zwitterionic monomers (e.g., SBMA, Sigma cat. 537284) ~$50-80 for 25g. Requires synthesis step, unlike Nafion or PU which are ready to use.

---

### 5. Bovine Serum Albumin (BSA)

**What it is:** A globular protein (~66 kDa) that, when crosslinked with glutaraldehyde, forms a hydrogel barrier on electrode surfaces. The crosslinked BSA network blocks other proteins from reaching the surface through competitive occupation of binding sites.

**Mechanism:** Surface passivation — the crosslinked BSA layer occupies all non-specific adsorption sites, preventing subsequent protein fouling. Also provides a size-exclusion barrier.

**What it blocks:** Proteins via competitive passivation.

**What it lets through:** Small molecules including cortisol diffuse through the porous BSA hydrogel.

**Application protocol:**
- **Direct adsorption + crosslinking:** Dip electrode in 1-10 mg/mL BSA in PBS for 30-60 minutes. Rinse. Then expose to 0.5-2.5% glutaraldehyde vapor or solution for 15-30 minutes. Rinse thoroughly.
- **Pre-mixed hydrogel:** Mix 150 mg BSA + 100 mg PEGDE + 990 uL water + 10 uL glycerol. Drop-cast 5-10 uL. Cure 55 C for 2 hours.

**Thickness:** 1-5 um.

**Durability:** Poor to moderate. Published studies show BSA blocking layers provide anti-fouling for hours to days, not weeks. The BSA can be displaced by other proteins in sweat. In cell culture studies, BSA alone showed "no protective properties." Crosslinked BSA hydrogels perform better but are still outperformed by Nafion and zwitterionic materials.

**Cost:** Very cheap. BSA (Sigma, cat. A7906) ~$20 for 10g.

**CortiPod assessment:** Not recommended as the primary anti-fouling layer. BSA is typically used as a blocking agent for immunosensors, not as a standalone membrane. It could be used in combination with another membrane (e.g., BSA blocking + Nafion overlay), but adds complexity without sufficient benefit for a wearable application.

---

### 6. Poly(2-hydroxyethyl methacrylate) (pHEMA)

**What it is:** A hydrophilic hydrogel polymer. Swells in water to form a soft, biocompatible gel. Used in contact lenses (38% water content). Recently demonstrated in wearable sweat sensors for glucose detection.

**Mechanism:** Hydration barrier (similar to PEG) plus physical size exclusion through the hydrogel mesh. The 3D network absorbs and retains sweat, creating a reservoir that delivers analyte to the sensor while filtering particulates.

**What it blocks:** Proteins (partial — less effective than Nafion or zwitterionics), keratinocytes, lipid droplets.

**What it lets through:** Small molecules freely. Glucose (180 Da) diffuses readily. Cortisol (362.5 Da) would also permeate, though slightly slower due to its larger size and hydrophobic character (pHEMA is hydrophilic — cortisol partitioning into the gel may be slower than through Nafion).

**Application protocol:**
- **UV-crosslinked hydrogel:** Mix HEMA monomer with crosslinker (EGDMA, 1-2 mol%) and photoinitiator (Irgacure 2959, 1 wt%). Drop-cast 5-10 uL onto electrode. UV cure (365 nm) for 5 minutes.
- **Free radical polymerization (recent protocol for sweat sensors):** HEMA monomer + APS initiator at 60 C for 2-4 hours. Pre-form the hydrogel, then cut to size and place over electrode.

**Thickness:** 10-100 um (swellable — thickness increases when hydrated).

**Durability:** Moderate. pHEMA is mechanically stable but can delaminate from electrode surfaces when swelling. Contact lens pHEMA lasts weeks, but on a sensor surface, 3-7 days is realistic. In cell culture studies, pHEMA-based coatings showed complete signal loss after two weeks.

**Cost:** Cheap. HEMA monomer (Sigma, cat. 128635) ~$25 for 100 mL.

---

### 7. Cellulose Acetate (CA)

**What it is:** A semi-synthetic polymer derived from cellulose. Forms thin, porous membranes by solvent casting and phase inversion. One of the oldest anti-fouling membranes in biosensor history — used in first-generation glucose sensors in the 1960s.

**Mechanism:** Size exclusion through nanopores. The pore size and MWCO are controlled by the casting conditions (solvent, temperature, humidity). Base hydrolysis after casting can increase porosity.

**What it blocks:** Proteins (albumin, immunoglobulins), lipids, ascorbic acid, uric acid — IF the MWCO is set below ~500 Da. CA membranes with MWCO of 100-500 Da effectively reject these interferents.

**What it lets through:** Cortisol (362.5 Da) is right at the critical size. Depending on the CA formulation and hydrolysis conditions, cortisol permeation can range from good to poor. This is a significant risk — the MWCO must be carefully tuned. If the membrane is too tight, cortisol is partially blocked; if too loose, proteins leak through.

**Application protocol:**
- **Drop-cast from acetone solution:** Dissolve CA in acetone (2-5 wt%). Drop-cast 5-10 uL. Evaporate at room temperature (acetone evaporates in ~60 seconds). The rapid evaporation creates a dense, low-porosity film.
- **Phase inversion:** Cast from acetone/water mixture. When acetone evaporates, water absorption triggers phase separation, creating an asymmetric membrane with a dense skin and porous sublayer. More complex but allows MWCO control.
- **Base hydrolysis (post-cast):** Soak the CA membrane in 0.07 M KOH for 20-60 minutes. This partially deacetylates the CA, increasing hydrophilicity and porosity. Essential for ensuring small-molecule permeation.

**Thickness:** 0.5-5 um (drop-cast). Can be controlled by solution concentration and drop volume.

**Durability:** Good. CA is chemically stable in sweat pH (4.5-7). Lasts weeks without degradation. However, thick CA membranes can crack when dry.

**Cost:** Very cheap. Cellulose acetate (Sigma, cat. 419028) ~$25 for 100g.

**CortiPod assessment:** Risky for cortisol because MW 362.5 Da is right at the cutoff boundary. Would require careful optimization of the hydrolysis step to ensure cortisol permeation while maintaining protein rejection. Not recommended as the primary choice when Nafion or PU are available.

---

## Compatibility with MIP Polypyrrole on Gold

The anti-fouling membrane is applied AFTER MIP fabrication and template removal. The key compatibility concerns are:

### Chemical compatibility

| Membrane | Solvent used for casting | Risk to polypyrrole MIP | Risk to gold electrode | Verdict |
|----------|------------------------|------------------------|----------------------|---------|
| Nafion | Ethanol/IPA/water mix | None. Polypyrrole is insoluble in alcohols. | None. Gold is inert. | **Compatible** |
| Polyurethane | THF or DMAC | **THF is a concern** — it can swell polypyrrole slightly. DMAC is less aggressive. Use brief contact time. | None. | **Compatible with care** |
| PEG (PEGDE crosslinked) | Water | None. | None. | **Compatible** |
| Zwitterionic hydrogel | Water | None. | None. | **Compatible** |
| BSA + glutaraldehyde | Water/PBS | Glutaraldehyde can react with amine groups in polypyrrole. Could modify MIP cavities. | None. | **Risky** |
| pHEMA | Water or ethanol | None. | None. | **Compatible** |
| Cellulose acetate | Acetone | **Acetone is a strong risk** — it can dissolve or swell polypyrrole. | None. | **Risky** |

### Electrostatic compatibility

Cortisol is a neutral molecule (no net charge at physiological pH). The MIP cavities in polypyrrole recognize cortisol through shape complementarity, hydrogen bonding, and van der Waals forces — NOT through electrostatic interactions.

This means:
- **Nafion's sulfonate groups** will not attract or repel cortisol directly. Cortisol will partition through Nafion via the hydrophobic PTFE domains, bypassing the sulfonate channels. The sulfonates will not interfere with MIP binding because they are in the membrane layer above, not inside the MIP cavities.
- **Zwitterionic polymers** are charge-neutral overall, so they will not interfere with cortisol binding.
- **PEG and pHEMA** are non-ionic, so no electrostatic interference.

### Molecular weight cutoff requirements

| Species | MW (Da) | Must pass? | Notes |
|---------|---------|-----------|-------|
| Cortisol | 362.5 | YES | The target analyte |
| Water | 18 | YES | Sweat carrier |
| Na+, K+, Cl- | 23-39 | YES | Maintain ionic conductivity for electrochemistry |
| Lactic acid | 90 | Ideally NO | Minor interferent, but some permeation is OK — MIP is selective |
| Uric acid | 168 | Ideally NO | Electroactive interferent (anodic) |
| Ascorbic acid | 176 | Ideally NO | Electroactive interferent (anodic) |
| Glucose | 180 | Neutral | Neither helps nor hurts |
| Cortisone | 360.4 | Doesn't matter | Structural analog — membrane cannot distinguish; MIP provides selectivity |
| Dermcidin | 4,702 | NO | Most abundant antimicrobial protein in sweat |
| Albumin | 66,500 | NO | Major fouling protein |
| IgG | 150,000 | NO | Major fouling protein |

**Ideal MWCO: 500-1,000 Da.** This passes cortisol and necessary electrolytes while blocking all proteins. Nafion, PU, and PEG all meet this requirement. Cellulose acetate is borderline.

---

## Nafion Deep Dive

### How Nafion interacts with cortisol

Nafion is a cation-exchange membrane, but this does NOT mean it only passes cations. Nafion's transport properties depend on the permeant:

1. **Cations** (Na+, K+, H+): Pass freely through hydrophilic sulfonate channels via Grotthuss mechanism and migration. Fastest transport.
2. **Anions** (ascorbate, urate): Repelled by Donnan exclusion (negative sulfonate groups repel negative species). Transport reduced by 90-99%.
3. **Neutral small molecules** (cortisol, glucose, acetaminophen): Permeate through two pathways:
   - **Hydrophobic partitioning** into the PTFE backbone matrix (dominant for hydrophobic molecules like cortisol, logP ~1.6)
   - **Diffusion through water channels** (dominant for hydrophilic molecules like glucose)
   Cortisol's moderate hydrophobicity means it partitions favorably into the fluorocarbon regions of Nafion, which actually enhances its transport relative to hydrophilic molecules of similar size.
4. **Proteins** (MW >5,000): Completely excluded by size — cannot enter the ~4 nm channels.

**Key evidence that cortisol permeates Nafion:** Multiple published cortisol sensors use Nafion-modified electrodes (including Nafion/CoO/GCE achieving 0.49 nM LOD for hydrocortisone, and Nafion-based immunosensors detecting cortisol at 0.1 ng/mL). If Nafion blocked cortisol, these sensors would not work.

### Nafion application protocols for screen-printed electrodes

**Protocol A: Simple drop-cast (recommended for CortiPod prototyping)**

```
Materials:
- Nafion 5% dispersion in lower aliphatic alcohols (Sigma-Aldrich 510211, ~$65/100mL)
- Ethanol, reagent grade
- Micropipette (1-10 uL)

Preparation:
1. Dilute Nafion to 0.5 wt%: Add 100 uL of 5% Nafion stock to 900 uL ethanol.
   Mix gently (do not vortex — creates bubbles in the film).
2. Store diluted solution in a glass vial, sealed. Stable for months at room temperature.

Application:
1. Ensure the MIP electrode is clean and dry (after template removal and PBS rinse).
2. Pipette 3 uL of 0.5% Nafion onto the working electrode area (4 mm diameter).
   - Hold the pipette tip ~1 mm above the surface.
   - Dispense slowly. The drop should spread across the electrode by capillarity.
   - Do NOT touch the MIP surface with the pipette tip.
3. Air dry at room temperature (20-25 C) for 30-60 minutes.
   - Place in a clean, dust-free environment (petri dish with lid slightly open).
   - Do not use forced air or heat — slow drying produces a more uniform film.
4. For a second layer (optional, for better anti-fouling):
   - Wait until the first layer is fully dry (no visible wetness, ~60 min).
   - Apply another 3 uL of 0.5% Nafion.
   - Dry 30-60 minutes.

Result: ~0.2-0.5 um Nafion film. Transparent, glossy appearance.
```

**Protocol B: Dip-coat (for batch processing multiple electrodes)**

```
1. Pour 5% Nafion stock into a small glass dish (enough to submerge the electrode tip).
2. Dip the electrode (working electrode end) into the Nafion solution for 5 seconds.
3. Withdraw slowly (~1 mm/sec) to allow excess to drain.
4. Dry at room temperature for 60 minutes.
5. Optional: cure at 120 C for 30 minutes for better mechanical adhesion.
   - WARNING: 120 C may degrade polypyrrole. If using this protocol on MIP electrodes,
     reduce to 60 C for 60 minutes or skip the heat step entirely.
6. Repeat dip 1-2 more times for additional layers.

Result: ~1-2 um Nafion film per dip. Thicker and more robust than drop-casting.
Tradeoff: Higher diffusion barrier = slower response time.
```

### Will Nafion's sulfonate groups affect MIP binding?

No, for three reasons:

1. **Spatial separation:** The Nafion membrane sits ON TOP of the MIP layer. It is not inside the MIP cavities. Cortisol passes through the Nafion, then enters the MIP cavity. The sulfonate groups never contact the binding site.

2. **Cortisol is neutral:** Sulfonates interact electrostatically with charged species. Cortisol has no net charge, so there is no electrostatic interaction between the sulfonates and cortisol as it transits through the membrane.

3. **Empirical evidence:** Nafion has been used over polypyrrole-based sensors for other analytes without disrupting the polymer's recognition properties. The polypyrrole nitrogen groups are protonated (positively charged) in acidic conditions, but at sweat pH (4.5-7), the interaction with Nafion sulfonates at the interface is minimal and occurs only at the top surface of the polypyrrole film — not within the MIP cavities below.

---

## Polyurethane Deep Dive

### Research/prototyping protocol for PU membranes

The Dexcom manufacturing protocol (DMAC solvent, knife-over-roll casting, 120-150 C drying) is designed for industrial-scale production. For lab prototyping on individual electrodes:

**Protocol: Solvent-cast PU membrane on SPE**

```
Materials:
- Medical-grade polyurethane pellets:
  Option 1: Tecoflex SG-80A (Lubrizol) — polyether-based, soft, biocompatible
  Option 2: Chronoflex AR (AdvanSource) — polycarbonate-based, supplied as 22% solution in DMAC
  Option 3: Generic biomedical PU (Sigma 81367) — cheaper, adequate for prototyping
- THF (tetrahydrofuran), anhydrous (Sigma 186562)
- Micropipette (10-100 uL)

Preparation (if starting from pellets):
1. Weigh 0.5 g PU pellets into a glass vial.
2. Add 10 mL THF (= 5 wt% solution).
3. Seal vial and stir at room temperature for 4-12 hours until fully dissolved.
   Some PU grades dissolve faster in THF/DMAC 1:1 mixture.
4. Filter through 0.45 um syringe filter to remove undissolved particles.

Preparation (if using Chronoflex AR solution):
1. Dilute the 22% DMAC stock to 5% by adding DMAC.
   Example: 2.3 mL stock + 7.7 mL DMAC = 10 mL of 5% solution.

Application:
1. Ensure MIP electrode is clean and dry.
2. Pipette 5-10 uL of 5% PU/THF solution onto the working electrode.
   - THF evaporates fast (~30 seconds for the bulk), so work quickly.
   - A single drop of 5 uL at 5 wt% PU produces ~10-15 um dry film on a 4 mm electrode.
3. Allow solvent to evaporate: room temperature, 2-4 hours for THF; 4-8 hours for DMAC.
   - For DMAC, heating to 50-60 C for 1-2 hours accelerates drying.
4. Optional second layer for thicker membrane.

Result: 10-20 um PU membrane. Translucent, slightly rubbery.

CAUTION: THF can slightly swell polypyrrole. Minimize contact time:
- Use a low volume (5 uL) so the THF evaporates quickly.
- Work in a well-ventilated area (THF fumes).
- Consider switching to DMAC if polypyrrole damage is observed.
  DMAC evaporates slower but is less aggressive to polypyrrole.
```

### Does PU let cortisol through?

Yes. The hydrophilic PEO segments in medical-grade PU form water-swollen channels with an effective pore size of 1-5 nm. Cortisol (molecular diameter ~1 nm) passes through these channels. The Dexcom membrane passes glucose (180 Da) efficiently — cortisol at 362.5 Da is larger but still well within the permeation range for hydrophilic channels.

The diffusion rate through PU is slower than through Nafion (thicker membrane, denser matrix), so expect a response time increase of 2-5 minutes compared to a bare electrode.

---

## Impact on Sensor Performance

### Quantitative estimates by membrane type

| Parameter | No membrane (bare MIP) | Nafion (0.5%, 1 layer, ~0.3 um) | Nafion (5%, dip, ~2 um) | PU (~15 um) | PEG hydrogel (~5 um) | CA (~2 um) |
|-----------|----------------------|-------------------------------|------------------------|------------|---------------------|-----------|
| **Sensitivity** (% of bare) | 100% | 70-85% | 50-70% | 40-70% | 75-90% | 50-80% |
| **Response time** (t90) | 30-60 sec | 1-2 min | 3-5 min | 5-10 min | 1-3 min | 2-5 min |
| **Detection limit** | Best (1-10 nM) | Slightly worse (2-20 nM) | Moderately worse | Moderately worse | Slightly worse | Variable |
| **Linearity range** | Maintained | Maintained | May compress at high end | May compress | Maintained | May compress |
| **Operational lifetime** | 4-8 hours | 3-7 days | 5-10 days | 7-14 days | 3-7 days | 5-10 days |
| **Baseline stability** | Poor (drift) | Good | Very good | Excellent | Good | Good |

**Key tradeoffs:**

1. **Nafion (thin, 0.5%, single layer):** The best balance for CortiPod. Loses ~15-30% sensitivity but extends lifetime from hours to days. Response time increases by <1 minute — acceptable for a 15-minute measurement interval. This is the recommendation.

2. **PU:** Best anti-fouling durability but the thickest membrane, causing the most diffusion delay. Best for sensors where a 5-10 minute response time is acceptable.

3. **PEG/zwitterionic:** Best anti-fouling per unit thickness, minimal sensitivity loss, but PEG degrades faster than Nafion and zwitterionics are harder to apply.

4. **CA:** The wildcard. Could work well for cortisol if the MWCO is properly tuned, but the optimization required is substantial and the risk of partially blocking cortisol is real.

### How membranes affect EIS (impedimetric) measurements on IDEs

If CortiPod moves to IDE-based impedimetric sensing:
- The membrane adds a parallel impedance element (membrane resistance + capacitance) to the equivalent circuit.
- Nafion (thin) has high ionic conductivity and adds minimal impedance — well-suited for EIS.
- PU (thicker) adds more impedance and may shift the optimal measurement frequency.
- The membrane capacitance can be characterized during calibration and subtracted.
- For single-frequency tracking at 100 Hz, a thin Nafion layer has negligible impact on impedance magnitude change from cortisol binding.

---

## Recommended Protocol for CortiPod

### Primary recommendation: Nafion (0.5%, single layer, drop-cast)

This is the simplest, most well-characterized, and most compatible option for the CortiPod MIP polypyrrole electrode.

**Complete step-by-step protocol:**

```
WHEN: After MIP fabrication and template removal are complete.
      The electrode has been washed in ethanol:acetic acid (9:1),
      rinsed with PBS, and air-dried.

MATERIALS:
- Nafion 5 wt% dispersion in lower aliphatic alcohols
  (Sigma-Aldrich 510211 or equivalent)
- Ethanol, reagent grade (same bottle used for template removal)
- Clean glass vial with cap (for diluted Nafion)
- Micropipette, 1-10 uL range
- Fresh pipette tip
- Clean petri dish or covered container for drying

STEP 1: Prepare 0.5% Nafion solution (one-time, lasts months)
  a. Label a clean glass vial "0.5% Nafion"
  b. Pipette 100 uL of 5% Nafion stock into the vial
  c. Add 900 uL of ethanol
  d. Cap and invert gently 5 times to mix
     - Do NOT shake vigorously or vortex
  e. Store at room temperature, sealed. Stable indefinitely.

STEP 2: Apply Nafion to the MIP electrode
  a. Place the MIP electrode (DRP-220AT) on a flat, clean surface
  b. Verify the working electrode area is dry (no visible liquid)
  c. Set micropipette to 3 uL
  d. Draw up 3 uL of 0.5% Nafion solution
  e. Position the pipette tip ~1 mm above the center of the
     working electrode (4 mm gold disc)
  f. Slowly dispense the 3 uL drop onto the electrode center
  g. The solution should spread across the electrode by itself
     - If it does not spread evenly, gently tilt the electrode
     - Do NOT touch the MIP surface
  h. Place the electrode in a clean petri dish with the lid
     cracked open (~2 mm gap for airflow)

STEP 3: Dry
  a. Leave at room temperature (20-25 C) for 60 minutes
  b. Do not disturb during drying
  c. After 60 minutes, the electrode should look clear/glossy
     with no visible liquid

STEP 4: Verify (optional but recommended)
  a. Run a baseline EIS or CV measurement in PBS
  b. Compare to the pre-Nafion baseline
  c. You should see:
     - Slightly increased charge transfer resistance (Rct)
     - Slightly reduced peak currents in CV (~15-30% reduction)
     - These changes confirm the Nafion layer is present

STEP 5: Store
  a. Store the Nafion-coated MIP electrode in PBS at 4 C (fridge)
  b. Use within 2 weeks for best performance
  c. Before use, equilibrate to room temperature for 15 minutes

TOTAL TIME: ~5 minutes hands-on + 60 minutes drying
COST PER ELECTRODE: <$0.01 (3 uL of diluted Nafion)
```

### Alternative recommendation: PU membrane (for maximum lifetime)

If testing shows that Nafion alone does not provide sufficient anti-fouling for multi-day wear, add a PU overlayer:

```
STEP 1: Apply Nafion first (Protocol above)
STEP 2: After Nafion is dry, apply PU:
  a. Prepare 2% PU/THF solution (dissolve 0.2g PU pellets in 10 mL THF)
  b. Pipette 3 uL onto the Nafion-coated electrode
  c. Allow THF to evaporate: 2-4 hours at room temperature
  d. Result: dual-layer protection (Nafion for charge exclusion + PU for size exclusion)
```

---

## Comparison Table

| Property | Nafion | Polyurethane | PEG | Zwitterionic | BSA | pHEMA | Cellulose Acetate |
|----------|--------|-------------|-----|-------------|-----|-------|-------------------|
| **Anti-fouling effectiveness** | Very good | Excellent | Good | Excellent | Poor-moderate | Moderate | Good |
| **Cortisol permeability** | Good (hydrophobic partitioning) | Good (hydrophilic channels) | Excellent | Excellent | Good | Moderate (hydrophilic gel, cortisol is hydrophobic) | Risky (MWCO near cortisol MW) |
| **Application difficulty** | Very easy (drop-cast) | Easy (solvent cast) | Moderate (crosslink step) | Hard (synthesis + casting) | Easy (dip + crosslink) | Moderate (UV cure or thermal) | Easy (drop-cast) but needs hydrolysis tuning |
| **Cost per electrode** | <$0.01 | ~$0.10 | <$0.05 | ~$0.50 | <$0.01 | <$0.05 | <$0.01 |
| **Durability (days on skin)** | 5-10 | 10-14 | 3-7 | 7-14+ | 1-3 | 3-7 | 7-14 |
| **Compatibility with polypyrrole MIP** | Excellent | Good (THF risk, mitigate with thin layer) | Excellent | Good (if pre-synthesized) | Poor (glutaraldehyde attacks PPy) | Good | Poor (acetone dissolves PPy) |
| **Sensitivity loss** | 15-30% | 30-60% | 10-25% | 5-15% | 10-20% | 15-30% | 20-50% |
| **Response time added** | <1 min | 5-10 min | 1-3 min | <1 min | <1 min | 2-5 min | 2-5 min |
| **Demonstrated with cortisol sensors?** | YES (multiple papers) | YES (Dexcom-style; not cortisol-specific but analogous) | NO (general anti-fouling only) | NO (general anti-fouling only) | NO | YES (sweat glucose, not cortisol) | NO |
| **Commercial precedent** | Ubiquitous in electrochemical sensors | Dexcom CGM, Abbott Libre | Research only | Research only | Research only | Contact lenses (not sensors) | Early glucose sensors |
| **Recommended for CortiPod?** | **YES (primary)** | **YES (secondary/add-on)** | Maybe (backup) | Future upgrade | No | No | No |

---

## User-Applied vs Factory-Applied

### Can the membrane be applied by the user during electrode swapping?

**Nafion: YES — user-applicable with a simple dip protocol.**

The simplest user-facing protocol would be:

```
User electrode preparation (before inserting into device):
1. Open the sealed electrode pouch
2. Dip the electrode tip into the "Nafion bottle" (provided in kit)
   - Dip for 3 seconds, withdraw slowly
3. Wave gently in air for 60 seconds to dry
4. Insert into the CortiPod cartridge slot

The Nafion bottle contains 0.5% Nafion in ethanol — essentially nail-polish consistency.
Shelf life: >1 year sealed at room temperature.
```

This is realistic and achievable by a non-technical user. It is analogous to how some at-home biosensor kits (e.g., blood glucose test strips) have a preparation step.

**However, factory-applied is better for two reasons:**

1. **Consistency:** A factory-applied Nafion layer (drop-cast with precise volume control) is more uniform than a user dip-coat. Non-uniform coating creates hot spots where fouling penetrates faster.

2. **Simplification:** Every step removed from the user workflow increases adoption. The ideal user experience is: open pouch, insert electrode, done.

**Recommended approach for CortiPod:**

- **Prototype phase:** Apply Nafion in the lab during MIP fabrication. Test whether the Nafion survives 2-4 weeks of dry storage in a sealed pouch (it should — Nafion is extremely stable).
- **Production phase:** Factory-apply Nafion as the last step of electrode preparation, before packaging. Ship electrodes with Nafion already coated.
- **Fallback:** If storage stability is an issue (unlikely), include a small bottle of 0.5% Nafion in the electrode refill kit with dip instructions.

**PU membrane: Best factory-applied.**

PU solvent casting requires THF or DMAC, which are hazardous solvents. Users should not handle these. PU membranes should be applied in the lab or factory.

**Zwitterionic/PEG: Factory-applied only.**

These require synthesis and/or UV curing steps that are not user-friendly.

---

## Sources

### Wearable cortisol sensor papers
- [Wearable MIP Electrochemical Sensor for Cortisol in Sweat (2025)](https://pmc.ncbi.nlm.nih.gov/articles/PMC11940103/) — SF/PVDF membrane + polypyrrole MIP
- [MIP + Copper MOF Cortisol Sensor (2024)](https://www.mdpi.com/2073-4360/16/16/2289)
- [Molecularly Selective Nanoporous Membrane Cortisol Sensor (Salleo 2018)](https://pmc.ncbi.nlm.nih.gov/articles/PMC6054510/) — MIP-PVC membrane for OECT cortisol sensing
- [MIP Cortisol Sensor with Prussian Blue/Polypyrrole (2024)](https://www.sciencedirect.com/science/article/pii/S266605392400033X)
- [Stressomic: Microfluidic Multi-Hormone Sweat Sensor (2025)](https://www.science.org/doi/10.1126/sciadv.adx6491)
- [Polyaniline Hydrogel Antifouling Cortisol Sensor (2025)](https://www.sciencedirect.com/science/article/abs/pii/S1001841725000713)

### Anti-fouling membrane reviews and comparisons
- [Antifouling (Bio)materials for Electrochemical (Bio)sensing — Review (2019)](https://pmc.ncbi.nlm.nih.gov/articles/PMC6358752/)
- [Methods of Protection of Electrochemical Sensors against Biofouling (2024)](https://pmc.ncbi.nlm.nih.gov/articles/PMC10831843/) — Tests 11+ coatings including Nafion, PEG, BSA, silicate, pHEMA
- [Cross-Linkable Polymer Multi-layers for Glucose Biosensor Protection (2023)](https://pubs.acs.org/doi/10.1021/acssensors.3c00050)
- [Zwitterionic Polymer Coatings for Mediated Glucose Biosensors (2022)](https://www.sciencedirect.com/science/article/pii/S0956566322008557)
- [Anti-fouling Polypeptide Hydrogel for Sweat Monitoring (2023)](https://pubs.acs.org/doi/abs/10.1021/acssensors.3c00778)
- [Mitigating Lipid Biofouling with Conductive MOF Electrodes (2025)](https://www.sciencedirect.com/science/article/abs/pii/S1385894725053136)

### Nafion protocols and properties
- [Nafion Optimization for pH Sensors — Layer/Concentration Study (2023)](https://pmc.ncbi.nlm.nih.gov/articles/PMC9965570/)
- [Screen-Printable Nafion Dispersion Development (2022)](https://www.mdpi.com/2076-3417/12/13/6533)
- [Nafion-CoO for Hydrocortisone Detection (2021)](https://www.sciencedirect.com/science/article/abs/pii/S0045653521015010) — Confirms cortisol detection through Nafion
- [Nafion-Modified Screen-Printed Gold Electrodes (2013)](https://www.sciencedirect.com/science/article/abs/pii/S0039914013000441)
- [Nafion Coating on Nanopore Electrodes for Aptamer Biosensing (2025)](https://pubs.rsc.org/en/content/articlehtml/2025/fd/d4fd00144c)

### Polyurethane membrane (Dexcom patents)
- [Dexcom PU Membrane Patent US9179869B2](https://patents.google.com/patent/US9179869B2/en) — Chronothane H + 1020 in DMAC, ~38 um, 120-150 C drying
- [Dexcom Membrane Layers Patent US20170188916](https://www.freepatentsonline.com/y2017/0188916.html)
- [Hydrophilic PU Membranes for Glucose Sensors EP0535898A1](https://patents.google.com/patent/EP0535898A1/en)
- [Electrospun PU Coatings for Glucose Biosensors (2012)](https://pmc.ncbi.nlm.nih.gov/articles/PMC3511670/)
- [Blending Polymer Outer Membrane for CGM Lifetime Extension (2024)](https://www.sciencedirect.com/science/article/abs/pii/S0925400524008724)

### pHEMA and hydrogel sensors
- [Cu@PHEMA Hydrogel Glucose Sweat Sensor (2024)](https://www.sciencedirect.com/science/article/pii/S0014305724008917)
- [pHEMA Hydrogel for Sweat Glucose/Ascorbic Acid (2025)](https://www.sciencedirect.com/science/article/abs/pii/S0026265X25022955)
- [Amyloid BSA Hydrogel for Dopamine Sweat Sensor (2024)](https://pubmed.ncbi.nlm.nih.gov/39146769/)

### Cellulose acetate membranes
- [Cellulose Acetate Membranes: Fouling Types and Antifouling Strategies (2023)](https://www.mdpi.com/2227-9717/11/2/489)
- [CA Membrane Permeability for Biosensors (2003)](https://link.springer.com/article/10.1023/A:1015137809504)
- [Cellulose-Based Membranes for Sensing Applications — Review (2020)](https://pmc.ncbi.nlm.nih.gov/articles/PMC7483080/)

### General wearable sweat sensor reviews
- [Diving into Sweat: Advances and Challenges in Wearable Sensing (2025)](https://pubs.acs.org/doi/10.1021/acsnano.4c10344)
- [Wearable and Flexible Electrochemical Sensors for Sweat Analysis — Review (2022)](https://www.nature.com/articles/s41378-022-00443-6)
- [Sweat-Based Wearable Biosensors: Continuous Health Monitoring (2025)](https://www.sciencedirect.com/science/article/pii/S2950235725000253)
