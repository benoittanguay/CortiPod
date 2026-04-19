// =============================================================================
// top_shell.scad — CortiPod unified shell
//
// Single-piece enclosure housing everything. The stepped electrode PCB slides
// directly into channels on the underside — no separate tray needed.
//
// Key zones (bottom to top):
//   Z = 0 to 1.2     Guard ring around skin window (outer wall only)
//   Z = 1.2 to 2.2   Electrode channels (±Y walls capture PCB ledges)
//   Z = 2.2 to 3.2   Mating wall (pogo pin bores pass through)
//   Z = 3.2 to 7.5   Internal cavity (PCB, battery, standoffs)
//   Z = 7.5 to 9.0   Top wall (sealed outer surface)
//
// Slide-on design:
//   - Electrode channels on ±Y inner walls capture PCB thin ledges
//   - Hard stop wall at -X end of each channel
//   - Open at +X for electrode insertion
//   - Detent bumps on channel floor click when PCB is fully seated
//   - Strap lugs at ±X ends (18mm quick-release)
//   - Skin window in bottom face exposes sensing area
//
// Assembly: slide electrode PCB in from the +X end.
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
        }

        // Hollow out the internal cavity (PCB + battery zone)
        internal_cavity();

        // Electrode compartment (below mating wall, for thick PCB center)
        electrode_compartment();

        // Channel slots (±Y grooves for thin PCB ledges)
        channel_slots();

        // Skin window through the bottom face
        skin_window();

        // Pogo pin bores through the mating wall
        pogo_pin_bores();

        // Insertion opening at +X end
        insertion_opening();
    }

    // PCB standoffs inside the cavity
    intersection() {
        shell_body();
        pcb_standoffs();
    }

    // Detent bumps on channel floor
    detent_bumps();
}

// ---- Shell body ----
// Full-height rounded-rect block: the entire pod outer profile.
module shell_body() {
    hull() {
        for (x = [-pod_length/2 + pod_corner_radius, pod_length/2 - pod_corner_radius])
            for (y = [-pod_width/2 + pod_corner_radius, pod_width/2 - pod_corner_radius])
                translate([x, y, 0])
                    cylinder(r=pod_corner_radius, h=shell_height);
    }
}

// ---- Internal cavity ----
// Hollowed space above the mating wall for main PCB and battery.
// Extends from cavity_bottom_z to inner_ceiling_z.
module internal_cavity() {
    inset = wall_thickness;
    inner_r = max(pod_corner_radius - inset + printer_tolerance, 0.5);

    translate([0, 0, cavity_bottom_z])
        hull() {
            for (x = [-pod_length/2 + pod_corner_radius + inset,
                       pod_length/2 - pod_corner_radius - inset])
                for (y = [-pod_width/2 + pod_corner_radius + inset,
                           pod_width/2 - pod_corner_radius - inset])
                    translate([x, y, 0])
                        cylinder(r=inner_r, h=inner_ceiling_z - cavity_bottom_z);
        }
}

// ---- Electrode compartment ----
// Open space below the mating wall where the thick electrode center sits.
// Spans from pod bottom (Z = 0) up to the mating wall bottom (Z = 2.2).
// The ±Y sides are bounded by the channel walls; ±X by the shell walls.
module electrode_compartment() {
    // Full width/length compartment between the channel walls
    comp_x = electrode_pcb_x + electrode_clearance * 2;  // PCB + clearance
    comp_y = electrode_sensing_y + electrode_clearance * 2;  // sensing zone + clearance
    comp_z = mating_wall_bottom_z;  // from Z=0 to mating wall bottom

    translate([-comp_x/2, -comp_y/2, -0.1])
        cube([comp_x, comp_y, comp_z + 0.1]);
}

// ---- Channel slots ----
// Horizontal grooves carved into the solid shell body on ±Y inner walls.
// The electrode PCB's thin ledges slide into these slots from +X.
//
// Each slot:
//   - Floor at Z = channel_floor_z (1.2mm, supports the step)
//   - Ceiling at Z = channel_ceiling_z (2.2mm, overhang captures ledge)
//   - Extends from the electrode compartment edge outward to the shell wall
//   - Runs the full X length (open at +X for insertion, closed at -X hard stop)
//
// The solid shell body below the slot (Z = 0 to channel_floor_z) forms the
// channel floor. The solid body above (Z = channel_ceiling_z to mating_wall_top_z)
// forms the ceiling/overhang.
module channel_slots() {
    // Y boundaries of the electrode compartment (sensing zone)
    comp_y_half = electrode_sensing_y/2 + electrode_clearance;

    for (side = [-1, 1]) {
        // Slot starts slightly inside the compartment (0.1mm overlap avoids
        // coincident faces that cause non-manifold warnings)
        y_inner_wall = side * (pod_width/2 - wall_thickness);

        slot_y_start = (side > 0) ? (comp_y_half - 0.1) : (y_inner_wall - 0.1);
        slot_y_end   = (side > 0) ? (y_inner_wall + 0.1) : (-comp_y_half + 0.1);
        slot_y_width = slot_y_end - slot_y_start;

        // Slot runs full channel length (+0.2 overlap at both ends)
        translate([channel_x_start - 0.1, slot_y_start, channel_floor_z])
            cube([channel_x_length + 0.3, slot_y_width, channel_slot_height]);
    }
}

// ---- Skin window ----
// Rectangular opening through the bottom face, exposing the sensing area.
module skin_window() {
    translate([-skin_window_width/2, -skin_window_length/2, -0.1])
        cube([skin_window_width, skin_window_length, channel_floor_z + 0.2]);
}

// ---- Pogo pin bores ----
// Through-holes in the mating wall for spring-loaded contacts.
// Bores extend through the full mating wall and protrude slightly below
// for the pogo pin tips to reach the electrode back contacts.
module pogo_pin_bores() {
    contacts = [
        [contact_we_mip_x, contact_we_mip_y],
        [contact_we_nip_x, contact_we_nip_y],
        [contact_ce_x,     contact_ce_y],
        [contact_re_x,     contact_re_y],
    ];

    for (pos = contacts) {
        // Bore through mating wall + protrusion below for pin tip
        translate([pos[0], pos[1], mating_wall_bottom_z - pogo_protrusion_below - 0.1])
            cylinder(d=spring_contact_hole,
                     h=mating_wall_thickness + pogo_protrusion_below + 0.2);
    }
}

// ---- Insertion opening ----
// The +X end of the electrode compartment is open to allow the PCB to
// slide in. This cuts through the shell wall at +X, from Z = 0 up to
// the mating wall bottom. The channel slots are also open at +X.
module insertion_opening() {
    // Main insertion slot: full electrode compartment height at +X wall
    open_x = pod_length/2 - wall_thickness;
    open_y = electrode_pcb_y + electrode_clearance * 2;

    translate([open_x - 0.1, -open_y/2, -0.1])
        cube([wall_thickness + 0.2, open_y, mating_wall_bottom_z + 0.1]);

    // Channel slots at +X end also need to be open
    for (side = [-1, 1]) {
        y_inner = side * (pod_width/2 - wall_thickness);
        slot_y_start = (side > 0) ? y_inner - channel_overhang : y_inner;
        slot_y_width = channel_overhang;

        translate([open_x - 0.1, slot_y_start, channel_floor_z])
            cube([wall_thickness + 0.2, slot_y_width, channel_slot_height]);
    }
}

// ---- PCB standoffs ----
// Asymmetric placement so PCB can only be installed one way (poka-yoke).
// Standoffs sit on the cavity floor (top of mating wall).
module pcb_standoffs() {
    standoff_od = 3.0;

    round_positions = [
        [-pcb_length/2 + 3, -pcb_width/2 + 3],
        [-pcb_length/2 + 3,  pcb_width/2 - 3],
        [ pcb_length/2 - 3, -pcb_width/2 + 3],
    ];

    for (pos = round_positions) {
        translate([pos[0], pos[1], cavity_bottom_z])
            cylinder(d=standoff_od, h=standoff_height);
    }

    // One slotted standoff (+X, +Y) for thermal expansion
    translate([pcb_length/2 - 3, pcb_width/2 - 3, cavity_bottom_z])
        hull() {
            cylinder(d=standoff_od, h=standoff_height);
            translate([1.0, 0, 0])
                cylinder(d=standoff_od, h=standoff_height);
        }
}

// ---- Strap lugs ----
// Protrusions at ±X ends with holes for an 18mm quick-release strap.
module strap_lugs() {
    for (end = [-1, 1]) {
        x_base = end * pod_length/2;
        x_outer = x_base + end * lug_extension;

        // Lug body — positioned at mid-height of the shell for strength
        translate([min(x_base, x_outer), -strap_width/2, 0])
            cube([lug_extension, strap_width, lug_height]);

        // Strap pin holes through each side of the lug
        lug_center_x = x_base + end * lug_extension / 2;
        for (side_y = [-1, 1]) {
            translate([lug_center_x,
                       side_y * strap_width/2,
                       lug_height/2])
                rotate([0, 90, 0])
                    cylinder(d=lug_hole_diameter,
                             h=lug_extension + 0.2,
                             center=true);
        }
    }
}

// ---- Detent bumps ----
// Small raised dimples on the floor of each channel.
// The electrode PCB rides over these bumps and clicks into place
// when fully seated (detent_position mm from -X hard stop).
module detent_bumps() {
    // Bump X position: detent_position from the -X hard stop
    bump_x = channel_x_start + detent_position;

    for (side = [-1, 1]) {
        y_inner = side * (pod_width/2 - wall_thickness);

        // Y center of the channel slot (midpoint of the overhang region)
        bump_y = y_inner - side * (channel_overhang / 2);

        // Bump sits on the channel floor
        translate([bump_x, bump_y, channel_floor_z])
            cylinder(d=detent_bump_diameter, h=detent_bump_height);
    }
}

// ---- Render ----
top_shell();
