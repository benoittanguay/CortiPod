// =============================================================================
// parameters.scad — CortiPod shared dimensions (single source of truth)
//
// All measurements in millimeters.
//
// DESIGN: 2-piece shell with side-loading electrode slot
//
//   TOP SHELL (the "brain"):
//     Houses PCB, battery. Fully sealed — no lever cutouts.
//     Alignment pins on mating face for shell-to-shell registration.
//
//   BOTTOM SHELL (the "frame"):
//     Two electrode channels with WALL-MOUNTED LEDGES (not a thin floor).
//     Electrodes slide in from +X on their ceramic edges — the sensing
//     face never touches anything. Skin windows are cut through the
//     full floor thickness below the ledges.
//
//     In the CONNECTOR TAIL zone (+X end):
//       - Same ledges support the electrode from below
//       - A retaining ceiling constrains the electrode from above
//       - Spring contacts (pogo pins) protrude up through the floor
//         between the ledges to press against the downward-facing pads
//       - The electrode is sandwiched: ledges + ceiling hold it flat,
//         spring contacts make electrical connection
//
//     In the SENSING zone (-X end):
//       - Ledges support the electrode edges
//       - Sensing face hangs free between ledges, exposed to skin window
//       - No floor under the sensing face — full opening to skin
//       - Channel is open-topped (top shell cavity above)
//
//   Assembly: snap shells together, slide electrodes in from +X end.
//   Spring contacts engage automatically. No lever, no tools.
//
// DATUMS:
//   Datum A: parting line (Z = bottom_shell_height, where shells meet)
//   Datum B: electrode end-stop face (-X inner wall)
//   Datum C: pod centerline (Y = 0, symmetry plane)
//
// ENGINEERING REFERENCES:
//   See docs/enclosure-design-engineering-reference.md
//   See docs/mechanical-engineering-guidelines.md
// =============================================================================

// ---- DRP-220AT Electrode ----
electrode_length     = 33.8;   // mm (total strip length)
electrode_width      = 10.2;   // mm
electrode_thickness  = 0.5;    // mm (ceramic substrate)
electrode_pad_length = 5.0;    // mm — length of connector tail (pad region)
electrode_active_length = electrode_length - electrode_pad_length; // ~28.8mm sensing region
electrode_count      = 2;      // MIP (cortisol-detecting) + NIP (control/reference)
electrode_gap        = 1.0;    // mm gap between the two electrode channels

// ---- Electrode contact pads (on the connector tail) ----
electrode_pad_count  = 3;      // WE, CE, REF per electrode
electrode_pad_width  = 2.0;    // mm — individual pad width
electrode_pad_pitch  = 3.0;    // mm — center-to-center spacing

// ---- Pod overall dimensions ----
pod_length           = 44.0;   // mm
pod_width            = 26.0;   // mm
pod_height           = 10.0;   // mm (total, target < 12mm to avoid cuff snagging)
pod_corner_radius    = 3.0;    // mm
wall_thickness       = 1.5;    // mm

// ---- Shell split ----
top_shell_height     = 7.5;    // mm (PCB + battery)
bottom_shell_height  = 2.5;    // mm (electrode channels + ledges + skin window)

// ---- Ergonomics ----
wrist_curvature_radius = 40.0;  // mm — convex radius on bottom skin face
skin_fillet_radius     = 1.5;   // mm — minimum fillet on all skin-facing edges

// ---- Electrode support: wall-mounted ledges ----
// Ledges protrude inward from channel walls. The electrode rests on its
// ceramic edges on these ledges. The sensing face hangs free between them,
// never touching any surface. This prevents scratching the MIP coating
// during insertion and eliminates the fragile 0.3mm thin floor.
//
// Ledge top surface is at Z = ledge_height from the bottom of the shell.
// The electrode sensing face (bottom) sits at Z = ledge_height.
// Skin is at Z = 0. So ledge_height = desired skin-to-electrode gap.
ledge_height         = 0.3;    // mm — distance from skin surface to electrode face
ledge_width          = 0.8;    // mm — how far the ledge protrudes inward from wall
ledge_clearance      = 0.1;    // mm — vertical gap above electrode to allow sliding

// ---- Skin window (through the full floor) ----
// With ledges supporting the electrode, the skin window can be nearly
// the full electrode width — cut through the entire floor thickness.
// The window is bounded by the ledges on each side.
sensor_window_length = 26.0;   // mm (slightly shorter than electrode_active_length)
sensor_window_width  = electrode_width - ledge_width * 2 + 0.2;  // ~8.8mm (between ledges)

// ---- Channel dimensions ----
// Channel width = electrode + clearance. Channel is open-topped in
// the sensing zone, and has a retaining ceiling in the connector tail zone.
channel_clearance    = 0.3;    // mm per side (FDM prototyping; reduce for production)
channel_width        = electrode_width + channel_clearance * 2;  // ~10.8mm

// ---- Connector tail zone (retaining slot) ----
// In this zone, a ceiling constrains the electrode from lifting when
// spring contacts push up. The electrode is sandwiched:
//   bottom: ledges + spring contacts pushing up
//   top:    retaining ceiling holding down
// Ceiling height = ledge_height + electrode_thickness + ledge_clearance
contact_zone_length  = electrode_pad_length + 1.0;  // 6mm (pad region + margin)
contact_zone_x_start = -pod_length/2 + wall_thickness + electrode_active_length;
retaining_ceiling_z  = ledge_height + electrode_thickness + ledge_clearance; // ~0.9mm

// ---- Insertion funnel ----
insertion_chamfer_depth  = 2.0;   // mm into the channel from +X face
insertion_chamfer_angle  = 30;    // degrees

// ---- Spring contacts (upward-facing, in connector tail zone floor) ----
// Pogo pins mounted in the floor between the ledges. Tips protrude up
// to contact the downward-facing electrode pads. The retaining ceiling
// prevents the electrode from lifting.
//
// Pin compressed height must equal ledge_height so electrode stays flat:
//   pin protrusion above floor = ledge_height (0.3mm) when compressed
//   pin protrusion when uncompressed = ledge_height + spring_contact_travel
spring_contact_diameter  = 1.0;   // mm (Mill-Max 0906 = 0.98mm)
spring_contact_hole      = 1.3;   // mm (mounting hole with clearance)
spring_contact_travel    = 0.5;   // mm (compression stroke)
spring_contacts_per_elec = 3;     // WE, CE, REF

// Contact X center (middle of the connector tail zone)
contact_x_center = contact_zone_x_start + contact_zone_length / 2;

// Flex cable pass-through: sealed hole at parting line
flex_passthrough_width  = 4.0;   // mm
flex_passthrough_height = 1.0;   // mm
flex_passthrough_x      = contact_x_center;

// ---- Insertion slot ----
insertion_slot_height = electrode_thickness + 0.6;  // ~1.1mm
insertion_slot_width  = channel_width;

// ---- Ventilation grooves (on bottom shell skin face) ----
vent_groove_width    = 0.8;    // mm
vent_groove_depth    = 0.3;    // mm
vent_groove_count    = 3;

// ---- Alignment pins ----
alignment_pin_diameter = 2.0;
alignment_pin_height   = 2.0;
alignment_hole_clearance = 0.1;

align_pin1_x = -pod_length/2 + 6;
align_pin1_y = -pod_width/2 + 4;
align_pin2_x =  pod_length/2 - 8;
align_pin2_y =  pod_width/2 - 4;

// ---- Strap lugs (18mm quick-release) ----
strap_width          = 18.0;
lug_width            = 2.5;
lug_height           = 3.0;
lug_hole_diameter    = 1.5;
lug_extension        = 3.0;

// ---- GSR electrode pads ----
gsr_pad_diameter     = 4.0;
gsr_pad_spacing      = 14.0;
gsr_pad_offset_y     = 3.0;

// ---- Magnetic charging pads ----
mag_pad_diameter     = 5.0;
mag_pad_depth        = 1.2;
mag_pad_spacing      = 12.0;
charge_pad_diameter  = 3.0;

// ---- PCB ----
pcb_length           = 32.0;
pcb_width            = 18.0;
pcb_thickness        = 0.8;

// ---- Battery ----
battery_length       = 20.0;
battery_width        = 15.0;
battery_thickness    = 3.0;

// ---- Snap-fit clips ----
clip_width           = 3.0;
clip_depth           = 0.8;
clip_beam_thickness  = 0.8;
clip_beam_length     = 5.0;

// ---- O-ring groove ----
oring_groove_width   = 1.5;
oring_groove_depth   = 0.75;
oring_cs             = 1.0;

// ---- Tolerances ----
printer_tolerance    = 0.2;
