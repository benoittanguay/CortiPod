// =============================================================================
// bottom_shell.scad — CortiPod electrode frame (skin-contact side)
//
// SOLID-BODY APPROACH: Start with a solid rounded rectangle, then cut out:
//   1. Electrode slot pocket (from top) — the cavity the board sits in
//   2. Skin window (from bottom) — exposes sensing face to skin
//   3. Insertion opening (through +X wall) — how the board enters
//   4. Small features (vent grooves, GSR holes, alignment, clips, key)
//
// The material left between cuts naturally forms:
//   - Perimeter walls (outer shell minus slot pocket)
//   - Floor/ledges (slot pocket floor minus skin window)
//   - End-stop wall (-X side of slot)
//
// Cross-section at the sensing zone (looking from +X):
//
//     ┌─ wall ─┬── shelf ──┐              ┌── shelf ──┬─ wall ─┐
//     │        │           │  electrode   │           │        │
//     │  2.5mm │  1.3mm    │   0.8mm PCB  │   1.3mm   │  2.5mm │
//     │        │           ├──────────────┤           │        │
//     │        │     0.3mm floor          0.3mm floor │        │
//     │        └───────────┘ ══ skin window ══ ───────┘        │
//     └────────────────────────────────────────────────────────┘
//                          skin
//
// Print: skin-side DOWN for smooth bottom surface.
// =============================================================================

include <parameters.scad>

$fn = $preview ? 32 : 96;

// ---- Helpers ----
module rounded_rect(l, w, h, r) {
    hull() {
        for (x = [-l/2 + r, l/2 - r])
            for (y = [-w/2 + r, w/2 - r])
                translate([x, y, 0])
                    cylinder(r=r, h=h);
    }
}

// ---- Derived positions ----
// Slot runs from the -X stop wall to the +X insertion opening
slot_x_start = -pod_length/2 + wall_thickness;
slot_x_end   =  pod_length/2;
slot_x_length = slot_x_end - slot_x_start;

// Skin window centered in the slot area
skin_win_x_center = slot_x_start + slot_x_length / 2;
skin_win_x_start  = skin_win_x_center - skin_window_width / 2;

// ---- Main module ----
module bottom_shell() {
    difference() {
        // === POSITIVE GEOMETRY (one connected solid) ===
        union() {
            // The entire shell body — solid block with rounded corners.
            // Everything (walls, floor, ledges) is part of this one piece.
            rounded_rect(pod_length, pod_width, bottom_shell_height, pod_corner_radius);

            // Strap lugs extending from ±X ends
            strap_lugs();
        }

        // === NEGATIVE GEOMETRY (all the cavities) ===

        // 1. ELECTRODE SLOT POCKET — cut from the top
        //    Creates the cavity the electrode board sits in.
        //    Leaves a floor of thickness ledge_height (0.3mm) at the bottom.
        //    The material between the slot boundary and the outer walls
        //    forms the shelves that support the electrode edges.
        translate([slot_x_start, -slot_width/2, ledge_height])
            cube([slot_x_length + 0.1,
                  slot_width,
                  bottom_shell_height]);

        // 2. SKIN WINDOW — cut from the bottom, through the floor
        //    Only in the sensing zone (smaller than the slot).
        //    The remaining floor around the window IS the electrode ledge.
        translate([skin_win_x_start, -skin_window_length/2, -0.1])
            cube([skin_window_width,
                  skin_window_length,
                  bottom_shell_height + 0.2]);

        // 3. INSERTION OPENING — cut through the +X perimeter wall
        //    Allows the electrode board to slide in from the +X end.
        insertion_opening();

        // 4. VENTILATION GROOVES — shallow channels on the bottom skin face
        ventilation_grooves();

        // 5. ALIGNMENT PIN HOLES — for shell-to-shell registration
        alignment_pin_holes();

        // 6. SNAP CLIP RECEIVER SLOTS — for top shell clips
        clip_receiver_slots();

        // 7. GSR PAD HOLES — through-holes for skin conductance pads
        gsr_pad_holes();

        // 8. ORIENTATION KEY — corner notch matching electrode chamfer
        orientation_key();
    }
}

// ---- Insertion opening ----
// Cut through the +X perimeter wall to create the slot entry.
// Includes a chamfered funnel to guide electrode insertion.
module insertion_opening() {
    // Rectangular cut through the +X wall, full slot width and height
    translate([pod_length/2 - wall_thickness - 0.1,
               -slot_width/2,
               0])
        cube([wall_thickness + 0.2,
              slot_width,
              ledge_height + electrode_board_thickness + slot_clearance + 0.1]);

    // Chamfered funnel at the entry face
    chamfer_exp = insertion_chamfer_depth * tan(insertion_chamfer_angle);
    translate([pod_length/2 - wall_thickness - insertion_chamfer_depth,
               -slot_width/2 - chamfer_exp,
               -0.1])
        hull() {
            translate([0, chamfer_exp, 0])
                cube([0.1,
                      slot_width,
                      ledge_height + electrode_board_thickness + slot_clearance + 0.1]);
            translate([insertion_chamfer_depth + wall_thickness, 0, 0])
                cube([0.1,
                      slot_width + chamfer_exp * 2,
                      ledge_height + electrode_board_thickness + slot_clearance + 0.1]);
        }
}

// ---- Ventilation grooves ----
// Shallow channels on the outer bottom face (skin side), flanking the skin window.
// Help air circulate under the device and prevent moisture pooling.
module ventilation_grooves() {
    groove_length = skin_window_width - 2;
    groove_x = skin_win_x_start + 1;

    spacing = (skin_window_length + 4) / max(vent_groove_count - 1, 1);

    for (i = [0 : vent_groove_count - 1]) {
        gy = -skin_window_length/2 - 2 + i * spacing;
        translate([groove_x, gy - vent_groove_width/2, -0.1])
            cube([groove_length, vent_groove_width, vent_groove_depth + 0.1]);
    }
}

// ---- Alignment pin holes ----
// Receive pins from the top shell for registration.
// Asymmetric placement prevents 180-degree assembly error.
module alignment_pin_holes() {
    hole_d = alignment_pin_diameter + alignment_hole_clearance * 2;

    // Pin 1: round hole
    translate([align_pin1_x, align_pin1_y,
               bottom_shell_height - alignment_pin_height])
        cylinder(d=hole_d, h=alignment_pin_height + 0.1);

    // Pin 2: slotted hole (accommodates tolerance)
    translate([align_pin2_x, align_pin2_y,
               bottom_shell_height - alignment_pin_height])
        hull() {
            cylinder(d=hole_d, h=alignment_pin_height + 0.1);
            translate([0.5, 0, 0])
                cylinder(d=hole_d, h=alignment_pin_height + 0.1);
        }
}

// ---- Clip receiver slots ----
// Rectangular notches in the perimeter walls where top shell
// snap-fit hooks engage.
module clip_receiver_slots() {
    notch_w = clip_width + 0.4;

    clip_x_positions = [
        -pod_length/2 + pod_corner_radius + 3,
         pod_length/2 - pod_corner_radius - 3 - clip_width,
    ];

    for (cx = clip_x_positions) {
        for (y_sign = [-1, 1]) {
            y_pos = (y_sign == -1)
                ? -pod_width/2 - 0.1
                :  pod_width/2 - wall_thickness - 0.1;

            translate([cx - 0.2, y_pos, -0.1])
                cube([notch_w, wall_thickness + 0.2, bottom_shell_height + 0.2]);
        }
    }
}

// ---- GSR pad holes ----
// Through-holes in the bottom face for galvanic skin response electrodes.
// Metal pads flush with the skin face provide sweat/contact detection.
module gsr_pad_holes() {
    for (x_off = [-gsr_pad_spacing/2, gsr_pad_spacing/2]) {
        translate([x_off, gsr_pad_y_offset, -0.1])
            cylinder(d=gsr_pad_diameter, h=bottom_shell_height + 0.2);
    }
}

// ---- Orientation key ----
// A small notch at one corner of the slot entry that matches the
// corner chamfer on the electrode board. The electrode can only be
// inserted with the correct orientation (prevents MIP/NIP swap).
module orientation_key() {
    // Chamfer notch at the -Y, stop-wall (-X) corner of the slot
    translate([slot_x_start - 0.1,
               -slot_width/2 - 0.1,
               -0.1])
        cube([chamfer_size + 0.2,
              chamfer_size + 0.2,
              bottom_shell_height + 0.2]);
}

// ---- Strap lugs ----
// Protrusions at ±X ends with holes for an 18mm quick-release strap.
module strap_lugs() {
    for (end = [-1, 1]) {
        x_base = end * pod_length/2;
        x_outer = x_base + end * lug_extension;

        // Lug body
        translate([min(x_base, x_outer), -strap_width/2, 0])
            cube([lug_extension, strap_width, lug_height]);

        // Strap pin holes through each side of the lug
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

// ---- Render ----
bottom_shell();
