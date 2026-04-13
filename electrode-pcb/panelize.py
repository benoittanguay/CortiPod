#!/usr/bin/env python3
"""
Panelize CortiPod dual electrode: 4x3 grid with V-score lines.
Uses KiCad 10 pcbnew API.

JLCPCB V-cut minimum panel size: 70mm x 70mm.
Panel uses 2mm breakaway rails on top and bottom to meet the
70mm height requirement while keeping cell positions unchanged
for stencil compatibility.
"""
import pcbnew
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
src_path = os.path.join(script_dir, "cortipod-electrode.kicad_pcb")
dst_path = os.path.join(script_dir, "cortipod-electrode-panel.kicad_pcb")

COLS, ROWS = 4, 3
CELL_W = pcbnew.FromMM(22.0)
CELL_H = pcbnew.FromMM(22.0)
RAIL_H = pcbnew.FromMM(3.0)  # breakaway rails (JLCPCB minimum edge rail: 3mm)

panel = pcbnew.LoadBoard(src_path)

# Find source board origin from Edge.Cuts bounding box
bb = panel.GetBoardEdgesBoundingBox()
src_x, src_y = bb.GetX(), bb.GetY()

# Cell area dimensions (unchanged from original)
cell_area_w = COLS * CELL_W
cell_area_h = ROWS * CELL_H

# Total panel with rails
panel_w = cell_area_w
panel_h = cell_area_h + 2 * RAIL_H  # 66 + 6 = 72mm

# Panel placement centered on A4; cell area offset by top rail
panel_x = pcbnew.FromMM((297.0 - pcbnew.ToMM(panel_w)) / 2.0)
panel_y = pcbnew.FromMM((210.0 - pcbnew.ToMM(panel_h)) / 2.0)
# Cell area starts after top rail
cell_area_x = panel_x
cell_area_y = panel_y + RAIL_H

dx_base = cell_area_x - src_x
dy_base = cell_area_y - src_y

# Remove existing Edge.Cuts, Dwgs.User, Cmts.User graphics
to_remove = [d for d in panel.GetDrawings()
             if d.GetLayer() in (pcbnew.Edge_Cuts, pcbnew.Dwgs_User, pcbnew.Cmts_User)]
for item in to_remove:
    panel.Remove(item)

# Move existing content (cell 0,0) to panel position
for fp in panel.GetFootprints():
    p = fp.GetPosition()
    fp.SetPosition(pcbnew.VECTOR2I(p.x + dx_base, p.y + dy_base))

for trk in panel.GetTracks():
    if isinstance(trk, pcbnew.PCB_VIA):
        p = trk.GetPosition()
        trk.SetPosition(pcbnew.VECTOR2I(p.x + dx_base, p.y + dy_base))
    else:
        s, e = trk.GetStart(), trk.GetEnd()
        trk.SetStart(pcbnew.VECTOR2I(s.x + dx_base, s.y + dy_base))
        trk.SetEnd(pcbnew.VECTOR2I(e.x + dx_base, e.y + dy_base))

# Snapshot the cell (0,0) items for cloning
fps_orig = list(panel.GetFootprints())
trks_orig = list(panel.GetTracks())

# Clone to remaining cells
for row in range(ROWS):
    for col in range(COLS):
        if row == 0 and col == 0:
            continue
        dx, dy = col * CELL_W, row * CELL_H
        idx = row * COLS + col + 1

        for fp in fps_orig:
            clone = pcbnew.FOOTPRINT(fp)  # copy constructor
            p = clone.GetPosition()
            clone.SetPosition(pcbnew.VECTOR2I(p.x + dx, p.y + dy))
            clone.SetReference(f"{fp.GetReference()}_{idx}")
            panel.Add(clone)

        for trk in trks_orig:
            clone = trk.Duplicate()
            if isinstance(trk, pcbnew.PCB_VIA):
                p = clone.GetStart()
                clone.SetPosition(pcbnew.VECTOR2I(p.x + dx, p.y + dy))
            else:
                s, e = clone.GetStart(), clone.GetEnd()
                clone.SetStart(pcbnew.VECTOR2I(s.x + dx, s.y + dy))
                clone.SetEnd(pcbnew.VECTOR2I(e.x + dx, e.y + dy))
            panel.Add(clone)

# Panel outline (Edge.Cuts) — includes rails
px, py = panel_x, panel_y
for (x1,y1),(x2,y2) in [
    ((px,py),(px+panel_w,py)),
    ((px+panel_w,py),(px+panel_w,py+panel_h)),
    ((px+panel_w,py+panel_h),(px,py+panel_h)),
    ((px,py+panel_h),(px,py))]:
    line = pcbnew.PCB_SHAPE(panel)
    line.SetShape(pcbnew.SHAPE_T_SEGMENT)
    line.SetStart(pcbnew.VECTOR2I(x1,y1))
    line.SetEnd(pcbnew.VECTOR2I(x2,y2))
    line.SetLayer(pcbnew.Edge_Cuts)
    line.SetWidth(pcbnew.FromMM(0.05))
    panel.Add(line)

# V-score lines (Cmts.User)
# Vertical: between columns (unchanged)
for col in range(1, COLS):
    x = px + col * CELL_W
    line = pcbnew.PCB_SHAPE(panel)
    line.SetShape(pcbnew.SHAPE_T_SEGMENT)
    line.SetStart(pcbnew.VECTOR2I(x, py))
    line.SetEnd(pcbnew.VECTOR2I(x, py + panel_h))
    line.SetLayer(pcbnew.Cmts_User)
    line.SetWidth(pcbnew.FromMM(0.15))
    panel.Add(line)

# Horizontal: top rail boundary, between rows, bottom rail boundary
for i in range(ROWS + 1):
    y = cell_area_y + i * CELL_H
    line = pcbnew.PCB_SHAPE(panel)
    line.SetShape(pcbnew.SHAPE_T_SEGMENT)
    line.SetStart(pcbnew.VECTOR2I(px, y))
    line.SetEnd(pcbnew.VECTOR2I(px + panel_w, y))
    line.SetLayer(pcbnew.Cmts_User)
    line.SetWidth(pcbnew.FromMM(0.15))
    panel.Add(line)

# Label
txt = pcbnew.PCB_TEXT(panel)
txt.SetText(f"CortiPod Electrode Panel {COLS}x{ROWS} = {COLS*ROWS} cells + rails - V-SCORE at marked lines")
txt.SetPosition(pcbnew.VECTOR2I(px + panel_w // 2, py - pcbnew.FromMM(3)))
txt.SetLayer(pcbnew.Cmts_User)
txt.SetTextSize(pcbnew.VECTOR2I(pcbnew.FromMM(1.0), pcbnew.FromMM(1.0)))
txt.SetTextThickness(pcbnew.FromMM(0.15))
panel.Add(txt)

panel.Save(dst_path)
print(f"Panel saved: {dst_path}")
print(f"Total panel: {pcbnew.ToMM(panel_w):.0f}mm x {pcbnew.ToMM(panel_h):.0f}mm (meets 70x70mm V-cut minimum)")
print(f"Cell area:   {pcbnew.ToMM(cell_area_w):.0f}mm x {pcbnew.ToMM(cell_area_h):.0f}mm")
print(f"Rails:       {pcbnew.ToMM(RAIL_H):.0f}mm top + {pcbnew.ToMM(RAIL_H):.0f}mm bottom (breakaway)")
print(f"Cells: {COLS}x{ROWS} = {COLS*ROWS}")
print(f"Cell positions unchanged — stencils remain compatible")
