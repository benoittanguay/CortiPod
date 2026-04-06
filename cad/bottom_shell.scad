// =============================================================================
// bottom_shell.scad — CortiPod electrode frame (skin-contact side)
//
// Simple frame: dual electrode windows + shelves + strap lugs.
// No electronics. Two electrodes (MIP + NIP) drop in from above,
// held by pogo pin pressure. Center divider (electrode_gap) provides
// structural support between the two pockets.
//
// Electrode layout (Y axis, centered at 0):
//   MIP pocket: Y = -(electrode_gap/2 + electrode_width + pocket_clearance) to -(electrode_gap/2)
//   NIP pocket: Y = +(electrode_gap/2) to +(electrode_gap/2 + electrode_width + pocket_clearance)
//
// Print: skin-side DOWN for smooth bottom surface.
// =============================================================================

include <parameters.scad>

$fn = 60;

module bottom_shell() {
    difference() {
        // Solid frame body
        frame_body();

        // Electrode pocket (electrode-sized, open from above)
        electrode_pocket();

        // Sensor window (smaller, creates shelf for electrode to rest on)
        sensor_window();

        // Snap clip receiver slots (top shell clips hook into these)
        clip_receiver_slots();

        // GSR pad holes (through-holes for wires/contacts from top shell)
        gsr_pad_holes();
    }
}

// ---- Frame body ----
module frame_body() {
    hull() {
        for (x = [-pod_length/2 + pod_corner_radius, pod_length/2 - pod_corner_radius])
            for (y = [-pod_width/2 + pod_corner_radius, pod_width/2 - pod_corner_radius])
                translate([x, y, 0])
                    cylinder(r=pod_corner_radius, h=bottom_shell_height);
    }
}

// ---- Electrode pocket ----
// Two electrode-sized openings, open from the top, separated by the center
// divider (electrode_gap wide). Each pocket holds one DRP-220AT electrode.
//   MIP (cortisol-detecting):  negative Y side
//   NIP (control/reference):   positive Y side
module electrode_pocket() {
    pocket_l = electrode_length + pocket_clearance * 2;
    pocket_w = electrode_width  + pocket_clearance * 2;

    // MIP pocket — negative Y half
    translate([-pocket_l/2,
               -(electrode_gap/2 + pocket_w),
               sensor_recess_depth])
        cube([pocket_l, pocket_w,
              bottom_shell_height - sensor_recess_depth + 0.1]);

    // NIP pocket — positive Y half
    translate([-pocket_l/2,
               electrode_gap/2,
               sensor_recess_depth])
        cube([pocket_l, pocket_w,
              bottom_shell_height - sensor_recess_depth + 0.1]);
}

// ---- Sensor window ----
// Two openings through the floor — one per electrode.
// Each window is narrower than the electrode pocket to create the shelf on
// which the electrode edges rest. A solid bridge at Y = 0 (the center
// divider / electrode_gap region) stays intact for structural integrity.
module sensor_window() {
    win_l = sensor_window_length;
    win_w = sensor_window_width;   // per electrode — narrower than pocket

    // MIP window — negative Y side
    translate([-win_l/2,
               -(electrode_gap/2 + electrode_width/2 + win_w/2),
               -0.1])
        cube([win_l, win_w, sensor_recess_depth + 0.2]);

    // NIP window — positive Y side
    translate([-win_l/2,
               electrode_gap/2 + electrode_width/2 - win_w/2,
               -0.1])
        cube([win_l, win_w, sensor_recess_depth + 0.2]);
}

// ---- Clip receiver slots ----
// Rectangular cutouts in the inner walls where the top shell's
// snap clips and hooks engage. Cut all the way through the wall
// so there are no leftover circle artifacts.
module clip_receiver_slots() {
    slot_height = bottom_shell_height; // full height slot
    slot_width = clip_width + 0.4;     // clearance for the clip arm

    clip_x_positions = [
        -pod_length/2 + pod_corner_radius + 4,
         pod_length/2 - pod_corner_radius - 4 - clip_width,
    ];

    for (cx = clip_x_positions) {
        // -Y side: slot through the wall
        translate([cx - 0.2, -pod_width/2 - 0.1, -0.1])
            cube([slot_width, wall_thickness + 1.0, slot_height + 0.2]);

        // +Y side: slot through the wall
        translate([cx - 0.2, pod_width/2 - wall_thickness - 0.9, -0.1])
            cube([slot_width, wall_thickness + 1.0, slot_height + 0.2]);
    }
}

// ---- GSR pad holes ----
// Simple through-holes where GSR contact wires/spring pins from
// the top shell can reach the skin surface. These are just small
// round holes — the conductive pads are on the PCB side.
module gsr_pad_holes() {
    for (x = [-gsr_pad_spacing/2, gsr_pad_spacing/2]) {
        translate([x, -pod_width/2 + gsr_pad_offset_y + pod_corner_radius, -0.1])
            cylinder(d=gsr_pad_diameter, h=bottom_shell_height + 0.2);
    }
}

// ---- Helper ----
module rounded_rect_2d(length, width, radius) {
    hull() {
        for (x = [-length/2 + radius, length/2 - radius])
            for (y = [-width/2 + radius, width/2 - radius])
                translate([x, y])
                    circle(r=radius);
    }
}

// ---- Strap lugs ----
module strap_lugs() {
    for (end = [-1, 1]) {
        for (side = [-1, 1]) {
            translate([end * (pod_length/2 + lug_extension/2),
                       side * (strap_width/2 + lug_width/2),
                       bottom_shell_height/2]) {
                difference() {
                    cube([lug_extension, lug_width, lug_height], center=true);
                    rotate([0, 90, 0])
                        cylinder(d=lug_hole_diameter, h=lug_extension + 1, center=true);
                }
            }
        }
    }
}

// ---- Render ----
bottom_shell();
strap_lugs();
