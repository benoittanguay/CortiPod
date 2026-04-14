# Electrode Swap Geometry Exploration

> Investigating enclosure geometries for tool-free daily electrode swapping, with direct skin contact as a hard constraint.

---

## Design Constraints

| Constraint | Value |
|------------|-------|
| Electrode | DRP-220AT: 33.8 x 10.2 x 0.5 mm rigid ceramic substrate |
| Electrode orientation | Sensing face **down** (toward skin) |
| Pod envelope | ~44 x 26 x 10 mm |
| Swap frequency | Daily (~365 cycles/year, ~700+ over device lifetime) |
| Electrical contacts | 3-4 pads on the electrode connector tail |
| Wearing position | Dorsal wrist, retained by strap |
| Sealing target | IP54 minimum (splash-proof) |
| Prototype method | FDM / SLA / MJF 3D printing |

**Hard rule:** The electrode sensing face must make direct contact with skin through an opening in the bottom of the enclosure. Every geometry must preserve this.

---

## Geometry 1: Side-Loading Slot (Current Design)

### Concept

The electrode slides horizontally into a channel from one end of the pod (+X). Guide rails constrain the electrode, an end-stop sets depth, and upward-facing pogo pins in the channel floor make electrical contact. The sensing face points down through skin windows.

```
Top view:
                    insertion direction →
    ┌──────────────────────────────────────┐
    │              top shell               │
    ├──────────────────────────────────────┤
    │  ┌─────────────────────────┬──┐  ◄── chamfered funnel
    │  │   electrode in channel  │  │  │
    │  └─────────────────────────┴──┘  │
    └──────────────────────────────────────┘

Cross-section (looking from +X end):
    ┌──────────────────────┐
    │      top shell       │
    │   ┌──────────────┐   │
    │   │  PCB/battery  │   │
    │   └──────────────┘   │
    ├───┬──────────────┬───┤ ← parting line
    │   │  electrode   │   │
    │   │▓▓▓▓▓▓▓▓▓▓▓▓▓▓│   │ ← 0.5mm ceramic
    └───┴──────────────┴───┘
    ════╧══════════════╧════ skin
         skin windows
```

### Swap Procedure

1. Pull old electrode out from the side
2. Slide new electrode in (connector tail first, sensing face down)

**Steps:** 2 | **Hands:** 1 (device stays on wrist) | **Tools:** None

### Pros

- Simplest mechanism — channel walls are the only geometry needed
- One-handed swap while device stays on wrist
- Self-aligning via channel walls and chamfered funnel
- Pogo pins engage automatically as electrode slides over them
- Well-understood precedent (glucose meter test strip insertion)

### Cons

- Slot opening at +X end is a sealing challenge — open hole in the side of the device
- Electrode must be oriented correctly before insertion (sensing face down, correct end first)
- Insertion force works against pogo pin springs laterally — needs enough friction or a detent to retain
- Channel depth adds to the bottom shell thickness
- Debris can enter the open slot

### Engineering Notes

- Retention force: pogo pin friction (~2-4 N) plus optional snap detent
- Cycle life: limited by channel rail wear and pogo pin fatigue (both >10,000 cycles)
- Sealing: labyrinth path through tight channel + optional silicone lip gasket at slot entrance
- Keying: asymmetric channel cross-section or notch on electrode prevents reversed insertion

---

## Geometry 2: Bottom Drop-In Cradle

### Concept

The bottom of the pod is a shaped pocket (cradle) that the electrode drops into vertically. The electrode is retained by a thin removable frame, magnetic attraction, or snap clips around the perimeter. The user removes the pod from their wrist, flips it over, swaps the electrode, and puts it back on.

```
Exploded view (side):
    ┌──────────────────────┐
    │      top shell       │  ← sealed, contains PCB + battery
    │   ┌──────────────┐   │
    │   │  PCB/battery  │   │
    │   └──────────────┘   │
    ├──────────────────────┤ ← parting line (O-ring sealed)
    │    bottom shell      │
    │   ┌──────────────┐   │
    │   │  cradle pocket│   │ ← shaped to electrode footprint
    │   │  ↑pogo pins↑  │   │   pogo pins point down from ceiling
    │   └──┤          ├──┘   │
    └──────┤          ├──────┘
           │electrode │  ← drops in, sensing face down
           │▓▓▓▓▓▓▓▓▓▓│
           └──────────┘
    ═══════════════════════ skin

Plan view of bottom shell (skin side up):
    ┌──────────────────────────────┐
    │         bottom shell         │
    │   ┌──────────────────────┐   │
    │   │                      │   │
    │   │   electrode pocket   │   │
    │   │   (recessed 0.6mm)   │   │
    │   │                      │   │
    │   └──────────────────────┘   │
    │  ●                        ●  │ ← snap clips or magnet positions
    ├──┤                        ├──┤
    │lug│                      │lug│
    └──┘                        └──┘
```

### Retention Options

**Option A — Perimeter snap clips:**
Two small cantilever clips on the long edges of the pocket flex outward as the electrode drops in, then snap over the electrode edges. To remove, press both clips outward simultaneously.

```
Cross-section through snap clip:
    │         │
    │  clip→ ╱│
    │       ╱ │
    │▓▓▓▓▓▓▓▓▓│ ← electrode held by clip overhang
    │         │
    ═══════════ skin
```

**Option B — Magnetic retention:**
Two small N52 neodymium magnets (2 x 1 mm disc) embedded in the cradle floor. Thin ferrous pads (stainless steel shim) bonded to the back face of the ceramic electrode. The magnets self-align and retain the electrode.

```
Cross-section through magnet:
    │    ┌─┐    │
    │    │N│    │ ← N52 magnet in cradle ceiling
    │    └─┘    │
    │  ┌─────┐  │
    │  │steel│  │ ← ferrous pad on electrode back
    │▓▓▓▓▓▓▓▓▓▓│ ← ceramic electrode
    ═══════════════ skin
```

**Option C — Friction fit:**
Cradle pocket is sized to electrode footprint + 0.1 mm clearance per side. The electrode press-fits in and is held by friction alone. Simplest, but loosens over time.

### Swap Procedure

1. Remove pod from wrist (or flip wrist over)
2. Release retention (press clips / pull against magnets / pry out)
3. Drop in new electrode (sensing face down)
4. Retention engages (clips snap / magnets grab / friction holds)
5. Put pod back on wrist

**Steps:** 3-4 | **Hands:** 2 | **Tools:** None

### Pros

- Electrode drops straight in — no sliding, no lateral force on pogo pins
- Vertical insertion is the most natural orientation (gravity assists)
- The entire electrode face is exposed for inspection before insertion
- Very easy to clean the pocket (open, accessible)
- No side opening = easier to seal the rest of the enclosure
- Pogo pins press straight down onto pads — optimal contact geometry
- Natural for skin contact: electrode sits at the very bottom, flush with or slightly recessed from the skin-facing surface

### Cons

- Requires removing the pod from wrist to swap (two-handed operation)
- Retention mechanism must survive 700+ cycles without loosening
- Snap clips add complexity and can break (especially in 3D-printed nylon)
- Magnetic retention adds BOM cost and requires bonding ferrous pads to each electrode
- Friction fit is unreliable at this scale — tolerance drift and wear
- Electrode is exposed on the skin side — no protection from impacts when the pod is off-wrist
- Pocket depth eats into the 10 mm height budget

### Engineering Notes

- Pogo pin placement: mounted on the PCB underside or on a flex cable, pointing down into the cradle ceiling. When the electrode drops in, pads face up toward the pogo pin tips.
- Wait — the sensing face must be DOWN (toward skin). So the pads (on the same face as sensing) also face down. This means pogo pins must be in the cradle floor, pointing UP. The electrode sits on top of the pogo pins, which press up against the downward-facing pads. This is the same contact geometry as the side-loading design.
- Corrected diagram: pogo pins are spring-loaded pins embedded in the cradle floor (between the skin windows), pressing upward. The electrode rests on them, held down by retention mechanism + strap pressure against skin.
- Magnet option: magnets could be in the cradle ceiling (above the electrode), pulling the electrode up and away from skin — this opposes the desired skin contact. Better: magnets in cradle floor near the edges, pulling electrode down into the pocket. But this puts magnets between the electrode and skin, taking up precious space. Magnets in the top shell pulling up through the electrode is another option but the 0.5 mm ceramic + air gap may weaken the magnetic circuit significantly.
- Best magnetic approach: small magnets at the narrow ends of the pocket (outside the skin window area), with matching ferrous features on the electrode's non-sensing edges.

---

## Geometry 3: Hinged Door (Hearing Aid Style)

### Concept

A hinged door on the bottom or side of the pod swings open to reveal the electrode bay. The electrode sits in a shallow tray behind the door. Opening the door releases the electrode; closing it clamps the electrode against pogo pins and seals the opening.

```
Side view — door closed:
    ┌──────────────────────┐
    │      top shell       │
    ├──────────────────────┤
    │    bottom shell      │
    │▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓│ ← electrode behind door
    └─────────┐┌───────────┘
              ││ ← hinge axis (along long edge)
    ══════════╧╧═══════════ skin

Side view — door open:
    ┌──────────────────────┐
    │      top shell       │
    ├──────────────────────┤
    │    bottom shell      │
    │   (electrode bay     │
    │    exposed)          │
    └─────────┐            │
              │            │
              │ door       │
              │ (swung     │
              │  open)     │
              └────────────┘

Cross-section — door closed:
    ┌──────────────────┐
    │    top shell     │
    │  ┌────────────┐  │
    │  │ PCB/battery │  │
    │  └────────────┘  │
    ├──────────────────┤
    │  ↑pogo pins↑     │ ← pins in bay ceiling
    │  ┌────────────┐  │
    │  │ electrode  │  │
    │  │▓▓▓▓▓▓▓▓▓▓▓▓│  │
    └──┤    door    ├──┘
       │  (closed)  │
    ═══╧════════════╧═══ skin
       skin window in door
```

### Hinge Options

**Pin hinge:** A metal pin (1 mm diameter stainless steel) through molded loops on the door and shell body. Most durable, but adds parts.

**Living hinge:** A thin flexible section of the shell material connecting the door to the body. Works well in polypropylene; less reliable in nylon or PETG (fatigue life ~100-500 cycles). Not recommended for daily use.

**Detachable hinge (captive):** The door is a separate piece that clips in via a barrel hinge or snap joint on one side. Can be fully removed for cleaning. Adds assembly complexity.

### Swap Procedure

1. Open the hinged door (swing away from skin)
2. Tip out or pull out old electrode
3. Place new electrode in the bay (sensing face toward skin/door)
4. Close the door — latches shut, compresses electrode against pogo pins

**Steps:** 3 | **Hands:** 2 (pod off wrist or awkward on-wrist) | **Tools:** None

### Pros

- Familiar UX — everyone understands how a hinged door works (hearing aids, battery compartments)
- Door closure provides positive clamping force against pogo pins
- Door can incorporate the skin window — when closed, it forms the skin-contact surface with the electrode visible/exposed through the window
- Latch provides unambiguous open/closed state
- Single moving part

### Cons

- Hinge axis must be along the long edge of the electrode bay — this means the door is ~34 mm long, which is almost the full length of the pod. A door this large on a 44 mm pod is structurally questionable.
- Living hinges fatigue in nylon at daily-swap rates (365 cycles/year exceeds typical nylon living hinge life of 100-500 cycles). A pin hinge is required.
- Door adds thickness: the door wall + hinge mechanism adds ~1-1.5 mm below the electrode, eating into the skin clearance and overall height budget.
- Hinge and latch are weak points for water ingress — two dynamic seals needed (hinge gap + latch interface).
- If the door is on the bottom (skin side), the hinge and latch are pressed against skin — potential comfort issue with hard edges and pressure points.
- On-wrist swapping is impractical — user must remove the pod.

### Engineering Notes

- Latch mechanism: a snap hook at the free edge of the door engaging a lip on the shell body. Must withstand strap tension pressing the door against skin (~5-10 N distributed).
- Hinge cycle life: pin hinge >10,000 cycles, living hinge in nylon ~200-500 cycles (insufficient for daily swap), living hinge in PP >100,000 cycles (but PP is not ideal for the structural shell).
- Skin window integration: the door itself can have a rectangular cutout (the skin window) with the electrode sensing face exposed through it. When the door closes, the electrode is sandwiched between the pogo pins above and the door frame below, with the sensing area exposed through the window.
- Gasket: a thin silicone gasket around the door perimeter provides splash sealing when closed.

---

## Geometry 4: Magnetic Bottom Plate

### Concept

The bottom face of the pod is a separate thin plate held on by magnets. The electrode is pre-mounted on this plate (or drops into a pocket on the plate). To swap, the user pulls off the bottom plate, replaces the electrode, and snaps the plate back on. The magnets self-align the plate.

```
Exploded view (side):
    ┌──────────────────────┐
    │      top shell       │
    │   ┌──────────────┐   │
    │   │  PCB/battery  │   │
    │   └──────────────┘   │
    ├──────────────────────┤ ← parting line (O-ring)
    │    main body         │
    │   ↑pogo pins↑        │ ← pogo pins point down
    │   ●              ●   │ ← magnets (N52, 3x2mm disc)
    ├ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─┤ ← magnetic attachment plane
    │   ○  bottom plate ○  │ ← matching magnets or steel inserts
    │   ┌──────────────┐   │
    │   │  electrode   │   │ ← in pocket on plate
    │   │▓▓▓▓▓▓▓▓▓▓▓▓▓▓│   │
    │   └──┤        ├──┘   │
    └──────┤ window ├──────┘
    ═══════╧════════╧═══════ skin
```

### Plate Designs

**Option A — Electrode pre-mounted on plate:**
The user receives electrodes already bonded into individual bottom plates. Swap the entire plate. Most convenient but highest per-electrode cost (each disposable electrode carries a plate).

**Option B — Electrode drops into plate pocket:**
The bottom plate has a pocket shaped to the electrode. The user separates the plate, swaps the electrode in the pocket, and reattaches the plate. Plate is reusable.

**Option C — Electrode sandwiched (no pocket):**
The electrode sits flat against the underside of the main body. The bottom plate clamps it from below. The plate has a skin window cutout. Simplest plate geometry.

### Swap Procedure (Option B)

1. Pull bottom plate off (overcomes magnetic force)
2. Tip out old electrode from plate pocket
3. Drop in new electrode (sensing face down)
4. Snap plate back on — magnets self-align

**Steps:** 3 | **Hands:** 2 | **Tools:** None

### Pros

- Magnetic self-alignment is extremely satisfying and foolproof — the plate snaps to the correct position every time
- No wear-out mechanism — magnets don't fatigue, no moving parts to break
- The plate removal exposes the full electrode bay for easy cleaning
- Clean aesthetic — no visible hinges, latches, or slot openings
- Plate can be made from skin-friendly material (silicone overmold) independent of the main shell material
- MagSafe-style UX is familiar from consumer electronics
- Excellent for one-handed reattachment (magnets grab and align)

### Cons

- Magnets add weight (small — ~0.5 g for 4x 3x2mm N52 discs) and BOM cost (~$0.50)
- Magnetic field could theoretically interfere with electrochemical measurements — must verify that the small DC field from N52 magnets at 5+ mm distance from the working electrode has negligible effect on chronoamperometry
- The plate is a loose part that can be dropped or lost
- Sealing between plate and body requires a gasket or O-ring at the magnetic interface — achievable but the magnetic force must be strong enough to compress the gasket
- Magnetic retention force must exceed strap tension and daily wear forces but be low enough for easy manual removal — tuning this requires prototyping
- Pod off-wrist required for swapping
- Adds ~1.5-2 mm to height budget (plate thickness + gasket + clearance)

### Engineering Notes

- Magnet sizing: 4x N52 neodymium discs (3 mm dia x 2 mm height) provide ~2-3 N pull force each at contact, ~8-12 N total. This is strong enough to resist strap tension (~5 N) with margin, yet easy to peel off by hand.
- Magnet placement: at the four corners of the electrode pocket, outside the skin window area and away from the sensing electrodes.
- Interference check: N52 disc at 5 mm distance produces ~5-10 mT field. Electrochemical chronoamperometry is not magnetosensitive at these field strengths (no Lorentz force effect on ion transport in thin films at <100 mT). Should be safe but verify empirically.
- Gasket: thin silicone ring (0.5 mm CS) in a groove on the body mating face, compressed by magnetic pull force.
- Poka-yoke: asymmetric magnet placement (e.g., 3 corners + 1 offset) prevents the plate from attaching in the wrong orientation.
- Pogo pin engagement: as the plate snaps on, it pushes the electrode up against pogo pins mounted on the underside of the main body. The magnetic force provides the clamping pressure.

---

## Geometry 5: Sliding Tray (SIM Card Style)

### Concept

A thin tray slides out from one end of the pod. The electrode sits in a pocket on the tray. The user pulls the tray out, swaps the electrode, and pushes the tray back in. Inspired by smartphone SIM trays.

```
Top view — tray extended:
    ┌─────────────────────────┬─────────────┐
    │        pod body         │             │
    │                         │    tray     │
    │                         │  ┌───────┐  │
    │     ↑pogo pins↑         │  │ elect.│  │
    │                         │  └───────┘  │
    │                         │             │
    └─────────────────────────┴─────────────┘
                              ← pull out

Top view — tray inserted:
    ┌──────────────────────────────────────┐
    │              pod body                │
    │         ┌──────────────────┐         │
    │         │ electrode in tray │         │
    │         └──────────────────┘         │
    └──────────────────────────────────────┘

Cross-section — tray inserted:
    ┌──────────────────┐
    │    top shell     │
    │  ┌────────────┐  │
    │  │ PCB/battery │  │
    │  └────────────┘  │
    ├──────────────────┤
    │  ↑pogo pins↑     │
    │┌────────────────┐│
    ││tray + electrode││
    ││▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓││
    │└────┤      ├────┘│
    └─────┤window├─────┘
    ══════╧══════╧══════ skin
```

### Swap Procedure

1. Pull tray out from +X end (fingernail catch or small pull tab)
2. Remove old electrode from tray pocket
3. Place new electrode in tray (sensing face down)
4. Slide tray back in until it clicks

**Steps:** 3 | **Hands:** 2 (or 1 if tray pull is easy enough on-wrist) | **Tools:** None (optional SIM-tool for flush tray)

### Pros

- Familiar SIM-tray UX — billions of people have used this gesture
- Tray guides the electrode into exact position every time
- Tray can be keyed to prevent wrong orientation
- Tray rails provide precise alignment for pogo pin contact
- Clean exterior — when tray is inserted, the side is nearly flush
- On-wrist swapping is possible (pull tray from exposed end)
- Tray is captive (rails prevent it from separating completely) — can't lose it

### Cons

- Tray adds mechanical complexity — rails, detent, pull-tab
- Tray thickness (~1 mm) adds to the bottom shell stack-up
- SIM-style trays at this scale are challenging to 3D print with adequate rail tolerances
- The side opening (tray slot) is a sealing weakness — same as Geometry 1
- Two-piece system (tray + electrode) means the user handles a thin, fragile ceramic on a thin tray
- If the tray ejects fully, the electrode can fall out
- Tray rails wear over time at daily cycle rates

### Engineering Notes

- Tray material: should be stiffer than the shell to maintain rail engagement. Stainless steel SIM trays in phones are 0.4-0.5 mm thick; a 3D-printed polymer tray would need to be ~1.0 mm for rigidity.
- Detent: a small bump on the tray engages a dimple in the rail at full insertion. Provides tactile click confirmation.
- Pull-tab: a small recessed nub at the +X end of the tray, flush with the pod surface. Alternatively, a pinhole for a SIM-tool-style ejector.
- Tray pocket: shaped to the electrode footprint with 0.15 mm clearance, plus a keying notch.
- Skin window: cut through the tray floor so the electrode sensing face contacts skin when the tray is inserted.

---

## Geometry 6: Snap-Frame Cassette

### Concept

The electrode is held in a thin plastic carrier frame (cassette) that clips into the bottom of the pod. The cassette has snap features that engage with the shell. The electrode is either pre-mounted in the cassette (disposable cassette) or placed into a reusable cassette by the user.

```
Exploded view (bottom-up):
    ┌──────────────────────┐
    │      pod body        │
    │   ↑pogo pins↑        │
    │   ┌──┐        ┌──┐   │ ← snap receivers
    │   └──┘        └──┘   │
    ├──────────────────────┤
    │                      │
    │  ┌─snap─┐  ┌─snap─┐  │
    │  │      │  │      │  │ ← cassette frame
    │  │  ┌────────────┐│  │
    │  │  │ electrode  ││  │
    │  │  │▓▓▓▓▓▓▓▓▓▓▓▓▓││  │
    │  │  └─┤ window ├─┘│  │
    │  └────┤        ├───┘  │
    └───────╧════════╧──────┘
    ════════════════════════ skin

Cross-section — cassette clipped in:
    ┌──────────────────┐
    │    pod body      │
    │  ┌────────────┐  │
    │  │ PCB/battery │  │
    │  └────────────┘  │
    │  ↑pogo pins↑     │
    ├──╗            ╔──┤ ← snap hooks engage
    │  ║  cassette  ║  │
    │  ║┌──────────┐║  │
    │  ║│electrode │║  │
    │  ║│▓▓▓▓▓▓▓▓▓▓│║  │
    │  ║└─┤      ├─┘║  │
    └──╚══┤window├══╝──┘
    ═══════╧══════╧═════ skin
```

### Snap Engagement Options

**Option A — Lateral squeeze-to-release:**
Two snap hooks on the cassette's long edges engage lips on the pod body. Squeezing the cassette's sides deflects the hooks inward, releasing the cassette. Similar to how many battery covers work.

**Option B — Push-to-release detent:**
The cassette is held by spring-loaded detents. Pushing the cassette upward (toward the pod) slightly past the engaged position triggers a cam release (push-push mechanism like an SD card).

**Option C — Twist-lock (bayonet):**
Two tabs on the cassette engage L-slots on the pod body. A 45-degree twist locks the cassette. A reverse twist releases it. Requires the cassette to be round or have rotational clearance.

### Swap Procedure (Option A)

1. Squeeze cassette sides to release snap hooks
2. Pull cassette off pod
3. Remove old electrode from cassette, drop in new one
4. Push cassette back onto pod until snaps click

**Steps:** 3 | **Hands:** 2 | **Tools:** None

### Pros

- Cassette protects the fragile ceramic electrode during handling
- If cassettes are disposable (electrode pre-mounted), the swap is 2 steps: pop off old cassette, pop on new one
- Snap engagement provides positive tactile feedback (click = locked)
- No side opening in the pod body — sealed on all sides except the bottom cassette interface
- Cassette frame can extend slightly below the pod to form a protective bumper around the electrode
- Cassette can incorporate the skin window frame, gasket, and any vent grooves — all skin-contact engineering moves to the cassette

### Cons

- Snap hooks in 3D-printed nylon fatigue at daily cycle rates — need careful beam geometry (length >= 5x thickness, tapered tip)
- Adds per-electrode cost if cassettes are disposable
- Cassette frame thickness (~1.0-1.5 mm) adds to height budget
- Squeeze-to-release gesture requires dexterity — could be difficult with sweaty hands
- Small loose part (cassette) that can be dropped
- Pogo pin alignment depends on cassette-to-body registration — tolerance stack is: body → snap interface → cassette → electrode → pogo pin tip. More interfaces = more variability.

### Engineering Notes

- Snap hook cycle life in nylon PA12: at 2% strain, ~1,000-3,000 cycles. At 1.5% strain, ~5,000+ cycles. Design for the lower strain target. Beam dimensions: 1.0 mm thickness, 5.0+ mm length, 50% taper at tip.
- Cassette wall thickness: 0.8-1.0 mm minimum for rigidity. Total cassette height: ~1.5 mm (0.5 mm electrode + 0.5 mm floor + 0.5 mm snap features).
- Poka-yoke: asymmetric cassette outline (one rounded corner, one square) prevents 180-degree insertion error.
- Gasket integration: a silicone gasket ring molded into or placed on the cassette's top face seals against the pod body when snapped in.
- Pre-loaded cassettes: if electrodes ship pre-mounted in cassettes, the user never handles the bare ceramic. This protects the sensor and simplifies the swap to a 2-step pop-off / pop-on.

---

## Comparison Matrix

| Criterion | 1. Side Slot | 2. Drop-In Cradle | 3. Hinged Door | 4. Magnetic Plate | 5. Sliding Tray | 6. Snap Cassette |
|-----------|:-----------:|:-----------------:|:-------------:|:-----------------:|:---------------:|:----------------:|
| **Swap steps** | 2 | 3-4 | 3 | 3 | 3 | 2-3 |
| **One-handed possible** | Yes | No | No | No | Maybe | No |
| **On-wrist swap** | Yes | No | No | No | Maybe | No |
| **Self-aligning** | Good | Fair | Good | Excellent | Good | Good |
| **Tactile feedback** | Slide-stop | Drop | Door-click | Mag-snap | Click | Snap-click |
| **Mechanism complexity** | Low | Low | Medium | Low | High | Medium |
| **Added parts** | 0 | 0-2 clips | Hinge pin | 4-8 magnets | Tray | Cassette |
| **Height overhead** | ~0 mm | ~0.5 mm | ~1.5 mm | ~1.5-2 mm | ~1 mm | ~1.5 mm |
| **Sealing difficulty** | Hard (side opening) | Easy (no openings) | Hard (hinge + latch) | Medium (gasket at plate interface) | Hard (side opening) | Medium (gasket at cassette interface) |
| **Cycle life concern** | Channel wear | Clip fatigue | Hinge fatigue | None (magnets) | Rail wear | Snap fatigue |
| **Prototype-friendly** | Very (current design) | Yes | Moderate (pin hinge) | Yes (glue magnets in) | Hard (tight rail tolerances) | Moderate (snap tuning) |
| **Electrode protection** | In channel | Exposed during swap | In bay | Exposed during swap | In tray | In cassette frame |
| **User error risk** | Wrong orientation | Wrong orientation | Low (bay shaped) | Low (magnets align) | Low (tray shaped) | Low (cassette keyed) |

---

## Recommendation

There is no single best geometry — the right choice depends on which tradeoffs matter most. Here is how they rank against the key priorities:

### If on-wrist swapping is a priority → Geometry 1 (Side Slot)

The current design is the only geometry that allows the user to swap the electrode without removing the pod from their wrist. For daily use, this is a significant convenience advantage. The sealing challenge at the slot opening is real but manageable with a labyrinth + lip gasket approach.

### If swap simplicity and mechanism durability matter most → Geometry 4 (Magnetic Plate)

Zero wear-out parts, self-aligning, satisfying UX. The magnetic approach has no fatigue failure mode and provides the cleanest user experience. The tradeoff is requiring removal from the wrist and adding ~1.5 mm to the height stack.

### If electrode protection during handling matters → Geometry 6 (Snap Cassette)

If the electrodes are fragile and users shouldn't handle bare ceramic, a pre-loaded cassette is the safest approach. It also moves all skin-contact engineering (gasket, window, vents) to the disposable part, simplifying the main pod design. The tradeoff is higher per-swap cost and snap fatigue risk.

### What I would prototype first

**Start with Geometry 1 (Side Slot)** — it's already designed, the simplest mechanism, and allows on-wrist swapping. Prototype it, live with it for a week of daily swaps, and note what's frustrating.

**Then prototype Geometry 4 (Magnetic Plate)** as the leading alternative. Buy a handful of 3x2 mm N52 disc magnets, glue them into cavities in a modified bottom shell, and test the snap-on UX. This will tell you quickly whether the magnetic retention force feels right and whether the height penalty is acceptable.

The comparison between these two — side slot convenience vs. magnetic plate durability — will drive the final design decision.
