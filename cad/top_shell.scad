// =============================================================================
// top_shell.scad — CortiPod main enclosure ("brain unit")
//
// Houses all electronics. Pogo pins protrude from bottom face.
// Snap clips extend below to grip the bottom shell.
//
// Pogo pin layout: 8 pins total — 4 per electrode (WE, CE, REF, GND).
//   MIP electrode: 4 pins on the negative-Y side of centre
//   NIP electrode: 4 pins on the positive-Y side of centre
//
// Print: TOP face down (smooth outer surface on build plate)
// =============================================================================

include <parameters.scad>

$fn = 60;

module top_shell() {
    difference() {
        union() {
            // Main shell body
            shell_body();

            // Snap-fit clips (extend below the shell)
            snap_fit_clips();
        }

        // Hollow out the cavity
        translate([0, 0, wall_thickness])
            internal_cavity();

        // Pogo pin holes through the floor
        pogo_pin_holes();

        // O-ring groove on the bottom mating face
        oring_groove();
    }

    // PCB standoffs (placed INSIDE the cavity after the difference)
    // This way they don't interfere with exterior geometry
    intersection() {
        shell_body(); // clip standoffs to shell boundary
        pcb_standoffs();
    }
}

// ---- Shell body ----
module shell_body() {
    hull() {
        for (x = [-pod_length/2 + pod_corner_radius, pod_length/2 - pod_corner_radius])
            for (y = [-pod_width/2 + pod_corner_radius, pod_width/2 - pod_corner_radius])
                translate([x, y, 0])
                    cylinder(r=pod_corner_radius, h=top_shell_height);
    }
}

// ---- Internal cavity ----
module internal_cavity() {
    inset = wall_thickness;
    cavity_h = top_shell_height - wall_thickness * 2 + 0.1;

    hull() {
        for (x = [-pod_length/2 + pod_corner_radius + inset,
                   pod_length/2 - pod_corner_radius - inset])
            for (y = [-pod_width/2 + pod_corner_radius + inset,
                       pod_width/2 - pod_corner_radius - inset])
                translate([x, y, 0])
                    cylinder(r=pod_corner_radius - inset + printer_tolerance,
                             h=cavity_h);
    }
}

// ---- PCB standoffs ----
// Short posts rising from the floor inside the cavity
module pcb_standoffs() {
    standoff_height = 1.0;
    standoff_od = 3.0;

    positions = [
        [-pcb_length/2 + 3, -pcb_width/2 + 3],
        [-pcb_length/2 + 3,  pcb_width/2 - 3],
        [ pcb_length/2 - 3, -pcb_width/2 + 3],
        [ pcb_length/2 - 3,  pcb_width/2 - 3],
    ];

    for (pos = positions) {
        translate([pos[0], pos[1], wall_thickness])
            cylinder(d=standoff_od, h=standoff_height);
    }
}

// ---- Pogo pin holes ----
// 8 holes total: 4 for the MIP electrode (negative Y), 4 for the NIP (positive Y).
// Each set of 4 is centred over that electrode's contact pads along X, and
// positioned at the Y-centre of each electrode pocket.
//
// pogo_count = 8, so pogo_count/2 = 4 pins per electrode.
// Pins per electrode are arranged in a 0.1"-pitch row along X.
module pogo_pin_holes() {
    pins_per_electrode = pogo_count / 2;           // 4
    row_span = (pins_per_electrode - 1) * pogo_spacing;
    start_x  = -(row_span / 2);

    // X centre: align to the electrode's contact pads
    pad_center_x = electrode_length/2 - electrode_pad_offset;

    // Y centre of each electrode pocket
    mip_y = -(electrode_gap/2 + electrode_width/2);
    nip_y =   electrode_gap/2 + electrode_width/2;

    for (i = [0 : pins_per_electrode - 1]) {
        x = pad_center_x + start_x + i * pogo_spacing;

        // MIP electrode holes
        translate([x, mip_y, -0.1])
            cylinder(d=pogo_pin_hole, h=wall_thickness + 0.2);

        // NIP electrode holes
        translate([x, nip_y, -0.1])
            cylinder(d=pogo_pin_hole, h=wall_thickness + 0.2);
    }
}

// ---- Snap-fit clips ----
// Extend below the shell body to grip the bottom shell ledges
module snap_fit_clips() {
    arm_thickness = 0.8;
    arm_length = bottom_shell_height + 1.0;

    // 4 clips: 2 per long edge, positioned within the pod footprint
    clip_x_positions = [
        -pod_length/2 + pod_corner_radius + 4,
         pod_length/2 - pod_corner_radius - 4 - clip_width,
    ];

    for (cx = clip_x_positions) {
        // -Y side
        translate([cx, -pod_width/2 + wall_thickness, -arm_length])
            cube([clip_width, arm_thickness, arm_length]);
        // -Y hook
        translate([cx, -pod_width/2 + wall_thickness - clip_depth, -arm_length])
            cube([clip_width, clip_depth, clip_depth]);

        // +Y side
        translate([cx, pod_width/2 - wall_thickness - arm_thickness, -arm_length])
            cube([clip_width, arm_thickness, arm_length]);
        // +Y hook
        translate([cx, pod_width/2 - wall_thickness, -arm_length])
            cube([clip_width, clip_depth, clip_depth]);
    }
}

// ---- O-ring groove ----
module oring_groove() {
    groove_inset = wall_thickness / 2;

    difference() {
        translate([0, 0, -0.01])
            linear_extrude(oring_groove_depth + 0.01)
                offset(r=-groove_inset)
                    rounded_rect_2d(pod_length, pod_width, pod_corner_radius);

        translate([0, 0, -0.1])
            linear_extrude(oring_groove_depth + 0.2)
                offset(r=-groove_inset - oring_groove_width)
                    rounded_rect_2d(pod_length, pod_width, pod_corner_radius);
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

// ---- Render ----
top_shell();
