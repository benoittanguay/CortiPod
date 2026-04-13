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
        detent_recesses();
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
// Centered in X and vertically centered within the tray height.
module usbc_port_slot() {
    translate([-usbc_port_width/2,
               tray_length/2 - usbc_port_depth,
               (tray_height - usbc_port_height) / 2])
        cube([usbc_port_width, usbc_port_depth + 0.1, usbc_port_height]);
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

// ---- Detent recesses ----
// Identical to bottom_shell's detent_recesses so the same top shell rails
// click-lock the cradle in the fully seated position.
module detent_recesses() {
    recess_d     = detent_bump_diameter + 0.2;
    recess_depth = detent_bump_height + 0.1;

    for (y_sign = [-1, 1]) {
        y_inner = y_sign * (tray_length/2 - tray_lip_thickness);
        translate([0,
                   y_inner,
                   tray_height + tray_lip_height/2])
            rotate([y_sign * 90, 0, 0])
                cylinder(d=recess_d, h=recess_depth + 0.1);
    }
}

// ---- Trace channel ----
// Internal pocket (0.8mm tall) for the cradle PCB, sitting just above the
// cradle floor. 2mm wall margin on all sides keeps the body structurally sound.
module trace_channel() {
    wall_margin = 2.0;
    ch_width  = tray_width  - wall_margin * 2;
    ch_length = tray_length - wall_margin * 2;
    ch_height = electrode_board_thickness;   // 0.8mm — matches PCB thickness

    translate([-ch_width/2, -ch_length/2, wall_margin])
        cube([ch_width, ch_length, ch_height + 0.1]);
}

// ---- Render ----
charging_cradle();
