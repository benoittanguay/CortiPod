// =============================================================================
// top_shell.scad — CortiPod main enclosure ("brain unit")
//
// Houses PCB and battery. FULLY SEALED — no lever cutouts or openings.
// Spring contacts are in the bottom shell; flex cable routes signals
// to the PCB through a sealed pass-through at the parting line.
//
// Engineering features:
//   - Corrected O-ring groove (1.5mm wide x 0.75mm deep for 1.0mm CS O-ring)
//   - Alignment pins for shell-to-shell registration (asymmetric poka-yoke)
//   - Snap-fit beams: 5mm length (>= 5x 0.8mm thickness), tapered 50% at tip
//   - No ZIF lever cutout — eliminated for better IP67 sealing
//
// Print: TOP face down (smooth outer surface on build plate)
// =============================================================================

include <parameters.scad>

// Adaptive resolution: fast preview, smooth export
$fn = $preview ? 32 : 96;

module top_shell() {
    difference() {
        union() {
            shell_body();
            snap_fit_clips();
            alignment_pins();
        }

        // Hollow out the cavity
        translate([0, 0, wall_thickness])
            internal_cavity();

        // O-ring groove on the bottom mating face
        oring_groove();
    }

    // PCB standoffs inside the cavity (asymmetric for poka-yoke)
    intersection() {
        shell_body();
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
// Three round standoffs + one slotted (accommodates thermal expansion).
module pcb_standoffs() {
    standoff_height = 1.0;
    standoff_od = 3.0;

    round_positions = [
        [-pcb_length/2 + 3, -pcb_width/2 + 3],
        [-pcb_length/2 + 3,  pcb_width/2 - 3],
        [ pcb_length/2 - 3, -pcb_width/2 + 3],
    ];

    for (pos = round_positions) {
        translate([pos[0], pos[1], wall_thickness])
            cylinder(d=standoff_od, h=standoff_height);
    }

    // One slotted standoff (+X, +Y) — elongated along X for thermal expansion
    translate([pcb_length/2 - 3, pcb_width/2 - 3, wall_thickness])
        hull() {
            cylinder(d=standoff_od, h=standoff_height);
            translate([1.5, 0, 0])
                cylinder(d=standoff_od, h=standoff_height);
        }
}

// ---- Alignment pins ----
// Protrude from the bottom mating face into holes in the bottom shell.
// Asymmetric placement prevents 180-degree assembly error.
module alignment_pins() {
    translate([align_pin1_x, align_pin1_y, -alignment_pin_height])
        cylinder(d=alignment_pin_diameter, h=alignment_pin_height);

    translate([align_pin2_x, align_pin2_y, -alignment_pin_height])
        cylinder(d=alignment_pin_diameter, h=alignment_pin_height);
}

// ---- Snap-fit clips ----
// Cantilever beams extending below the shell body.
// Tapered: 0.8mm at root, 0.4mm at tip for even stress distribution.
module snap_fit_clips() {
    arm_length = clip_beam_length;
    root_t = clip_beam_thickness;
    tip_t  = clip_beam_thickness * 0.5;

    clip_x_positions = [
        -pod_length/2 + pod_corner_radius + 4,
         pod_length/2 - pod_corner_radius - 4 - clip_width,
    ];

    for (cx = clip_x_positions) {
        for (side = [-1, 1]) {
            y_base = (side == -1)
                ? -pod_width/2 + wall_thickness
                :  pod_width/2 - wall_thickness - root_t;

            // Tapered beam (root at top, tip at bottom)
            translate([cx, y_base, -arm_length])
                hull() {
                    translate([0, 0, arm_length])
                        cube([clip_width, root_t, 0.1]);
                    translate([0, (root_t - tip_t) / 2, 0])
                        cube([clip_width, tip_t, 0.1]);
                }

            // Hook at tip
            hook_y = (side == -1)
                ? y_base - clip_depth
                : y_base + root_t;
            translate([cx, hook_y, -arm_length])
                cube([clip_width, clip_depth, clip_depth]);
        }
    }
}

// ---- O-ring groove ----
// For 1.0mm CS silicone O-ring: 1.5mm wide, 0.75mm deep (25% compression).
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
