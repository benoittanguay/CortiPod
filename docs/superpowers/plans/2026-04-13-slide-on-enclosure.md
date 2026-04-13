# Slide-On 2-Piece Enclosure Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rewrite the CortiPod OpenSCAD enclosure from a snap-together design to a slide-on 2-piece system with U-channel rails, detent click retention, and a pogo-pin charging cradle.

**Architecture:** The top shell (brains + strap) has U-channel rails on its underside. The bottom shell (electrode tray) slides in from the +Y end via lips that ride in the channels, locked by a detent bump. A charging cradle with identical profile substitutes for the bottom shell during charging, delivering USB-C power through the same 4 pogo pins. All old snap-fit, O-ring, alignment pin, GSR, LED, and magnetic charging features are removed.

**Tech Stack:** OpenSCAD (parametric CAD), existing project at `cad/`

**Spec:** `docs/superpowers/specs/2026-04-13-slide-on-enclosure-design.md`

---

## File Map

| File | Action | Responsibility |
|------|--------|----------------|
| `cad/parameters.scad` | Modify | Remove old params (snap clips, O-ring, GSR, LED, magnets, alignment pins, vents). Add rail, detent, and cradle params. |
| `cad/top_shell.scad` | Rewrite | Remove snap clips, O-ring groove, LED hole, charging pad recesses, alignment pins. Add U-channel rails with detent. Move strap lugs here. |
| `cad/bottom_shell.scad` | Rewrite | Strip to minimal electrode tray with lips. Remove strap lugs, insertion opening, vent grooves, GSR holes, alignment pin holes, clip receivers. |
| `cad/charging_cradle.scad` | Create | New file. Same outer profile as bottom shell with USB-C port slot and 4 contact pad recesses. |
| `cad/assembly.scad` | Rewrite | Update all views for slide-on architecture. Add charging cradle to exploded/layout views. Remove old components (magnets, alignment pins, O-ring). |
| `cad/README.md` | Rewrite | Update diagrams, dimensions, assembly instructions, file table, and printing notes. |

---

### Task 1: Update parameters.scad — remove old, add new

**Files:**
- Modify: `cad/parameters.scad`

- [ ] **Step 1: Remove deprecated parameter blocks**

Delete these parameter sections from `cad/parameters.scad`:

```
// Lines to DELETE (the parameters, not the whole file):

// ---- GSR electrode pads ----
gsr_pad_diameter     = 4.0;
gsr_pad_spacing      = 20.0;
gsr_pad_y_offset     = 0;

// ---- Magnetic charging pads ----
mag_pad_diameter     = 5.0;
mag_pad_depth        = 1.2;
mag_pad_spacing      = 12.0;
charge_pad_diameter  = 3.0;

// ---- Alignment pins ----
alignment_pin_diameter = 2.0;
alignment_pin_height   = 2.0;
alignment_hole_clearance = 0.1;
align_pin1_x = -pod_length/2 + 5;
align_pin1_y = -pod_width/2 + 4;
align_pin2_x =  pod_length/2 - 6;
align_pin2_y =  pod_width/2 - 4;

// ---- Snap-fit clips ----
clip_width           = 3.0;
clip_depth           = 0.8;
clip_beam_thickness  = 0.8;
clip_beam_length     = 5.0;

// ---- O-ring groove ----
oring_groove_width   = 1.5;
oring_groove_depth   = 0.75;
oring_cs             = 1.0;

// ---- Ventilation grooves ----
vent_groove_width    = 0.8;
vent_groove_depth    = 0.3;
vent_groove_count    = 3;

// ---- LED status indicator ----
led_hole_diameter    = 2.0;
```

- [ ] **Step 2: Update the file header comment**

Replace the header comment (lines 1-31) with:

```openscad
// =============================================================================
// parameters.scad — CortiPod shared dimensions (single source of truth)
//
// All measurements in millimeters.
//
// DESIGN: Slide-on 2-piece enclosure with U-channel rails
//
//   TOP SHELL (the "brain"):
//     Houses PCB, battery. Strap lugs at ±X ends.
//     Pogo pins mounted on the underside of the main PCB, pressing DOWN
//     onto the back contacts of the electrode board.
//     U-channel rails on the underside (±Y sides) receive the bottom shell.
//     Fully sealed — only openings are pogo pin pass-throughs.
//
//   BOTTOM SHELL (electrode tray):
//     Minimal tray holding the 22x22mm dual electrode PCB.
//     Lips on ±Y edges slide into the top shell's U-channel rails.
//     Electrode drops into the pocket, sensing face down.
//     Detent click locks tray in place; pogo pins hold electrode firm.
//
//   CHARGING CRADLE:
//     Same outer profile as bottom shell. Slides into same rails.
//     4 contact pads aligned with pogo pins carry USB-C power.
//
//   Assembly: wear top shell on strap, slide bottom shell in from +Y.
//   Pogo pins on main PCB engage electrode back contacts automatically.
//
// DATUMS:
//   Datum A: top shell underside (Z = bottom_shell_height, rail interface)
//   Datum B: hard stop face (-Y inner wall of rail cavity)
//   Datum C: pod centerline (Y = 0, symmetry plane)
//
// ENGINEERING REFERENCES:
//   See docs/superpowers/specs/2026-04-13-slide-on-enclosure-design.md
//   See docs/enclosure-design-engineering-reference.md
// =============================================================================
```

- [ ] **Step 3: Add new U-channel rail parameters**

Add after the `// ---- Strap lugs ----` section:

```openscad
// ---- U-channel rails (on top shell underside, ±Y sides) ----
// Bottom shell lips slide into these channels from the +Y end.
// Channel overhang prevents Z-axis pullout.
rail_channel_width    = 1.2;    // mm — width of the channel slot
rail_channel_depth    = 0.8;    // mm — overhang depth (captures lip)
rail_wall_thickness   = 1.0;    // mm — rail wall material
rail_length           = pod_width - wall_thickness * 2;  // ~25mm usable

// ---- Detent (retention click) ----
detent_bump_height    = 0.3;    // mm — raised dimple on channel floor
detent_bump_diameter  = 1.5;    // mm
detent_position       = 3.0;    // mm from -Y hard stop (fully seated position)

// ---- Bottom shell (electrode tray) ----
tray_width  = pod_length - wall_thickness * 2 - rail_wall_thickness * 2;  // ~23mm
tray_length = pod_width - wall_thickness;  // ~26.5mm (open at +Y)
tray_height = bottom_shell_height;  // 2.5mm
tray_lip_thickness = 1.0;    // mm — captured by rail channel
tray_lip_height    = 0.8;    // mm — matches channel depth
```

- [ ] **Step 4: Add charging cradle parameters**

Add after the tray parameters:

```openscad
// ---- Charging cradle ----
// Same outer profile as bottom shell tray. Slides into same rails.
// USB-C port on +Y face (exposed end).
usbc_port_width    = 9.0;    // mm (USB-C receptacle body width)
usbc_port_height   = 3.3;    // mm (USB-C receptacle body height)
usbc_port_depth    = 7.5;    // mm (receptacle insertion depth)
cradle_pad_diameter = 2.0;   // mm (gold-plated contact pads on cradle top)
```

- [ ] **Step 5: Update pogo pin protrusion**

Change the pogo pin protrusion to 1.0mm (was 1.5mm) per the design spec:

```openscad
pogo_total_height        = 2.5;   // mm (full pin length — protrudes 1.0mm below mating face)
pogo_protrusion_below    = pogo_total_height - wall_thickness; // 1.0mm below mating face
// Z-stack check: pin tip unloaded at Z = 2.5 - 1.0 = 1.5
//                electrode back at Z = 0.5 + 0.8 = 1.3
//                compression = 1.5 - 1.3 = 0.2mm (within 0.5mm travel)
```

- [ ] **Step 6: Move strap lugs note**

Update the strap lugs comment to indicate they're now on the top shell:

```openscad
// ---- Strap lugs (18mm quick-release, on TOP SHELL ±X ends) ----
strap_width          = 18.0;
lug_width            = 2.5;
lug_height           = 3.0;
lug_hole_diameter    = 1.5;
lug_extension        = 3.0;
```

- [ ] **Step 7: Verify file renders without errors**

Open `cad/parameters.scad` in OpenSCAD, press F5. It should render without errors (it's just variables, no geometry, but syntax must be valid).

- [ ] **Step 8: Commit**

```bash
git add cad/parameters.scad
git commit -m "refactor: update parameters.scad for slide-on enclosure

Remove snap-fit, O-ring, GSR, LED, alignment pin, magnet, and vent
parameters. Add U-channel rail, detent, tray, and charging cradle
parameters. Update pogo protrusion to 1.0mm."
```

---

### Task 2: Rewrite top_shell.scad — rails, lugs, no snap-fits

**Files:**
- Rewrite: `cad/top_shell.scad`

- [ ] **Step 1: Write the new top_shell.scad**

Replace the entire contents of `cad/top_shell.scad` with:

```openscad
// =============================================================================
// top_shell.scad — CortiPod main enclosure ("brain unit")
//
// Houses PCB, battery, and pogo pins. Strap lugs at ±X ends.
// U-channel rails on underside (±Y sides) receive the bottom shell tray.
// Fully sealed — only openings are pogo pin pass-throughs on underside.
//
// New design: slide-on mechanism replaces snap-fit clips, O-ring, and
// alignment pins. No LED hole, no magnetic charging recesses.
//
// Print: TOP face down (smooth outer surface on build plate)
// =============================================================================

include <parameters.scad>

$fn = $preview ? 32 : 96;

module top_shell() {
    difference() {
        union() {
            shell_body();
            strap_lugs();
            u_channel_rails();
        }

        // Hollow out the internal cavity (PCB + battery space)
        translate([0, 0, wall_thickness])
            internal_cavity();

        // Pogo pin pass-through holes (4 holes through the underside)
        pogo_pin_holes();
    }

    // PCB standoffs inside the cavity
    intersection() {
        shell_body();
        pcb_standoffs();
    }

    // Detent bumps inside the rail channels
    detent_bumps();
}

// ---- Shell body ----
// Rounded rectangle, Z=0 is the underside (rail interface / parting line).
// Z=top_shell_height is the outer top face.
module shell_body() {
    hull() {
        for (x = [-pod_length/2 + pod_corner_radius, pod_length/2 - pod_corner_radius])
            for (y = [-pod_width/2 + pod_corner_radius, pod_width/2 - pod_corner_radius])
                translate([x, y, 0])
                    cylinder(r=pod_corner_radius, h=top_shell_height);
    }
}

// ---- Internal cavity ----
// Hollow pocket for PCB and battery. Starts wall_thickness above underside.
module internal_cavity() {
    inset = wall_thickness;
    inner_r = max(pod_corner_radius - inset + printer_tolerance, 0.5);
    cavity_h = top_shell_height - wall_thickness * 2 + 0.1;

    hull() {
        for (x = [-pod_length/2 + pod_corner_radius + inset,
                   pod_length/2 - pod_corner_radius - inset])
            for (y = [-pod_width/2 + pod_corner_radius + inset,
                       pod_width/2 - pod_corner_radius - inset])
                translate([x, y, 0])
                    cylinder(r=inner_r, h=cavity_h);
    }
}

// ---- PCB standoffs ----
// Asymmetric placement so PCB can only be installed one way (poka-yoke).
module pcb_standoffs() {
    standoff_height = 1.0;
    standoff_od = 3.0;
    pcb_z = wall_thickness;

    round_positions = [
        [-pcb_length/2 + 3, -pcb_width/2 + 3],
        [-pcb_length/2 + 3,  pcb_width/2 - 3],
        [ pcb_length/2 - 3, -pcb_width/2 + 3],
    ];

    for (pos = round_positions) {
        translate([pos[0], pos[1], pcb_z])
            cylinder(d=standoff_od, h=standoff_height);
    }

    // One slotted standoff (+X, +Y) for thermal expansion
    translate([pcb_length/2 - 3, pcb_width/2 - 3, pcb_z])
        hull() {
            cylinder(d=standoff_od, h=standoff_height);
            translate([1.0, 0, 0])
                cylinder(d=standoff_od, h=standoff_height);
        }
}

// ---- Pogo pin bores ----
// Through-bores in the underside wall for spring-loaded pogo pins.
// Pin tips protrude below the underside into the tray cavity.
module pogo_pin_holes() {
    contacts = [
        [contact_we_mip_x, contact_we_mip_y],
        [contact_we_nip_x, contact_we_nip_y],
        [contact_ce_x,     contact_ce_y],
        [contact_re_x,     contact_re_y],
    ];

    for (pos = contacts) {
        translate([pos[0], pos[1], -pogo_protrusion_below - 0.1])
            cylinder(d=spring_contact_hole,
                     h=wall_thickness + pogo_protrusion_below + 0.2);
    }
}

// ---- Strap lugs (moved from bottom shell) ----
// 18mm quick-release lugs at ±X ends of the top shell.
module strap_lugs() {
    for (end = [-1, 1]) {
        x_base = end * pod_length/2;
        x_outer = x_base + end * lug_extension;

        // Lug body — extends from shell at mid-height for strength
        translate([min(x_base, x_outer), -strap_width/2, 0])
            cube([lug_extension, strap_width, lug_height]);

        // Strap pin holes
        lug_center_x = x_base + end * lug_extension / 2;
        for (side = [-1, 1]) {
            translate([lug_center_x,
                       side * strap_width/2,
                       lug_height/2])
                rotate([0, 90, 0])
                    cylinder(d=lug_hole_diameter,
                             h=lug_extension + 0.2,
                             center=true);
        }
    }
}

// ---- U-channel rails ----
// Two parallel channels on the underside along the ±Y inner walls.
// The bottom shell's lips slide into these channels from the +Y end.
// The channel overhang captures the lips so they can't pull out in Z.
module u_channel_rails() {
    // Rails are positioned on the underside of the shell body (Z <= 0).
    // Each rail is a U-shaped profile extruded along X (pod_length).

    for (y_sign = [-1, 1]) {
        y_inner_wall = y_sign * (pod_length/2 - wall_thickness);

        // Rail body: a block that extends below the shell underside
        // The channel is cut into it in the main difference() above.
        // Instead, we build the rail as positive geometry with the
        // channel gap already formed.

        // Bottom plate of channel (floor the lip slides on)
        translate([-pod_length/2 + pod_corner_radius,
                   y_inner_wall - y_sign * (rail_wall_thickness + rail_channel_width),
                   -rail_channel_depth])
            cube([pod_length - pod_corner_radius * 2,
                  rail_wall_thickness,
                  rail_channel_depth]);

        // Overhang (captures lip from below)
        translate([-pod_length/2 + pod_corner_radius,
                   y_inner_wall - y_sign * (rail_wall_thickness + rail_channel_width),
                   -rail_channel_depth])
            cube([pod_length - pod_corner_radius * 2,
                  rail_channel_width + rail_wall_thickness,
                  rail_wall_thickness]);
    }

    // Hard stop wall at -Y end (closed end)
    translate([-pod_length/2 + pod_corner_radius,
               -pod_width/2 + wall_thickness - 0.1,
               -rail_channel_depth])
        cube([pod_length - pod_corner_radius * 2,
              wall_thickness,
              rail_channel_depth]);
}

// ---- Detent bumps ----
// Small raised dimples on the channel floor. When the bottom shell
// is fully inserted, its matching recesses click over these bumps.
module detent_bumps() {
    for (y_sign = [-1, 1]) {
        y_inner_wall = y_sign * (pod_length/2 - wall_thickness);
        channel_center_y = y_inner_wall - y_sign * (rail_wall_thickness + rail_channel_width/2);

        // Position: detent_position mm from -Y hard stop
        detent_y = -pod_width/2 + wall_thickness + detent_position;

        translate([0, channel_center_y, -rail_channel_depth])
            cylinder(d=detent_bump_diameter, h=detent_bump_height);
    }
}

// ---- Render ----
top_shell();
```

- [ ] **Step 2: Open in OpenSCAD, press F5 to preview**

Verify: shell body renders, strap lugs visible at ±X, rail structures visible on underside, no error messages.

- [ ] **Step 3: Commit**

```bash
git add cad/top_shell.scad
git commit -m "feat: rewrite top_shell with U-channel rails and strap lugs

Replace snap-fit clips, O-ring groove, alignment pins, LED hole, and
charging pad recesses with U-channel rails, detent bumps, and strap
lugs. Pogo pin pass-throughs retained."
```

---

### Task 3: Rewrite bottom_shell.scad — minimal electrode tray

**Files:**
- Rewrite: `cad/bottom_shell.scad`

- [ ] **Step 1: Write the new bottom_shell.scad**

Replace the entire contents of `cad/bottom_shell.scad` with:

```openscad
// =============================================================================
// bottom_shell.scad — CortiPod electrode tray
//
// Minimal tray that holds the 22x22mm dual electrode PCB.
// Slides into the top shell via U-channel rails from the +Y end.
//
// Features:
//   - Electrode pocket with support ledges
//   - Skin window exposing sensing face
//   - Lips on ±Y edges for rail engagement
//   - Detent recesses matching top shell bumps
//   - Orientation key notch (prevents MIP/NIP swap)
//
// No strap lugs, no GSR pads, no vent grooves, no alignment pins,
// no snap clip receivers — all removed in the slide-on redesign.
//
// Print: skin-side DOWN for smooth bottom surface.
// =============================================================================

include <parameters.scad>

$fn = $preview ? 32 : 96;

// ---- Derived positions ----
// Electrode pocket centered in the tray
pocket_x = -electrode_board_width/2 - slot_clearance;
pocket_y = -electrode_board_total_y/2 - slot_clearance/2;

// Skin window centered under the sensing zone
skin_win_x = -skin_window_width/2;
skin_win_y = -skin_window_length/2;

// ---- Main module ----
module bottom_shell() {
    difference() {
        union() {
            // Tray body
            tray_body();

            // Lips on ±Y edges for rail engagement
            tray_lips();
        }

        // 1. ELECTRODE POCKET — cut from the top
        electrode_pocket();

        // 2. SKIN WINDOW — cut from the bottom through the floor
        skin_window();

        // 3. ORIENTATION KEY — corner notch matching electrode chamfer
        orientation_key();

        // 4. DETENT RECESSES — matching top shell bumps
        detent_recesses();
    }
}

// ---- Tray body ----
// Simple rectangular block with rounded edges.
module tray_body() {
    tr = min(pod_corner_radius, 2.0);  // smaller radius for the tray

    hull() {
        for (x = [-tray_width/2 + tr, tray_width/2 - tr])
            for (y = [-tray_length/2 + tr, tray_length/2 - tr])
                translate([x, y, 0])
                    cylinder(r=tr, h=tray_height);
    }
}

// ---- Lips ----
// Thin protrusions on the ±Y edges that slide into the top shell's
// U-channel rails. Height matches rail_channel_depth.
module tray_lips() {
    lip_length = tray_width;  // full width of tray

    for (y_sign = [-1, 1]) {
        y_pos = y_sign * tray_length/2;

        translate([-lip_length/2,
                   y_pos - (y_sign > 0 ? 0 : tray_lip_thickness),
                   tray_height])
            cube([lip_length, tray_lip_thickness, tray_lip_height]);
    }
}

// ---- Electrode pocket ----
// Recessed cavity the electrode board sits in.
// Leaves support ledges around the perimeter.
module electrode_pocket() {
    translate([pocket_x, pocket_y, ledge_height])
        cube([slot_width, slot_depth, tray_height]);
}

// ---- Skin window ----
// Through-hole from bottom, exposing electrode sensing face to skin.
module skin_window() {
    translate([skin_win_x, skin_win_y, -0.1])
        cube([skin_window_width, skin_window_length, tray_height + 0.2]);
}

// ---- Orientation key ----
// Corner notch at one corner of the pocket matching the electrode's
// 1.5mm 45° chamfer. Board only fits one way.
module orientation_key() {
    translate([pocket_x - 0.1,
               pocket_y - 0.1,
               -0.1])
        cube([chamfer_size + 0.2,
              chamfer_size + 0.2,
              tray_height + 0.2]);
}

// ---- Detent recesses ----
// Small dimples on the inner face of each lip. When the tray is
// fully inserted, these click over the detent bumps in the top
// shell's channel floor.
module detent_recesses() {
    for (y_sign = [-1, 1]) {
        y_pos = y_sign * tray_length/2;

        // Position along the lip: detent_position from the leading edge
        // The leading edge (-Y side of tray) goes in first toward -Y stop.
        recess_y = -tray_length/2 + detent_position;

        translate([0,
                   y_pos + (y_sign > 0 ? tray_lip_thickness/2 : -tray_lip_thickness/2),
                   tray_height + tray_lip_height - detent_bump_height])
            cylinder(d=detent_bump_diameter + 0.2,
                     h=detent_bump_height + 0.1);
    }
}

// ---- Render ----
bottom_shell();
```

- [ ] **Step 2: Open in OpenSCAD, press F5 to preview**

Verify: rectangular tray renders, lips visible on ±Y top edges, skin window visible through the bottom, pocket cavity visible from the top.

- [ ] **Step 3: Commit**

```bash
git add cad/bottom_shell.scad
git commit -m "feat: rewrite bottom_shell as minimal electrode tray

Simple tray with electrode pocket, skin window, rail lips, detent
recesses, and orientation key. Removed strap lugs, GSR pads, vent
grooves, alignment pins, snap clip receivers, and insertion opening."
```

---

### Task 4: Create charging_cradle.scad

**Files:**
- Create: `cad/charging_cradle.scad`

- [ ] **Step 1: Write charging_cradle.scad**

Create the new file `cad/charging_cradle.scad`:

```openscad
// =============================================================================
// charging_cradle.scad — CortiPod charging dock
//
// Same outer profile as the bottom shell (electrode tray). Slides into
// the top shell's U-channel rails using the same lips and detent.
//
// Instead of an electrode pocket, has 4 gold-plated contact pads aligned
// with the pogo pin positions. USB-C port on the +Y face (exposed end).
//
// Pin assignment:
//   WE_MIP + WE_NIP pogo pins → V+ (USB 5V)
//   CE + RE pogo pins         → GND
//
// Print: top face up (contact pad surface needs to be smooth).
// =============================================================================

include <parameters.scad>

$fn = $preview ? 32 : 96;

module charging_cradle() {
    difference() {
        union() {
            // Same tray body as bottom shell
            cradle_body();

            // Same lips for rail engagement
            cradle_lips();
        }

        // USB-C port slot on +Y face
        usbc_port_slot();

        // Contact pad recesses (pogo pins land here)
        contact_pad_recesses();

        // Detent recesses (same as bottom shell)
        detent_recesses();

        // Internal channel for PCB traces (USB-C to pads)
        trace_channel();
    }
}

// ---- Cradle body ----
// Same dimensions as bottom shell tray body.
module cradle_body() {
    tr = min(pod_corner_radius, 2.0);

    hull() {
        for (x = [-tray_width/2 + tr, tray_width/2 - tr])
            for (y = [-tray_length/2 + tr, tray_length/2 - tr])
                translate([x, y, 0])
                    cylinder(r=tr, h=tray_height);
    }
}

// ---- Lips ----
// Identical to bottom shell lips.
module cradle_lips() {
    lip_length = tray_width;

    for (y_sign = [-1, 1]) {
        y_pos = y_sign * tray_length/2;

        translate([-lip_length/2,
                   y_pos - (y_sign > 0 ? 0 : tray_lip_thickness),
                   tray_height])
            cube([lip_length, tray_lip_thickness, tray_lip_height]);
    }
}

// ---- USB-C port slot ----
// Rectangular cutout on the +Y face for the USB-C receptacle.
module usbc_port_slot() {
    translate([-usbc_port_width/2,
               tray_length/2 - usbc_port_depth,
               (tray_height - usbc_port_height) / 2])
        cube([usbc_port_width, usbc_port_depth + 0.1, usbc_port_height]);
}

// ---- Contact pad recesses ----
// Shallow circular recesses on the top face where pogo pins make contact.
// A small PCB with gold pads sits in these recesses.
module contact_pad_recesses() {
    contacts = [
        [contact_we_mip_x, contact_we_mip_y],
        [contact_we_nip_x, contact_we_nip_y],
        [contact_ce_x,     contact_ce_y],
        [contact_re_x,     contact_re_y],
    ];

    pad_recess_depth = 0.4;  // mm — just enough to seat a contact pad

    for (pos = contacts) {
        translate([pos[0], pos[1], tray_height - pad_recess_depth])
            cylinder(d=cradle_pad_diameter + 0.5, h=pad_recess_depth + 0.1);
    }
}

// ---- Detent recesses ----
// Same as bottom shell — clicks over top shell's detent bumps.
module detent_recesses() {
    for (y_sign = [-1, 1]) {
        y_pos = y_sign * tray_length/2;

        translate([0,
                   y_pos + (y_sign > 0 ? tray_lip_thickness/2 : -tray_lip_thickness/2),
                   tray_height + tray_lip_height - detent_bump_height])
            cylinder(d=detent_bump_diameter + 0.2,
                     h=detent_bump_height + 0.1);
    }
}

// ---- Trace channel ----
// Internal pocket for a small PCB that routes USB-C to the 4 contact pads.
module trace_channel() {
    pcb_clearance = 0.8;  // mm height for the internal cradle PCB

    translate([-tray_width/2 + 2,
               -tray_length/2 + 2,
               (tray_height - pcb_clearance) / 2])
        cube([tray_width - 4,
              tray_length - 4,
              pcb_clearance]);
}

// ---- Render ----
charging_cradle();
```

- [ ] **Step 2: Open in OpenSCAD, press F5 to preview**

Verify: body identical profile to bottom shell, USB-C slot visible on +Y face, contact pad recesses visible on top, lips on ±Y edges.

- [ ] **Step 3: Commit**

```bash
git add cad/charging_cradle.scad
git commit -m "feat: add charging cradle with USB-C and pogo pin pads

Same outer profile as electrode tray — slides into top shell rails.
4 contact pads at pogo pin positions deliver USB-C power for LiPo
charging through the same spring contacts."
```

---

### Task 5: Rewrite assembly.scad

**Files:**
- Rewrite: `cad/assembly.scad`

- [ ] **Step 1: Write the new assembly.scad**

Replace the entire contents of `cad/assembly.scad` with:

```openscad
// =============================================================================
// assembly.scad — CortiPod full assembly (slide-on design)
//
// Slide-on 2-piece: top shell (brain + strap) with U-channel rails,
// bottom shell (electrode tray) slides in from +Y.
// Charging cradle substitutes for bottom shell during charging.
//
// view_mode: "assembled", "exploded", "layout", "cross", "charging"
// =============================================================================

include <parameters.scad>
use <bottom_shell.scad>
use <top_shell.scad>
use <charging_cradle.scad>

// =============================================================================
// *** CHANGE THIS ***
// =============================================================================
view_mode = "exploded";

show_top       = true;
show_bottom    = true;
show_electrode = true;
show_pcb       = true;
show_battery   = true;
show_contacts  = true;
show_skin      = true;
show_labels    = true;
show_cradle    = true;

explode_gap    = 14;
layout_gap     = 12;

$fn = $preview ? 32 : 96;

// ---- Electrode position (assembled) ----
elec_z = ledge_height;

// =============================================================================
if (view_mode == "assembled") assembled_view();
else if (view_mode == "exploded") exploded_view();
else if (view_mode == "layout") layout_view();
else if (view_mode == "charging") charging_view();
else if (view_mode == "cross") {
    difference() {
        assembled_view();
        translate([-100, 0, -50]) cube([200, 200, 200]);
    }
}

// =============================================================================
// ASSEMBLED
// =============================================================================
module assembled_view() {
    if (show_bottom)
        color("DimGray", 0.9)
            bottom_shell();

    if (show_electrode)
        _electrode_assembled();

    if (show_contacts)
        _pogo_pins_assembled();

    if (show_top)
        color("DarkSlateGray", 0.9)
            translate([0, 0, bottom_shell_height])
                top_shell();

    if (show_pcb)
        color("Green", 0.5)
            translate([-pcb_length/2, -pcb_width/2,
                       bottom_shell_height + wall_thickness + 1.0])
                cube([pcb_length, pcb_width, pcb_thickness]);

    if (show_battery)
        color("DodgerBlue", 0.5)
            translate([-battery_length/2, -battery_width/2,
                       bottom_shell_height + wall_thickness + 1.0 + pcb_thickness + 0.5])
                cube([battery_length, battery_width, battery_thickness]);

    if (show_skin)
        color("PeachPuff", 0.15)
            translate([-25, -20, -0.5])
                cube([50, 40, 0.3]);
}

// =============================================================================
// CHARGING VIEW — cradle replaces bottom shell
// =============================================================================
module charging_view() {
    color("OrangeRed", 0.9)
        charging_cradle();

    if (show_contacts)
        _pogo_pins_assembled();

    color("DarkSlateGray", 0.9)
        translate([0, 0, bottom_shell_height])
            top_shell();

    if (show_pcb)
        color("Green", 0.5)
            translate([-pcb_length/2, -pcb_width/2,
                       bottom_shell_height + wall_thickness + 1.0])
                cube([pcb_length, pcb_width, pcb_thickness]);

    if (show_battery)
        color("DodgerBlue", 0.5)
            translate([-battery_length/2, -battery_width/2,
                       bottom_shell_height + wall_thickness + 1.0 + pcb_thickness + 0.5])
                cube([battery_length, battery_width, battery_thickness]);
}

// =============================================================================
// EXPLODED
// =============================================================================
module exploded_view() {
    g = explode_gap;

    // Skin
    if (show_skin) {
        color("PeachPuff", 0.15)
            translate([-25, -20, -g])
                cube([50, 40, 0.3]);
        if (show_labels) _label("Skin (wrist)", 0, -22, -g);
    }

    // Layer 1: Bottom shell (electrode tray)
    if (show_bottom) {
        color("DimGray", 0.9)
            bottom_shell();
        if (show_labels)
            _label("Electrode Tray (slides in from +Y)", 0, -tray_length/2 - 6, 0);

        // Slide direction arrow
        color("Red", 0.6)
            translate([0, pod_width/2 + 6, tray_height/2])
                rotate([0, 0, 180]) _arrow_slide();
    }

    // Layer 2: Dual electrode board
    if (show_electrode) {
        color("Gold", 0.8)
            translate([-electrode_board_total_y/2, -electrode_board_width/2, g * 1.3])
                cube([electrode_board_total_y, electrode_board_width, electrode_board_thickness]);

        // WE indicators
        color("DarkRed", 0.6)
            translate([we_mip_offset_x, 0, g * 1.3 + electrode_board_thickness])
                cylinder(d=we_diameter, h=0.1);
        color("DarkOrange", 0.6)
            translate([we_nip_offset_x, 0, g * 1.3 + electrode_board_thickness])
                cylinder(d=we_diameter, h=0.1);

        if (show_labels) {
            _label("Dual Electrode PCB (drops into tray)", 0, -electrode_board_width/2 - 4, g * 1.3);
            _label("MIP", we_mip_offset_x, 6, g * 1.3);
            _label("NIP", we_nip_offset_x, 6, g * 1.3);
        }
    }

    // Layer 3: Pogo pins (on main PCB underside)
    if (show_contacts) {
        _pogo_pins_exploded(g * 2.5);
        if (show_labels)
            _label("Pogo Pins x4 (on PCB, press down onto electrode)", 0, -8, g * 2.5);
    }

    // Layer 4: Main PCB
    if (show_pcb) {
        color("Green", 0.6)
            translate([-pcb_length/2, -pcb_width/2, g * 3.2])
                cube([pcb_length, pcb_width, pcb_thickness]);
        if (show_labels)
            _label("PCB (nRF52832 + AD5941, 24x24mm)", 0, -pcb_width/2 - 4, g * 3.2);
    }

    // Layer 5: Battery
    if (show_battery) {
        color("DodgerBlue", 0.6)
            translate([-battery_length/2, -battery_width/2, g * 4.0])
                cube([battery_length, battery_width, battery_thickness]);
        if (show_labels) _label("Battery 60mAh LiPo", 0, -battery_width/2 - 4, g * 4.0);
    }

    // Layer 6: Top shell (with strap lugs and rails)
    if (show_top) {
        color("DarkSlateGray", 0.9)
            translate([0, 0, g * 5.0])
                top_shell();
        if (show_labels)
            _label("Top Shell (sealed, rails, strap lugs)", 0, -pod_width/2 - 4, g * 5.0);
    }

    // Layer 7: Charging cradle (shown offset to the side)
    if (show_cradle) {
        color("OrangeRed", 0.8)
            translate([pod_length + layout_gap, 0, 0])
                charging_cradle();
        if (show_labels)
            _label("Charging Cradle (USB-C, same rails)", pod_length + layout_gap, -tray_length/2 - 4, 0);
    }

    // Assembly arrows
    if (show_labels)
        color("Red", 0.5)
            for (z = [g * 0.5, g * 1.8, g * 2.8, g * 3.6, g * 4.5])
                translate([0, 0, z])
                    _arrow_down();
}

// =============================================================================
// LAYOUT
// =============================================================================
module layout_view() {
    g = layout_gap;

    if (show_bottom) {
        color("DimGray", 0.9) bottom_shell();
        if (show_labels) _label("Electrode Tray", 0, -tray_length/2 - 4, 0);
    }

    if (show_top) {
        color("DarkSlateGray", 0.9)
            translate([pod_length + g, 0, top_shell_height])
                mirror([0, 0, 1]) top_shell();
        if (show_labels) _label("Top Shell (flipped)", pod_length + g, -pod_width/2 - 4, 0);
    }

    if (show_cradle) {
        color("OrangeRed", 0.8)
            translate([2 * (pod_length + g), 0, 0])
                charging_cradle();
        if (show_labels) _label("Charging Cradle", 2 * (pod_length + g), -tray_length/2 - 4, 0);
    }

    row2_y = -pod_width - g * 2;

    if (show_electrode) {
        color("Gold", 0.8)
            translate([-electrode_board_total_y/2, row2_y - electrode_board_width/2, 0])
                cube([electrode_board_total_y, electrode_board_width, electrode_board_thickness]);
        if (show_labels)
            _label("Electrode PCB (22x22mm)", 0, row2_y - electrode_board_width/2 - 4, 0);
    }

    if (show_pcb) {
        color("Green", 0.6)
            translate([pod_length + g - pcb_length/2, row2_y - pcb_width/2, 0])
                cube([pcb_length, pcb_width, pcb_thickness]);
        if (show_labels) _label("Main PCB", pod_length + g, row2_y - pcb_width/2 - 4, 0);
    }

    if (show_battery) {
        color("DodgerBlue", 0.6)
            translate([2 * (pod_length + g) - battery_length/2, row2_y - battery_width/2, 0])
                cube([battery_length, battery_width, battery_thickness]);
        if (show_labels) _label("Battery", 2 * (pod_length + g), row2_y - battery_width/2 - 4, 0);
    }
}

// =============================================================================
// Helpers
// =============================================================================

module _electrode_assembled() {
    color("Gold", 0.75)
        translate([-electrode_board_total_y/2,
                   -electrode_board_width/2,
                   elec_z])
            cube([electrode_board_total_y, electrode_board_width, electrode_board_thickness]);

    color("DarkRed", 0.5)
        translate([we_mip_offset_x, 0, elec_z - 0.05])
            cylinder(d=we_diameter, h=0.1);

    color("DarkOrange", 0.5)
        translate([we_nip_offset_x, 0, elec_z - 0.05])
            cylinder(d=we_diameter, h=0.1);
}

module _pogo_pins_assembled() {
    contacts = [
        [contact_we_mip_x, contact_we_mip_y],
        [contact_we_nip_x, contact_we_nip_y],
        [contact_ce_x,     contact_ce_y],
        [contact_re_x,     contact_re_y],
    ];

    pin_top = bottom_shell_height + wall_thickness;
    pin_bottom = electrode_back_z;

    color("Gold", 0.9)
        for (pos = contacts) {
            translate([pos[0], pos[1], pin_bottom])
                cylinder(d=spring_contact_diameter, h=pin_top - pin_bottom);
        }
}

module _pogo_pins_exploded(z_pos) {
    contacts = [
        [contact_we_mip_x, contact_we_mip_y],
        [contact_we_nip_x, contact_we_nip_y],
        [contact_ce_x,     contact_ce_y],
        [contact_re_x,     contact_re_y],
    ];

    color("Gold", 0.9)
        for (pos = contacts) {
            translate([pos[0], pos[1], z_pos])
                cylinder(d=spring_contact_diameter, h=pogo_total_height);
        }
}

module _arrow_down() {
    cylinder(d=0.4, h=explode_gap * 0.3, center=true);
    translate([0, 0, -explode_gap * 0.15])
        cylinder(d1=1.5, d2=0, h=2);
}

module _arrow_slide() {
    cylinder(d=0.4, h=6, center=true);
    translate([0, 0, -3])
        cylinder(d1=0, d2=1.5, h=2);
}

module _label(txt, x, y, z) {
    color("Black")
        translate([x, y, z])
            linear_extrude(0.2)
                text(txt, size=2.0, halign="center", font="Liberation Sans:style=Bold");
}
```

- [ ] **Step 2: Open in OpenSCAD, test each view mode**

Change `view_mode` and press F5 for each:
- `"assembled"` — all parts in position, tray inside top shell
- `"exploded"` — stacked with gaps, charging cradle shown to the side
- `"layout"` — all parts laid flat including cradle
- `"charging"` — cradle replaces bottom shell
- `"cross"` — assembled, sliced in half

- [ ] **Step 3: Commit**

```bash
git add cad/assembly.scad
git commit -m "feat: rewrite assembly for slide-on design with charging view

Update all view modes for U-channel rail architecture. Add 'charging'
view showing cradle in place of electrode tray. Remove alignment pins,
magnets, O-ring from exploded/layout views. Add charging cradle to
exploded and layout views."
```

---

### Task 6: Update README.md

**Files:**
- Rewrite: `cad/README.md`

- [ ] **Step 1: Write the new README.md**

Replace the entire contents of `cad/README.md` with:

```markdown
# CortiPod CAD Files

## Design: Slide-On 2-Piece Enclosure

```
Exploded view (side):

        ┌──────────────────────┐
  lug ──┤      Top Shell        ├── lug    ← PCB + battery + strap lugs
        │  [pogo pins ↓↓↓↓]   │              4 pogo pins press DOWN
        ├══ U-channel rails ═══┤              through pass-through holes
        │   Electrode Tray     │           ← slides in from +Y via lips
        │  ┌──────────────────┐│
        │  │ MIP WE   NIP WE ││←── 22x22mm dual electrode PCB
        │  │ (8mm)    (8mm)  ││     drops into tray, sensing face DOWN
        │  │    CE frame     ││     pogo pins hold it firm
        │  └──────────────────┘│
        └──────────────────────┘
        ═══════════════════════  skin
```

## Key Design Changes (v2 snap-fit → v3 slide-on)

| Feature | v2 (Snap-Fit) | v3 (Slide-On) |
|---------|:-:|:-:|
| Shell connection | Snap-fit clips + alignment pins | **U-channel rails + detent click** |
| Strap attachment | Bottom shell lugs | **Top shell lugs** |
| Electrode swap | Slide in/out from +X (pod open) | **Drop into tray, slide tray in from +Y** |
| Charging | Magnetic pads + magnets | **Cradle with same rails, pogo pin power** |
| Sealing | O-ring at parting line | **Each shell individually sealed** |
| GSR pads | 2x stainless steel | **Removed (infer from electrode impedance)** |
| LED | Light pipe hole | **Removed (status via phone app)** |

## Electrical Contact Design

Pogo pins are mounted on the underside of the main PCB, pointing DOWN. They protrude through 4 pass-through holes in the top shell's underside. When the tray slides in, the pins compress against the electrode board's back contact pads.

```
Cross-section (assembled):

     ┌─────── Top Shell ────────────┐
     │  [Battery]                    │
     │  [Main PCB ↓↓↓↓ pogo pins]  │
     ├══ rail ════════════════ rail ═┤  ← U-channel rail interface
     │  lip ┌──────────────┐ lip    │  ← tray lips in channels
     │      │  electrode   │        │     pogo pins contact back pads
     │      │  front ▼▼▼▼▼ │        │     sensing face through window
     │      └──────────────┘        │
     │     ════ skin window ════     │
     └───────────────────────────────┘
                   skin
```

No flex cables. Electrical path: electrode back pad → pogo pin → main PCB trace → AD5941.

## Charging

A dedicated cradle with the same outer profile slides into the top shell's rails. USB-C power is delivered through the 4 pogo pins:

| Pogo pin | Normal use | Charging |
|----------|-----------|----------|
| WE_MIP | Working electrode | V+ (5V) |
| WE_NIP | Working electrode | V+ (5V) |
| CE | Counter electrode | GND |
| RE | Reference electrode | GND |

## Files

| File | Description | Print? |
|------|-------------|:------:|
| `parameters.scad` | All dimensions — single source of truth | No |
| `top_shell.scad` | Top half (PCB + battery + rails + strap lugs) | Yes |
| `bottom_shell.scad` | Electrode tray (pocket + lips + skin window) | Yes |
| `charging_cradle.scad` | Charging dock (USB-C + contact pads + lips) | Yes |
| `assembly.scad` | Full assembly — 5 view modes | No |

## How to swap the electrode

```
1. Slide tray out    →  pull from +Y end
2. Flip tray over    →  old electrode falls out
3. Drop new one in   →  sensing face down, chamfer aligns orientation
4. Slide tray back   →  detent clicks when fully seated
                        pogo pins engage automatically
```

## How to charge

```
1. Slide electrode tray out  →  pull from +Y end
2. Slide charging cradle in  →  detent clicks
3. Plug USB-C into cradle    →  TP4056 charges LiPo via pogo pins
4. When done, swap back      →  remove cradle, insert electrode tray
```

## How to use OpenSCAD

1. Install [OpenSCAD](https://openscad.org/downloads.html) (free)
2. Open any `.scad` file
3. **F5** = quick preview, **F6** = full render (needed before export)
4. **File > Export > STL** to save for 3D printing

### Assembly view modes

Open `assembly.scad` and change `view_mode`:

| Mode | What it shows |
|------|---------------|
| `"assembled"` | All parts in final position |
| `"exploded"` | Parts stacked with gaps + labels + arrows |
| `"layout"` | All parts laid out flat side by side |
| `"cross"` | Assembled, sliced in half to see inside |
| `"charging"` | Cradle in place of electrode tray |

## Key dimensions

```
Pod:              28 x 28 x 9 mm
Top shell:        6.5 mm (PCB + battery + pogo clearance)
Bottom shell:     2.5 mm (electrode tray)
Electrode board:  22 x 22 mm, 0.8 mm thick
  WE_MIP:         8 mm diameter (50.3 mm²)
  WE_NIP:         8 mm diameter (50.3 mm²)
  CE frame:       ~170 mm² (horseshoe)
  RE:             2 mm diameter (Ag/AgCl)
Strap:            18mm quick-release (on top shell)
Pogo pins:        4x Mill-Max 0906 (on main PCB)
Rails:            U-channel, 1.2mm wide, 0.8mm deep
Detent:           0.3mm bump, 1.5mm diameter
```

## Strap options

1. **Quick-release band** — 18mm silicone strap through top shell lugs
2. **Whoop-style sleeve** — fabric band with pocket for the pod body

Both use the same top shell — no modifications needed.

## Printing

| Part | Qty | Notes |
|------|-----|-------|
| Top shell | 2-3 | Print top face down. Iteration. |
| Electrode tray | 3-5 | Print skin-side down. Cheap, order extras. |
| Charging cradle | 1 | Print top face up for smooth contact surface. |

| Material | Method | Where | Notes |
|----------|--------|-------|-------|
| MJF Nylon PA12 | MJF | JLCPCB, Shapeways | Best overall |
| SLA BioMed Amber | SLA | Xometry | Skin-safe certified |
| PETG | FDM | Home printer | Good for prototyping |
| PLA | FDM | Home printer | Test fit only |

## Assembly order

1. Mount 4 pogo pins on main PCB underside
2. Place PCB on standoffs inside top shell (asymmetric — poka-yoke)
3. Connect battery, tuck beside PCB
4. Apply conformal coating to top shell internals
5. Drop electrode into tray (sensing face down, chamfer aligns)
6. Slide tray into top shell from +Y — detent clicks
7. Attach 18mm strap through lugs

## Related documents

- `docs/superpowers/specs/2026-04-13-slide-on-enclosure-design.md` — design spec
- `docs/custom-electrode-fabrication-guide.md` — electrode PCB ordering and MIP fabrication
- `electrode-pcb/cortipod-electrode.kicad_pcb` — KiCad source for the dual electrode PCB
- `docs/enclosure-design-engineering-reference.md` — engineering principles
```

- [ ] **Step 2: Commit**

```bash
git add cad/README.md
git commit -m "docs: update CAD README for slide-on enclosure design

Rewrite diagrams, file table, assembly instructions, dimensions,
and printing notes. Add charging workflow and strap options."
```

---

### Task 7: Validate all files render in OpenSCAD

**Files:**
- Validate: all `cad/*.scad` files

- [ ] **Step 1: Open each file in OpenSCAD and press F5**

Test each file in order:
1. `parameters.scad` — no geometry, should render empty scene with no errors
2. `top_shell.scad` — shell body with lugs and rails, no holes on top face
3. `bottom_shell.scad` — small tray with lips, pocket, and skin window
4. `charging_cradle.scad` — same tray profile with USB-C slot and pad recesses
5. `assembly.scad` — test all 5 view modes: `assembled`, `exploded`, `layout`, `cross`, `charging`

- [ ] **Step 2: Fix any OpenSCAD warnings or errors**

Common issues to check:
- Undefined variables (removed params still referenced somewhere)
- Missing `include` or `use` statements
- Zero-height geometry warnings
- Manifold errors in F6 render

- [ ] **Step 3: Visual check in exploded view**

In `assembly.scad` with `view_mode = "exploded"`:
- Tray should be smaller than top shell
- Lips should be visible on tray ±Y edges
- Rails should be visible on top shell underside
- Charging cradle should appear offset to the side
- No alignment pins, magnets, or O-ring visible
- Strap lugs on top shell, not bottom

- [ ] **Step 4: Visual check in cross-section view**

In `assembly.scad` with `view_mode = "cross"`:
- Electrode sitting on ledges inside tray
- Pogo pins reaching down from PCB to electrode back
- Rail channels visible at ±Y sides
- Tray lips captured in channels
- No O-ring groove visible

- [ ] **Step 5: Final commit**

```bash
git add -A cad/
git commit -m "fix: resolve any OpenSCAD rendering issues

Validate all view modes render cleanly. Fix any undefined variable
references or geometry warnings."
```

Note: only commit if changes were needed. If everything rendered cleanly in step 1, skip this commit.
