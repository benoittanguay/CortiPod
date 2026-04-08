# Mechanical Engineering Guidelines for Small Wearable Enclosures

> Practical, actionable engineering rules of thumb for designing, tolerancing, prototyping, and manufacturing a 44x26x10mm wrist-worn device with multi-part snap-together assembly and user-swappable cartridge.

---

## Table of Contents

1. [Parametric CAD Best Practices](#1-parametric-cad-best-practices)
2. [Tolerance Stack-Up Analysis](#2-tolerance-stack-up-analysis)
3. [Design for Assembly (DFA)](#3-design-for-assembly-dfa)
4. [Prototyping Workflow](#4-prototyping-workflow)
5. [Shell / Enclosure Design Patterns](#5-shell--enclosure-design-patterns)
6. [Thermal and Moisture Management](#6-thermal-and-moisture-management)

---

## 1. Parametric CAD Best Practices

### 1.1 Model Architecture: Skeleton-Driven vs Feature-Driven

There are two fundamental approaches to structuring a parametric multi-part assembly:

| Approach | How It Works | When to Use |
|----------|-------------|-------------|
| **Skeleton/master sketch** | A single top-level sketch or part defines all critical dimensions, datum planes, and interface geometry. Every child part references only the skeleton. | Multi-part assemblies where parts share interfaces (shell halves, cartridge slots, PCB mounting). This is the right approach for CortiPod. |
| **Feature-driven (bottom-up)** | Each part is modeled independently with its own dimensions. Assembly constraints align them. | Parts that are truly independent (off-the-shelf components, fasteners). |

**For CortiPod, use the skeleton approach.** The current `parameters.scad` file already serves this role -- all dimensions live in one place, and both shells reference it.

### 1.2 Rules for Robust Parametric Models

These rules prevent models from breaking when you change a dimension:

**Rule 1: Single source of truth for every dimension.**
Every physical dimension should be defined exactly once. Other features reference it, never redefine it. In OpenSCAD, this means every magic number lives in `parameters.scad`.

**Rule 2: Reference primary datums, not derived geometry.**
Sketch constraints and references should point to origin planes, primary datums, or skeleton geometry -- never to edges or faces of other features that might move or disappear.

- Good: "Electrode channel starts 2mm from the datum plane at the -X end"
- Bad: "Electrode channel starts at the edge of the fillet on the internal wall"

**Rule 3: Constrain intent, not just position.**
Use relationships that express design intent:
- Shell clearance = `wall_thickness - mating_wall_thickness - clearance_gap`
- Boss OD = `screw_hole_ID + 2 * boss_wall`
- Snap beam length = `5 * beam_thickness` (minimum for elastic deflection)

**Rule 4: Avoid over-constraining.**
A sketch or feature tree should have exactly the constraints needed to define the geometry. Extra constraints create conflicts when you change a driving dimension.

**Rule 5: Design for the change you expect.**
Ask: "What will I change most often?" For CortiPod, the answer is probably:
- Overall pod dimensions (as PCB layout evolves)
- Electrode channel width/depth (as electrode selection changes)
- Wall thickness (as structural testing reveals needs)
- Snap clip geometry (as fit testing requires tuning)

Make these the top-level parameters that propagate cleanly to all dependent features.

### 1.3 Reference Geometry Strategy

For a two-part shell like CortiPod:

```
Primary datum planes:
  XY plane = parting line (where top and bottom shells meet)
  XZ plane = longitudinal centerline (symmetry plane)
  YZ plane = electrode insertion end reference

Key reference points:
  Origin = geometric center of pod at parting line
  Electrode datum = -X end stop face (sets electrode insertion depth)
  PCB datum = standoff positions (sets PCB location relative to shell)
```

**Every mating feature (O-ring groove, snap clips, alignment pins) should be dimensioned from these datums, not from each other.** This ensures that when you change the pod length, the features move correctly without breaking references.

### 1.4 Multi-Part Assembly Structure

For CortiPod's 2-part shell + electrode cartridge:

```
parameters.scad          <- Single source of truth
  |
  +-- top_shell.scad     <- References parameters.scad only
  |     Features: PCB cavity, battery pocket, snap hooks, O-ring face
  |
  +-- bottom_shell.scad  <- References parameters.scad only
  |     Features: Electrode channels, skin windows, snap receivers, strap lugs
  |
  +-- assembly.scad      <- Imports both shells, positions them
        No new geometry -- only transforms and visualization
```

**Never create a circular reference** where top_shell references bottom_shell geometry or vice versa. Both reference only the shared parameters.

### 1.5 OpenSCAD-Specific Tips

Since CortiPod uses OpenSCAD:

- **Use `include` for parameters, `use` for modules.** `include` brings variables into scope; `use` brings only modules. Keep `parameters.scad` as `include` so all values propagate.
- **Parameterize fillet radii.** Fillets are the most common feature to adjust for printability vs aesthetics. Make them parameters, not hardcoded.
- **Use `$fn` strategically.** Low `$fn` (16-24) for preview speed; high `$fn` (64-128) only for export. Define `$fn = $preview ? 24 : 96;` at the top.
- **Comment every parameter with units and intent.** Future-you will not remember why `clip_depth = 0.8`.

---

## 2. Tolerance Stack-Up Analysis

### 2.1 The Core Problem

When multiple parts assemble, manufacturing variation accumulates. For CortiPod, the critical stack-ups are:

1. **Top shell to bottom shell alignment** -- affects O-ring compression and snap engagement
2. **Electrode in channel** -- affects electrical contact alignment and sealing
3. **PCB to electrode registration** -- affects pogo pin or ZIF contact with electrode pads
4. **Pod to skin surface** -- affects sensor contact quality

### 2.2 Two Analysis Methods

**Worst-case (arithmetic) stack:**
```
Total tolerance = Sum of all individual tolerances
T_total = t1 + t2 + t3 + ... + tn
```
Assumes every part is simultaneously at its worst limit. Conservative. Use for critical dimensions where any failure is unacceptable (O-ring compression, seal gaps).

**Statistical (RSS) stack:**
```
T_total = sqrt(t1^2 + t2^2 + t3^2 + ... + tn^2)
```
Assumes tolerances are independently and normally distributed. Gives a result valid for ~99.73% of assemblies (3-sigma). Use for non-critical dimensions where occasional rework is acceptable.

**Adjusted RSS (recommended for prototyping):**
```
T_total = 1.5 * sqrt(t1^2 + t2^2 + ... + tn^2)
```
Adds a 1.5x safety factor to the RSS result. Accounts for non-normal distributions and unknown process biases in 3D printing.

### 2.3 Process Tolerances for CortiPod's Size Range

For parts in the 10-50mm range:

| Process | Dimensional Tolerance | Min Feature | Surface Finish (Ra) | Notes |
|---------|----------------------|-------------|---------------------|-------|
| **FDM (PETG/PLA)** | +/- 0.3-0.5 mm | 1.2 mm wall, 2mm pin | 10-25 um | Anisotropic; worst in Z |
| **SLA (standard)** | +/- 0.1-0.15 mm | 0.5 mm wall, 0.8mm pin | 1-5 um | Isotropic; post-cure shrinkage 0.1-0.3% |
| **MJF (PA12)** | +/- 0.2-0.3 mm (or +/- 0.3% whichever is larger) | 1.0 mm wall, 1.5mm pin | 6-10 um | Near-isotropic; shrinkage ~3% (compensated by printer) |
| **SLS (PA12)** | +/- 0.2-0.3 mm | 1.0 mm wall, 1.5mm pin | 8-15 um | Similar to MJF |
| **Injection molding** | +/- 0.05-0.15 mm (fine), +/- 0.1-0.3 mm (commercial) | 0.5 mm wall | 0.4-3.2 um | Shrinkage 0.5-2% (material dependent, compensated in mold) |

### 2.4 Worked Example: Electrode-to-Pogo-Pin Stack-Up

Critical question: "Will the pogo pins land on the electrode contact pads?"

The stack from pogo pin tip to electrode pad center:

| Contributor | Nominal (mm) | Tolerance (mm) | Source |
|-------------|-------------|----------------|--------|
| Pogo pin position on PCB (solder placement) | 0 | +/- 0.15 | PCB assembly tolerance |
| PCB position on standoffs (lateral play) | 0 | +/- 0.1 | Standoff hole clearance |
| Standoff position in top shell (MJF) | 0 | +/- 0.25 | MJF dimensional tolerance |
| Top shell to bottom shell alignment (snap fit) | 0 | +/- 0.2 | Snap clip clearance |
| Electrode position in channel (lateral) | 0 | +/- 0.15 | Channel clearance per side |
| Electrode pad position on substrate | 0 | +/- 0.1 | Screen-printed electrode tolerance |

**Worst-case total:** 0.15 + 0.1 + 0.25 + 0.2 + 0.15 + 0.1 = **+/- 0.95 mm**

**RSS total:** sqrt(0.15^2 + 0.1^2 + 0.25^2 + 0.2^2 + 0.15^2 + 0.1^2) = **+/- 0.42 mm**

**Adjusted RSS (1.5x):** 1.5 x 0.42 = **+/- 0.63 mm**

**Design implication:** Electrode contact pads should be at least 2 mm diameter (1 mm radius) to absorb +/- 0.63 mm of misalignment with a 0.37 mm margin. If pads are only 1 mm wide, this stack-up will cause contact misses.

**Strategies to reduce the stack:**
- Add alignment pins between shell halves (reduces shell-to-shell from +/- 0.2 to +/- 0.05)
- Tighten electrode channel clearance (but increases insertion friction)
- Use pogo pin arrays with oversized contact tips (1.5mm tip on 1.0mm pad)
- Design electrode end-stop as a datum that simultaneously sets both longitudinal and lateral position

### 2.5 Clearance and Interference Fit Guidelines

For plastic-to-plastic fits in the 10-50mm range:

| Fit Type | Radial Clearance Per Side | Use Case |
|----------|--------------------------|----------|
| **Loose clearance** | 0.3-0.5 mm | Parts that must slide freely (electrode in channel during insertion) |
| **Close clearance** | 0.1-0.2 mm | Parts that align but still move (electrode seated in channel) |
| **Transition fit** | 0.0-0.05 mm | Parts that locate precisely (alignment pins) |
| **Light press fit** | -0.02 to -0.05 mm | Parts that stay put but can be pushed apart (bushing in hole) |
| **Press fit** | -0.05 to -0.1 mm | Permanent assembly (metal pin in plastic) |

**Adjust for process:**
- FDM: Add 0.1-0.2 mm extra clearance to all fits (shrinkage, layer lines, elephant foot)
- SLA: Use nominal clearances; parts are accurate but brittle
- MJF: Add 0.05-0.1 mm extra clearance (powder sintering slightly enlarges features)
- Injection molding: Use nominal clearances; adjust mold for measured shrinkage

### 2.6 GD&T Basics for Small Plastic Parts

For communicating tolerances on drawings (needed when you send parts to a manufacturer):

**The critical GD&T callouts for CortiPod:**

| Symbol | Control | Where to Apply | Typical Value |
|--------|---------|---------------|---------------|
| **Position** (circled +) | Controls hole/feature location relative to datums | Standoff holes, alignment pin holes, pogo pin through-holes | 0.2-0.5 mm (MJF), 0.1-0.2 mm (injection molded) |
| **Flatness** | Controls surface waviness | O-ring mating face, parting line surface | 0.05-0.1 mm (injection molded), 0.1-0.2 mm (MJF) |
| **Profile of a surface** | Controls 3D surface shape | Skin-contact curved surface, shell exterior | 0.2-0.5 mm |
| **Perpendicularity** | Controls wall angle relative to datum | Electrode channel walls, snap clip faces | 0.1-0.2 mm |

**Datum selection for CortiPod:**
- Datum A: Parting line face (flat mating surface between shells)
- Datum B: Electrode end-stop face (-X wall)
- Datum C: Centerline of pod (symmetry plane)

All critical features (electrode channel position, standoff holes, O-ring groove) should be toleranced relative to these three datums.

---

## 3. Design for Assembly (DFA)

### 3.1 Part Count Minimization

The Boothroyd-Dewhurst DFA method asks three questions for every part:

1. **Does this part move relative to adjacent parts during operation?** If no, consider combining.
2. **Must this part be a different material?** If no, consider combining.
3. **Must this part be separate for assembly/disassembly?** If no, consider combining.

Applied to CortiPod:

| Part | Must Be Separate? | Reason |
|------|-------------------|--------|
| Top shell | Yes | Must open for PCB access |
| Bottom shell | Yes | Must separate from top shell |
| O-ring | Yes | Different material (elastomer) |
| PCB assembly | Yes | Different material/process (electronics) |
| Battery | Yes | Different component |
| Electrode cartridge | Yes | User-swappable |
| Strap | Yes | Standard interface |

**Current count: 7 functional parts.** This is already near-minimum for this architecture. Areas to potentially reduce:

- Integrate O-ring groove seal with a liquid silicone gasket-in-place (eliminates separate O-ring part)
- Combine battery holder features into the top shell (eliminate separate battery clip if present)

### 3.2 Poka-Yoke (Mistake-Proofing)

Design every interface so it can only go together one way:

**Shell-to-shell:**
- Add asymmetric alignment features: one pin + one slot, placed off-center so the top shell only fits one way on the bottom shell
- Current snap clips should be asymmetric (e.g., 3 clips on the long sides, 1 on the short side) so orientation is unambiguous
- Use a "D-shaped" alignment pin rather than round -- prevents 180-degree rotation

**Electrode insertion:**
- The electrode should only fit one way. Strategies:
  - Chamfer one corner of the electrode (keying notch)
  - Make the channel asymmetric in cross-section (one rail wider than the other)
  - Shape the connector tail so it only enters the ZIF/contact area in the correct orientation
- The end-stop ensures correct insertion depth
- The channel width ensures correct lateral position

**PCB in shell:**
- Standoffs should be placed asymmetrically so the PCB only fits one way
- Use 2 round standoffs + 1 slotted standoff (the slot accommodates thermal expansion while maintaining orientation)

**General poka-yoke rules for small devices:**
- Every mating surface should have one and only one correct orientation
- Color-code or texture-code parts if visual differentiation helps assembly workers
- Design parts so gravity assists assembly (parts fall into place when held in the correct orientation)
- Avoid mirror-symmetric parts that can be confused with each other

### 3.3 One-Handed and Tool-Free Assembly

How commercial wearables achieve tool-free assembly:

| Device | Assembly Method | Key Mechanism |
|--------|----------------|---------------|
| **Whoop 4.0/5.0** | Pod clips into band clasp | Snap-fit pod holder, flex-band retention |
| **Apple Watch** | Band slides into rail slots | Spring-loaded ball-detent in rail groove; button press to release |
| **Fitbit Charge** | Module snaps into band cradle | Cantilever snaps on band cradle engage pod undercuts |
| **Dexcom G7** | Applicator snaps onto sensor pod | One-press applicator with lancing mechanism |

**Design rules for tool-free assembly:**
- Maximum insertion/snap force for one-handed operation: **15-25 N** (comfortable thumb push)
- Maximum disassembly force: **5-15 N** (enough to prevent accidental release, low enough for intentional removal)
- Provide tactile and audible feedback: a "click" when parts engage. Snap-fit geometry naturally provides this.
- Round/chamfer all lead-in edges at 30-45 degrees to guide parts together
- Design for "drop-in" assembly where possible: parts align by gravity before engagement

### 3.4 Assembly Sequence Optimization

For CortiPod, the optimal assembly sequence:

```
1. Place PCB onto standoffs in top shell (self-aligning via standoff holes)
2. Connect battery, tuck into cavity (cable length constrains position)
3. Apply RTV or seat O-ring on top shell mating face
4. Align top shell over bottom shell (alignment pins guide)
5. Press together until snaps click (one action, both hands)
6. Slide electrode into channel from +X end (one-handed, friction retention)
7. Close ZIF lever or let pogo pins make contact (one-handed)
8. Attach strap (standard quick-release)
```

**Steps 1-5 are "manufacturing assembly" (done once or rarely). Steps 6-8 are "user assembly" (done by the end user).** User steps must be simpler, lower force, and more mistake-proof than manufacturing steps.

---

## 4. Prototyping Workflow

### 4.1 The Iteration Funnel

```
                    FDM (days)
                 /     |
           Form fit    |
          Rough check  |
                 \     |
                  SLA/MJF (1-2 weeks)
                 /     |
        Functional     |
         test fit      |
       Tolerance       |
        check          |
                 \     |
              Soft tooling / 3D printed mold (3-4 weeks)
                 /     |
        Near-production |
        material test  |
        50-500 units   |
                 \     |
           Production injection mold (8-16 weeks)
                       |
                    Ship
```

### 4.2 Process Selection by Prototype Stage

| Stage | Process | Why | What You Learn | Cost (per set) |
|-------|---------|-----|----------------|----------------|
| **Concept (v0.1-0.3)** | FDM (PLA/PETG) | Same-day prints, pennies per part | Overall form, ergonomic feel, PCB fit check, basic assembly sequence | $1-3 |
| **Engineering (v0.4-0.8)** | SLA or MJF | Accurate dimensions, functional snap fits, testable seals | Tolerance stack-ups, snap engagement force, O-ring compression, electrode insertion feel | $5-25 (MJF via JLCPCB) |
| **Validation (v0.9-1.0)** | MJF PA12 or SLA BioMed Amber | Production-representative material and accuracy | Durability, seal testing (dunk test), extended skin wear, drop test | $10-30 |
| **Pre-production** | 3D-printed injection mold or soft aluminum tool | Actual production material (e.g., injection-molded PC or PA12) | Shrinkage, surface finish, ejection, part-to-part consistency | $500-2000 (mold) + $1-5/part |

### 4.3 Tolerance Expectations by Process

Specific to CortiPod's 44x26x10mm size:

| Dimension | FDM (+/-) | SLA (+/-) | MJF (+/-) | Injection Molded (+/-) |
|-----------|-----------|-----------|-----------|----------------------|
| Overall length (44mm) | 0.4 mm | 0.15 mm | 0.25 mm | 0.08 mm |
| Overall width (26mm) | 0.35 mm | 0.12 mm | 0.2 mm | 0.06 mm |
| Wall thickness (1.5mm) | 0.2 mm | 0.08 mm | 0.15 mm | 0.05 mm |
| Hole diameter (2mm standoff) | 0.3 mm | 0.1 mm | 0.2 mm | 0.05 mm |
| Channel width (10.5mm electrode slot) | 0.35 mm | 0.12 mm | 0.2 mm | 0.06 mm |
| Feature position | 0.4 mm | 0.15 mm | 0.25 mm | 0.08 mm |

### 4.4 FDM-Specific Prototyping Rules

- **Orientation matters.** Print shells open-face-up to avoid supports on internal features. The parting line face should be the first layer (on the build plate) for flatness.
- **Elephant foot compensation.** The first layer spreads 0.1-0.2mm wider than nominal. Sand or account for this on mating faces.
- **Hole undersizing.** Holes print 0.1-0.3mm smaller than nominal on FDM. Either model them larger or ream after printing.
- **Snap fits on FDM are fragile.** PLA snaps break. PETG is better. Nylon (NylonX, CF-nylon) is best for functional snap-fit prototypes on FDM.
- **Layer orientation for snaps.** Print snap beams so that layer lines run along the beam length, not across it. Cross-layer beams delaminate under bending.

### 4.5 When to Stop Iterating in 3D Print and Move to Molding

Move to injection molding when:
- [ ] All interfaces verified: snap fits engage/disengage correctly for 50+ cycles
- [ ] Electrode insertion/removal works one-handed with correct force feel
- [ ] O-ring or gasket seal passes 30-minute dunk test (IP67 equivalent)
- [ ] PCB seats correctly with all connectors accessible
- [ ] Pogo pins or ZIF makes reliable electrical contact across 20+ insertion cycles
- [ ] Skin comfort validated in 8+ hour wear test
- [ ] Production volume justifies mold cost (typically >500-1000 units)

---

## 5. Shell / Enclosure Design Patterns

### 5.1 Boss and Screw Post Design

For PCB mounting standoffs and screw bosses in CortiPod:

**Dimensional rules (for injection molding -- 3D printing is more forgiving):**

| Parameter | Rule | CortiPod Value (1.5mm wall) |
|-----------|------|---------------------------|
| Boss OD | 2.0-2.5x screw diameter | For M2 screw: OD = 4.0-5.0 mm |
| Boss wall thickness | 0.5-0.6x nominal wall thickness | 0.75-0.9 mm |
| Boss height | Max 3x boss OD | Max 12-15 mm (not a concern at 10mm pod height) |
| Base fillet radius | 0.25-0.5x wall thickness | 0.375-0.75 mm |
| Draft (outer) | 0.5 deg minimum | 0.5-1.0 deg |
| Draft (inner hole) | 0.25 deg minimum | 0.25-0.5 deg |
| Rib connection | Connect to nearest wall with rib | Always; isolated bosses sink and warp |

**Why boss wall = 0.5-0.6x nominal wall:** A thicker boss creates a thick section where it meets the shell wall, causing sink marks on the exterior surface. Keeping the boss thinner than the wall avoids this.

**For CortiPod's standoffs specifically:**
- Current standoff design uses integral bosses in the top shell
- At 10mm total height with 1.5mm walls, the standoffs are only ~3-4mm tall -- well within the 3x OD limit
- Connect each standoff to the nearest wall with a rib for stiffness and to prevent weld-line weakness

### 5.2 Rib Design for Stiffness

Ribs increase part stiffness without increasing wall thickness (which causes sink marks and long cycle times).

**Dimensional rules:**

| Parameter | Rule | CortiPod Value (1.5mm wall) |
|-----------|------|---------------------------|
| Rib thickness | 0.5-0.6x wall thickness | 0.75-0.9 mm |
| Rib height | Max 3x wall thickness | Max 4.5 mm |
| Rib spacing | Min 2-3x wall thickness | Min 3.0-4.5 mm center-to-center |
| Base fillet | 0.25-0.5x wall thickness | 0.375-0.75 mm |
| Draft angle | 0.5-1.5 deg per side | 1.0 deg |
| Rib-to-wall transition | Fillet, not sharp corner | R 0.4 mm minimum |

**Stiffness calculation for a ribbed plate:**

The moment of inertia of a ribbed section vs. a flat plate:
```
Flat plate:  I = (b * t^3) / 12
Ribbed:      I = (b * t^3) / 12 + n * (t_rib * h_rib^3) / 12 + n * (t_rib * h_rib) * d^2
```
Where `d` is the distance from the rib centroid to the plate neutral axis, `n` is the number of ribs, and `b` is the plate width. A single 0.9mm x 4.5mm rib on a 1.5mm wall increases bending stiffness by roughly **8-12x** compared to the flat wall alone.

**Where CortiPod needs ribs:**
- Top shell ceiling (spans the full 44x26mm unsupported). 2-3 longitudinal ribs between the PCB standoffs prevent flexing when the user presses the pod.
- Bottom shell floor between skin windows, if the floor feels too flexible.
- Around the electrode channel walls for lateral stiffness.

### 5.3 Cantilever Snap-Fit Beam Design

This is the most critical structural calculation for the shell-to-shell joint.

**Geometry of a cantilever snap:**
```
        |<--- L --->|
        |           |
   _____|           |___
  |     |           |   |  <- t (beam thickness)
  |     |     beam  | / |
  |wall |           |/  |  <- undercut (deflection Y)
  |     |___________/   |
  |_____________________|
        |<- B (width) ->|
```

**Key formulas (rectangular uniform cross-section):**

Maximum deflection from allowable strain:
```
Y = 0.67 * epsilon * L^2 / t
```

Force to deflect beam:
```
P = (B * t^2 * E * epsilon) / (6 * L)
```

Assembly/insertion force (with friction and lead-in angle):
```
W = P * (mu + tan(alpha)) / (1 - mu * tan(alpha))
```

Maximum stress at root:
```
sigma_max = (E * t * Y) / (2 * L^2)
```

**For a tapered beam (recommended -- tip thickness = 0.5x root thickness):**
Replace the 0.67 coefficient with **1.09** in the deflection formula. This allows 63% more deflection for the same strain, or the same deflection with a shorter beam.

**Worked example for CortiPod snap clips:**

Given (from current parameters.scad):
- Beam width B = 3.0 mm (clip_width)
- Undercut/deflection Y = 0.8 mm (clip_depth)
- Material: MJF Nylon PA12 (dry)
  - E = 1,500 MPa
  - Allowable repeated-use strain = 2.5% (0.025)
- Coefficient of friction mu = 0.3 (nylon on nylon)
- Lead-in angle alpha = 30 deg

Calculate required beam length (uniform beam):
```
L = sqrt(Y * t / (0.67 * epsilon))
```
We need to pick t. For a 0.8mm undercut, try t = 1.0 mm:
```
L = sqrt(0.8 * 1.0 / (0.67 * 0.025)) = sqrt(0.8 / 0.01675) = sqrt(47.76) = 6.9 mm
```

Check: Is L >= 5t? 6.9 >= 5.0, yes -- beam is slender enough for simple beam theory.

Deflection force:
```
P = (3.0 * 1.0^2 * 1500 * 0.025) / (6 * 6.9) = 112.5 / 41.4 = 2.72 N
```

Assembly force:
```
W = 2.72 * (0.3 + tan(30)) / (1 - 0.3 * tan(30))
  = 2.72 * (0.3 + 0.577) / (1 - 0.173)
  = 2.72 * 0.877 / 0.827
  = 2.88 N per clip
```

For 4 clips total: **~11.5 N total assembly force** -- well within the 15-25N one-handed limit.

**If using a tapered beam** (tip = 0.5mm, root = 1.0mm):
```
L = sqrt(0.8 * 1.0 / (1.09 * 0.025)) = sqrt(0.8 / 0.02725) = sqrt(29.36) = 5.4 mm
```
The tapered beam is 22% shorter for the same deflection and strain. Shorter beams save space inside the enclosure.

### 5.4 Material Strain Limits for Snap Fits

| Material | Single-Use Strain Limit | Repeated-Use Strain Limit | Elastic Modulus E (MPa) |
|----------|------------------------|--------------------------|------------------------|
| **Nylon PA12 (dry)** | 4-6% | 2-3% | 1,200-1,800 |
| **Nylon PA12 (conditioned/wet)** | 6-8% | 3-4% | 800-1,200 |
| **ABS** | 2-4% | 1-2% | 2,000-2,600 |
| **PC (polycarbonate)** | 4-8% | 2-4% | 2,200-2,400 |
| **Acetal (POM)** | 4-7% | 2-3% | 2,800-3,200 |
| **PP (polypropylene)** | 6-10% | 3-5% | 1,100-1,500 |
| **PETG** | 2-4% | 1-2% | 2,000-2,200 |
| **PLA** | 1-2% | <1% (too brittle) | 2,500-3,500 |

**Critical note for 3D-printed snaps:** Reduce allowable strain by 50% if the beam bends across layer lines (Z-axis). MJF is nearly isotropic so this penalty is small (~10-20% reduction). FDM is severely anisotropic -- always orient snap beams with layers along the beam length.

### 5.5 Living Hinge Design

A living hinge is a thin flexible section connecting two rigid sections, allowing rotation without a separate hinge mechanism.

**Applicability to CortiPod:** A living hinge could connect a seal flap over the electrode insertion slot, or connect a battery door to the shell.

**Design rules:**

| Parameter | Rule | Typical Value |
|-----------|------|---------------|
| Hinge thickness | T = H/5 to H/8 (H = adjoining wall thickness) | 0.2-0.4 mm |
| Hinge land length | Along the fold axis | 0.5-1.5 mm |
| Radius on tension side | Min 0.75 mm | R 0.75-1.0 mm |
| Material | PP is best; nylon is second | PP: millions of cycles; nylon: thousands |

**PP living hinge can endure millions of flex cycles.** Nylon PA12 can handle thousands of cycles but will eventually fatigue-crack. For a flap that opens ~200 times over the device lifetime, nylon is fine.

**Critical manufacturing detail:** A living hinge must be flexed several times immediately after molding while the material is still warm. This orients the polymer chains in the hinge zone and dramatically increases fatigue life. For 3D-printed living hinges, this conditioning step is less effective -- expect 10-100x fewer cycles than injection-molded.

**3D printing a living hinge:** Difficult on FDM (layer lines create stress concentrators at hinge). SLA with flexible resin or MJF with PA12 can produce functional hinges for low-cycle applications (<100 cycles). Design the hinge 0.3-0.5mm thick for MJF, 0.4-0.6mm for FDM with TPU.

### 5.6 Draft Angle Rules

Only required for injection molding. Included here for DFM-forward design.

**General rules:**

| Surface Condition | Min Draft | Recommended Draft |
|-------------------|-----------|-------------------|
| Polished/Class A | 0.5 deg | 1.0 deg |
| Standard (SPI B-2/B-3) | 1.0 deg | 1.5 deg |
| Light texture (MT-11000 range) | 3.0 deg | 3.0-4.0 deg |
| Heavy texture/matte | 5.0 deg | 5.0+ deg |
| Shutoffs (metal-to-metal) | 3.0 deg min | 3.0-5.0 deg |

**Depth rule of thumb:** Add 1 degree of draft per 25mm of draw depth. CortiPod's maximum draw depth is ~7.5mm (top shell height), so 1 degree is sufficient for untextured surfaces.

**Where draft matters in CortiPod (future injection molding):**
- Electrode channel walls: 0.5-1.0 deg (tight tolerance needed, but the open +X end is the pull direction, so the channel is actually a through-feature -- no draft needed along the insertion axis)
- Shell exterior walls: 1.0-1.5 deg
- Interior ribs: 0.5-1.0 deg per side
- Snap clip beams: 0.5 deg on the engagement face; the beam itself is formed by the core pull direction
- O-ring groove: No draft needed (formed in the parting line plane)

### 5.7 Corner and Fillet Design

**Interior corners:** Always fillet. Sharp interior corners are stress concentrators and molding defects.
- Minimum interior fillet: 0.5x wall thickness = 0.75 mm for CortiPod
- Recommended: 0.75-1.0x wall thickness = 1.0-1.5 mm

**Exterior corners:** Fillet for ergonomics and aesthetics.
- Minimum exterior fillet: interior fillet + wall thickness = 2.25-3.0 mm for CortiPod
- This maintains uniform wall thickness through the corner

**Rule:** Exterior radius = Interior radius + wall thickness. This prevents thin spots at corners.

---

## 6. Thermal and Moisture Management

### 6.1 Heat Sources in CortiPod

| Component | Estimated Power Dissipation | Duty Cycle | Notes |
|-----------|---------------------------|------------|-------|
| nRF52840 (BLE SoC) | 15-30 mW (active TX) | 1-5% (intermittent transmit) | Negligible average thermal load |
| AD5941 (potentiostat AFE) | 10-20 mW (active measurement) | 5-20% (measurement cycles) | Small thermal load |
| LiPo battery (charging) | 200-500 mW (charge cycle) | 0% during wear (no charging while worn) | Not a thermal concern during use |
| **Total during wear** | **~5-15 mW average** | | **Very low thermal load** |

**Assessment:** CortiPod's thermal load is negligible. The nRF52840 and AD5941 combined dissipate less than 50mW peak, with low duty cycles. For comparison, an Apple Watch dissipates 500-2000mW during active use. **No active or passive thermal management is needed for CortiPod.** The plastic shell itself provides sufficient thermal conduction to ambient air.

However, if a future revision adds continuous sensing or a display, thermal management may become relevant. The guidelines below apply to that scenario.

### 6.2 Thermal Management Strategies for Sealed Wearables

For devices with higher thermal loads (>200mW sustained):

**Conduction path design:**
```
Heat source (IC) --> Thermal pad/paste --> PCB copper pour -->
Thermal via array --> Shell wall (contact pad) --> Ambient air/skin
```

- **Thermal vias:** 0.3mm diameter vias under the IC, filled or tented, on 1.0mm pitch. A 3x3 array of vias reduces junction-to-case thermal resistance by 50-70%.
- **Copper pour:** Connect thermal vias to a ground-plane copper pour on the shell-facing side of the PCB. This spreads heat over a larger area.
- **Thermal interface:** Where the PCB contacts the shell wall, use a thermal gap pad (0.5-2.0 W/mK) or apply thermal paste if the gap is <0.1mm.
- **Shell material conductivity:** PA12 nylon = 0.25 W/mK (poor), aluminum = 205 W/mK (excellent), PC = 0.2 W/mK (poor). For a plastic shell, heat must spread before it reaches the shell -- the PCB copper pour does this.

**Temperature limits:**
- Skin contact surface: Max 43 deg C (IEC 62368-1 limit for continuous skin contact with metal; 48 deg C for plastic). Above this, users feel discomfort and risk burns.
- Battery: Max 45 deg C recommended for LiPo longevity; max 60 deg C absolute.
- Electronics: Typical commercial range -10 to +70 deg C junction temperature.

### 6.3 Moisture and Condensation Management

**The problem:** A sealed enclosure traps air. Temperature changes cause the air inside to expand/contract, creating pressure differentials. When warm humid air inside cools (e.g., moving from a warm room to cold outdoors), moisture condenses on internal surfaces.

**How serious is this for CortiPod?**

With a ~6 cm^3 internal air volume and a 20 deg C temperature swing, the pressure differential is approximately:
```
delta_P = P_atm * delta_T / T = 101325 * 20/293 = ~6900 Pa (~1 psi)
```
This pressure differential can:
- Stress gaskets and seals (potentially breaking the seal over time)
- Push moisture-laden air through imperfect seals on cooling
- Cause visible condensation on internal surfaces

**Solution: ePTFE membrane vent (GORE-style)**

A breathable vent uses expanded PTFE membrane with pores that are:
- Large enough to pass air and water vapor (equalizes pressure and humidity)
- Small enough to block liquid water droplets (maintains IP67 rating)

Specifications for a typical ePTFE vent suitable for CortiPod:
- Pore size: ~0.2 um (20,000x smaller than a water droplet)
- Water entry pressure: >10 kPa (withstands IP67 immersion test)
- Air flow: 200-2000 mL/min at 70 mbar differential (device-size dependent)
- Temperature range: -40 to +125 deg C
- Size: As small as 3mm diameter adhesive-backed disc

**Placement on CortiPod:** A 3-4mm diameter ePTFE vent on the top shell (away from skin, away from electrode slot) would equalize pressure without admitting liquid water. During prototyping, this is optional -- condensation is only a problem in production devices worn across temperature extremes.

**Products:**
- GORE Protective Vents (PolyVent series): adhesive-backed, IP67-IP69K rated
- Donaldson Tetratex membrane vents: similar performance, often cheaper
- Nitto Temish series: common in consumer electronics

### 6.4 Sweat Ingress Management

CortiPod is unique because it **needs** sweat to reach the electrode (for cortisol sensing) but must **prevent** sweat from reaching the electronics.

**The architecture already handles this:**
```
                     Electronics cavity (DRY)
                    +-----------------------+
                    |  PCB  battery  BLE    |
                    +-----------+-----------+
                    | top shell wall 1.5mm  |
   O-ring seal --> =========================  <-- parting line
                    | bottom shell 2.5mm    |
                    +-----+-----+-----+----+
                    |     | electrode  |    |
                    | dry | (wet face) | dry|
                    +-----+-----+-----+----+
                          |  |  |  |
                         skin windows
                    ==========================
                              SKIN (wet with sweat)
```

The electrode substrate itself is the moisture barrier. Sweat contacts the electrode sensing face (bottom) but cannot pass through the ceramic substrate to reach the electronics above.

**Vulnerable points for sweat ingress:**
1. **Around the electrode edges in the channel:** Capillary wicking can draw sweat up the 0.15mm gap between the electrode and channel walls. Mitigation: slot gasket or hydrophobic coating on channel walls.
2. **Through the insertion slot opening at +X end:** Sweat can wick or splash into the open end. Mitigation: silicone flap, labyrinth seal, or both.
3. **Through the shell-to-shell joint:** If the O-ring or RTV seal fails. Mitigation: proper O-ring compression (20-25%), use RTV as backup.

**Hydrophobic surface treatment:** Applying a hydrophobic coating (e.g., NeverWet, fluorosilane, or Parylene C conformal coating on the PCB) to internal surfaces prevents wicking and provides a last line of defense if moisture does enter.

### 6.5 Testing Moisture Resistance

**Simple prototype tests:**

| Test | How | Pass Criteria | IP Equivalent |
|------|-----|---------------|---------------|
| **Splash test** | Run under faucet for 1 minute | No water inside | ~IP54 |
| **Sweat simulation** | Apply dyed saline (0.5% NaCl + food coloring) to skin side, wear 8 hours | No dye visible inside | Functional sweat test |
| **Dunk test** | Submerge in dyed water at 1m depth for 30 min | No dye inside | IP67 |
| **Thermal cycle** | Heat to 40C, seal, cool to 10C, check for condensation | No visible condensation on PCB | Thermal cycling robustness |
| **Pressure decay** | Seal device, pressurize to 10 kPa, monitor pressure for 60s | <10% pressure drop | Quantitative seal quality |

For prototype testing, the dyed-water dunk test is the most informative single test. Use fluorescein dye (bright yellow-green under UV light) for maximum sensitivity -- even tiny ingress paths are visible.

---

## Applied to CortiPod: Quick Reference Card

### Critical Dimensions and Tolerances

| Feature | Nominal | Tolerance (MJF prototype) | Tolerance (injection molded) |
|---------|---------|--------------------------|------------------------------|
| Pod exterior | 44 x 26 x 10 mm | +/- 0.25 mm | +/- 0.08 mm |
| Shell wall | 1.5 mm | +/- 0.15 mm | +/- 0.05 mm |
| Electrode channel width | 10.5 mm (10.2 + 0.3 clearance) | +/- 0.2 mm | +/- 0.06 mm |
| O-ring groove depth | 0.75 mm | +/- 0.1 mm | +/- 0.03 mm |
| Snap clip undercut | 0.8 mm | +/- 0.15 mm | +/- 0.05 mm |
| Alignment pin diameter | 2.0 mm | +/- 0.15 mm | +/- 0.05 mm |
| Alignment pin hole | 2.2 mm (0.1mm clearance per side) | +/- 0.15 mm | +/- 0.05 mm |

### Snap-Fit Summary

| Parameter | Value |
|-----------|-------|
| Number of clips | 4 (2 per long side) |
| Clip width | 3.0 mm |
| Clip undercut | 0.8 mm |
| Beam thickness (root) | 1.0 mm |
| Beam length (tapered) | 5.4 mm |
| Taper ratio | 2:1 (root:tip) |
| Assembly force per clip | ~2.9 N |
| Total assembly force | ~11.5 N |
| Lead-in angle | 30 deg |
| Root fillet | R 0.5 mm |

### Material Cheat Sheet

| Material | E (MPa) | Repeated Strain | Density | Skin-Safe? |
|----------|---------|-----------------|---------|------------|
| MJF PA12 | 1,500 | 2-3% | 1.01 g/cm3 | Needs testing |
| SLA BioMed Amber | 2,800 | 1-2% | 1.18 g/cm3 | USP Class VI |
| Injection-molded PC | 2,300 | 2-4% | 1.20 g/cm3 | Needs testing |
| Injection-molded ABS | 2,200 | 1-2% | 1.04 g/cm3 | Needs testing |
| Medical silicone (LSR) | 5-10 | >100% | 1.10 g/cm3 | ISO 10993 |

---

## Sources

### Parametric CAD
- [Managing Complex Parametric Relationships in SOLIDWORKS](https://www.engineersrule.com/managing-complex-parametric-relationships-in-solidworks/)
- [Flexible Parametric Design - Onshape](https://www.onshape.com/en/blog/flexible-parametric-design-part-studio-configurations)
- [Robust Sketch Constraints - CAD Journal](https://www.cad-journal.net/files/vol_20/CAD_20(1)_2023_56-81.pdf)
- [Parametric Assemblies - Dezignstuff](https://dezignstuff.com/parametric-assemblies/)

### Tolerance Analysis
- [The Three Steps of Tolerance Analysis - Simplexity](https://www.simplexitypd.com/the-three-steps-of-tolerance-analysis/)
- [Tolerance Stack-Up Analysis Basics - GD Prototyping](https://www.gd-prototyping.com/tolerance-stack-up-analysis/)
- [How to Conduct Tolerance Analysis for 3D Printed Parts - Fictiv](https://www.fictiv.com/articles/how-to-conduct-a-tolerance-analysis-for-3d-printed-parts)
- [Engineering Fits for 3D Printed Assemblies - AON3D](https://www.aon3d.com/applications/engineering-fits-how-to-design-for-3d-printed-assemblies/)
- [Injection Molding Tolerances - Evok Polymers](https://evokpoly.com/feeds/blog/plastic-moulding-tolerances)

### Design for Assembly
- [Design for Assembly Guide - Xometry](https://xometry.pro/en/articles/design-for-assembly-dfa-guide/)
- [DFA Principles - DFMA.com](https://www.dfma.com/design-for-assembly.asp)
- [DFA Best Practices - Five Flute](https://www.fiveflute.com/guide/design-for-assembly-dfa-best-practices/)
- [DFMA Principles and Real-World Examples - Fictiv](https://www.fictiv.com/articles/dfma-design-for-assembly-and-manufacturing)
- [DFA in Medical Device Design - Arrotek](https://arrotek.com/en/what-is-dfa-design-for-assembly-in-medical-device-design/)

### Prototyping and 3D Printing Tolerances
- [3D Printing Tolerances Explained - 3D On Demand](https://www.3d-demand.com/blog/3d-printing-tolerances-explained)
- [FDM vs SLA vs SLS Technology Comparison - Formlabs](https://formlabs.com/blog/fdm-vs-sla-vs-sls-how-to-choose-the-right-3d-printing-technology/)
- [3D Printing Tolerances Chart - GD Prototyping](https://www.gd-prototyping.com/3d-printing-tolerances-chart/)
- [SLS vs FDM vs SLA vs MJF Comparison - TPM3D](https://english.tpm3d.com/sls-fdm-sla-mjf-what-to-choose-for-end-use-parts/)
- [3D Printing Tolerances - Protolabs](https://www.protolabs.com/resources/design-tips/3d-printing-tolerances/)
- [Scaling from 3D Prototypes to Injection Mold-Ready Designs - Fictiv](https://www.fictiv.com/articles/scaling-up-from-3d-printed-prototypes-to-injection-mold-ready-designs)

### Snap-Fit Design
- [How to Design Snap Fit Components - Fictiv](https://www.fictiv.com/articles/how-to-design-snap-fit-components)
- [Snap Force Calculator - StudioRed](https://www.studiored.com/snap-force-calculator/)
- [BASF Snap-Fit Design Manual](https://www.studocu.com/sg/document/national-university-of-singapore/design-for-manufacturing-and-assembly/snap-fit-design-manual/9485628)
- [Bayer Plastic Snap-Fit Design Guide (MIT)](https://fab.cba.mit.edu/classes/S62.12/people/vernelle.noel/Plastic_Snap_fit_design.pdf)
- [Improving Snapfit Design Series - UL Prospector](https://www.ulprospector.com/knowledge/1248/pe-snapfit-3/)

### Enclosure Design (Bosses, Ribs, Draft)
- [10 Boss Design Guidelines - DFMPro](https://dfmpro.com/blog/10-simple-design-guidelines-one-follow-effective-design-boss-features-plastic-parts/)
- [Screw Boss Design Guide - RapidDirect](https://www.rapiddirect.com/blog/screw-boss-design-injection-molding/)
- [Design Better Screw Bosses - Protolabs](https://www.protolabs.com/resources/blog/design-better-screw-bosses-on-molded-parts/)
- [Rib Design Guide for Injection Moulding - HLH Rapid](https://hlhrapid.com/knowledge/rib-design-guide-injection-moulding/)
- [Plastic Ribs for Injection Molding - Xometry](https://www.xometry.com/resources/injection-molding/plastic-ribs-for-injection-molding-design/)
- [Draft Angle Guidelines - Protolabs](https://www.protolabs.com/resources/design-tips/improving-part-moldability-with-draft/)
- [Draft Angle Guide - Fictiv](https://www.fictiv.com/articles/draft-angle-injection-molding)

### Living Hinge Design
- [Living Hinge Design Guidelines - MatterHackers](https://www.matterhackers.com/news/living-hinge:--design-guidelines-and-material-selection)
- [Living Hinge Design Guide - RevPart](https://revpart.com/living-hinge-design-guide/)
- [How to Design Living Hinges - Fictiv](https://www.fictiv.com/articles/how-to-design-living-hinges)
- [Design Issues on Living Hinges - MIT](https://stuff.mit.edu/afs/athena/course/2/2.75/resources/random/Living%20Hinge%20Design.pdf)

### Thermal and Moisture Management
- [GORE Protective Vents - Condensation Management](https://www.gore.com/solutions-condensation-management)
- [IP-Rated Vents for Electronics - Bud Industries](https://www.budind.com/breathable-ip-rated-vents/)
- [IP Ratings Design Guide - Embien](https://www.embien.com/blog/ingress-protection-ip-ratings-for-electronics-a-design-guide)
- [IP67 IoT Enclosure Design - Engon Technologies](https://engontechnologies.com/ip67-drop-proof-and-heat-managed-iot-enclosures/)
