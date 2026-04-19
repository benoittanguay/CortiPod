// =============================================================================
// parameters.scad — CortiPod shared dimensions (single source of truth)
//
// All measurements in millimeters.
//
// DESIGN: Single-shell enclosure with stepped electrode PCB
//
//   SHELL (one piece):
//     Houses PCB, battery, and pogo pins. Strap lugs at ±X ends.
//     Pogo pins on main PCB underside press DOWN through a mating wall
//     onto the electrode board's back contacts.
//     Electrode channels on the underside (±Y inner walls) capture the
//     PCB's thin ledge edges. Skin window in the bottom face exposes
//     the sensing area to sweat/skin.
//
//   ELECTRODE PCB (stepped profile, slides into shell):
//     2.0mm FR4 with depth-controlled milling from the front (skin) side.
//     Thick center (2.0mm): carries WE, CE, RE electrodes on front,
//       back contacts for pogo pins on rear. Protrudes toward skin.
//     Thin ±Y ledges (0.8mm): slide into shell channels for retention.
//     No separate tray — the PCB IS the sliding element.
//
//   CHARGING CRADLE:
//     Same channel interface as electrode PCB. Slides into same channels.
//     4 contact pads aligned with pogo pins carry USB-C power.
//
//   Assembly: slide electrode PCB into shell from +X end until detent clicks.
//   Pogo pins engage back contacts automatically.
//
// DATUMS:
//   Datum A: shell bottom face (Z = 0, skin contact plane)
//   Datum B: hard stop face (-X inner wall of channel)
//   Datum C: pod centerline (Y = 0, symmetry plane)
//
// Z-STACK (from pod bottom / skin upward):
//   Z = 0.0          sensing face (skin contact, through skin window)
//   Z = 1.2          electrode step / channel floor
//   Z = 2.0          electrode back (contact pads) / channel ceiling top
//   Z = 2.2          mating wall bottom (channel ceiling + clearance)
//   Z = 3.2          mating wall top / cavity bottom
//   Z = 3.7          main PCB bottom (on 0.5mm standoffs)
//   Z = 4.5          main PCB top
//   Z = 4.7          battery bottom (0.2mm gap)
//   Z = 7.2          battery top
//   Z = 7.5          inner ceiling (top wall starts)
//   Z = 9.0          shell top (outer surface)
//
// ENGINEERING REFERENCES:
//   See docs/superpowers/specs/2026-04-13-slide-on-enclosure-design.md
//   See docs/enclosure-design-engineering-reference.md
// =============================================================================

// ---- Stepped Electrode PCB (MIP + NIP on one board) ----
// Front (skin side): two 8mm WE circles, CE frame, RE pad
// Back (pod side): FLAT — 4 contact pads for pogo pins
// Depth milling from front (skin) side creates thin ±Y ledges.
// ±X edges remain at full thickness (no milling needed).
electrode_sensing_x      = 22.0;   // mm — sensing zone width (X)
electrode_sensing_y      = 18.0;   // mm — sensing zone height (Y)
electrode_ledge_y        = 3.3;    // mm — thin ledge extension on each ±Y side
electrode_pcb_x          = electrode_sensing_x;                        // 22.0mm
electrode_pcb_y          = electrode_sensing_y + electrode_ledge_y * 2; // ~24.6mm
electrode_board_thickness = 2.0;   // mm — full thickness at sensing area (JLCPCB max)
electrode_ledge_thickness = 0.8;   // mm — remaining after depth milling on ±Y ledges
electrode_step_height    = electrode_board_thickness - electrode_ledge_thickness; // 1.2mm
electrode_count          = 1;      // single board carries both MIP + NIP

// ---- Working electrode geometry (on the front/sensing face) ----
we_diameter              = 8.0;    // mm (each WE circle)
we_mip_offset_x          = -5.0;   // mm from board center
we_nip_offset_x           =  5.0;   // mm from board center
we_area_each             = 50.3;   // mm² (pi * 4²)
we_area_total            = 100.6;  // mm² (both WEs combined)

// ---- Back contact pad positions (relative to board center) ----
// These define where pogo pins on the main PCB must land.
// All contacts are within the full-thickness sensing zone.
// Vias connect front electrodes to back contacts through the 2.0mm board.
contact_we_mip_x = -4.0;   contact_we_mip_y = -2.0;
contact_we_nip_x =  4.0;   contact_we_nip_y = -2.0;
contact_ce_x     = -4.0;   contact_ce_y     =  4.0;
contact_re_x     =  4.0;   contact_re_y     =  4.0;
contact_pad_diameter = 1.8;  // mm

// ---- Corner chamfer (orientation key) ----
// Bottom-left corner of the sensing zone is chamfered so the electrode
// can only be inserted one way (prevents MIP/NIP swap).
chamfer_size = 1.5;  // mm (45-degree chamfer at one corner)

// ---- Pod overall dimensions ----
pod_length           = 28.0;   // mm (X, along insertion direction)
pod_width            = 28.0;   // mm (Y, perpendicular to insertion)
pod_height           = 9.0;    // mm (Z, total height — same as old design)
pod_corner_radius    = 3.0;    // mm
wall_thickness       = 1.5;    // mm (outer shell walls, top wall)

// ---- Shell ----
// Single piece — no separate bottom shell. Full pod height.
shell_height         = pod_height;  // 9.0mm

// ---- Ergonomics ----
wrist_curvature_radius = 40.0;  // mm — convex radius on bottom skin face
skin_fillet_radius     = 1.5;   // mm — minimum fillet on all skin-facing edges

// ---- Electrode channels (on shell underside, ±Y inner walls) ----
// The electrode PCB's thin ±Y ledges slide into these channels from the
// +X end. The channel overhang prevents Z-axis pullout. The step between
// thick center and thin ledge prevents the PCB from dropping through.
//
// Channel cross-section (Y-Z plane):
//   ┌─overhang (ceiling)─┐
//   │  slot (0.8mm ledge) │  ← channel captures thin ledge
//   └─floor (step level)──┘
//
channel_slot_height   = electrode_ledge_thickness + 0.2;  // 1.0mm (fits 0.8mm + clearance)
channel_overhang      = 1.5;    // mm — how far ceiling extends inward (captures ledge)
channel_wall          = 1.0;    // mm — structural wall outside the channel
channel_floor_z       = electrode_step_height;             // 1.2mm from pod bottom
channel_ceiling_z     = channel_floor_z + channel_slot_height;  // 2.2mm

// ---- Electrode compartment ----
// Space below the mating wall that houses the electrode PCB.
// Thick center protrudes from Z = 0 to Z = 2.0 (through skin window).
// Thin ledges sit in channels from Z = 1.2 to Z = 2.0.
electrode_clearance   = 0.2;    // mm per side (XY clearance in compartment)
electrode_back_z      = electrode_board_thickness;  // 2.0mm from pod bottom

// ---- Mating wall ----
// Solid wall separating the electrode compartment from the internal cavity.
// Pogo pin bores pass through this wall.
mating_wall_thickness = 1.0;    // mm
mating_wall_bottom_z  = channel_ceiling_z;                              // 2.2mm
mating_wall_top_z     = mating_wall_bottom_z + mating_wall_thickness;   // 3.2mm

// ---- Skin window ----
// Through-opening in the pod bottom face (Z = 0). Exposes the sensing
// area to skin/sweat. Sensing face of the electrode is flush with Z = 0.
skin_window_width    = electrode_sensing_x - 2.0;  // ~20.0mm (X, slight inset)
skin_window_length   = 16.0;    // mm (Y, covers both 8mm WE circles + CE bars)

// ---- Insertion opening ----
// +X end of the shell is open below the mating wall, allowing the
// electrode PCB to slide in. The opening spans the channel zone height.
insertion_chamfer_depth = 1.5;   // mm — gentle lead-in on channel entrance
insertion_chamfer_angle = 20;    // degrees

// ---- Spring contacts (pogo pins) ----
// Mounted on the main PCB underside. Extend down through bores in the
// mating wall to contact the electrode back pads.
//
// Pin geometry:
//   Top portion in cavity (connects to main PCB): ~1.1mm
//   Middle portion in mating wall bore: 1.0mm
//   Bottom protrusion below mating wall: 0.4mm
//   Electrode back at Z = 2.0, mating wall bottom at Z = 2.2
//   Uncompressed tip at Z = 2.2 - 0.4 = 1.8
//   Compression when electrode present: 2.0 - 1.8 = 0.2mm ✓
spring_contact_count     = 4;
spring_contact_diameter  = 1.0;   // mm (Mill-Max 0906 = 0.98mm)
spring_contact_hole      = 1.3;   // mm (bore diameter through mating wall)
spring_contact_travel    = 0.5;   // mm (max compression stroke)
pogo_total_height        = 2.5;   // mm (full pin length)
pogo_protrusion_below    = 0.4;   // mm below mating wall bottom (provides 0.2mm preload)

// ---- Strap lugs (18mm quick-release, on shell ±X ends) ----
strap_width          = 18.0;
lug_width            = 2.5;
lug_height           = 3.0;
lug_hole_diameter    = 1.5;
lug_extension        = 3.0;

// ---- Detent (retention click) ----
// Bump on channel floor clicks into a notch milled in the PCB ledge edge.
detent_bump_height    = 0.3;    // mm — raised dimple on channel floor
detent_bump_diameter  = 1.5;    // mm
detent_position       = 3.0;    // mm from -X hard stop (fully seated position)

// ---- Electrode channel rail geometry (derived) ----
// Rails run along X on ±Y inner walls. Open at +X for insertion,
// hard stop wall at -X end.
channel_x_start  = -pod_length/2 + wall_thickness;
channel_x_length = pod_length - wall_thickness * 2;  // ~25mm usable

// ---- Charging cradle ----
// Same channel interface as electrode PCB. Body spans the electrode
// compartment zone (Z = channel_floor_z to channel_ceiling_z).
// USB-C port on +X face (exposed end when inserted).
usbc_port_width    = 9.0;    // mm (USB-C receptacle body width)
usbc_port_height   = 3.3;    // mm (USB-C receptacle body height)
usbc_port_depth    = 7.5;    // mm (receptacle insertion depth)
cradle_pad_diameter = 2.0;   // mm (gold-plated contact pads on cradle top)

// Cradle body dimensions — fits between channel walls
cradle_width   = electrode_pcb_x + electrode_clearance;       // ~22.2mm (X)
cradle_length  = electrode_pcb_y + electrode_clearance;       // ~24.8mm (Y)
cradle_height  = channel_ceiling_z;                           // 2.2mm (fills up to channel ceiling)

// ---- Main PCB (inside shell cavity, above mating wall) ----
pcb_length           = 24.0;   // mm (X)
pcb_width            = 24.0;   // mm (Y)
pcb_thickness        = 0.8;    // mm
standoff_height      = 0.5;    // mm (PCB standoffs from cavity floor)

// ---- Battery ----
battery_length       = 18.0;   // mm (compact cell, stacks above PCB)
battery_width        = 12.0;   // mm
battery_thickness    = 2.5;    // mm

// ---- Tolerances ----
printer_tolerance    = 0.2;

// ---- Derived: key Z positions ----
cavity_bottom_z  = mating_wall_top_z;                          // 3.2mm
pcb_bottom_z     = cavity_bottom_z + standoff_height;          // 3.7mm
pcb_top_z        = pcb_bottom_z + pcb_thickness;               // 4.5mm
battery_bottom_z = pcb_top_z + 0.2;                            // 4.7mm
battery_top_z    = battery_bottom_z + battery_thickness;        // 7.2mm
inner_ceiling_z  = shell_height - wall_thickness;              // 7.5mm

// ---- Derived: pogo pin Z check ----
// Pin tip (uncompressed) = mating_wall_bottom_z - pogo_protrusion_below
//                        = 2.2 - 0.4 = 1.8mm
// Electrode back         = 2.0mm
// Compression            = 2.0 - 1.8 = 0.2mm (within 0.5mm stroke) ✓
pogo_tip_z         = mating_wall_bottom_z - pogo_protrusion_below;  // 1.8mm
pogo_compression   = electrode_back_z - pogo_tip_z;                 // 0.2mm

// ---- Backward compatibility aliases ----
// These allow charging_cradle and other files to reference old names
// during transition. Will be removed once all files are updated.
electrode_board_width     = electrode_pcb_x;
electrode_board_total_y   = electrode_pcb_y;
