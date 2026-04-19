// =============================================================================
// charging_cradle.scad — CortiPod charging dock
//
// Slides into the same shell channels as the electrode PCB. Instead of
// a stepped sensing area, carries 4 gold-plated contact pads on top and
// a USB-C port on the exposed +X face.
//
// Power path:
//   USB-C → cradle PCB → contact pads → pogo pins → main PCB → LiPo charger
//
// Pin assignment (cradle top face → pogo pin):
//   WE_MIP + WE_NIP → V+ (charge current)
//   CE + RE          → GND
//
// The cradle body fills the electrode compartment zone. Its ±Y edges
// form thin lips that engage the shell's electrode channels (same
// interface as the electrode PCB ledges).
//
// Print: contact-pad side UP for best surface finish on mating faces.
// =============================================================================

include <parameters.scad>

$fn = $preview ? 32 : 96;

// ---- Cradle dimensions ----
// Body fills the electrode compartment. Lips on ±Y engage channels.
cradle_body_x = electrode_pcb_x - electrode_clearance;     // ~21.8mm
cradle_body_y = electrode_sensing_y - electrode_clearance;  // ~17.8mm (inner, between lips)
cradle_lip_y  = electrode_ledge_y;      // matches electrode ledge width
cradle_body_z = mating_wall_bottom_z;   // fills up to channel ceiling (2.2mm)

// ---- Main module ----
module charging_cradle() {
    difference() {
        union() {
            cradle_body();
            cradle_lips();
        }
        usbc_port_slot();
        contact_pad_recesses();
        cradle_detent_notches();
        trace_channel();
    }
}

// ---- Cradle body ----
// Solid block spanning the electrode compartment. Rounded corners.
module cradle_body() {
    r = min(pod_corner_radius, 2.0);
    hull() {
        for (x = [-cradle_body_x/2 + r, cradle_body_x/2 - r])
            for (y = [-cradle_body_y/2 + r, cradle_body_y/2 - r])
                translate([x, y, 0])
                    cylinder(r=r, h=cradle_body_z);
    }
}

// ---- Cradle lips ----
// Thin extensions on the ±Y edges that slide into the shell channels.
// Same profile as the electrode PCB ledges: sits on the channel floor,
// captured by the channel ceiling overhang.
module cradle_lips() {
    for (side = [-1, 1]) {
        y_start = side * cradle_body_y/2;
        y_pos = (side > 0) ? y_start : y_start - cradle_lip_y;

        // Lips span from channel floor to channel ceiling
        translate([-cradle_body_x/2, y_pos, channel_floor_z])
            cube([cradle_body_x, cradle_lip_y, channel_slot_height - 0.2]);
    }
}

// ---- USB-C port slot ----
// Rectangular cutout on the +X face (exposed end when inserted) for
// a USB-C receptacle body. Centered in Y, bottom-aligned near Z = 0.
module usbc_port_slot() {
    translate([cradle_body_x/2 - usbc_port_depth,
               -usbc_port_width/2,
               0])
        cube([usbc_port_depth + 0.1, usbc_port_width,
              min(usbc_port_height, cradle_body_z)]);
}

// ---- Contact pad recesses ----
// 4 shallow circular recesses on the top face of the cradle,
// at the same XY positions as the pogo pin back contacts.
module contact_pad_recesses() {
    pad_d    = cradle_pad_diameter + 0.5;
    recess_h = 0.4;

    positions = [
        [contact_we_mip_x, contact_we_mip_y],
        [contact_we_nip_x, contact_we_nip_y],
        [contact_ce_x,     contact_ce_y    ],
        [contact_re_x,     contact_re_y    ]
    ];

    for (p = positions) {
        translate([p[0], p[1], cradle_body_z - recess_h])
            cylinder(d=pad_d, h=recess_h + 0.1);
    }
}

// ---- Cradle detent notches ----
// Match the channel detent bumps, same geometry as electrode PCB notches.
module cradle_detent_notches() {
    notch_d     = detent_bump_diameter + 0.2;
    notch_depth = detent_bump_height + 0.1;

    notch_x = detent_position - cradle_body_x/2;

    for (side = [-1, 1]) {
        lip_y_center = side * (cradle_body_y/2 + cradle_lip_y/2);

        translate([notch_x, lip_y_center, channel_floor_z - notch_depth])
            cylinder(d=notch_d, h=notch_depth + 0.1);
    }
}

// ---- Trace channel ----
// Internal pocket for the cradle PCB. Sits above the bottom floor,
// leaving material above for contact pad backing and below for rigidity.
module trace_channel() {
    wall_margin = 2.0;
    ch_x      = cradle_body_x - wall_margin * 2;
    ch_y      = cradle_body_y - wall_margin * 2;
    ch_height = 0.8;   // mm — matches PCB thickness

    translate([-ch_x/2, -ch_y/2, 0.5])
        cube([ch_x, ch_y, ch_height + 0.1]);
}

// ---- Render ----
charging_cradle();
