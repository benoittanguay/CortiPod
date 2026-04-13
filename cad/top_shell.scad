// =============================================================================
// top_shell.scad — CortiPod main enclosure ("brain unit")
//
// Houses PCB, battery, and pogo pins. FULLY SEALED — only openings are
// pogo pin pass-throughs in the mating face.
//
// Pogo pins are mounted on the underside of the main PCB, pointing DOWN
// through the parting line to contact the electrode board's back pads.
// This eliminates the need for flex cables or contacts in the bottom shell.
//
// Slide-on enclosure design:
//   - U-channel rails on the underside (±Y sides) capture the bottom shell lips
//   - Detent bumps on the channel floor click when the tray is fully seated
//   - Hard stop wall at -Y end of each rail channel
//   - Strap lugs at ±X ends (18mm quick-release)
//   - No snap-fit clips, O-ring groove, alignment pins, LED hole, or magnets
//
// Assembly: slide bottom shell (electrode tray) in from the +Y end.
// Pogo pins on main PCB engage electrode back contacts automatically.
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

        // Hollow out the cavity
        translate([0, 0, wall_thickness])
            internal_cavity();

        // Pogo pin pass-through holes (4 holes through the mating face)
        pogo_pin_holes();
    }

    // PCB standoffs inside the cavity (clipped to shell body)
    intersection() {
        shell_body();
        pcb_standoffs();
    }

    // Detent bumps on channel floor (clipped to shell body + rails solid)
    detent_bumps();
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
// pogo_protrusion_below = 1.0mm (pogo_total_height - wall_thickness)
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

// ---- Strap lugs ----
// Protrusions at ±X ends with holes for an 18mm quick-release strap.
// MOVED from bottom_shell to top_shell — the brain unit is worn on the strap.
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

// ---- U-channel rails ----
// Two U-channel profiles on the underside along ±Y inner walls.
// The bottom shell (electrode tray) has lips on its ±Y edges that slide
// into these channels from the +Y end.
// Channel overhang prevents Z-axis separation.
// Hard stop wall at -Y end prevents over-insertion.
module u_channel_rails() {
    // Rail runs the full inner length along X, positioned at ±Y inner wall
    rail_x_start = -pod_length/2 + wall_thickness;
    rail_x_length = pod_length - wall_thickness * 2;

    for (side = [-1, 1]) {
        // Y position of the inner wall face
        y_inner_wall = side * (pod_width/2 - wall_thickness);

        // Outer rail wall (flush with inner shell wall, extending downward)
        // Forms the outer vertical face of the U-channel
        translate([rail_x_start,
                   y_inner_wall - (side > 0 ? rail_channel_width + rail_wall_thickness : 0),
                   -bottom_shell_height])
            cube([rail_x_length,
                  rail_wall_thickness + rail_channel_width,
                  bottom_shell_height]);

        // Channel overhang lip (horizontal ceiling of the U)
        // Sits at Z = 0 (mating face), extends inward by rail_channel_depth
        translate([rail_x_start,
                   y_inner_wall - (side > 0 ? rail_channel_depth : -rail_channel_depth - rail_wall_thickness),
                   -rail_channel_width])
            cube([rail_x_length,
                  rail_channel_depth + rail_wall_thickness,
                  rail_channel_width]);

        // Hard stop wall at -Y end (prevents over-insertion)
        // Closes the channel at the -Y side
        stop_y_pos = (side == 1)
            ? y_inner_wall - rail_channel_width - rail_wall_thickness
            : y_inner_wall;
        translate([rail_x_start,
                   stop_y_pos,
                   -bottom_shell_height])
            cube([rail_wall_thickness,
                  rail_channel_width + rail_wall_thickness,
                  bottom_shell_height]);
    }
}

// ---- Detent bumps ----
// Small raised dimples on the floor of each U-channel.
// The bottom shell tray rides over these bumps and clicks into place
// when fully seated (detent_position = 3mm from -Y hard stop).
module detent_bumps() {
    rail_x_start = -pod_length/2 + wall_thickness;

    // Detent is placed detent_position mm from the -Y hard stop (closed end)
    bump_x = rail_x_start + detent_position;

    for (side = [-1, 1]) {
        y_inner_wall = side * (pod_width/2 - wall_thickness);

        // Channel floor Y centerline (midpoint of the channel slot)
        bump_y = y_inner_wall + side * (-(rail_channel_width/2));

        // Bump sits on the channel floor at Z = -bottom_shell_height
        translate([bump_x, bump_y, -bottom_shell_height])
            cylinder(d=detent_bump_diameter, h=detent_bump_height);
    }
}

// ---- Render ----
top_shell();
