// =============================================================================
// assembly.scad — CortiPod full assembly
//
// Slide-on 2-piece enclosure with U-channel rail architecture.
// Top shell (brain) + bottom shell (electrode tray) slide together from +Y.
// Charging cradle uses the same rail interface as the bottom shell.
//
// view_mode: "assembled", "exploded", "layout", "cross", "charging"
// =============================================================================

include <parameters.scad>
use <bottom_shell.scad>
use <top_shell.scad>
use <charging_cradle.scad>

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
show_cradle    = true;

explode_gap    = 14;
layout_gap     = 12;

$fn = $preview ? 32 : 96;

// ---- Electrode assembled Z position ----
// Board rests on ledges; sensing face down, back contacts up.
elec_z = ledge_height;

// =============================================================================
if      (view_mode == "assembled") assembled_view();
else if (view_mode == "exploded")  exploded_view();
else if (view_mode == "layout")    layout_view();
else if (view_mode == "charging")  charging_view();
else if (view_mode == "cross") {
    difference() {
        assembled_view();
        // Cut along Y=0 plane, show +Y half removed
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

    // Layer 1: Bottom shell (electrode tray)
    if (show_bottom) {
        color("DimGray", 0.9)
            bottom_shell();
        if (show_labels)
            _label("Electrode Tray (slides in from +Y)", 0, -pod_width/2 - 4, 0);
    }

    // Layer 2: Electrode board — offset in +X to show slide-in direction
    if (show_electrode) {
        color("Gold", 0.8)
            translate([4, -electrode_board_width/2, g * 1.3])
                cube([electrode_board_total_y, electrode_board_width, electrode_board_thickness]);

        // WE_MIP indicator
        color("DarkRed", 0.6)
            translate([4 + electrode_board_total_y/2 + we_mip_offset_x,
                       0,
                       g * 1.3 + electrode_board_thickness])
                cylinder(d=we_diameter, h=0.1);

        // WE_NIP indicator
        color("DarkOrange", 0.6)
            translate([4 + electrode_board_total_y/2 + we_nip_offset_x,
                       0,
                       g * 1.3 + electrode_board_thickness])
                cylinder(d=we_diameter, h=0.1);

        if (show_labels) {
            _label("Dual Electrode PCB (MIP + NIP, 22x22mm)",
                   10, -electrode_board_width/2 - 4, g * 1.3);
            _label("8mm WE_MIP",
                   4 + electrode_board_total_y/2 + we_mip_offset_x, 6, g * 1.3);
            _label("8mm WE_NIP",
                   4 + electrode_board_total_y/2 + we_nip_offset_x, 6, g * 1.3);
        }

        // Slide direction arrow (tray enters from +Y)
        color("Red", 0.6)
            translate([0, pod_width/2 + 8, g * 1.3 + electrode_board_thickness/2])
                rotate([90, 0, 0])
                    _arrow_slide();
    }

    // Layer 3: Pogo pins (mounted on main PCB underside)
    if (show_contacts) {
        _pogo_pins_exploded(g * 2.5);
        if (show_labels)
            _label("Pogo Pins x4 (on PCB, press onto electrode back)",
                   0, -8, g * 2.5);
    }

    // Layer 4: Main PCB
    if (show_pcb) {
        color("Green", 0.6)
            translate([-pcb_length/2, -pcb_width/2, g * 3.5])
                cube([pcb_length, pcb_width, pcb_thickness]);
        if (show_labels)
            _label("PCB (nRF52832 + AD5941, 24x24mm)",
                   0, -pcb_width/2 - 4, g * 3.5);
    }

    // Layer 5: Battery
    if (show_battery) {
        color("DodgerBlue", 0.6)
            translate([-battery_length/2, -battery_width/2, g * 4.2])
                cube([battery_length, battery_width, battery_thickness]);
        if (show_labels)
            _label("Battery 60mAh LiPo",
                   0, -battery_width/2 - 4, g * 4.2);
    }

    // Layer 6: Top shell
    if (show_top) {
        color("DarkSlateGray", 0.9)
            translate([0, 0, g * 5.0])
                top_shell();
        if (show_labels)
            _label("Top Shell (sealed, rails, strap lugs)",
                   0, -pod_width/2 - 4, g * 5.0);
    }

    // Charging cradle — shown to the side in exploded view
    if (show_cradle) {
        color("OrangeRed", 0.7)
            translate([pod_length + layout_gap, 0, g * 0.5])
                charging_cradle();
        if (show_labels)
            _label("Charging Cradle (slides into same rails)",
                   pod_length + layout_gap, -pod_width/2 - 4, g * 0.5);
    }

    // Assembly arrows (downward, between layers)
    if (show_labels)
        color("Red", 0.5)
            for (z = [g * 0.5, g * 1.8, g * 3.0, g * 3.9, g * 4.6])
                translate([0, 0, z])
                    _arrow_down();
}

// =============================================================================
// LAYOUT
// =============================================================================
module layout_view() {
    g = layout_gap;

    // Top shell (flipped upside-down to show interior)
    if (show_top) {
        color("DarkSlateGray", 0.9)
            translate([pod_length + g, 0, top_shell_height])
                mirror([0, 0, 1]) top_shell();
        if (show_labels)
            _label("Top Shell (flipped, rails visible)",
                   pod_length + g, -pod_width/2 - 4, 0);
    }

    // Bottom shell (electrode tray)
    if (show_bottom) {
        color("DimGray", 0.9) bottom_shell();
        if (show_labels)
            _label("Electrode Tray", 0, -pod_width/2 - 4, 0);
    }

    row2_y = -pod_width - g * 2;

    // Electrode board
    if (show_electrode) {
        color("Gold", 0.8)
            translate([-electrode_board_total_y/2,
                       row2_y - electrode_board_width/2, 0])
                cube([electrode_board_total_y, electrode_board_width,
                      electrode_board_thickness]);
        if (show_labels)
            _label("Dual Electrode PCB (22x22mm)",
                   0, row2_y - electrode_board_width/2 - 4, 0);
    }

    // Main PCB
    if (show_pcb) {
        color("Green", 0.6)
            translate([pod_length + g - pcb_length/2,
                       row2_y - pcb_width/2, 0])
                cube([pcb_length, pcb_width, pcb_thickness]);
        if (show_labels)
            _label("Main PCB (nRF52832 + AD5941)",
                   pod_length + g, row2_y - pcb_width/2 - 4, 0);
    }

    row3_y = -2 * (pod_width + g * 2);

    // Battery
    if (show_battery) {
        color("DodgerBlue", 0.6)
            translate([-battery_length/2, row3_y - battery_width/2, 0])
                cube([battery_length, battery_width, battery_thickness]);
        if (show_labels)
            _label("Battery 60mAh LiPo",
                   0, row3_y - battery_width/2 - 4, 0);
    }

    // Pogo pins
    if (show_contacts) {
        for (i = [0 : spring_contact_count - 1]) {
            color("Gold", 0.9)
                translate([pod_length + g - 8 + i * 5, row3_y, 0])
                    cylinder(d=spring_contact_diameter, h=pogo_total_height);
        }
        if (show_labels)
            _label("Pogo Pins x4 (Mill-Max 0906)",
                   pod_length + g, row3_y - 4, 0);
    }

    // Charging cradle
    if (show_cradle) {
        color("OrangeRed", 0.7)
            translate([2 * (pod_length + g), row3_y - pod_width/2, 0])
                charging_cradle();
        if (show_labels)
            _label("Charging Cradle",
                   2 * (pod_length + g), row3_y - pod_width/2 - 4, 0);
    }
}

// =============================================================================
// CHARGING VIEW
// =============================================================================
// Shows top shell in use on the strap with the charging cradle slid in,
// replacing the electrode tray. Pogo pins make contact with cradle pads.
module charging_view() {
    // Top shell (main device body with strap lugs)
    if (show_top)
        color("DarkSlateGray", 0.9)
            translate([0, 0, bottom_shell_height])
                top_shell();

    // Charging cradle in place of bottom shell
    if (show_cradle)
        color("OrangeRed", 0.8)
            charging_cradle();

    // Pogo pins making contact with cradle pads
    if (show_contacts)
        _pogo_pins_assembled();

    // Main PCB
    if (show_pcb)
        color("Green", 0.5)
            translate([-pcb_length/2, -pcb_width/2,
                       bottom_shell_height + wall_thickness + 1.0])
                cube([pcb_length, pcb_width, pcb_thickness]);

    // Battery
    if (show_battery)
        color("DodgerBlue", 0.5)
            translate([-battery_length/2, -battery_width/2,
                       bottom_shell_height + wall_thickness + 1.0 + pcb_thickness + 0.5])
                cube([battery_length, battery_width, battery_thickness]);

    // Labels
    if (show_labels) {
        _label("Top Shell (on strap)", 0, -pod_width/2 - 4, bottom_shell_height);
        _label("Charging Cradle (USB-C, slides in from +Y)",
               0, pod_width/2 + 2, 0);
        _label("Pogo pins carry charge to battery",
               0, -pod_width/2 - 4, 0);

        // Slide direction arrow on cradle
        color("OrangeRed", 0.8)
            translate([0, pod_width/2 + 10, tray_height/2])
                rotate([90, 0, 0])
                    _arrow_slide();
    }
}

// =============================================================================
// Helpers — electrode & pogo pins
// =============================================================================

module _electrode_assembled() {
    color("Gold", 0.75)
        translate([-electrode_board_total_y/2,
                   -electrode_board_width/2,
                   elec_z])
            cube([electrode_board_total_y, electrode_board_width,
                  electrode_board_thickness]);

    // WE_MIP indicator (sensing face, bottom)
    color("DarkRed", 0.5)
        translate([we_mip_offset_x, 0, elec_z - 0.05])
            cylinder(d=we_diameter, h=0.1);

    // WE_NIP indicator (sensing face, bottom)
    color("DarkOrange", 0.5)
        translate([we_nip_offset_x, 0, elec_z - 0.05])
            cylinder(d=we_diameter, h=0.1);
}

// Pogo pins in assembled/charging position.
// Extend from main PCB (top of bottom_shell_height wall) down to electrode back.
module _pogo_pins_assembled() {
    contacts = [
        [contact_we_mip_x, contact_we_mip_y],
        [contact_we_nip_x, contact_we_nip_y],
        [contact_ce_x,     contact_ce_y],
        [contact_re_x,     contact_re_y],
    ];

    pin_top    = bottom_shell_height + wall_thickness;
    pin_bottom = electrode_back_z;   // defined in parameters.scad

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
                cylinder(d=spring_contact_diameter, h=pogo_total_height);
        }
}

// =============================================================================
// Helpers — arrows & labels
// =============================================================================

// Down-pointing assembly arrow (between exploded layers)
module _arrow_down() {
    cylinder(d=0.4, h=explode_gap * 0.3, center=true);
    translate([0, 0, -explode_gap * 0.15])
        cylinder(d1=1.5, d2=0, h=2);
}

// Slide direction indicator (points in -Y, i.e. direction of tray insertion)
module _arrow_slide() {
    cylinder(d=0.5, h=8, center=true);
    translate([0, 0, -4])
        cylinder(d1=0, d2=2.0, h=2.5);
}

module _label(txt, x, y, z) {
    color("Black")
        translate([x, y, z])
            linear_extrude(0.2)
                text(txt, size=2.0, halign="center",
                     font="Liberation Sans:style=Bold");
}
