class_name BuildingPlacementController
extends Node2D

const GRID_SIZE: float = 4.0 # Snaps building placement to the low-resolution pixel grid.

var _game_state: GameState # Stores the simulation target for placed construction sites.
var _building_id: StringName = &"" # Stores the building type currently following the mouse.
var _ghost_x: float = 0.0 # Stores the snapped left edge of the current placement ghost.
var _last_valid: bool = false # Stores whether the current ghost footprint can be placed.

func setup(game_state: GameState) -> void: # Supplies the authoritative state used to validate and create construction sites.
    _game_state = game_state

func begin_placement(building_id: StringName) -> bool: # Starts mouse-following placement for one unlocked building type.
    if _game_state == null or not _game_state.can_place_building_type(building_id):
        return false
    _building_id = building_id
    _update_ghost_position()
    queue_redraw()
    return true

func cancel_placement() -> void: # Clears the active placement ghost without changing simulation state.
    if _building_id == &"":
        return
    _building_id = &""
    queue_redraw()

func is_active() -> bool: # Reports whether world clicks currently belong to building placement rather than camera dragging.
    return _building_id != &""

func _process(_delta: float) -> void: # Keeps the blueprint centered beneath the mouse while placement mode is active.
    if not is_active() or _game_state == null:
        return
    var previous_x: float = _ghost_x
    var previous_valid: bool = _last_valid
    _update_ghost_position()
    if previous_x != _ghost_x or previous_valid != _last_valid:
        queue_redraw()

func _unhandled_input(event: InputEvent) -> void: # Places on left click and cancels on right click or Escape after GUI controls decline the event.
    if not is_active():
        return
    if event is InputEventMouseButton:
        var mouse_button: InputEventMouseButton = event
        if not mouse_button.pressed:
            return
        if mouse_button.button_index == MOUSE_BUTTON_RIGHT:
            cancel_placement()
            get_viewport().set_input_as_handled()
            return
        if mouse_button.button_index == MOUSE_BUTTON_LEFT:
            if _last_valid and _game_state.try_place_building(_building_id, _ghost_x):
                cancel_placement()
            get_viewport().set_input_as_handled()
            return
    if event is InputEventKey:
        var key_event: InputEventKey = event
        if key_event.pressed and key_event.keycode == KEY_ESCAPE:
            cancel_placement()
            get_viewport().set_input_as_handled()

func _update_ghost_position() -> void: # Converts the camera-aware mouse position into a centered, grid-snapped building footprint.
    var definition: BuildingDefinition = _game_state.buildings[_building_id]
    var pointer_x: float = get_global_mouse_position().x - float(definition.footprint_width) * 0.5
    var snapped_x: float = round(pointer_x / GRID_SIZE) * GRID_SIZE
    _ghost_x = clampf(snapped_x, SideViewLayout.BUILDABLE_MIN_X, SideViewLayout.BUILDABLE_MAX_X - float(definition.footprint_width))
    _last_valid = _game_state.can_place_building_at(_building_id, _ghost_x)

func _draw() -> void: # Draws the exact building silhouette translucently at ground level beneath the mouse.
    if not is_active() or _game_state == null:
        return
    var tint: Color = Color(1.0, 1.0, 1.0, 0.45)
    if not _last_valid:
        tint = Color(1.0, 0.35, 0.35, 0.55)
    BuildingPixelArt.draw_building(self, _building_id, Vector2(_ghost_x, SideViewLayout.GROUND_Y), tint)
