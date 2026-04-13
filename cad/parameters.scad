// =============================================================================
// parameters.scad — CortiPod shared dimensions (single source of truth)
//
// All measurements in millimeters.
//
// DESIGN: 2-piece shell with bottom-loading single electrode slot
//
//   TOP SHELL (the "brain"):
//     Houses PCB, battery. Fully sealed — no lever cutouts.
//     Pogo pins mounted on the underside of the main PCB, pressing DOWN
//     onto the back contacts of the electrode board.
//
//   BOTTOM SHELL (the "frame"):
//     Single electrode slot for the 22x22mm dual electrode PCB.
//     The electrode slides in from one end.
//     Skin window exposes the sensing face (front) to sweat.
//     The electrode board's back contacts face UP toward the pogo pins.
//
//   Assembly: snap shells together, slide electrode in from +X end.
//   Pogo pins on main PCB engage back contacts automatically.
//
// DATUMS:
//   Datum A: parting line (Z = bottom_shell_height, where shells meet)
//   Datum B: electrode end-stop face (-X inner wall)
//   Datum C: pod centerline (Y = 0, symmetry plane)
//
// ENGINEERING REFERENCES:
//   See docs/enclosure-design-engineering-reference.md
//   See docs/mechanical-engineering-guidelines.md
//   See docs/custom-electrode-fabrication-guide.md
// =============================================================================

// ---- Custom Dual PCB Electrode (MIP + NIP on one board) ----
// Front (skin side): two 8mm WE circles, CE frame, RE pad
// Back (pod side): 4 contact pads for pogo pins (WE_MIP, WE_NIP, CE, RE)
// Test tab: 4mm extension with bench test points, snaps off for final pod
electrode_board_width    = 22.0;   // mm (X dimension, insertion direction)
electrode_board_height   = 18.0;   // mm (Y dimension, sensing zone only, no tab)
electrode_board_tab      = 4.0;    // mm (test point tab, extends beyond sensing zone)
electrode_board_total_y  = electrode_board_height + electrode_board_tab; // 22mm with tab
electrode_board_thickness = 0.8;   // mm (PCB, FR4)
electrode_count          = 1;      // single board carries both MIP + NIP

// ---- Working electrode geometry (on the front/sensing face) ----
we_diameter              = 8.0;    // mm (each WE circle)
we_mip_offset_x          = -5.0;   // mm from board center
we_nip_offset_x           =  5.0;   // mm from board center
we_area_each             = 50.3;   // mm² (pi * 4²)
we_area_total            = 100.6;  // mm² (both WEs combined)

// ---- Back contact pad positions (relative to board center) ----
// These define where pogo pins on the main PCB must land
contact_we_mip_x = -4.0;   contact_we_mip_y = -2.0;
contact_we_nip_x =  4.0;   contact_we_nip_y = -2.0;
contact_ce_x     = -4.0;   contact_ce_y     =  4.0;
contact_re_x     =  4.0;   contact_re_y     =  4.0;
contact_pad_diameter = 1.8;  // mm

// ---- Corner chamfer (orientation key) ----
// Bottom-left corner of the tab end is chamfered so the electrode
// can only be inserted one way (prevents MIP/NIP swap)
chamfer_size = 1.5;  // mm (45-degree chamfer at one corner)

// ---- Pod overall dimensions ----
// Compact design wrapping around the 22x22mm electrode board
pod_length           = 28.0;   // mm (X, along insertion direction)
pod_width            = 28.0;   // mm (Y, perpendicular to insertion)
pod_height           = 9.0;    // mm (Z, total stacked height)
pod_corner_radius    = 3.0;    // mm
wall_thickness       = 1.5;    // mm

// ---- Shell split ----
// Bottom shell: electrode slot + skin window
// Top shell: PCB + battery + pogo pins press down onto electrode back
top_shell_height     = 6.5;    // mm (PCB + battery + pogo clearance)
bottom_shell_height  = 2.5;    // mm (electrode slot + skin window)

// ---- Ergonomics ----
wrist_curvature_radius = 40.0;  // mm — convex radius on bottom skin face
skin_fillet_radius     = 1.5;   // mm — minimum fillet on all skin-facing edges

// ---- Electrode slot ----
// Single slot for the dual electrode board.
// Board slides in from +X end, stops at -X inner wall.
slot_clearance       = 0.2;    // mm per side (tighter than old 0.3mm, SLA/MJF target)
slot_width           = electrode_board_width + slot_clearance * 2;   // ~22.4mm
slot_depth           = electrode_board_total_y + slot_clearance;     // ~22.2mm (with tab)
slot_height          = electrode_board_thickness + 0.2;              // ~1.0mm

// ---- Electrode support ledges ----
// Narrow shelves along the slot walls. The electrode board rests on its
// PCB edges on these ledges. The sensing face (WE, CE, RE pads) hangs
// free below the ledges, exposed through the skin window.
ledge_height         = 0.5;    // mm — distance from skin surface to electrode front face
ledge_width          = 1.0;    // mm — how far ledge protrudes inward from slot wall

// ---- Skin window ----
// Full-depth opening below the sensing zone. Exposes both WE pads,
// the CE frame, and RE to sweat/skin contact.
skin_window_width    = electrode_board_width - ledge_width * 2 - 0.2;  // ~19.8mm
skin_window_length   = 16.0;   // mm (covers both 8mm WE circles + CE bars)

// ---- Insertion opening ----
// +X end of the pod is open for electrode insertion.
// Chamfered funnel guides the board in.
insertion_chamfer_depth  = 2.0;   // mm into the slot from the +X face
insertion_chamfer_angle  = 25;    // degrees (gentler than old 30°)

// ---- Spring contacts (pogo pins) ----
// Mounted in bores through the top shell mating face. Tips protrude
// DOWN into the bottom shell cavity to contact the electrode back pads.
// Pin bodies sit in the mating face wall; pads on top connect to the
// main PCB via short wires or solder bridges.
//
// Z-stack: parting line at Z=2.5, electrode back at Z=1.1.
// Pins need to bridge 1.4mm. With 2.0mm total travel, they compress
// ~0.6mm when the electrode is installed — good contact force.
spring_contact_count     = 4;
spring_contact_diameter  = 1.0;   // mm (Mill-Max 0906 = 0.98mm)
spring_contact_hole      = 1.3;   // mm (bore diameter in mating face)
spring_contact_travel    = 0.5;   // mm (compression stroke)
pogo_total_height        = 3.0;   // mm (full pin length — protrudes 1.5mm below mating face)
pogo_protrusion_below    = pogo_total_height - wall_thickness; // 1.5mm below mating face
// Z-stack check: pin tip unloaded at Z = 2.5 - 1.5 = 1.0
//                electrode back at Z = 0.5 + 0.8 = 1.3
//                compression = 1.3 - 1.0 = 0.3mm (good contact, within 0.5mm travel)

// ---- Strap lugs (18mm quick-release) ----
strap_width          = 18.0;
lug_width            = 2.5;
lug_height           = 3.0;
lug_hole_diameter    = 1.5;
lug_extension        = 3.0;

// ---- GSR electrode pads ----
// Two exposed metal pads on the bottom shell skin face
// for galvanic skin response (sweat/contact detection).
// Positioned flanking the skin window.
gsr_pad_diameter     = 4.0;
gsr_pad_spacing      = 20.0;   // mm center-to-center
gsr_pad_y_offset     = 0;      // mm from pod center (centered)

// ---- Magnetic charging pads ----
mag_pad_diameter     = 5.0;
mag_pad_depth        = 1.2;
mag_pad_spacing      = 12.0;
charge_pad_diameter  = 3.0;

// ---- Main PCB (inside top shell) ----
pcb_length           = 24.0;   // mm (smaller — fits above electrode)
pcb_width            = 24.0;   // mm
pcb_thickness        = 0.8;

// ---- Battery ----
battery_length       = 18.0;   // mm (compact cell, stacks above PCB)
battery_width        = 12.0;   // mm
battery_thickness    = 2.5;    // mm (thinner cell for reduced height)

// ---- Alignment pins ----
alignment_pin_diameter = 2.0;
alignment_pin_height   = 2.0;
alignment_hole_clearance = 0.1;

// Asymmetric placement prevents 180° assembly error
align_pin1_x = -pod_length/2 + 5;
align_pin1_y = -pod_width/2 + 4;
align_pin2_x =  pod_length/2 - 6;
align_pin2_y =  pod_width/2 - 4;

// ---- Snap-fit clips ----
clip_width           = 3.0;
clip_depth           = 0.8;
clip_beam_thickness  = 0.8;
clip_beam_length     = 5.0;

// ---- O-ring groove ----
oring_groove_width   = 1.5;
oring_groove_depth   = 0.75;
oring_cs             = 1.0;

// ---- Ventilation grooves (on bottom shell skin face) ----
vent_groove_width    = 0.8;    // mm
vent_groove_depth    = 0.3;    // mm
vent_groove_count    = 3;

// ---- Tolerances ----
printer_tolerance    = 0.2;

// ---- LED status indicator ----
led_hole_diameter    = 2.0;    // mm (light pipe hole in top shell)

// ---- Derived: electrode Z position ----
// The electrode front face (sensing) sits at Z = ledge_height from bottom of pod.
// The electrode back face (contacts) sits at Z = ledge_height + electrode_board_thickness.
// Pogo pins from the main PCB must reach down to this height.
electrode_back_z = ledge_height + electrode_board_thickness;  // 0.5 + 0.8 = 1.3mm from bottom
