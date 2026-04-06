// =============================================================================
// assembly.scad — CortiPod full assembly
//
// Top shell = main enclosure (PCB, battery, pogo pins protruding down)
// Bottom shell = electrode frame (window + shelf + GSR pads + strap lugs)
// Electrodes = two DRP-220AT electrodes drop into the frame, held by pogo pins
//
//   MIP Electrode (cortisol-detecting) — negative Y pocket — shown in Gold
//   NIP Electrode (control/reference)  — positive Y pocket — shown in Orange
//
// Differential measurement: MIP signal − NIP signal = true cortisol signal
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
show_pogo_pins = true;
show_skin      = true;
show_labels    = true;

explode_gap    = 16;
layout_gap     = 15;

$fn = 60;

// ---- Z positions (assembled) ----
// Z = 0: skin surface
// Bottom shell: Z = 0 to Z = bottom_shell_height (2.5mm)
// Top shell: Z = bottom_shell_height to Z = pod_height (10mm)
// Electrode: sensing face at Z = sensor_recess_depth (0.3mm)
//            back at Z = sensor_recess_depth + electrode_thickness (0.8mm)
// Pogo pins: protrude from top shell floor down to electrode back

// =============================================================================
if (view_mode == "assembled") assembled_view();
else if (view_mode == "exploded") exploded_view();
else if (view_mode == "layout") layout_view();
else if (view_mode == "cross") {
    difference() {
        assembled_view();
        translate([-100, 0, -50]) cube([200, 100, 200]);
    }
}

// =============================================================================
// ASSEMBLED
// =============================================================================
module assembled_view() {
    // Bottom shell (electrode frame, at Z=0)
    if (show_bottom)
        color("DimGray", 0.9)
            bottom_shell();

    // MIP Electrode — negative Y pocket (cortisol-detecting), resting on shelf
    if (show_electrode) {
        mip_y = -(electrode_gap/2 + electrode_width);
        color("Gold", 0.75)
            translate([-electrode_length/2, mip_y, sensor_recess_depth])
                cube([electrode_length, electrode_width, electrode_thickness]);

        // NIP Electrode — positive Y pocket (control/reference)
        nip_y = electrode_gap/2;
        color("DarkOrange", 0.75)
            translate([-electrode_length/2, nip_y, sensor_recess_depth])
                cube([electrode_length, electrode_width, electrode_thickness]);
    }

    // Top shell (main enclosure, sits on top of bottom shell)
    if (show_top)
        color("DarkSlateGray", 0.9)
            translate([0, 0, bottom_shell_height])
                top_shell();

    // Pogo pins (protrude from top shell, pressing on both electrodes)
    if (show_pogo_pins)
        _pogo_pins(bottom_shell_height - pogo_protrusion,
                   bottom_shell_height + wall_thickness + 1);

    // PCB (inside top shell)
    if (show_pcb)
        color("Green", 0.5)
            translate([-pcb_length/2, -pcb_width/2,
                       bottom_shell_height + wall_thickness + 1])
                cube([pcb_length, pcb_width, pcb_thickness]);

    // Battery (inside top shell, above PCB)
    if (show_battery)
        color("DodgerBlue", 0.5)
            translate([-battery_length/2, -battery_width/2,
                       bottom_shell_height + wall_thickness + 1 + pcb_thickness + 0.5])
                cube([battery_length, battery_width, battery_thickness]);

    // Skin
    if (show_skin)
        color("PeachPuff", 0.15)
            translate([-30, -20, -0.5])
                cube([60, 40, 0.3]);
}

// =============================================================================
// EXPLODED
// =============================================================================
module exploded_view() {
    g = explode_gap;

    // Skin
    if (show_skin) {
        color("PeachPuff", 0.15)
            translate([-30, -20, -g])
                cube([60, 40, 0.3]);
        if (show_labels) _label("Skin (wrist)", 0, -22, -g);
    }

    // Layer 1: Bottom shell (electrode frame)
    if (show_bottom) {
        color("DimGray", 0.9)
            bottom_shell();
        if (show_labels) _label("Bottom Shell (electrode frame)", 0, -pod_width/2 - 4, 0);
    }

    // Layer 2: Electrodes (drop into the frame — MIP + NIP side by side)
    if (show_electrode) {
        mip_y = -(electrode_gap/2 + electrode_width);
        nip_y = electrode_gap/2;

        // MIP electrode (Gold)
        color("Gold", 0.8)
            translate([-electrode_length/2, mip_y, g * 1.3])
                cube([electrode_length, electrode_width, electrode_thickness]);
        if (show_labels)
            _label("MIP Electrode (cortisol)", 0, mip_y - 4, g * 1.3);

        // NIP electrode (DarkOrange)
        color("DarkOrange", 0.8)
            translate([-electrode_length/2, nip_y, g * 1.3])
                cube([electrode_length, electrode_width, electrode_thickness]);
        if (show_labels)
            _label("NIP Electrode (reference)", 0, nip_y + electrode_width + 1, g * 1.3);
    }

    // Layer 3: Pogo pins (protrude from top shell) — 8 pins, 4 per electrode
    if (show_pogo_pins) {
        _pogo_pins(g * 2.3, g * 2.3 + 4);
        if (show_labels) _label("Pogo Pins x8 (4 per electrode)", 0, -4, g * 2.3);
    }

    // Layer 4: PCB
    if (show_pcb) {
        color("Green", 0.6)
            translate([-pcb_length/2, -pcb_width/2, g * 3.2])
                cube([pcb_length, pcb_width, pcb_thickness]);
        if (show_labels) _label("PCB (nRF52832 + AD5941)", 0, -pcb_width/2 - 4, g * 3.2);
    }

    // Layer 5: Battery
    if (show_battery) {
        color("DodgerBlue", 0.6)
            translate([-battery_length/2, -battery_width/2, g * 4.0])
                cube([battery_length, battery_width, battery_thickness]);
        if (show_labels) _label("Battery 60mAh LiPo", 0, -battery_width/2 - 4, g * 4.0);
    }

    // Layer 6: Top shell (main enclosure — all electronics inside)
    if (show_top) {
        color("DarkSlateGray", 0.9)
            translate([0, 0, g * 5.0])
                top_shell();
        if (show_labels) _label("Top Shell (main enclosure)", 0, -pod_width/2 - 4, g * 5.0);
    }

    // Arrows
    if (show_labels)
        color("Red", 0.5)
            for (z = [g * 0.6, g * 1.8, g * 2.8, g * 3.6, g * 4.5])
                translate([0, 0, z])
                    _arrow_down();
}

// =============================================================================
// LAYOUT
// =============================================================================
module layout_view() {
    g = layout_gap;

    // Row 1: Two shells
    if (show_bottom) {
        color("DimGray", 0.9) bottom_shell();
        if (show_labels) _label("Bottom Shell (frame)", 0, -pod_width/2 - 5, 0);
    }
    if (show_top) {
        color("DarkSlateGray", 0.9)
            translate([pod_length + g, 0, top_shell_height])
                mirror([0, 0, 1]) top_shell();
        if (show_labels) _label("Top Shell (flipped)", pod_length + g, -pod_width/2 - 5, 0);
    }

    // Row 2: Components
    row2_y = -pod_width - g * 2;

    if (show_electrode) {
        // MIP electrode (Gold) — left
        color("Gold", 0.8)
            translate([-electrode_length/2, row2_y - electrode_width - electrode_gap/2, 0])
                cube([electrode_length, electrode_width, electrode_thickness]);
        if (show_labels)
            _label("MIP Electrode", 0, row2_y - electrode_width - electrode_gap/2 - 5, 0);

        // NIP electrode (DarkOrange) — right of gap
        color("DarkOrange", 0.8)
            translate([-electrode_length/2, row2_y + electrode_gap/2, 0])
                cube([electrode_length, electrode_width, electrode_thickness]);
        if (show_labels)
            _label("NIP Electrode", 0, row2_y + electrode_width + electrode_gap/2 + 1, 0);
    }
    if (show_pcb) {
        color("Green", 0.6)
            translate([pod_length + g - pcb_length/2, row2_y - pcb_width/2, 0])
                cube([pcb_length, pcb_width, pcb_thickness]);
        if (show_labels) _label("PCB", pod_length + g, row2_y - pcb_width/2 - 5, 0);
    }

    // Row 3: Small parts
    row3_y = -2 * (pod_width + g * 2);

    if (show_battery) {
        color("DodgerBlue", 0.6)
            translate([-battery_length/2, row3_y - battery_width/2, 0])
                cube([battery_length, battery_width, battery_thickness]);
        if (show_labels) _label("Battery", 0, row3_y - battery_width/2 - 5, 0);
    }
    if (show_pogo_pins) {
        for (i = [0 : pogo_count - 1])
            color("Gold", 0.9)
                translate([pod_length + g - 10 + i * 4, row3_y, 0])
                    cylinder(d=pogo_pin_diameter, h=5);
        if (show_labels) _label("Pogo Pins x8 (4 per electrode)", pod_length + g, row3_y - 5, 0);
    }
    color("Silver", 0.7) {
        translate([2*(pod_length+g)-5, row3_y, 0]) cylinder(d=mag_pad_diameter, h=mag_pad_depth);
        translate([2*(pod_length+g)+5, row3_y, 0]) cylinder(d=mag_pad_diameter, h=mag_pad_depth);
    }
    if (show_labels) _label("Magnets x2", 2*(pod_length+g), row3_y - 5, 0);
}

// =============================================================================
// Helpers
// =============================================================================
// _pogo_pins — renders 8 pogo pins: 4 over MIP, 4 over NIP.
// Pins are arranged in a 0.1"-pitch row along X, centred on each electrode's
// contact pad region, and placed at each electrode's Y centre.
module _pogo_pins(z_bottom, z_top) {
    pins_per_electrode = pogo_count / 2;        // 4
    row_span = (pins_per_electrode - 1) * pogo_spacing;
    start_x  = -(row_span / 2);
    pad_x    = electrode_length/2 - electrode_pad_offset;

    mip_y = -(electrode_gap/2 + electrode_width/2);
    nip_y =   electrode_gap/2 + electrode_width/2;

    color("Gold", 0.9)
        for (i = [0 : pins_per_electrode - 1]) {
            x = pad_x + start_x + i * pogo_spacing;

            // MIP pins
            translate([x, mip_y, z_bottom])
                cylinder(d=pogo_pin_diameter, h=z_top - z_bottom);

            // NIP pins
            translate([x, nip_y, z_bottom])
                cylinder(d=pogo_pin_diameter, h=z_top - z_bottom);
        }
}

module _arrow_down() {
    cylinder(d=0.4, h=explode_gap * 0.3, center=true);
    translate([0, 0, -explode_gap * 0.15])
        cylinder(d1=1.5, d2=0, h=2);
}

module _label(txt, x, y, z) {
    color("Black")
        translate([x, y, z])
            linear_extrude(0.2)
                text(txt, size=2.5, halign="center", font="Liberation Sans:style=Bold");
}
