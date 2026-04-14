// =============================================================================
// charging_cradle.scad — CortiPod charging dock
//
// Same outer profile as the electrode tray (bottom shell). Slides into the
// same U-channel rails on the top shell underside. Instead of an electrode
// pocket, carries 4 gold-plated contact pads aligned with the pogo pin
// positions and a USB-C port on the exposed +Y face.
//
// Power path:
//   USB-C → cradle PCB → contact pads → pogo pins → main PCB → LiPo charger
//
// Pin assignment (cradle top face → pogo pin):
//   WE_MIP + WE_NIP → V+ (charge current)
//   CE + RE          → GND
//
// The internal trace_channel pocket seats the cradle PCB (0.8mm FR4).
// Wall margin is 2mm on all sides so the cradle body remains rigid.
//
// Print: contact-pad side UP for best surface finish on mating faces.
// =============================================================================

include <parameters.scad>

$fn = $preview ? 32 : 96;

// ---- Main module ----
module charging_cradle() {
    difference() {
        union() {
            cradle_body();
            cradle_lips();
        }
        usbc_port_slot();
        contact_pad_recesses();
        cradle_detent_recesses();
        trace_channel();
    }
}

// ---- Cradle body ----
// Identical to bottom_shell's tray_body: rounded-rect block at the tray
// footprint. Corner radius capped at 2.0mm to stay within the tray walls.
module cradle_body() {
    r = min(pod_corner_radius, 2.0);
    hull() {
        for (x = [-tray_width/2 + r, tray_width/2 - r])
            for (y = [-tray_length/2 + r, tray_length/2 - r])
                translate([x, y, 0])
                    cylinder(r=r, h=tray_height);
    }
}

// ---- Cradle lips ----
// Identical to bottom_shell's tray_lips. Thin protrusions on the ±Y edges
// that slide into the top shell U-channel rails.
module cradle_lips() {
    for (y_sign = [-1, 1]) {
        y_pos = y_sign * (tray_length/2 - tray_lip_thickness/2);
        translate([0, y_pos, tray_height])
            cube([tray_width, tray_lip_thickness, tray_lip_height], center=true);
    }
}

// ---- USB-C port slot ----
// Rectangular cutout on the +Y face to accept a USB-C receptacle body.
// Centered in X, bottom-aligned at Z = 0 (covered by top shell when assembled).
// Height is clipped to tray_height so the slot never exits the top surface.
module usbc_port_slot() {
    translate([-usbc_port_width/2,
               tray_length/2 - usbc_port_depth,
               0])
        cube([usbc_port_width, usbc_port_depth + 0.1, min(usbc_port_height, tray_height)]);
}

// ---- Contact pad recesses ----
// 4 shallow circular recesses (0.4mm deep) on the top face of the cradle,
// at the same XY positions as the pogo pin back contacts on the electrode.
// Diameter is cradle_pad_diameter + 0.5mm for generous contact area.
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
        translate([p[0], p[1], tray_height - recess_h])
            cylinder(d=pad_d, h=recess_h + 0.1);
    }
}

// ---- Cradle detent recesses ----
// Upward-facing dimples on the bottom face of each lip (Z-axis, matching the
// bump axis on the top shell channel floor). Geometry identical to
// tray_detent_recesses in bottom_shell.scad so the same top shell rails
// click-lock the cradle in the fully seated position.
module cradle_detent_recesses() {
    recess_d     = detent_bump_diameter + 0.2;
    recess_depth = detent_bump_height + 0.1;

    // X position: same as bump_x in top_shell.scad
    recess_x = -pod_length/2 + wall_thickness + detent_position;

    for (y_sign = [-1, 1]) {
        // Y center of the lip
        lip_y = y_sign * (tray_length/2 - tray_lip_thickness/2);

        // Drill downward from the bottom face of the lip (Z = tray_height)
        translate([recess_x, lip_y, tray_height - recess_depth])
            cylinder(d=recess_d, h=recess_depth + 0.1);
    }
}

// ---- Trace channel ----
// Internal pocket (0.8mm tall) for the cradle PCB, sitting 0.5mm above the
// cradle floor. This ensures the pocket starts at Z = 0.5 and ends at
// Z = 1.3, leaving 1.2mm of material above for contact pad backing.
// 2mm wall margin on all sides keeps the body structurally sound.
module trace_channel() {
    wall_margin = 2.0;
    ch_width  = tray_width  - wall_margin * 2;
    ch_length = tray_length - wall_margin * 2;
    ch_height = electrode_board_thickness;   // 0.8mm — matches PCB thickness

    translate([-ch_width/2, -ch_length/2, 0.5])
        cube([ch_width, ch_length, ch_height + 0.1]);
}

// ---- Render ----
charging_cradle();
