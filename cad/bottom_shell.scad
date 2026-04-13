// =============================================================================
// bottom_shell.scad — CortiPod minimal electrode tray
//
// Slides into the top shell's U-channel rails from +Y. The electrode PCB
// drops into the pocket from above (sensing face down). Lips on ±Y edges
// are captured by the top shell rails. Detent dimples on the lip inner faces
// snap against bumps in the rail channel floor when fully seated.
//
// No strap lugs, no GSR pads, no vent grooves, no alignment pins,
// no snap clip receivers, no insertion opening.
//
// Print: skin-side DOWN for smooth bottom surface.
// =============================================================================

include <parameters.scad>

$fn = $preview ? 32 : 96;

// ---- Main module ----
module bottom_shell() {
    difference() {
        union() {
            tray_body();
            tray_lips();
        }
        electrode_pocket();
        skin_window();
        orientation_key();
        detent_recesses();
    }
}

// ---- Tray body ----
// Solid rounded-rect block sized to the tray footprint.
module tray_body() {
    r = min(pod_corner_radius, 2.0);
    hull() {
        for (x = [-tray_width/2 + r, tray_width/2 - r])
            for (y = [-tray_length/2 + r, tray_length/2 - r])
                translate([x, y, 0])
                    cylinder(r=r, h=tray_height);
    }
}

// ---- Tray lips ----
// Thin protrusions on the ±Y edges that slide into the top shell U-channels.
// Positioned at the top of the tray body (Z = tray_height), extending upward.
module tray_lips() {
    for (y_sign = [-1, 1]) {
        y_pos = y_sign * (tray_length/2 - tray_lip_thickness/2);
        translate([0, y_pos, tray_height])
            cube([tray_width, tray_lip_thickness, tray_lip_height], center=true);
    }
}

// ---- Electrode pocket ----
// Recessed cavity cut from the top that receives the dual electrode PCB.
// Floor of the pocket sits at Z = ledge_height (the electrode support ledge).
module electrode_pocket() {
    pocket_z = ledge_height;
    translate([-slot_width/2, -slot_depth/2, pocket_z])
        cube([slot_width, slot_depth, tray_height - pocket_z + 0.1]);
}

// ---- Skin window ----
// Through-hole from the bottom face exposing the sensing pads to skin/sweat.
module skin_window() {
    translate([-skin_window_width/2, -skin_window_length/2, -0.1])
        cube([skin_window_width, skin_window_length, tray_height + 0.2]);
}

// ---- Orientation key ----
// Corner notch at one pocket corner matching the electrode board's chamfer.
// Prevents MIP/NIP orientation swap during assembly.
module orientation_key() {
    translate([-slot_width/2 - 0.1,
               -slot_depth/2 - 0.1,
               -0.1])
        cube([chamfer_size + 0.2,
              chamfer_size + 0.2,
              tray_height + 0.2]);
}

// ---- Detent recesses ----
// Small dimples on the inner face of each lip that mate with the detent bumps
// on the top shell rail channel floor, providing a tactile retention click.
module detent_recesses() {
    recess_d = detent_bump_diameter + 0.2;
    recess_depth = detent_bump_height + 0.1;

    for (y_sign = [-1, 1]) {
        // Inner face of each lip faces the tray centerline
        y_inner = y_sign * (tray_length/2 - tray_lip_thickness);
        translate([0,
                   y_inner,
                   tray_height + tray_lip_height/2])
            rotate([y_sign * 90, 0, 0])
                cylinder(d=recess_d, h=recess_depth + 0.1);
    }
}

// ---- Render ----
bottom_shell();
