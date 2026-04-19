// =============================================================================
// assembly.scad — CortiPod full assembly
//
// Single-shell design with stepped electrode PCB.
// The electrode PCB slides directly into the shell's channels from +X.
// Charging cradle uses the same channel interface.
//
// view_mode: "assembled", "exploded", "layout", "cross", "charging"
// =============================================================================

include <parameters.scad>
use <electrode_pcb.scad>
use <top_shell.scad>
use <charging_cradle.scad>

// =============================================================================
// *** CHANGE THIS ***
// =============================================================================
view_mode = "exploded";

show_shell     = true;
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

// ---- Electrode assembled position ----
// When fully seated, the PCB's -X edge is at the hard stop.
// PCB center X offset from pod center:
elec_center_x = channel_x_start + electrode_pcb_x/2;

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
    if (show_shell)
        color("DarkSlateGray", 0.9)
            top_shell();

    if (show_electrode)
        _electrode_assembled();

    if (show_contacts)
        _pogo_pins_assembled();

    if (show_pcb)
        color("Green", 0.5)
            translate([-pcb_length/2, -pcb_width/2, pcb_bottom_z])
                cube([pcb_length, pcb_width, pcb_thickness]);

    if (show_battery)
        color("DodgerBlue", 0.5)
            translate([-battery_length/2, -battery_width/2, battery_bottom_z])
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

    // Layer 1: Electrode PCB (stepped profile)
    if (show_electrode) {
        color("Gold", 0.8)
            electrode_pcb();

        // WE_MIP indicator
        color("DarkRed", 0.6)
            translate([we_mip_offset_x, 0, -0.05])
                cylinder(d=we_diameter, h=0.1);

        // WE_NIP indicator
        color("DarkOrange", 0.6)
            translate([we_nip_offset_x, 0, -0.05])
                cylinder(d=we_diameter, h=0.1);

        if (show_labels) {
            _label("Stepped Electrode PCB (2.0mm, depth-milled ledges)",
                   0, -electrode_pcb_y/2 - 4, 0);
            _label("8mm WE_MIP", we_mip_offset_x, 6, 0);
            _label("8mm WE_NIP", we_nip_offset_x, 6, 0);
        }

        // Slide direction arrow (enters from +X)
        color("Red", 0.6)
            translate([pod_length/2 + 8, 0, electrode_board_thickness/2])
                rotate([0, -90, 0])
                    _arrow_slide();
    }

    // Layer 2: Pogo pins (mounted on main PCB underside)
    if (show_contacts) {
        _pogo_pins_exploded(g * 2.0);
        if (show_labels)
            _label("Pogo Pins x4 (on PCB, press onto electrode back)",
                   0, -8, g * 2.0);
    }

    // Layer 3: Main PCB
    if (show_pcb) {
        color("Green", 0.6)
            translate([-pcb_length/2, -pcb_width/2, g * 3.0])
                cube([pcb_length, pcb_width, pcb_thickness]);
        if (show_labels)
            _label("PCB (nRF52832 + AD5941, 24x24mm)",
                   0, -pcb_width/2 - 4, g * 3.0);
    }

    // Layer 4: Battery
    if (show_battery) {
        color("DodgerBlue", 0.6)
            translate([-battery_length/2, -battery_width/2, g * 3.8])
                cube([battery_length, battery_width, battery_thickness]);
        if (show_labels)
            _label("Battery 60mAh LiPo",
                   0, -battery_width/2 - 4, g * 3.8);
    }

    // Layer 5: Shell (unified, single piece)
    if (show_shell) {
        color("DarkSlateGray", 0.9)
            translate([0, 0, g * 5.0])
                top_shell();
        if (show_labels)
            _label("Shell (single piece, channels, skin window, strap lugs)",
                   0, -pod_width/2 - 4, g * 5.0);
    }

    // Charging cradle — shown to the side
    if (show_cradle) {
        color("OrangeRed", 0.7)
            translate([pod_length + layout_gap, 0, g * 0.5])
                charging_cradle();
        if (show_labels)
            _label("Charging Cradle (slides into same channels)",
                   pod_length + layout_gap, -pod_width/2 - 4, g * 0.5);
    }

    // Assembly arrows (downward, between layers)
    if (show_labels)
        color("Red", 0.5)
            for (z = [g * 0.8, g * 2.5, g * 3.4, g * 4.4])
                translate([0, 0, z])
                    _arrow_down();
}

// =============================================================================
// LAYOUT
// =============================================================================
module layout_view() {
    g = layout_gap;

    // Shell (flipped upside-down to show interior)
    if (show_shell) {
        color("DarkSlateGray", 0.9)
            translate([pod_length + g, 0, shell_height])
                mirror([0, 0, 1]) top_shell();
        if (show_labels)
            _label("Shell (flipped, channels visible)",
                   pod_length + g, -pod_width/2 - 4, 0);
    }

    // Electrode PCB
    if (show_electrode) {
        color("Gold", 0.8) electrode_pcb();
        if (show_labels)
            _label("Stepped Electrode PCB",
                   0, -electrode_pcb_y/2 - 4, 0);
    }

    row2_y = -pod_width - g * 2;

    // Main PCB
    if (show_pcb) {
        color("Green", 0.6)
            translate([-pcb_length/2, row2_y - pcb_width/2, 0])
                cube([pcb_length, pcb_width, pcb_thickness]);
        if (show_labels)
            _label("Main PCB (nRF52832 + AD5941)",
                   0, row2_y - pcb_width/2 - 4, 0);
    }

    // Battery
    if (show_battery) {
        color("DodgerBlue", 0.6)
            translate([pod_length + g - battery_length/2,
                       row2_y - battery_width/2, 0])
                cube([battery_length, battery_width, battery_thickness]);
        if (show_labels)
            _label("Battery 60mAh LiPo",
                   pod_length + g, row2_y - battery_width/2 - 4, 0);
    }

    row3_y = -2 * (pod_width + g * 2);

    // Pogo pins
    if (show_contacts) {
        for (i = [0 : spring_contact_count - 1]) {
            color("Gold", 0.9)
                translate([-8 + i * 5, row3_y, 0])
                    cylinder(d=spring_contact_diameter, h=pogo_total_height);
        }
        if (show_labels)
            _label("Pogo Pins x4 (Mill-Max 0906)",
                   0, row3_y - 4, 0);
    }

    // Charging cradle
    if (show_cradle) {
        color("OrangeRed", 0.7)
            translate([pod_length + g, row3_y, 0])
                charging_cradle();
        if (show_labels)
            _label("Charging Cradle",
                   pod_length + g, row3_y - pod_width/2 - 4, 0);
    }
}

// =============================================================================
// CHARGING VIEW
// =============================================================================
module charging_view() {
    // Shell
    if (show_shell)
        color("DarkSlateGray", 0.9)
            top_shell();

    // Charging cradle in place of electrode
    if (show_cradle)
        color("OrangeRed", 0.8)
            charging_cradle();

    // Pogo pins making contact with cradle pads
    if (show_contacts)
        _pogo_pins_assembled();

    // Main PCB
    if (show_pcb)
        color("Green", 0.5)
            translate([-pcb_length/2, -pcb_width/2, pcb_bottom_z])
                cube([pcb_length, pcb_width, pcb_thickness]);

    // Battery
    if (show_battery)
        color("DodgerBlue", 0.5)
            translate([-battery_length/2, -battery_width/2, battery_bottom_z])
                cube([battery_length, battery_width, battery_thickness]);

    // Labels
    if (show_labels) {
        _label("Shell (on strap)", 0, -pod_width/2 - 4, shell_height);
        _label("Charging Cradle (USB-C, slides in from +X)",
               0, pod_width/2 + 2, 0);
        _label("Pogo pins carry charge to battery",
               0, -pod_width/2 - 4, 0);

        // Slide direction arrow on cradle
        color("OrangeRed", 0.8)
            translate([pod_length/2 + 10, 0, cradle_height/2])
                rotate([0, -90, 0])
                    _arrow_slide();
    }
}

// =============================================================================
// Helpers — electrode & pogo pins
// =============================================================================

module _electrode_assembled() {
    // Position the electrode PCB at its seated location
    translate([elec_center_x, 0, 0]) {
        color("Gold", 0.75)
            electrode_pcb();

        // WE_MIP indicator (sensing face, Z = 0)
        color("DarkRed", 0.5)
            translate([we_mip_offset_x, 0, -0.05])
                cylinder(d=we_diameter, h=0.1);

        // WE_NIP indicator
        color("DarkOrange", 0.5)
            translate([we_nip_offset_x, 0, -0.05])
                cylinder(d=we_diameter, h=0.1);
    }
}

// Pogo pins in assembled position.
// Extend from mating wall down to electrode back contacts.
module _pogo_pins_assembled() {
    contacts = [
        [contact_we_mip_x, contact_we_mip_y],
        [contact_we_nip_x, contact_we_nip_y],
        [contact_ce_x,     contact_ce_y],
        [contact_re_x,     contact_re_y],
    ];

    pin_top    = cavity_bottom_z;  // top of mating wall
    pin_bottom = electrode_back_z; // electrode back contacts

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

module _arrow_down() {
    cylinder(d=0.4, h=explode_gap * 0.3, center=true);
    translate([0, 0, -explode_gap * 0.15])
        cylinder(d1=1.5, d2=0, h=2);
}

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
