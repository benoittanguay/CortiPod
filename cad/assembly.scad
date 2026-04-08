// =============================================================================
// assembly.scad — CortiPod full assembly
//
// Wall-mounted ledge design:
//   - Electrodes slide in on ceramic edges along ledges (sensing face protected)
//   - Sensing zone: open skin window below, ledges support edges
//   - Contact zone: retaining ceiling + spring contacts = sandwiched slot
//   - Top shell fully sealed (no cutouts) for IP67
//
// view_mode: "assembled", "exploded", "layout", "cross"
//
// TIP: Use "cross" mode to see the ledge + ceiling + spring sandwich.
//      The cross-section cuts through the MIP channel (negative Y half).
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
show_contacts  = true;   // spring contacts (pogo pins)
show_skin      = true;
show_labels    = true;
show_align     = true;

explode_gap    = 16;
layout_gap     = 15;

// Adaptive resolution
$fn = $preview ? 32 : 96;

// ---- Electrode X position (assembled) ----
elec_x_start = -pod_length/2 + wall_thickness + 0.5;

// =============================================================================
if (view_mode == "assembled") assembled_view();
else if (view_mode == "exploded") exploded_view();
else if (view_mode == "layout") layout_view();
else if (view_mode == "cross") {
    // Cut through the MIP channel (negative Y) to show:
    //   - Ledges supporting electrode edges
    //   - Sensing face hanging free over skin window
    //   - Retaining ceiling in connector tail zone
    //   - Spring contacts in contact zone floor
    mip_cut_y = -(electrode_gap/2 + electrode_width/2);  // center of MIP channel
    difference() {
        assembled_view();
        // Remove the positive-Y half to expose the MIP channel cross-section
        translate([-100, mip_cut_y, -50]) cube([200, 200, 200]);
    }
}

// =============================================================================
// ASSEMBLED
// =============================================================================
module assembled_view() {
    if (show_bottom)
        color("DimGray", 0.9)
            bottom_shell();

    if (show_contacts)
        _spring_contacts_assembled();

    if (show_electrode)
        _electrodes_assembled();

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

    // Layer 1: Bottom shell (with spring contacts visible in floor)
    if (show_bottom) {
        color("DimGray", 0.9)
            bottom_shell();
        if (show_labels) _label("Bottom Shell (spring contacts, vent grooves, convex)", 0, -pod_width/2 - 5, 0);
    }

    // Layer 1.5: Spring contacts (shown protruding from floor)
    if (show_contacts) {
        _spring_contacts_exploded(g * 0.7);
        if (show_labels)
            _label("Spring Contacts x6 (3/electrode, press up against pads)", 0, -8, g * 0.7);
    }

    // Layer 2: Electrodes — offset in +X to show insertion direction
    if (show_electrode) {
        mip_y = -(electrode_gap/2 + electrode_width);
        nip_y =  electrode_gap/2;

        color("Gold", 0.8)
            translate([elec_x_start + 6, mip_y, g * 1.5])
                cube([electrode_length, electrode_width, electrode_thickness]);
        if (show_labels)
            _label("MIP Electrode (slide in, spring contacts engage)", 8, mip_y - 4, g * 1.5);

        color("DarkOrange", 0.8)
            translate([elec_x_start + 6, nip_y, g * 1.5])
                cube([electrode_length, electrode_width, electrode_thickness]);
        if (show_labels)
            _label("NIP Electrode (slide in, spring contacts engage)", 8, nip_y + electrode_width + 1, g * 1.5);

        // Insertion direction arrows
        color("Red", 0.6) {
            translate([pod_length/2 + 6, mip_y + electrode_width/2, g * 1.5 + electrode_thickness/2])
                rotate([0, 90, 0]) _arrow_left();
            translate([pod_length/2 + 6, nip_y + electrode_width/2, g * 1.5 + electrode_thickness/2])
                rotate([0, 90, 0]) _arrow_left();
        }
    }

    // Layer 3: Alignment pins
    if (show_align) {
        _alignment_pins_exploded(g * 2.5);
        if (show_labels)
            _label("Alignment Pins (asymmetric poka-yoke)", -8, -10, g * 2.5);
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

    // Layer 6: Top shell (fully sealed — no lever cutout)
    if (show_top) {
        color("DarkSlateGray", 0.9)
            translate([0, 0, g * 5.0])
                top_shell();
        if (show_labels) _label("Top Shell (fully sealed, O-ring groove)", 0, -pod_width/2 - 5, g * 5.0);
    }

    // Assembly arrows
    if (show_labels)
        color("Red", 0.5)
            for (z = [g * 0.6, g * 2.0, g * 2.9, g * 3.6, g * 4.5])
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
        if (show_labels) _label("Bottom Shell", 0, -pod_width/2 - 5, 0);
    }
    if (show_top) {
        color("DarkSlateGray", 0.9)
            translate([pod_length + g, 0, top_shell_height])
                mirror([0, 0, 1]) top_shell();
        if (show_labels) _label("Top Shell (flipped)", pod_length + g, -pod_width/2 - 5, 0);
    }

    row2_y = -pod_width - g * 2;

    if (show_electrode) {
        color("Gold", 0.8)
            translate([-electrode_length/2, row2_y - electrode_width - electrode_gap/2, 0])
                cube([electrode_length, electrode_width, electrode_thickness]);
        if (show_labels)
            _label("MIP Electrode", 0, row2_y - electrode_width - electrode_gap/2 - 5, 0);

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

    row3_y = -2 * (pod_width + g * 2);

    if (show_battery) {
        color("DodgerBlue", 0.6)
            translate([-battery_length/2, row3_y - battery_width/2, 0])
                cube([battery_length, battery_width, battery_thickness]);
        if (show_labels) _label("Battery", 0, row3_y - battery_width/2 - 5, 0);
    }
    if (show_contacts) {
        // Show 6 pogo pins laid out
        for (i = [0 : 5]) {
            color("Gold", 0.9)
                translate([pod_length + g - 10 + i * 4, row3_y, 0])
                    cylinder(d=spring_contact_diameter, h=3);
        }
        if (show_labels) _label("Spring Contacts x6 (Mill-Max 0906)", pod_length + g, row3_y - 5, 0);
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

module _electrodes_assembled() {
    mip_y = -(electrode_gap/2 + electrode_width);
    nip_y =  electrode_gap/2;

    color("Gold", 0.75)
        translate([elec_x_start, mip_y, sensor_recess_depth])
            cube([electrode_length, electrode_width, electrode_thickness]);

    color("DarkOrange", 0.75)
        translate([elec_x_start, nip_y, sensor_recess_depth])
            cube([electrode_length, electrode_width, electrode_thickness]);
}

// Spring contacts in their assembled position — protruding from the floor
// in the contact zone, tips just reaching the electrode pad surface.
module _spring_contacts_assembled() {
    mip_y_center = -(electrode_gap/2 + electrode_width/2);
    nip_y_center =  (electrode_gap/2 + electrode_width/2);

    contact_x = contact_x_center;
    pin_span = (spring_contacts_per_elec - 1) * electrode_pad_pitch;
    first_pin_y_offset = -pin_span / 2;

    // Pin extends from below the floor up to the electrode pad surface.
    // When compressed, pin tip is at ledge_height (flush with ledge top).
    // When uncompressed, pin protrudes ledge_height + spring_contact_travel.
    pin_bottom = -0.5;
    pin_top = ledge_height + spring_contact_travel;

    color("Gold", 0.9)
        for (yc = [mip_y_center, nip_y_center]) {
            for (i = [0 : spring_contacts_per_elec - 1]) {
                pin_y = yc + first_pin_y_offset + i * electrode_pad_pitch;

                translate([contact_x, pin_y, pin_bottom])
                    cylinder(d=spring_contact_diameter, h=pin_top - pin_bottom);
            }
        }
}

// Spring contacts shown floating for exploded view
module _spring_contacts_exploded(z_pos) {
    mip_y_center = -(electrode_gap/2 + electrode_width/2);
    nip_y_center =  (electrode_gap/2 + electrode_width/2);

    contact_x = contact_x_center;
    pin_span = (spring_contacts_per_elec - 1) * electrode_pad_pitch;
    first_pin_y_offset = -pin_span / 2;

    color("Gold", 0.9)
        for (yc = [mip_y_center, nip_y_center]) {
            for (i = [0 : spring_contacts_per_elec - 1]) {
                pin_y = yc + first_pin_y_offset + i * electrode_pad_pitch;

                translate([contact_x, pin_y, z_pos])
                    cylinder(d=spring_contact_diameter, h=3);
            }
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
                text(txt, size=2.5, halign="center", font="Liberation Sans:style=Bold");
}
