// =============================================================================
// parameters.scad — CortiPod shared dimensions
//
// All measurements in millimeters.
//
// DESIGN: 2-piece, top shell is the main enclosure
//
//   TOP SHELL (the "brain"):
//     Houses PCB, battery, pogo pins, charging pads, magnets.
//     All electronics are self-contained in this piece.
//     Pogo pins protrude from the bottom face.
//
//   BOTTOM SHELL (the "frame"):
//     Simple window frame with electrode shelf.
//     Electrode drops in from above, rests on shelf.
//     GSR pads on the skin-facing surface.
//     Strap lugs.
//
//   Assembly: drop electrode into bottom frame, snap top shell on.
//   Pogo pins press electrode firmly against the shelf.
// =============================================================================

// ---- DRP-220AT Electrode ----
electrode_length     = 33.8;   // mm
electrode_width      = 10.2;   // mm
electrode_thickness  = 0.5;    // mm (ceramic substrate)
electrode_pad_offset = 5.0;    // mm from connector end to contact pads
electrode_count      = 2;      // MIP (cortisol-detecting) + NIP (control/reference)
electrode_gap        = 1.0;    // mm gap between the two electrodes (center divider)

// ---- Pod overall dimensions ----
// Width calculation: wall(1.5) + electrode(10.2) + gap(1.0) + electrode(10.2) + wall(1.5) = 24.4 → 26.0mm
pod_length           = 40.0;   // mm
pod_width            = 26.0;   // mm  (widened for dual-electrode MIP+NIP layout)
pod_height           = 10.0;   // mm (total)
pod_corner_radius    = 6.0;    // mm
wall_thickness       = 1.5;    // mm (minimum everywhere)

// ---- Shell split ----
// Top shell is the larger piece (holds all electronics)
// Bottom shell is thin (just the electrode frame)
top_shell_height     = 7.5;    // mm (PCB + battery + pogo protrusion)
bottom_shell_height  = 2.5;    // mm (electrode frame + shelf + skin clearance)
// top + bottom = pod_height

// ---- Electrode window and shelf (in bottom shell) ----
// Window = opening in the floor (smaller than electrode)
// Shelf = step between window and pocket where electrode edges rest
// Two side-by-side windows separated by a center bridge for structural support.
// Each window is slightly narrower than electrode_width to create the shelf.
sensor_window_length = 28.0;   // mm (shared along electrode length axis)
sensor_window_width  = 9.0;    // mm per electrode window (leaves 0.6mm shelf each side)
sensor_recess_depth  = 0.3;    // mm (electrode face above skin)

// Pocket = electrode-sized recess open from above
// Each electrode drops in loosely, pogo pins hold it down.
// Two pockets side-by-side, separated by the center divider (electrode_gap).
pocket_clearance     = 0.15;   // mm per side (easy drop-in)

// ---- Pogo pins (Mill-Max 0906) ----
// Mounted on the PCB inside the top shell.
// Protrude downward through holes in the top shell floor.
// When shells are snapped together, pins press on electrode pads.
pogo_pin_diameter    = 1.0;    // mm (body)
pogo_pin_hole        = 1.2;    // mm (hole for pin to pass through)
pogo_count           = 8;      // 4 per electrode × 2 electrodes: WE, CE, REF, GND each
pogo_spacing         = 2.54;   // mm (0.1" pitch)
pogo_travel          = 1.0;    // mm (spring compression)
pogo_protrusion      = 1.5;    // mm (how far pins stick out below top shell)

// ---- Strap lugs (18mm quick-release) ----
strap_width          = 18.0;   // mm
lug_width            = 2.5;    // mm
lug_height           = 3.0;    // mm
lug_hole_diameter    = 1.5;    // mm
lug_extension        = 3.0;    // mm

// ---- GSR electrode pads (on bottom shell skin face) ----
gsr_pad_diameter     = 4.0;    // mm
gsr_pad_spacing      = 14.0;   // mm center-to-center
gsr_pad_offset_y     = 3.0;    // mm from center

// ---- Magnetic charging pads (on top shell) ----
mag_pad_diameter     = 5.0;    // mm
mag_pad_depth        = 1.2;    // mm
mag_pad_spacing      = 12.0;   // mm
charge_pad_diameter  = 3.0;    // mm

// ---- PCB ----
pcb_length           = 32.0;   // mm
pcb_width            = 18.0;   // mm
pcb_thickness        = 0.8;    // mm

// ---- Battery ----
battery_length       = 20.0;   // mm
battery_width        = 15.0;   // mm
battery_thickness    = 3.0;    // mm

// ---- Snap-fit clips (top to bottom) ----
clip_width           = 3.0;    // mm
clip_depth           = 0.8;    // mm

// ---- O-ring groove (seal between shells) ----
oring_groove_width   = 1.2;    // mm
oring_groove_depth   = 0.8;    // mm

// ---- Tolerances ----
printer_tolerance    = 0.2;    // mm
