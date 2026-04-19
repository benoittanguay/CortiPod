// =============================================================================
// electrode_pcb.scad — CortiPod stepped electrode PCB
//
// Replaces the old bottom_shell (electrode tray). The PCB itself has
// integrated mechanical features — no separate tray needed.
//
// Manufactured as 2.0mm FR4 (JLCPCB max standard thickness) with
// depth-controlled milling from the FRONT (skin) side on the ±Y
// ledge regions, leaving 0.8mm remaining.
//
// Profile (Y-Z cross-section):
//
//   Back (pogo pin side) — FLAT across full board
//   ═══════════════════════════════════════════════
//   │  ledge  │                          │ ledge │   ← 0.8mm (milled)
//   │ (thin)  │     full 2.0mm thick     │(thin) │
//   └─────────┘     sensing area         └───────┘
//                   with electrodes
//                   on bottom face
//                        ↓
//                   protrudes to skin (1.2mm step)
//
// The thin ±Y ledges slide into the shell's U-channels.
// The thick center protrudes through the skin window for sweat contact.
// ±X edges are full thickness (no milling needed — not in channels).
//
// Orientation key: chamfer on one corner prevents MIP/NIP swap.
// Detent notch: milled recess in ledge edge for channel bump click.
//
// JLCPCB fabrication:
//   - Board thickness: 2.0mm
//   - Surface finish: ENIG (applied before milling)
//   - Depth milling: mark ±Y ledge regions on User.1 layer
//   - Milling depth: 1.2mm from front face (leaves 0.8mm)
//   - Tolerance: ±0.1mm on milling depth
//
// Print note: this is a PCB, not a printed part. This file is for
// visualization in OpenSCAD assembly views only.
// =============================================================================

include <parameters.scad>

$fn = $preview ? 32 : 96;

// ---- Main module ----
module electrode_pcb() {
    difference() {
        union() {
            sensing_area();
            ledges();
        }
        orientation_key();
        detent_notches();
    }
}

// ---- Sensing area (full thickness center) ----
// The thick zone carrying electrodes on the front and contacts on the back.
// Positioned so the sensing face is at Z = 0 (skin) and back at Z = 2.0.
module sensing_area() {
    translate([-electrode_sensing_x/2, -electrode_sensing_y/2, 0])
        cube([electrode_sensing_x, electrode_sensing_y, electrode_board_thickness]);
}

// ---- Thin ledges (±Y extensions) ----
// Depth-milled from the front (skin) side. The back surface is flush
// with the sensing area back (Z = electrode_board_thickness).
// The front surface is at Z = electrode_step_height (recessed 1.2mm
// from the sensing face).
module ledges() {
    for (side = [-1, 1]) {
        // Y position: starts at the sensing area edge, extends outward
        y_start = side * electrode_sensing_y/2;
        y_pos = (side > 0) ? y_start : y_start - electrode_ledge_y;

        translate([-electrode_pcb_x/2, y_pos, electrode_step_height])
            cube([electrode_pcb_x, electrode_ledge_y, electrode_ledge_thickness]);
    }
}

// ---- Orientation key ----
// Corner chamfer at one corner of the sensing zone.
// Prevents 180° rotation error during insertion.
// Cut from the -X, -Y corner of the sensing area.
module orientation_key() {
    translate([-electrode_sensing_x/2 - 0.1,
               -electrode_sensing_y/2 - 0.1,
               -0.1])
        cube([chamfer_size + 0.2,
              chamfer_size + 0.2,
              electrode_board_thickness + 0.2]);
}

// ---- Detent notches ----
// Small recesses milled into the ±Y ledge edges (matching the channel
// detent bumps). These can be done during the same depth-routing
// operation as the ledge milling.
module detent_notches() {
    notch_d     = detent_bump_diameter + 0.2;
    notch_depth = detent_bump_height + 0.1;

    // X position matches the channel bump position when PCB is fully seated.
    // Fully seated: PCB -X edge at hard stop → PCB center offset from pod center.
    // Hard stop at channel_x_start = -pod_length/2 + wall_thickness = -12.5mm
    // PCB -X edge at hard stop: -12.5mm → PCB center at -12.5 + electrode_pcb_x/2
    // Bump at channel_x_start + detent_position
    // Notch X relative to PCB center:
    //   bump_x_abs = channel_x_start + detent_position
    //   pcb_center_x = channel_x_start + electrode_pcb_x/2
    //   notch_x = bump_x_abs - pcb_center_x = detent_position - electrode_pcb_x/2
    notch_x = detent_position - electrode_pcb_x/2;

    for (side = [-1, 1]) {
        // Y position: on the ledge, matching channel bump Y
        ledge_y_center = side * (electrode_sensing_y/2 + electrode_ledge_y/2);

        // Notch cut from the bottom of the ledge (channel floor side)
        translate([notch_x, ledge_y_center, electrode_step_height - notch_depth])
            cylinder(d=notch_d, h=notch_depth + 0.1);
    }
}

// ---- Render ----
electrode_pcb();
