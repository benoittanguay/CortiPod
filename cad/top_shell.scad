// =============================================================================
// top_shell.scad — CortiPod main enclosure ("brain unit")
//
// Houses PCB, battery, and pogo pins. FULLY SEALED — no lever cutouts.
//
// Pogo pins are mounted on the underside of the main PCB, pointing DOWN
// through the parting line to contact the electrode board's back pads.
// This eliminates the need for flex cables or contacts in the bottom shell.
//
// Engineering features:
//   - O-ring groove (1.5mm wide x 0.75mm deep for 1.0mm CS O-ring)
//   - Alignment pins (asymmetric poka-yoke)
//   - Snap-fit beams: 5mm length (>= 5x 0.8mm thickness), tapered 50% at tip
//   - Pogo pin pass-through holes in the mating face
//   - LED light pipe hole
//
// Print: TOP face down (smooth outer surface on build plate)
// =============================================================================

include <parameters.scad>

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

        // Pogo pin pass-through holes (4 holes through the mating face)
        pogo_pin_holes();

        // LED light pipe hole
        led_hole();

        // Magnetic charging pad recesses
        charging_pad_recesses();
    }

    // PCB standoffs inside the cavity
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
module pcb_standoffs() {
    standoff_height = 1.0;
    standoff_od = 3.0;

    // PCB sits above the pogo pin zone, offset toward +Z
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
// Through-bores in the mating face wall for spring-loaded pogo pins.
// Pins sit in these bores with tips protruding below the mating face
// into the bottom shell cavity, reaching the electrode back contacts.
// Pin tops protrude above the mating face wall into the PCB cavity,
// where they solder or press-fit to the main PCB pads.
module pogo_pin_holes() {
    contacts = [
        [contact_we_mip_x, contact_we_mip_y],
        [contact_we_nip_x, contact_we_nip_y],
        [contact_ce_x,     contact_ce_y],
        [contact_re_x,     contact_re_y],
    ];

    for (pos = contacts) {
        // Bore through the full mating face wall + clearance above and below
        translate([pos[0], pos[1], -pogo_protrusion_below - 0.1])
            cylinder(d=spring_contact_hole,
                     h=wall_thickness + pogo_protrusion_below + 0.2);
    }
}

// ---- LED light pipe hole ----
module led_hole() {
    translate([pod_length/2 - 5, 0, top_shell_height - wall_thickness - 0.1])
        cylinder(d=led_hole_diameter, h=wall_thickness + 0.2);
}

// ---- Charging pad recesses ----
module charging_pad_recesses() {
    for (x_off = [-mag_pad_spacing/2, mag_pad_spacing/2]) {
        translate([x_off, pod_width/2 - wall_thickness - 0.1, top_shell_height - mag_pad_depth])
            cylinder(d=mag_pad_diameter, h=mag_pad_depth + 0.1);
    }
}

// ---- Alignment pins ----
module alignment_pins() {
    translate([align_pin1_x, align_pin1_y, -alignment_pin_height])
        cylinder(d=alignment_pin_diameter, h=alignment_pin_height);

    translate([align_pin2_x, align_pin2_y, -alignment_pin_height])
        cylinder(d=alignment_pin_diameter, h=alignment_pin_height);
}

// ---- Snap-fit clips ----
module snap_fit_clips() {
    arm_length = clip_beam_length;
    root_t = clip_beam_thickness;
    tip_t  = clip_beam_thickness * 0.5;

    clip_x_positions = [
        -pod_length/2 + pod_corner_radius + 3,
         pod_length/2 - pod_corner_radius - 3 - clip_width,
    ];

    for (cx = clip_x_positions) {
        for (side = [-1, 1]) {
            y_base = (side == -1)
                ? -pod_width/2 + wall_thickness
                :  pod_width/2 - wall_thickness - root_t;

            // Tapered beam
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
