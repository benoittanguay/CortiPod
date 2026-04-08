# CortiPod Enclosure Design Engineering Reference

> Industrial design and mechanical engineering principles for a 44x26x10mm wrist-worn electrochemical sensor pod with user-swappable electrode cartridge.

---

## Table of Contents

1. [Ergonomic Design for Wrist-Worn Devices](#1-ergonomic-design-for-wrist-worn-devices)
2. [Cartridge / Slot Mechanism Design](#2-cartridge--slot-mechanism-design)
3. [Seal and IP Rating Design](#3-seal-and-ip-rating-design)
4. [Skin-Contact Surface Design](#4-skin-contact-surface-design)
5. [DFM — Design for Manufacturing](#5-dfm--design-for-manufacturing)
6. [Spring Contact / Electrical Interface Design](#6-spring-contact--electrical-interface-design)

---

## 1. Ergonomic Design for Wrist-Worn Devices

### 1.1 Wrist Anthropometry — The Numbers

All wrist-worn device geometry must accommodate the 5th-percentile female through the 95th-percentile male wrist. Key anthropometric data (U.S. Army ANSUR II and CDC NHANES):

| Dimension | 5th %ile Female | 50th %ile Male | 95th %ile Male |
|-----------|----------------|----------------|----------------|
| Wrist circumference | ~140 mm | ~172 mm | ~195 mm |
| Wrist breadth (mediolateral) | ~46 mm | ~59 mm | ~67 mm |
| Wrist depth (dorsal-palmar) | ~33 mm | ~42 mm | ~48 mm |

**Derived dorsal curvature radius:** The dorsal (top-of-wrist) surface where a band sits approximates an elliptical cross-section. For a wrist circumference of 140-195 mm, the effective transverse radius of curvature on the dorsal surface is roughly **30-50 mm**. The longitudinal (along the forearm) radius is much larger, effectively flat over a 44 mm pod length.

**Implication for CortiPod:** At 26 mm wide, the pod spans roughly half the dorsal wrist breadth. The bottom (skin-contact) surface should have a transverse convex curvature with radius **35-45 mm** to conform to the dorsal wrist across the target population. A single fixed radius of ~40 mm is a reasonable compromise. The strap tension handles the remaining conformance for smaller and larger wrists.

### 1.2 Comparable Device Dimensions

| Device | Dimensions (mm) | Thickness | Weight | Notes |
|--------|-----------------|-----------|--------|-------|
| Whoop 5.0 | 34.7 x 24 x 10.6 | 10.6 mm | 26.5 g | No screen, continuous HR/HRV |
| Whoop 4.0 | ~36 x 25 x 11.5 | 11.5 mm | ~12 g (pod only) | Previous generation |
| Apple Watch Series 9 (41mm) | 41 x 35 x 10.7 | 10.7 mm | 31.9 g (aluminum) | Full display |
| Dexcom G7 | 24 x 27.3 x 4.6 | 4.6 mm | ~4 g | Adhesive patch, no strap |
| FreeStyle Libre 3 | 21.2 dia x 2.9 | 2.9 mm | ~1 g | Thinnest CGM, adhesive |
| **CortiPod (target)** | **44 x 26 x 10** | **10 mm** | **est. 15-25 g** | **No screen, electrode slot** |

CortiPod at 10 mm total height is thinner than both the Whoop 5.0 (10.6 mm) and Apple Watch (10.7 mm). This is viable but tight given the internal stack: bottom shell (2.5 mm) + electrode (0.5 mm) + PCB (0.8 mm) + battery (3 mm) + top shell wall.

### 1.3 Profile Height and Snagging

**Rule of thumb:** Wrist-worn devices under ~12 mm total height with chamfered/rounded edges avoid snagging on shirt cuffs and daily objects. At 10 mm, CortiPod is in good territory.

**Key design moves to minimize snagging:**
- Chamfer or radius all edges that face the proximal (toward elbow) and distal (toward hand) directions — these catch on cuffs
- The lug-to-strap transition should be smooth and flush; protruding lugs catch fabric
- The insertion slot opening at the +X end should be recessed or beveled, not a sharp ledge
- Maximum protrusion above strap surface: keep the pod's top surface within ~7-8 mm of the strap line

### 1.4 Skin-Contact Surface Contouring

**Principles from commercial wearables:**

1. **Convex curvature on the skin-facing surface.** The dorsal wrist is convex; the device's skin side should match. A flat bottom on a curved wrist creates edge pressure points at the lateral margins — uncomfortable and causes uneven sensor contact.

2. **Large radii on all skin-facing edges.** Every edge the skin touches should have a minimum fillet radius of **1.0-1.5 mm**, ideally 2.0 mm+. Sharp edges dig into tissue, cause red marks, and are the primary comfort complaint. The Whoop and Apple Watch both use generously radiused caseback surfaces.

3. **Smooth transitions between materials.** If using a rigid shell (nylon/PC) with a softer overmold (silicone/TPU) on the skin side, the transition should be flush — no steps or lips that trap sweat and irritate.

4. **No flat spots wider than ~15 mm without curvature.** Flat areas on the skin side act as suction cups when sweaty, trapping moisture and causing irritation.

### 1.5 How Commercial Devices Handle It

- **Whoop 4.0/5.0:** Slightly convex caseback, silicone/elastomer band provides conformance. Sensor pod is slightly raised relative to band. Designed to be worn 1-2 inches above the wrist bone (ulna styloid) where the wrist is more cylindrical.
- **Apple Watch:** Ceramic/sapphire caseback with convex curvature. Band attachment is co-planar with case edges. Solo Loop bands provide continuous elastic tension.
- **Dexcom G7:** Eliminates the wrist-curvature problem entirely by using a thin adhesive patch. The sensor housing is only 4.6 mm tall, so conformance to skin curvature is handled by the flexible adhesive pad rather than the rigid housing.

---

## 2. Cartridge / Slot Mechanism Design

### 2.1 Mechanism Taxonomy

There are four main approaches for user-replaceable cartridge retention:

| Mechanism | How It Works | Pros | Cons | Examples |
|-----------|-------------|------|------|----------|
| **Friction fit** | Tight tolerance holds part in place | Simplest, cheapest, fewest parts | Wears out, force varies with tolerance, no positive lock | USB-A plugs, some test strips |
| **Spring retention (push-push)** | Spring + cam groove locks on push, releases on second push | Positive lock, satisfying feel, one-handed | Complex mechanism, needs space for spring + cam | SD cards, SIM cards |
| **Latch/lever lock** | Mechanical latch (ZIF lever, SIM tray pin) | Very secure, high retention force | Requires tool or deliberate action to release | ZIF connectors, SIM trays, FPC connectors |
| **Snap detent** | Flexible cantilever with bump clicks into groove | Simple, positive feel, no extra parts | Fatigue over cycles, force hard to tune | Battery doors, lens caps |

### 2.2 What the CortiPod Currently Uses: ZIF Lever Lock

The current CAD design uses a ZIF (Zero Insertion Force) connector — the electrode slides into the ZIF from the +X end, and closing the lever clamps the contacts.

**ZIF advantages for this application:**
- Zero insertion force protects the delicate electrode surface and ceramic substrate
- Positive locking — the lever provides unambiguous locked/unlocked state
- Standard FPC-style ZIFs are rated for 10,000-20,000 cycles
- Excellent contact reliability at very low contact resistance (<50 milliohm)

**ZIF concerns:**
- The lever mechanism adds 2-3 mm of height to the connector body
- Lever access requires a cutout in the shell, which is a seal-breaking opening
- User must understand the lever operation (two-step: insert, then close lever)
- FPC-style ZIFs expect a flat flexible circuit, not a rigid 0.5 mm ceramic substrate — the ceramic is stiffer and thicker than a typical 0.3 mm FPC, so you need a ZIF rated for thicker substrates (0.5 mm versions exist but are less common)

### 2.3 Engineering Principles from SIM/SD Card Mechanisms

**Push-push SD card mechanisms** use a heart-shaped cam groove and a spring-loaded pin follower. When pushed in, the pin traces one path of the heart cam and locks at the center; a second push traces the other path and the spring ejects the card. Key parameters:

- Insertion force: typically 1.5-3.5 N (150-350 gf)
- Ejection force (spring): typically 0.5-1.5 N
- Rated cycles: 1,500-5,000 insertions for consumer, 10,000+ for industrial
- Keying: asymmetric notch prevents reversed insertion
- Card detection: integrated switch actuated by card presence (useful for CortiPod to detect electrode insertion)

**SIM tray mechanisms** are simpler — the tray slides in on rails and is retained by a spring clip or friction. A pin-hole eject mechanism prevents accidental removal. For CortiPod, a SIM-tray-style approach with a seal over the opening could work.

### 2.4 Glucose Meter Test Strip Insertion — The Closest Analog

Commercial glucose meters are the most directly relevant precedent: they accept a disposable electrochemical test strip with printed electrodes, make electrical contact, and perform amperometric measurement. How they do it:

**Accu-Chek Guide / Aviva:**
- Strip inserts into a slot at the top of the meter
- Internal spring-loaded contacts press against the strip's printed electrode pads
- Contact pads are at one end of the strip (the "connector tail"), sensing area is at the other end
- The strip is friction-retained; pulling it out requires ~1-2 N
- The meter auto-detects strip insertion (contact closure triggers wake-up)
- Strips are keyed by shape — only the correct strip fits the slot

**FreeStyle (Abbott):**
- Similar card-edge approach: strip slides into a narrow slot
- Internal contacts are leaf-spring or cantilever contacts that press against the strip pads
- Very low insertion force (<1 N) for elderly/diabetic users with reduced dexterity
- Color-coded strip port with funnel/chamfer for easy blind insertion

**Key design lessons from glucose meters:**
1. The connector tail should have wider pads than the signal traces — this provides tolerance for insertion misalignment
2. A funnel/chamfer at the slot entrance guides the strip in, even in low-light conditions
3. The slot geometry itself acts as the anti-reversal key — the strip only fits one way
4. Detection of strip presence (via a dedicated sense contact or short between two pads) is essential for auto-wake and measurement triggering
5. Friction retention of ~0.5-2 N is sufficient; a spring mechanism is unnecessary for strips that are changed every few weeks rather than hourly

### 2.5 Recommendations for CortiPod Electrode Insertion

Given that the CortiPod electrode:
- Is a rigid 0.5 mm ceramic substrate (not flexible like FPC)
- Is 33.8 x 10.2 mm (larger than a glucose strip, smaller than an SD card)
- Needs electrical contact on 4 pads (WE, CE, RE, ground)
- Is swapped every few weeks (not daily)
- Must maintain sensor-to-skin registration (the sensing face must end up precisely over the skin windows)

**The ZIF approach is sound** but consider these refinements:
- Add a **mechanical end-stop** at the -X wall so the electrode can only insert to the correct depth
- Add **lateral guide rails** (the channel walls in the current design serve this purpose)
- Add a **keying feature** — a notch or chamfer on one corner of the electrode substrate so it cannot be inserted upside-down or backward
- Consider whether the ZIF lever access cutout can be sealed with a small **hinged silicone flap** that the user lifts to access the lever

---

## 3. Seal and IP Rating Design

### 3.1 IP Rating Targets

| Rating | Protection Level | Test Condition | Realistic for CortiPod? |
|--------|-----------------|----------------|------------------------|
| IP54 | Dust-protected + splash-proof | Water splashing from any direction | Yes, minimum target |
| IP65 | Dust-tight + low-pressure jets | 6.3 mm nozzle, 12.5 L/min | Achievable with good gaskets |
| IP67 | Dust-tight + temporary immersion | 1 m depth, 30 minutes | Achievable for sealed body; challenging around cartridge slot |
| IP68 | Dust-tight + continuous submersion | Depth specified by manufacturer | Very difficult with user-accessible slot |

**Recommendation: Target IP67 for the sealed pod body, IP54-IP65 effective rating with the cartridge slot.** The cartridge slot is the weakest link. A labyrinth or gasket seal around the slot can bring the effective rating to IP65. Accepting that the user should not submerge the device during electrode swaps is reasonable.

### 3.2 Seal Architecture for CortiPod

The device has three sealing challenges:

**Challenge 1: Top shell to bottom shell joint**
- Current design: O-ring groove (1.2 mm wide x 0.8 mm deep) around the perimeter mating surface
- This is the right approach. An O-ring in a face-seal groove, compressed by the snap-fit closure, is the standard method for IP67 enclosures.

**O-ring groove design rules for this joint:**

For a ~1.0 mm cross-section (CS) O-ring (appropriate for this enclosure size):
- Groove depth: 0.72-0.78 mm (targeting 20-25% compression of 1.0 mm CS)
- Groove width: 1.4-1.6 mm (1.4-1.6x the CS, providing room for compression without extrusion)
- Corner radii in groove: R 0.2 mm minimum
- Surface finish on groove and mating face: Ra 1.6 micrometer or smoother (achievable with SLA; MJF may need post-processing)
- Gland fill: 60-85% of groove cross-section area

The current parameters.scad has: groove_width = 1.2 mm, groove_depth = 0.8 mm. For a 1.0 mm CS O-ring, the depth should be **~0.75 mm** (not 0.8 mm — 0.8 mm only gives 20% compression, which is the low end). Consider changing to groove_depth = 0.72-0.75 mm. The groove_width of 1.2 mm is a bit narrow for 1.0 mm CS; **1.4-1.5 mm** would be better.

**Challenge 2: Electrode insertion slot opening**

This is the hardest problem. Options:

*Option A — Silicone flap seal:*
A flexible silicone flap (molded or glued) covers the +X end insertion opening. The user peels it open to swap electrodes, then presses it closed. The flap has a lip that mates with a groove in the shell.
- Pros: Simple, cheap, intuitive
- Cons: Flap wears out, may not re-seal reliably after many cycles, looks inelegant
- IP achievable: ~IP54-IP65

*Option B — Labyrinth seal:*
The insertion channel itself acts as a labyrinth. The electrode's tight fit in the channel (0.15 mm clearance per side per the current design) creates a long, narrow gap path that water must traverse. The electrode acts as its own seal plug.
- Pros: No extra parts, seal is automatic when electrode is inserted
- Cons: 0.15 mm clearance may not stop water under pressure; any debris in the channel breaks the seal
- IP achievable: ~IP54 (splash protection only)

*Option C — Slot gasket:*
A thin elastomeric gasket (shore A 30-50 silicone) lines the insertion slot opening. When the electrode is inserted, it compresses the gasket, sealing around the electrode perimeter.
- Pros: Good seal, self-actuating, no user action needed beyond inserting the electrode
- Cons: Adds friction to insertion, gasket must be precisely sized, adds a replaceable wear part
- IP achievable: ~IP65-IP67

*Option D — External plug/cap:*
A separate plug or cap covers the insertion end when not in use. Think USB-C waterproof cap.
- Pros: Can achieve IP67+, simple to implement
- Cons: Users lose caps, extra step, annoying

**Recommended approach: Combine Option B (labyrinth) + Option C (slot gasket).** Use tight-tolerance channels as the primary labyrinth path, and add a thin silicone lip gasket at the slot entrance that the electrode compresses on insertion. This provides IP65 when the electrode is inserted and tells the user "if the electrode is in, it's sealed."

**Challenge 3: Skin windows**

The bottom shell has two large openings (26 x 9 mm each) through which the electrodes contact skin. When the electrodes are inserted, they cover these windows. The electrode ceramic substrate rests 0.3 mm above the skin surface (sensor_recess_depth).

Sealing approach: The electrode sitting in the channel with its 0.15 mm clearance forms a reasonable seal. Improving this: add a thin silicone gasket rim around each skin window that the electrode compresses when fully inserted. This prevents sweat from wicking up around the electrode and into the pod interior.

### 3.3 General Waterproofing Principles

- **Every seal is a failure point.** Minimize the number of seals. The CortiPod has three sealing zones; this is reasonable.
- **Static seals are more reliable than dynamic seals.** The shell-to-shell O-ring is static (compressed once during assembly). The electrode slot is quasi-dynamic (compressed/released at each swap). Design the electrode slot seal for at least 200 cycles.
- **O-ring compression: 20-30% for static, 10-20% for dynamic.** For the shell joint (static), target 25% compression. For the slot gasket (quasi-dynamic), target 15-20%.
- **Surface finish matters.** Sealing surfaces need Ra < 1.6 micrometer. MJF PA12 as-printed is roughly Ra 6-10 micrometer (too rough for direct O-ring sealing). Options: vapor-smooth the PA12, use SLA for sealing surfaces, or add a silicone RTV sealant as currently planned.
- **Test early.** A simple dunk test (submerge sealed prototype in dyed water for 30 minutes, then open and check for dye ingress) gives you IP67-equivalent data without formal certification.

---

## 4. Skin-Contact Surface Design

### 4.1 Contact Pressure for Sweat-Based Sensing

Unlike optical sensors (PPG in Whoop/Apple Watch) which need firm contact for light coupling, sweat-based electrochemical sensors need relatively light contact:

**Minimum requirements:**
- The electrode sensing face must be in contact with or within ~1 mm of the skin surface
- Sweat must be able to reach the electrode surface via capillary action or direct wetting
- The sensor does NOT need firm pressure — excessive pressure actually occludes sweat glands and reduces sweat delivery

**Optimal contact regime:**
- Light contact pressure: 1-5 kPa (roughly 10-50 gf/cm2)
- For comparison, a comfortable watch band provides ~3-10 kPa of contact pressure
- The band tension, not the pod geometry, is the primary pressure control
- The current design has the electrode face sitting 0.3 mm above (recessed from) the skin surface. This is good — it creates a thin air/sweat gap that allows sweat to pool on the sensor without the electrode pressing directly into skin

### 4.2 Sweat Access: Ventilation vs. Seal Tradeoffs

This is the central tension in the CortiPod skin interface design:

**The sensor needs sweat to reach the electrode (requires openness)**
vs.
**The enclosure needs to keep water out of the electronics (requires sealing)**

The current design resolves this well: the skin windows allow sweat access to the electrode face, while the electrode substrate itself acts as a barrier between the wet sensing area and the dry electronics cavity above.

**Passive sweat collection approaches from the research literature:**
1. **Direct skin contact:** Electrode face sits against or very near skin. Sweat collects naturally in the gap. This is the simplest approach and what CortiPod uses.
2. **Capillary wicking:** Paper or textile wicking strips draw sweat from a larger skin area to a small sensor zone. Useful if sweat rate is low (e.g., resting, not exercising).
3. **Microfluidic channels:** Molded or printed channels on the skin-facing surface route sweat to the sensor. Provides controlled flow and prevents pooling/evaporation.

**For CortiPod's prototype stage,** direct skin contact through the windows is the right starting point. If sweat delivery proves insufficient at rest, consider adding a capillary wicking layer (a small piece of filter paper or hydrophilic membrane) in the skin window that bridges from the skin to the electrode face.

### 4.3 Skin Irritation Prevention

Skin irritation is the most common complaint with wearable medical devices (Dexcom users report this frequently). Causes and mitigations:

| Irritation Source | Mechanism | Mitigation |
|-------------------|-----------|------------|
| **Moisture trapping** | Sweat trapped under device breeds bacteria, causes maceration | Ventilation channels, breathable materials, periodic removal |
| **Contact allergy** | Nickel, acrylate adhesives, uncured silicone | Use only medical-grade (ISO 10993 / USP Class VI) materials for skin contact. Gold or stainless steel for metal contacts. No nickel. |
| **Mechanical pressure** | Concentrated pressure points cause red marks, tissue necrosis over time | Distribute pressure over large area. Radius all edges >= 1.5 mm. Convex skin surface. |
| **Friction/shear** | Band slides on skin during movement | Band material with high friction coefficient (silicone). Snug but not tight fit. |
| **Chemical irritation** | Electrode chemicals leaching to skin | The electrode sensing face IS the skin-contact surface — MIP chemistry must be biocompatible. The polypyrrole/poly-oPD film is inert once cured. Wash solution residue must be fully rinsed. |

**How CGMs handle it:**
- **Dexcom G7:** Medical-grade acrylic pressure-sensitive adhesive. 10-day wear limit specifically to prevent adhesive-related irritation. Recommends rotating insertion sites.
- **FreeStyle Libre:** Similar adhesive approach. Known for skin reactions in ~5-10% of users.
- **Whoop:** No adhesive — relies entirely on band tension. Recommends wearing 1-2 inches above wrist bone. Suggests alternating wrists every few days.

**For CortiPod:** Since there is no adhesive (band-retained like Whoop), the primary irritation risks are moisture trapping and pressure points. Key mitigations:
1. The skin windows actually serve double duty: they provide ventilation as well as sweat access
2. Add shallow ventilation channels (0.3-0.5 mm deep grooves) on the bottom shell's skin-facing surface between and around the sensor windows
3. Recommend users alternate wrists daily
4. Ensure the GSR pads are flush or slightly recessed — protruding metal pads are a pressure point

### 4.4 Skin-Contact Surface Material

The bottom shell skin-facing surface is the primary skin-contact zone. Material options:

| Material | Biocompatibility | Comfort | Durability | Manufacturability |
|----------|-----------------|---------|------------|-------------------|
| MJF Nylon PA12 | Not inherently certified; needs testing or coating | Hard, smooth after vapor treatment | Excellent | Default MJF material |
| Formlabs BioMed Amber (SLA) | USP Class VI certified | Hard, very smooth | Good | Requires SLA printer or Xometry order |
| Silicone overmold (LSR) | ISO 10993 / USP Class VI (with correct grade) | Soft, skin-friendly, gold standard | Good | Requires two-shot mold or manual bonding |
| Medical-grade TPU overmold | ISO 10993 compliant grades available | Semi-soft, conformable | Very good | Overmoldable onto PA12 or PC |

**For prototyping:** MJF PA12 or SLA BioMed Amber are fine. PA12 is not certified biocompatible but is generally well-tolerated for external skin contact in short-duration wear. For production, a silicone or TPU overmold on the skin-facing surface is the professional approach.

---

## 5. DFM — Design for Manufacturing

### 5.1 Wall Thickness Rules

**For 3D printing (prototype phase):**

| Process | Min Supported Wall | Min Unsupported Wall | Min Pin Diameter | Tolerance |
|---------|-------------------|---------------------|------------------|-----------|
| MJF PA12 | 1.0 mm | 1.5 mm | 2.0 mm | +/- 0.3% (min +/- 0.5 mm) |
| SLA (BioMed Amber) | 0.5 mm | 1.0 mm | 1.0 mm | +/- 0.1-0.2 mm |
| FDM (PETG/PLA) | 1.2 mm | 1.5 mm | 2.0 mm | +/- 0.3-0.5 mm |

**For injection molding (production):**

| Material | Recommended Wall | Min Wall | Max Wall | Notes |
|----------|-----------------|----------|----------|-------|
| Nylon PA12 | 1.5-3.0 mm | 0.8 mm | 3.0 mm | Hygroscopic; wall uniformity critical |
| PC (polycarbonate) | 1.5-3.5 mm | 1.0 mm | 3.5 mm | Transparent options available |
| ABS | 1.2-3.0 mm | 0.8 mm | 3.0 mm | Good for snap fits |
| Medical-grade TPU | 1.0-2.5 mm | 0.5 mm | 3.0 mm | Flexible overmold |

**CortiPod currently uses 1.5 mm wall_thickness** — this is the minimum for robust MJF parts and adequate for injection molding. No changes needed.

**Wall thickness uniformity rule:** Adjacent walls should be within 40-60% of each other's thickness. Avoid abrupt transitions from thick to thin — they cause sink marks, warpage, and stress concentrations in injection molding.

### 5.2 Draft Angles

**Only relevant for injection molding** (3D printing does not need draft angles). When CortiPod transitions to injection molding:

| Surface Type | Minimum Draft | Recommended Draft |
|-------------|--------------|-------------------|
| Polished (Class A) | 0.5 deg/side | 1.0 deg/side |
| Standard (semi-gloss) | 1.0 deg/side | 1.5 deg/side |
| Textured (light) | 1.5 deg/side | 2.0 deg/side |
| Textured (heavy/matte) | 3.0 deg/side | 5.0 deg/side |
| Deep core pulls / ribs | 1.0 deg/side minimum | 1.5-2.0 deg/side |

**For the current 3D-printed design, draft is not needed.** But designing with 1 deg draft now makes the eventual transition to molding easier. Internal features (electrode channels, ZIF cavity) should be designed with draft awareness.

### 5.3 Snap-Fit Design Rules

The current design uses snap clips to join the top and bottom shells. Key engineering rules:

**Cantilever snap-fit calculations:**

Maximum deflection of a uniform rectangular cantilever:
```
Y = 0.67 * (epsilon * L^2) / H
```
Where:
- Y = maximum deflection (mm) at the beam tip
- epsilon = allowable strain (fraction, not percent)
- L = beam length (mm)
- H = beam thickness at the root (mm)

Deflection force:
```
P = (B * H^2 * E * epsilon) / (6 * L)
```
Where:
- P = force to deflect beam (N)
- B = beam width (mm)
- E = modulus of elasticity (MPa)
- epsilon = strain at deflection

Assembly force (with friction):
```
W = P * (mu + tan(alpha)) / (1 - mu * tan(alpha))
```
Where:
- mu = coefficient of friction (0.2-0.4 for plastic on plastic)
- alpha = snap overhang lead-in angle (typically 30-45 deg)

**Material strain limits for snap fits:**

| Material | Max Allowable Strain (single use) | Max Allowable Strain (repeated use) | Modulus E (MPa) |
|----------|----------------------------------|-------------------------------------|-----------------|
| Nylon PA12 (dry) | 4-6% | 2-3% | 1,200-1,800 |
| Nylon PA12 (conditioned) | 6-8% | 3-4% | 800-1,200 |
| ABS | 2-4% | 1-2% | 2,000-2,600 |
| PC | 4-8% | 2-4% | 2,200-2,400 |
| Acetal (POM) | 4-7% | 2-3% | 2,800-3,200 |

**Design best practices:**
- Taper the beam: reduce thickness at the tip to 50% of root thickness. This distributes stress more evenly and changes the deflection coefficient from 0.67 to 1.09.
- Fillet at the root: minimum R 0.5 * beam thickness (current clip_depth = 0.8 mm, so fillet >= 0.4 mm)
- Beam length should be >= 5x beam thickness for nylon to stay within elastic strain limits
- Current design: clip_width = 3.0 mm, clip_depth = 0.8 mm. These are reasonable for a nylon snap fit. Beam length (the distance from the shell wall to the clip hook) should be >= 4.0 mm.

### 5.4 Undercut Avoidance

For injection molding, undercuts require side actions or lifters in the mold, increasing tool cost 20-50%. The current design has several undercuts:

- **Electrode channels:** Internal channels running the length of the pod. These can be molded if the +X end is open (which it is — the insertion opening acts as the mold core pull direction).
- **O-ring groove:** Internal groove on the mating face. Moldable as-is since it's on the parting line face.
- **Snap clip hooks:** These ARE undercuts. They require either: (a) flexible enough material to deflect past the mold (nylon often works), (b) a side action in the mold, or (c) redesigning as through-hole clips where the hook is formed through a window in the shell wall.
- **Strap lug holes:** Through-holes perpendicular to the pull direction. Require core pins in the mold — standard and low cost.

### 5.5 Material Selection Summary for Skin-Contact Wearable

**Regulatory landscape:**
- External skin contact < 24 hours continuous: ISO 10993-5 (cytotoxicity) and ISO 10993-10 (irritation/sensitization) testing required for a commercial medical device
- External skin contact > 24 hours: Add ISO 10993-11 (systemic toxicity)
- USP Class VI is a shorthand certification that covers acute toxicity, intracutaneous, and implantation tests
- For a prototype/personal use device, formal certification is not required, but using materials with existing biocompatibility data reduces risk

**Recommended materials by component:**

| Component | Prototype Material | Production Material |
|-----------|-------------------|-------------------|
| Top shell | MJF PA12 | PC or PA12 (injection molded) |
| Bottom shell | MJF PA12 or SLA BioMed Amber | PA12 + silicone overmold on skin face |
| O-ring | Silicone 50A durometer | Medical-grade silicone (ISO 10993) |
| Slot gasket | Silicone 30-40A durometer | Medical-grade LSR (liquid silicone rubber) |
| Strap | Off-the-shelf silicone 18mm band | Custom medical-grade silicone band |
| Electrode substrate | Ceramic (as-purchased from DropSens) | Ceramic or Kapton (polyimide) |

---

## 6. Spring Contact / Electrical Interface Design

### 6.1 Connector Options for Rigid Electrode Substrates

The CortiPod needs to make reliable electrical contact with 4 pads on a 0.5 mm thick ceramic electrode substrate. Three main approaches:

| Approach | How It Works | Contact Resistance | Cycle Life | Force per Contact | Pros | Cons |
|----------|-------------|-------------------|------------|-------------------|------|------|
| **ZIF connector** | Lever clamps contacts onto pad surface | <30 milliohm | 10,000-20,000 | ~0 N insertion, ~1-3 N clamp | Zero insertion force protects substrate; excellent contact | Requires lever access; FPC-style ZIFs may not fit 0.5mm ceramic; height overhead |
| **Pogo pins** | Spring-loaded pins press against pads | 20-50 milliohm typical | 10,000-1,000,000 | 0.5-4 N per pin (50-400 gf) | Works with any flat pad; very robust; no lever needed | Adds insertion force (4 pins x 1N = 4N total); pins need alignment; height overhead |
| **Card-edge (leaf spring)** | Thin cantilever contacts wipe against pads as strip inserts | 30-100 milliohm | 1,000-10,000 | 0.5-2 N per contact | Simple, cheap, proven in glucose meters; self-cleaning wipe action | Higher insertion force than ZIF; contacts wear over time; substrate edge must be clean |

### 6.2 ZIF Connector Details (Current Design)

The current design uses FPC-style ZIF connectors. Key specifications to look for:

- **Substrate thickness rating:** Must accept 0.5 mm substrate. Standard FPC ZIFs are 0.3 mm. Look for "0.5 mm FPC" or "thick FPC" ZIF variants, or use a ZIF rated for 0.5 mm flex circuits (e.g., Molex 503480 series, Hirose FH12 series with 0.5 mm option).
- **Contact pitch:** The DRP-220AT electrode has 4 pads. A 0.5 mm pitch ZIF with 10+ positions gives plenty of room to use only the 4 needed contacts, with alignment tolerance.
- **Bottom-contact vs. top-contact:** The current design specifies bottom-contact (contacts on the underside of the ZIF body, pressing upward against the electrode pads that face down). This is correct for the face-down electrode orientation.
- **Actuator type:** Lock/unlock lever on the back side. The lever rotates ~90 degrees. Needs 3-5 mm of access clearance behind the connector.

### 6.3 Pogo Pin Alternative (Recommended Consideration)

Pogo pins may be simpler than ZIF for this application. Here is why:

**Advantages over ZIF for CortiPod:**
- No lever mechanism = no lever access cutout = easier sealing
- Works natively with 0.5 mm rigid ceramic (ZIF may need a special thick-substrate version)
- The electrode slides in against spring pressure and is held by friction + spring force — one-step operation vs. ZIF's two-step (insert + close lever)
- Pogo pins are surface-mount components; easier PCB layout than ZIF

**Pogo pin specifications for this application:**

| Parameter | Recommended Value | Rationale |
|-----------|------------------|-----------|
| Pin diameter | 0.7-1.0 mm | Small enough for 4 pins in 10.2 mm electrode width |
| Spring force | 50-100 gf per pin (0.5-1.0 N) | Light enough for easy insertion of ceramic substrate |
| Total insertion force | 2-4 N (4 pins) | Comfortable finger push |
| Working stroke | 0.3-0.5 mm | Enough to absorb tolerance stack-up |
| Contact resistance | <30 milliohm | Standard for gold-plated pogo pins |
| Gold plating | >= 10 micro-inches (0.25 micrometer) on plunger tip | Corrosion resistance in sweat environment |
| Cycle life | >= 10,000 cycles | Far exceeds the ~200 electrode swaps over device lifetime |
| Current rating | >= 500 mA per pin | AD5941 potentiostat currents are in the microamp range; this is very conservative |

**Mounting:** Pogo pins would be soldered to the PCB underside, pointing downward through the top shell into the electrode channel. The pin tips press against the electrode's contact pads when the electrode is in position. The channel geometry aligns the electrode under the pins.

**Recommended pogo pin products:**
- Mill-Max 0906 series (0.98 mm diameter, 100 gf spring force, <50 milliohm)
- Mill-Max 0985 series (0.68 mm diameter, for tighter pitch)
- Harwin P70 series (0.9 mm diameter, gold-plated, 10,000+ cycles)

### 6.4 Contact Pad Design on the Electrode

Regardless of connector type, the electrode's contact pad design affects reliability:

- **Pad size:** Minimum 2.0 x 2.0 mm per pad for pogo pin alignment tolerance. The DRP-220AT has existing pad geometry — measure and verify these dimensions.
- **Pad material:** Gold or carbon. Gold pads (as on the DRP-220AT) provide the lowest and most stable contact resistance with gold-plated pogo pins or ZIF contacts.
- **Pad spacing:** Minimum 1.0 mm gap between adjacent pads to prevent shorting from sweat bridging or misalignment.
- **Pad location:** At one end of the strip (the connector tail), as far from the sensing area as possible. The current electrode design has a 5 mm connector tail — this provides space for 4 pads.

### 6.5 Comparison: ZIF vs. Pogo Pins for CortiPod

| Criterion | ZIF (current design) | Pogo Pins (alternative) |
|-----------|---------------------|------------------------|
| Insertion force | 0 N (zero insertion force) | 2-4 N (spring compression) |
| Locking | Positive lever lock | Friction + spring retention |
| Seal impact | Lever cutout breaks seal | No cutout needed; much easier to seal |
| User steps | Insert + close lever (2 steps) | Push in until stop (1 step) |
| Ceramic compatibility | Needs 0.5mm-rated ZIF | Works natively with rigid substrates |
| Contact reliability | Excellent (clamped contact) | Very good (spring-loaded contact) |
| Height overhead | 2.5 mm (ZIF body) | 3-5 mm (pin + housing) |
| PCB complexity | ZIF footprint + lever clearance | 4x SMD pogo pin pads |

**Assessment:** For the prototype, the ZIF approach works and is already designed. For the next revision, seriously consider switching to pogo pins — the elimination of the lever access cutout alone is worth it for sealing simplicity, and the one-step insertion is better UX.

---

## Sources

### Ergonomic Design
- [The Ergonomics of Wearable Designs: Part 1 - Medical Design Briefs](https://www.medicaldesignbriefs.com/component/content/article/33734-the-ergonomics-of-wearable-designs-part-1)
- [Ergonomic Design Checklist for Wearable Medical Devices - Fusion Design](https://www.fusiondesigninc.com/blog/2024/9/30/ergonomic-design-checklist-for-wearable-medical-devices)
- [Best Practices for Designing a User-Friendly and Comfortable Wearable Device - MPO](https://www.mpo-mag.com/exclusives/best-practices-for-designing-a-user-friendly-and-comfortable-wearable-device/)
- [CDC NHANES Anthropometric Reference Data](https://www.cdc.gov/nchs/data/series/sr_03/sr03_039.pdf)
- [Average Wrist Size Statistics - Nutritioneering](https://www.bodybuildingmealplan.com/average-wrist-size/)
- [Whoop 5.0 Review - Tom's Guide](https://www.tomsguide.com/wellness/fitness-trackers/whoop-5-0-review-should-you-give-a-whoop-about-this-new-tracker)

### Cartridge / Slot Mechanism
- [Push-Push and Beyond: SD Card Connector Mechanisms - MoarConn](https://www.moarconn.com/blog/Push-Push-and-Beyond-The-Evolution-and-Inner-Workings-of-SD-Card-Connector-Mechanisms_b15649)
- [SIM Card Connector Insertion Mechanisms - GCT](https://gct.co/sim-connector/sim-card-connector-insertion-mechanisms)
- [Glucose Test Strips and Electroanalytical Chemistry - BASi](https://www.basinc.com/assets/library/presentations/pdf/JOH-01.pdf)
- [Accu-Chek Guide Test Strips](https://www.accu-chek.com/products/strips/guide)

### Seal and IP Rating Design
- [Waterproof Enclosure Design 101 (and IP68) - Fictiv](https://www.fictiv.com/articles/nothing-gets-in-waterproof-enclosure-design-101-and-ip68)
- [How to Design Waterproof Products - Five Flute](https://www.fiveflute.com/guide/how-to-design-waterproof-products/)
- [IP Ratings for Sealed Enclosures - Stockwell Elastomerics](https://www.stockwell.com/ip-ratings-for-sealed-enclosures/)
- [O-Ring Groove Design - Global O-Ring and Seal](https://www.globaloring.com/o-ring-groove-design/)
- [O-Ring Groove Design Guide - Canyon Components](https://www.canyoncomponents.com/general-groove-design)

### Skin-Contact Surface Design
- [Recent Advances in Skin-Interfaced Wearable Sweat Sensors - PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC11211071/)
- [Skin-Interfaced Wearable Sweat Sensors for Precision Medicine - PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC10406569/)
- [Bioinspired Microfluidic Wearable Sensor for Sweat Sampling - Science Advances](https://www.science.org/doi/10.1126/sciadv.adw9024)
- [Wearable Paper-Integrated Microfluidic Device for Sweat Analysis - RSC](https://pubs.rsc.org/en/content/articlehtml/2022/sd/d2sd00032f)
- [CGM Adhesive Solutions - Avery Dennison](https://medical.averydennison.com/en/home/markets/wearables/comprehensive-adhesive-solutions-for-continuous-glucose-monitoring.html)

### DFM / Manufacturing
- [DFM Guidelines for Injection Molding - Protolabs](https://www.protolabs.com/resources/design-for-moldability-toolkit/)
- [MJF Design Guidelines - Forge Labs](https://forgelabs.com/mjf-design-guide/)
- [Snap-Fit Design Guide - Synectic](https://synectic.net/snap-fit-design/)
- [Snap-Fit Calculator - Fictiv](https://www.fictiv.com/tools/snap-fit-calculator)
- [How to Design Injection-Molded Enclosures - Promwad](https://promwad.com/news/injection-molded-enclosure-design)
- [Injection Molding Design Guidelines - 3DDFM](https://www.3ddfm.com/design-guides/injection-molding-design-guidelines/)

### Materials / Biocompatibility
- [ISO 10993 vs USP Class VI: Medical Molding - Rubber Group](https://rubber-group.com/iso-10993-vs-usp-class-vi-medical-molding/)
- [Medical Grade Silicone - ElastaPro](https://elastapro.com/medical-grade-silicone/)
- [TPUs Revolutionize Medical Device Manufacturing - Plastics Today](https://www.plasticstoday.com/medical/tpus-revolutionize-medical-device-manufacturing)

### Electrical Interface / Pogo Pins
- [Pogo Pins: The Ultimate Guide - Same Sky Devices](https://www.sameskydevices.com/blog/pogo-pins-101)
- [Pogo Pins Engineering - Mill-Max](https://www.mill-max.com/engineering-notebooks/spring-loaded-pogo-pins-connectors/pogo-pins-engineering)
- [Spring-Loaded Pogo Pins & Connectors - Mill-Max](https://www.mill-max.com/engineering-notebooks/spring-loaded-pogo-pins-connectors)
- [ZIF Connectors: Everything You Need to Know - Crystalfontz](https://www.crystalfontz.com/blog/zif-connectors-everything-you-need-to-know/)
- [What are ZIF and LIF Connectors - Connector Supplier](https://connectorsupplier.com/what-are-zif-and-lif-connectors/)
