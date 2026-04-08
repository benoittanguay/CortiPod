// =============================================================================
// bottom_shell.scad — CortiPod electrode frame (skin-contact side)
//
// WALL-MOUNTED LEDGE DESIGN: Electrodes slide on their ceramic edges along
// ledges protruding from the channel walls. The sensing face never touches
// any surface — it hangs free between the ledges, exposed to the skin window.
//
// Two zones per channel:
//
//   SENSING ZONE (-X end, ~29mm):
//     Ledges support electrode edges. Open top. Full skin window below.
//     Electrode face hangs free — no scratching, no thin floor.
//
//   CONNECTOR TAIL ZONE (+X end, ~6mm):
//     Same ledges + retaining ceiling above = sandwiched slot.
//     Spring contacts protrude up through floor between ledges.
//     Electrode held flat: springs push up, ceiling holds down.
//
// Cross-section in SENSING ZONE (looking from +X):
//
//     ┌──wall──┐                           ┌──wall──┐
//     │        ├─ledge   ┌electrode┐ ledge─┤        │
//     │        │         │face▼▼▼▼▼│       │        │
//     │        └─────────┘         └───────┘        │
//     │            ══════ skin window ══════         │
//     └─────────────────────────────────────────────┘
//
// Cross-section in CONNECTOR TAIL ZONE:
//
//     ┌──wall──────── ceiling ─────────wall──┐
//     │        ├─ledge ┌electrode┐ ledge─┤   │
//     │        │    ●●●│pads▼▼▼▼▼│●●●    │   │
//     │        └───────┘ springs └───────┘   │
//     └──────────────────────────────────────┘
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
// Y centers of each electrode channel
mip_y_center = -(electrode_gap/2 + electrode_width/2);
nip_y_center =  (electrode_gap/2 + electrode_width/2);

// Channel X extent
channel_x_start = -pod_length/2 + wall_thickness;  // -X stop wall
channel_x_end   =  pod_length/2;                    // +X open end

// Sensing zone X extent
sensing_x_start = channel_x_start;
sensing_x_end   = contact_zone_x_start;

// ---- Main module ----
module bottom_shell() {
    difference() {
        union() {
            // Perimeter walls (full height)
            perimeter_walls();

            // Center divider between MIP and NIP channels
            center_divider();

            // Wall-mounted ledges (electrode support rails)
            electrode_ledges();

            // Retaining ceiling in the connector tail zone
            retaining_ceilings();

            // Solid floor in the connector tail zone (for spring contacts)
            contact_zone_floor();

            // Strap lugs
            strap_lugs();
        }

        // Insertion openings with chamfered funnel at +X end
        insertion_openings();

        // Skin windows — full-depth openings between the ledges
        sensor_windows();

        // Spring contact mounting holes through the contact zone floor
        spring_contact_holes();

        // Flex cable pass-through at parting line
        flex_cable_passthrough();

        // Ventilation grooves on the outer skin-facing surface
        ventilation_grooves();

        // Alignment pin holes
        alignment_pin_holes();

        // Snap clip receiver slots
        clip_receiver_slots();

        // GSR pad through-holes
        gsr_pad_holes();
    }
}

// ---- Perimeter walls ----
// Full-height walls forming the outer boundary. No thin base plate —
// the floor is only present in the connector tail zone.
module perimeter_walls() {
    inner_r = max(pod_corner_radius - wall_thickness, 0.5);

    difference() {
        rounded_rect(pod_length, pod_width, bottom_shell_height, pod_corner_radius);

        translate([0, 0, -0.1])
            rounded_rect(pod_length - wall_thickness * 2,
                         pod_width  - wall_thickness * 2,
                         bottom_shell_height + 0.2,
                         inner_r);
    }
}

// ---- Center divider ----
module center_divider() {
    inner_length = pod_length - wall_thickness * 2;

    translate([-inner_length/2, -electrode_gap/2, 0])
        cube([inner_length, electrode_gap, bottom_shell_height]);
}

// ---- Electrode ledges ----
// Narrow shelves protruding inward from the channel walls at ledge_height.
// The electrode's ceramic edges rest on these. The sensing face hangs
// between them without touching anything.
//
// Each channel has 4 ledges: 2 from the outer wall, 2 from the center divider.
// Ledges run the full channel length (both sensing and contact zones).
module electrode_ledges() {
    ledge_x_start = channel_x_start;
    ledge_x_length = channel_x_end - channel_x_start;

    for (yc = [mip_y_center, nip_y_center]) {
        // Outer wall ledge (away from center divider)
        outer_wall_y = (yc < 0)
            ? -pod_width/2 + wall_thickness         // MIP: inner face of -Y wall
            :  pod_width/2 - wall_thickness - ledge_width;  // NIP: inner face of +Y wall

        translate([ledge_x_start, outer_wall_y, 0])
            cube([ledge_x_length, ledge_width, ledge_height]);

        // Center divider ledge (toward center)
        divider_y = (yc < 0)
            ? -electrode_gap/2 - ledge_width  // MIP: inner face of divider (-Y side)
            :  electrode_gap/2;                // NIP: inner face of divider (+Y side)

        translate([ledge_x_start, divider_y, 0])
            cube([ledge_x_length, ledge_width, ledge_height]);
    }
}

// ---- Retaining ceilings ----
// In the connector tail zone only: a ceiling that constrains the electrode
// from lifting when spring contacts push up. Forms a sandwiched slot.
// Ceiling spans from outer wall to center divider at retaining_ceiling_z.
module retaining_ceilings() {
    ceil_x_start = contact_zone_x_start;
    ceil_x_length = contact_zone_length;

    for (yc = [mip_y_center, nip_y_center]) {
        ch_inner_y = (yc < 0)
            ? -(electrode_gap/2 + channel_width)   // MIP channel -Y edge
            :   electrode_gap/2;                    // NIP channel +Y edge

        translate([ceil_x_start, ch_inner_y, retaining_ceiling_z])
            cube([ceil_x_length, channel_width, bottom_shell_height - retaining_ceiling_z]);
    }
}

// ---- Contact zone floor ----
// Solid floor only in the connector tail zone (last ~6mm of each channel).
// Spring contacts mount through this floor. The floor extends from Z=0
// up to ledge_height so it's flush with the ledge surface.
module contact_zone_floor() {
    floor_x_start = contact_zone_x_start;
    floor_x_length = contact_zone_length;

    for (yc = [mip_y_center, nip_y_center]) {
        ch_inner_y = (yc < 0)
            ? -(electrode_gap/2 + channel_width)
            :   electrode_gap/2;

        translate([floor_x_start, ch_inner_y, 0])
            cube([floor_x_length, channel_width, ledge_height]);
    }
}

// ---- Insertion openings ----
// Cut through the +X perimeter wall with chamfered funnel.
// The slot height matches the retaining ceiling slot height in the
// connector tail zone.
module insertion_openings() {
    for (yc = [mip_y_center, nip_y_center]) {
        // Main slot through +X wall (from floor to ceiling height)
        translate([pod_length/2 - wall_thickness - 0.1,
                   yc - channel_width/2,
                   0])
            cube([wall_thickness + 0.2,
                  channel_width,
                  retaining_ceiling_z + 0.1]);

        // Chamfered funnel at entry
        chamfer_exp = insertion_chamfer_depth * tan(insertion_chamfer_angle);
        translate([pod_length/2 - wall_thickness - insertion_chamfer_depth,
                   yc - channel_width/2 - chamfer_exp,
                   -0.1])
            hull() {
                translate([0, chamfer_exp, 0])
                    cube([0.1, channel_width, retaining_ceiling_z + 0.1]);
                translate([insertion_chamfer_depth + wall_thickness, 0, 0])
                    cube([0.1, channel_width + chamfer_exp * 2, retaining_ceiling_z + 0.1]);
            }
    }
}

// ---- Sensor windows ----
// Full-depth openings through the floor between the ledges.
// These are in the sensing zone only — the contact zone has solid floor.
// The window width is the space between the two ledges (nearly full electrode width).
module sensor_windows() {
    win_x_start = sensing_x_start + 0.5;  // small margin from stop wall
    win_x_length = sensor_window_length;

    for (yc = [mip_y_center, nip_y_center]) {
        translate([win_x_start, yc - sensor_window_width/2, -0.1])
            cube([win_x_length, sensor_window_width, bottom_shell_height + 0.2]);
    }
}

// ---- Spring contact holes ----
// Through-holes in the contact zone floor for pogo pins.
// Pins protrude up through the floor to contact electrode pads.
module spring_contact_holes() {
    pin_span = (spring_contacts_per_elec - 1) * electrode_pad_pitch;
    first_y = -pin_span / 2;

    for (yc = [mip_y_center, nip_y_center]) {
        for (i = [0 : spring_contacts_per_elec - 1]) {
            pin_y = yc + first_y + i * electrode_pad_pitch;

            translate([contact_x_center, pin_y, -0.1])
                cylinder(d=spring_contact_hole, h=ledge_height + 0.5);
        }
    }
}

// ---- Flex cable pass-through ----
module flex_cable_passthrough() {
    // MIP side (-Y wall)
    translate([flex_passthrough_x - flex_passthrough_width/2,
               -pod_width/2 - 0.1,
               bottom_shell_height - flex_passthrough_height])
        cube([flex_passthrough_width, wall_thickness + 0.2, flex_passthrough_height + 0.1]);

    // NIP side (+Y wall)
    translate([flex_passthrough_x - flex_passthrough_width/2,
               pod_width/2 - wall_thickness - 0.1,
               bottom_shell_height - flex_passthrough_height])
        cube([flex_passthrough_width, wall_thickness + 0.2, flex_passthrough_height + 0.1]);
}

// ---- Ventilation grooves ----
// On the outer skin-facing surfaces of the perimeter walls.
module ventilation_grooves() {
    groove_positions_y = [
        0,
        -(electrode_gap/2 + electrode_width + wall_thickness/2),
         (electrode_gap/2 + electrode_width + wall_thickness/2),
    ];

    groove_length = sensor_window_length;
    groove_x_start = sensing_x_start + 0.5;

    for (gy = groove_positions_y) {
        translate([groove_x_start, gy - vent_groove_width/2, -0.1])
            cube([groove_length, vent_groove_width, vent_groove_depth + 0.1]);
    }
}

// ---- Alignment pin holes ----
module alignment_pin_holes() {
    hole_d = alignment_pin_diameter + alignment_hole_clearance * 2;

    translate([align_pin1_x, align_pin1_y, bottom_shell_height - alignment_pin_height])
        cylinder(d=hole_d, h=alignment_pin_height + 0.1);

    translate([align_pin2_x, align_pin2_y, bottom_shell_height - alignment_pin_height])
        hull() {
            cylinder(d=hole_d, h=alignment_pin_height + 0.1);
            translate([0.5, 0, 0])
                cylinder(d=hole_d, h=alignment_pin_height + 0.1);
        }
}

// ---- Clip receiver slots ----
module clip_receiver_slots() {
    slot_width = clip_width + 0.4;

    clip_x_positions = [
        -pod_length/2 + pod_corner_radius + 4,
         pod_length/2 - pod_corner_radius - 4 - clip_width,
    ];

    for (cx = clip_x_positions) {
        translate([cx - 0.2, -pod_width/2 - 0.1, -0.1])
            cube([slot_width, wall_thickness + 0.2, bottom_shell_height + 0.2]);

        translate([cx - 0.2, pod_width/2 - wall_thickness - 0.1, -0.1])
            cube([slot_width, wall_thickness + 0.2, bottom_shell_height + 0.2]);
    }
}

// ---- GSR pad holes ----
module gsr_pad_holes() {
    for (x = [-gsr_pad_spacing/2, gsr_pad_spacing/2]) {
        translate([x, -pod_width/2 + gsr_pad_offset_y + pod_corner_radius, -0.1])
            cylinder(d=gsr_pad_diameter, h=bottom_shell_height + 0.2);
    }
}

// ---- Strap lugs ----
module strap_lugs() {
    for (end = [-1, 1]) {
        x_pos = end * (pod_length/2 + lug_extension/2);

        translate([x_pos - lug_extension/2, -strap_width/2, 0])
            cube([lug_extension, strap_width, lug_height]);

        for (side = [-1, 1]) {
            translate([x_pos, side * (strap_width/2), lug_height/2])
                rotate([0, 90, 0])
                    cylinder(d=lug_hole_diameter, h=lug_extension + 0.2, center=true);
        }
    }
}

// ---- Render ----
bottom_shell();
