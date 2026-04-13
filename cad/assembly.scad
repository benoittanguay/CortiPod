// =============================================================================
// assembly.scad — CortiPod full assembly
//
// Single-slot design for 22x22mm dual electrode PCB (MIP + NIP on one board).
// Pogo pins mounted on main PCB (top shell), pressing down onto electrode
// back contacts through pass-through holes in the parting line.
//
// view_mode: "assembled", "exploded", "layout", "cross"
// =============================================================================

include <parameters.scad>
use <bottom_shell.scad>
use <top_shell.scad>

// =============================================================================
// *** CHANGE THIS ***
// =============================================================================
view_mode = "exploded";

show_top       = true;
show_bottom    = true;
show_electrode = true;
show_pcb       = true;
show_battery   = true;
show_contacts  = true;
show_skin      = true;
show_labels    = true;
show_align     = true;

explode_gap    = 14;
layout_gap     = 12;

$fn = $preview ? 32 : 96;

// ---- Electrode position (assembled) ----
// Board center sits at pod center (0, 0).
// Board rests on ledges at Z = ledge_height.
elec_z = ledge_height;

// =============================================================================
if (view_mode == "assembled") assembled_view();
else if (view_mode == "exploded") exploded_view();
else if (view_mode == "layout") layout_view();
else if (view_mode == "cross") {
    difference() {
        assembled_view();
        // Cut along Y=0 plane to show electrode cross-section
        translate([-100, 0, -50]) cube([200, 200, 200]);
    }
}

// =============================================================================
// ASSEMBLED
// =============================================================================
module assembled_view() {
    if (show_bottom)
        color("DimGray", 0.9)
            bottom_shell();

    if (show_electrode)
        _electrode_assembled();

    if (show_contacts)
        _pogo_pins_assembled();

    if (show_top)
        color("DarkSlateGray", 0.9)
            translate([0, 0, bottom_shell_height])
                top_shell();

    if (show_pcb)
        color("Green", 0.5)
            translate([-pcb_length/2, -pcb_width/2,
                       bottom_shell_height + wall_thickness + 1.0])
                cube([pcb_length, pcb_width, pcb_thickness]);

    if (show_battery)
        color("DodgerBlue", 0.5)
            translate([-battery_length/2, -battery_width/2,
                       bottom_shell_height + wall_thickness + 1.0 + pcb_thickness + 0.5])
                cube([battery_length, battery_width, battery_thickness]);

    if (show_skin)
        color("PeachPuff", 0.15)
            translate([-25, -20, -0.5])
                cube([50, 40, 0.3]);
}

// =============================================================================
// EXPLODED
// =============================================================================
module exploded_view() {
    g = explode_gap;

    // Skin
    if (show_skin) {
        color("PeachPuff", 0.15)
            translate([-25, -20, -g])
                cube([50, 40, 0.3]);
        if (show_labels) _label("Skin (wrist)", 0, -22, -g);
    }

    // Layer 1: Bottom shell
    if (show_bottom) {
        color("DimGray", 0.9)
            bottom_shell();
        if (show_labels) _label("Bottom Shell (single slot, skin window, GSR pads)", 0, -pod_width/2 - 4, 0);
    }

    // Layer 2: Dual electrode board (offset in +X to show insertion direction)
    if (show_electrode) {
        color("Gold", 0.8)
            translate([4, -electrode_board_width/2, g * 1.3])
                cube([electrode_board_total_y, electrode_board_width, electrode_board_thickness]);

        // WE_MIP indicator circle
        color("DarkRed", 0.6)
            translate([4 + electrode_board_total_y/2 + we_mip_offset_x,
                       0,
                       g * 1.3 + electrode_board_thickness])
                cylinder(d=we_diameter, h=0.1);

        // WE_NIP indicator circle
        color("DarkOrange", 0.6)
            translate([4 + electrode_board_total_y/2 + we_nip_offset_x,
                       0,
                       g * 1.3 + electrode_board_thickness])
                cylinder(d=we_diameter, h=0.1);

        if (show_labels) {
            _label("Dual Electrode PCB (MIP + NIP, 22x22mm)", 10, -electrode_board_width/2 - 4, g * 1.3);
            _label("8mm WE_MIP", 4 + electrode_board_total_y/2 + we_mip_offset_x, 6, g * 1.3);
            _label("8mm WE_NIP", 4 + electrode_board_total_y/2 + we_nip_offset_x, 6, g * 1.3);
        }

        // Insertion direction arrow
        color("Red", 0.6)
            translate([pod_length/2 + 6, 0, g * 1.3 + electrode_board_thickness/2])
                rotate([0, 90, 0]) _arrow_left();
    }

    // Layer 3: Alignment pins
    if (show_align) {
        _alignment_pins_exploded(g * 2.3);
        if (show_labels)
            _label("Alignment Pins (asymmetric)", -6, -8, g * 2.3);
    }

    // Layer 4: Pogo pins (mounted on main PCB underside)
    if (show_contacts) {
        _pogo_pins_exploded(g * 3.0);
        if (show_labels)
            _label("Pogo Pins x4 (on PCB, press down onto electrode)", 0, -8, g * 3.0);
    }

    // Layer 5: Main PCB
    if (show_pcb) {
        color("Green", 0.6)
            translate([-pcb_length/2, -pcb_width/2, g * 3.5])
                cube([pcb_length, pcb_width, pcb_thickness]);
        if (show_labels) _label("PCB (nRF52832 + AD5941, 24x24mm)", 0, -pcb_width/2 - 4, g * 3.5);
    }

    // Layer 6: Battery
    if (show_battery) {
        color("DodgerBlue", 0.6)
            translate([-battery_length/2, -battery_width/2, g * 4.2])
                cube([battery_length, battery_width, battery_thickness]);
        if (show_labels) _label("Battery 60mAh LiPo", 0, -battery_width/2 - 4, g * 4.2);
    }

    // Layer 7: Top shell
    if (show_top) {
        color("DarkSlateGray", 0.9)
            translate([0, 0, g * 5.0])
                top_shell();
        if (show_labels) _label("Top Shell (sealed, pogo pass-through, O-ring)", 0, -pod_width/2 - 4, g * 5.0);
    }

    // Assembly arrows
    if (show_labels)
        color("Red", 0.5)
            for (z = [g * 0.5, g * 1.8, g * 2.7, g * 3.3, g * 3.9, g * 4.6])
                translate([0, 0, z])
                    _arrow_down();
}

// =============================================================================
// LAYOUT
// =============================================================================
module layout_view() {
    g = layout_gap;

    if (show_bottom) {
        color("DimGray", 0.9) bottom_shell();
        if (show_labels) _label("Bottom Shell", 0, -pod_width/2 - 4, 0);
    }
    if (show_top) {
        color("DarkSlateGray", 0.9)
            translate([pod_length + g, 0, top_shell_height])
                mirror([0, 0, 1]) top_shell();
        if (show_labels) _label("Top Shell (flipped)", pod_length + g, -pod_width/2 - 4, 0);
    }

    row2_y = -pod_width - g * 2;

    if (show_electrode) {
        color("Gold", 0.8)
            translate([-electrode_board_total_y/2, row2_y - electrode_board_width/2, 0])
                cube([electrode_board_total_y, electrode_board_width, electrode_board_thickness]);
        if (show_labels)
            _label("Dual Electrode PCB (22x22mm)", 0, row2_y - electrode_board_width/2 - 4, 0);
    }
    if (show_pcb) {
        color("Green", 0.6)
            translate([pod_length + g - pcb_length/2, row2_y - pcb_width/2, 0])
                cube([pcb_length, pcb_width, pcb_thickness]);
        if (show_labels) _label("Main PCB", pod_length + g, row2_y - pcb_width/2 - 4, 0);
    }

    row3_y = -2 * (pod_width + g * 2);

    if (show_battery) {
        color("DodgerBlue", 0.6)
            translate([-battery_length/2, row3_y - battery_width/2, 0])
                cube([battery_length, battery_width, battery_thickness]);
        if (show_labels) _label("Battery", 0, row3_y - battery_width/2 - 4, 0);
    }
    if (show_contacts) {
        for (i = [0 : spring_contact_count - 1]) {
            color("Gold", 0.9)
                translate([pod_length + g - 8 + i * 5, row3_y, 0])
                    cylinder(d=spring_contact_diameter, h=pogo_compressed_height);
        }
        if (show_labels) _label("Pogo Pins x4 (Mill-Max 0906)", pod_length + g, row3_y - 4, 0);
    }
    // Magnets
    color("Silver", 0.7) {
        translate([2*(pod_length+g)-5, row3_y, 0]) cylinder(d=mag_pad_diameter, h=mag_pad_depth);
        translate([2*(pod_length+g)+5, row3_y, 0]) cylinder(d=mag_pad_diameter, h=mag_pad_depth);
    }
    if (show_labels) _label("Magnets x2", 2*(pod_length+g), row3_y - 4, 0);
}

// =============================================================================
// Helpers
// =============================================================================

module _electrode_assembled() {
    // Electrode board centered at (0, 0), resting on ledges
    // Sensing face (front) faces DOWN (-Z), back contacts face UP (+Z)
    color("Gold", 0.75)
        translate([-electrode_board_total_y/2,
                   -electrode_board_width/2,
                   elec_z])
            cube([electrode_board_total_y, electrode_board_width, electrode_board_thickness]);

    // WE_MIP indicator (on bottom/sensing face)
    color("DarkRed", 0.5)
        translate([we_mip_offset_x, 0, elec_z - 0.05])
            cylinder(d=we_diameter, h=0.1);

    // WE_NIP indicator (on bottom/sensing face)
    color("DarkOrange", 0.5)
        translate([we_nip_offset_x, 0, elec_z - 0.05])
            cylinder(d=we_diameter, h=0.1);
}

// Pogo pins in assembled position — extending down from main PCB area
// through the parting line to contact the electrode back pads.
module _pogo_pins_assembled() {
    contacts = [
        [contact_we_mip_x, contact_we_mip_y],
        [contact_we_nip_x, contact_we_nip_y],
        [contact_ce_x,     contact_ce_y],
        [contact_re_x,     contact_re_y],
    ];

    pin_top = bottom_shell_height + wall_thickness;  // starts at main PCB level
    pin_bottom = electrode_back_z;  // reaches electrode back surface

    color("Gold", 0.9)
        for (pos = contacts) {
            translate([pos[0], pos[1], pin_bottom])
                cylinder(d=spring_contact_diameter, h=pin_top - pin_bottom);
        }
}

module _pogo_pins_exploded(z_pos) {
    contacts = [
        [contact_we_mip_x, contact_we_mip_y],
        [contact_we_nip_x, contact_we_nip_y],
        [contact_ce_x,     contact_ce_y],
        [contact_re_x,     contact_re_y],
    ];

    color("Gold", 0.9)
        for (pos = contacts) {
            translate([pos[0], pos[1], z_pos])
                cylinder(d=spring_contact_diameter, h=pogo_compressed_height);
        }
}

module _alignment_pins_exploded(z_pos) {
    color("Silver", 0.9) {
        translate([align_pin1_x, align_pin1_y, z_pos])
            cylinder(d=alignment_pin_diameter, h=alignment_pin_height);
        translate([align_pin2_x, align_pin2_y, z_pos])
            cylinder(d=alignment_pin_diameter, h=alignment_pin_height);
    }
}

module _arrow_down() {
    cylinder(d=0.4, h=explode_gap * 0.3, center=true);
    translate([0, 0, -explode_gap * 0.15])
        cylinder(d1=1.5, d2=0, h=2);
}

module _arrow_left() {
    cylinder(d=0.4, h=6, center=true);
    translate([0, 0, -3])
        cylinder(d1=0, d2=1.5, h=2);
}

module _label(txt, x, y, z) {
    color("Black")
        translate([x, y, z])
            linear_extrude(0.2)
                text(txt, size=2.0, halign="center", font="Liberation Sans:style=Bold");
}
