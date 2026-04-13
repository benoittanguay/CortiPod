// =============================================================================
// parameters.scad — CortiPod shared dimensions (single source of truth)
//
// All measurements in millimeters.
//
// DESIGN: Slide-on 2-piece enclosure with U-channel rails
//
//   TOP SHELL (the "brain"):
//     Houses PCB, battery. Strap lugs at ±X ends.
//     Pogo pins mounted on the underside of the main PCB, pressing DOWN
//     onto the back contacts of the electrode board.
//     U-channel rails on the underside (±Y sides) receive the bottom shell.
//     Fully sealed — only openings are pogo pin pass-throughs.
//
//   BOTTOM SHELL (electrode tray):
//     Minimal tray holding the 22x22mm dual electrode PCB.
//     Lips on ±Y edges slide into the top shell's U-channel rails.
//     Electrode drops into the pocket, sensing face down.
//     Detent click locks tray in place; pogo pins hold electrode firm.
//
//   CHARGING CRADLE:
//     Same outer profile as bottom shell. Slides into same rails.
//     4 contact pads aligned with pogo pins carry USB-C power.
//
//   Assembly: wear top shell on strap, slide bottom shell in from +Y.
//   Pogo pins on main PCB engage electrode back contacts automatically.
//
// DATUMS:
//   Datum A: top shell underside (Z = bottom_shell_height, rail interface)
//   Datum B: hard stop face (-Y inner wall of rail cavity)
//   Datum C: pod centerline (Y = 0, symmetry plane)
//
// ENGINEERING REFERENCES:
//   See docs/superpowers/specs/2026-04-13-slide-on-enclosure-design.md
//   See docs/enclosure-design-engineering-reference.md
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
// Bottom shell: electrode tray
// Top shell: PCB + battery + pogo pins press down onto electrode back
top_shell_height     = 6.5;    // mm (PCB + battery + pogo clearance)
bottom_shell_height  = 2.5;    // mm (electrode tray height)

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
spring_contact_count     = 4;
spring_contact_diameter  = 1.0;   // mm (Mill-Max 0906 = 0.98mm)
spring_contact_hole      = 1.3;   // mm (bore diameter in mating face)
spring_contact_travel    = 0.5;   // mm (compression stroke)
pogo_total_height        = 2.5;   // mm (full pin length — protrudes 1.0mm below mating face)
pogo_protrusion_below    = pogo_total_height - wall_thickness; // 1.0mm below mating face
// Z-stack check: pin tip unloaded at Z = 2.5 - 1.0 = 1.5
//                electrode back at Z = 0.5 + 0.8 = 1.3
//                compression = 1.5 - 1.3 = 0.2mm (within 0.5mm travel)

// ---- Strap lugs (18mm quick-release, on TOP SHELL ±X ends) ----
strap_width          = 18.0;
lug_width            = 2.5;
lug_height           = 3.0;
lug_hole_diameter    = 1.5;
lug_extension        = 3.0;

// ---- U-channel rails (on top shell underside, ±Y sides) ----
// Bottom shell lips slide into these channels from the +Y end.
// Channel overhang prevents Z-axis pullout.
rail_channel_width    = 1.2;    // mm — width of the channel slot
rail_channel_depth    = 0.8;    // mm — overhang depth (captures lip)
rail_wall_thickness   = 1.0;    // mm — rail wall material
rail_length           = pod_width - wall_thickness * 2;  // ~25mm usable

// ---- Detent (retention click) ----
detent_bump_height    = 0.3;    // mm — raised dimple on channel floor
detent_bump_diameter  = 1.5;    // mm
detent_position       = 3.0;    // mm from -Y hard stop (fully seated position)

// ---- Bottom shell (electrode tray) ----
tray_width  = pod_length - wall_thickness * 2 - rail_wall_thickness * 2;  // ~23mm
tray_length = pod_width - wall_thickness;  // ~26.5mm (open at +Y)
tray_height = bottom_shell_height;  // 2.5mm
tray_lip_thickness = 1.0;    // mm — captured by rail channel
tray_lip_height    = 0.8;    // mm — matches channel depth

// ---- Charging cradle ----
// Same outer profile as bottom shell tray. Slides into same rails.
// USB-C port on +Y face (exposed end).
usbc_port_width    = 9.0;    // mm (USB-C receptacle body width)
usbc_port_height   = 3.3;    // mm (USB-C receptacle body height)
usbc_port_depth    = 7.5;    // mm (receptacle insertion depth)
cradle_pad_diameter = 2.0;   // mm (gold-plated contact pads on cradle top)

// ---- Main PCB (inside top shell) ----
pcb_length           = 24.0;   // mm (smaller — fits above electrode)
pcb_width            = 24.0;   // mm
pcb_thickness        = 0.8;

// ---- Battery ----
battery_length       = 18.0;   // mm (compact cell, stacks above PCB)
battery_width        = 12.0;   // mm
battery_thickness    = 2.5;    // mm (thinner cell for reduced height)

// ---- Tolerances ----
printer_tolerance    = 0.2;

// ---- Derived: electrode Z position ----
// The electrode front face (sensing) sits at Z = ledge_height from bottom of pod.
// The electrode back face (contacts) sits at Z = ledge_height + electrode_board_thickness.
// Pogo pins from the main PCB must reach down to this height.
electrode_back_z = ledge_height + electrode_board_thickness;  // 0.5 + 0.8 = 1.3mm from bottom
