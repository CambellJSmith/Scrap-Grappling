class_name MachineView
extends Node2D

var _game_state: GameState # Stores the simulation source used to reveal constructed machine sections.
var _last_stage_index: int = -1 # Tracks stage transitions that require a redraw.
var _last_progress_bucket: int = -1 # Tracks coarse construction progress to avoid unnecessary redraws.

func setup(game_state: GameState) -> void: # Supplies the authoritative machine state after scene construction.
    _game_state = game_state
    queue_redraw()

func _process(_delta: float) -> void: # Redraws only when a stage changes or construction crosses a visible progress bucket.
    if _game_state == null:
        return
    var stage_index: int = _game_state.machine.current_stage_index()
    var progress_bucket: int = int(floor(_game_state.machine.stage_progress_ratio() * 20.0))
    if stage_index != _last_stage_index or progress_bucket != _last_progress_bucket:
        _last_stage_index = stage_index
        _last_progress_bucket = progress_bucket
        queue_redraw()

func _draw() -> void: # Draws the machine as a strict side elevation rooted on the same ground line as the settlement.
    if _game_state == null:
        return
    var completed_stages: int = mini(_game_state.machine.current_stage_index(), _game_state.machine.stage_count())
    for stage_index: int in range(completed_stages):
        _draw_stage(stage_index, 1.0)
    if not _game_state.machine.is_complete():
        _draw_stage(_game_state.machine.current_stage_index(), _game_state.machine.stage_progress_ratio())
    else:
        _draw_active_pixels()

func _draw_stage(stage_index: int, progress: float) -> void: # Routes each machine stage to its progressively revealed side-on pixel assembly.
    if stage_index == 0:
        _draw_foundation(progress)
    elif stage_index == 1:
        _draw_frame(progress)
    elif stage_index == 2:
        _draw_drive(progress)
    elif stage_index == 3:
        _draw_controls(progress)

func _draw_foundation(progress: float) -> void: # Reveals a foundation that sits directly on the common world ground line.
    var width: float = floor(112.0 * progress)
    draw_rect(Rect2(SideViewLayout.MACHINE_LEFT_X, SideViewLayout.GROUND_Y - 10.0, width, 8.0), PixelPalette.IRON, true)
    draw_rect(Rect2(SideViewLayout.MACHINE_LEFT_X + 4.0, SideViewLayout.GROUND_Y - 2.0, minf(width, 104.0), 2.0), PixelPalette.INK, true)

func _draw_frame(progress: float) -> void: # Reveals vertical and horizontal structural beams in one side elevation.
    var height: float = floor(92.0 * progress)
    draw_rect(Rect2(478.0, SideViewLayout.GROUND_Y - 10.0 - height, 8.0, height), PixelPalette.IRON_LIGHT, true)
    draw_rect(Rect2(558.0, SideViewLayout.GROUND_Y - 10.0 - height, 8.0, height), PixelPalette.IRON_LIGHT, true)
    if progress > 0.35:
        var top_width: float = floor(80.0 * clampf((progress - 0.35) / 0.65, 0.0, 1.0))
        draw_rect(Rect2(486.0, SideViewLayout.GROUND_Y - 102.0, top_width, 7.0), PixelPalette.IRON, true)

func _draw_drive(progress: float) -> void: # Reveals a large profile-view drive assembly using blocky gears and shafts.
    var radius: float = floor(24.0 * progress)
    if radius <= 0.0:
        return
    draw_circle(Vector2(522.0, SideViewLayout.GROUND_Y - 41.0), radius, PixelPalette.INK)
    draw_circle(Vector2(522.0, SideViewLayout.GROUND_Y - 41.0), maxf(radius - 5.0, 1.0), PixelPalette.NICKEL)
    draw_rect(Rect2(519.0, SideViewLayout.GROUND_Y - 80.0, 6.0, 78.0 * progress), PixelPalette.IRON_LIGHT, true)

func _draw_controls(progress: float) -> void: # Reveals electronic panels across the upper side of the machine.
    var panel_height: float = floor(46.0 * progress)
    draw_rect(Rect2(492.0, SideViewLayout.GROUND_Y - 82.0, 60.0, panel_height), PixelPalette.INK, true)
    if progress > 0.2:
        draw_rect(Rect2(499.0, SideViewLayout.GROUND_Y - 72.0, 3.0, 3.0), PixelPalette.ELECTRIC, true)
    if progress > 0.45:
        draw_rect(Rect2(510.0, SideViewLayout.GROUND_Y - 66.0, 2.0, 2.0), PixelPalette.COBALT, true)
    if progress > 0.7:
        draw_rect(Rect2(541.0, SideViewLayout.GROUND_Y - 74.0, 4.0, 2.0), PixelPalette.ELECTRIC, true)

func _draw_active_pixels() -> void: # Adds restrained profile-view indicator pixels once the prototype machine is fully assembled.
    draw_rect(Rect2(500.0, SideViewLayout.GROUND_Y - 76.0, 3.0, 3.0), PixelPalette.ELECTRIC, true)
    draw_rect(Rect2(541.0, SideViewLayout.GROUND_Y - 69.0, 2.0, 2.0), PixelPalette.COBALT, true)
