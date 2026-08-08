class_name BuildingView
extends Node2D

var _game_state: GameState # Stores the simulation source used to determine completed positioned buildings.
var _last_signature: String = "" # Avoids redraw work when completed building positions have not changed.

func setup(game_state: GameState) -> void: # Supplies the authoritative settlement state after scene construction.
    _game_state = game_state
    queue_redraw()

func _process(_delta: float) -> void: # Redraws the completed building layer only when settlement composition changes.
    if _game_state == null:
        return
    var signature: String = _building_signature()
    if signature != _last_signature:
        _last_signature = signature
        queue_redraw()

func _building_signature() -> String: # Creates a compact signature containing type and world position for every completed building.
    var parts: PackedStringArray = PackedStringArray()
    for placed: PlacedBuilding in _game_state.settlement.instances():
        parts.append(String(placed.building_id) + ":" + str(placed.x))
    return "|".join(parts)

func _draw() -> void: # Draws every completed building at the exact position chosen by the player.
    if _game_state == null:
        return
    for placed: PlacedBuilding in _game_state.settlement.instances():
        BuildingPixelArt.draw_building(self, placed.building_id, Vector2(placed.x, SideViewLayout.GROUND_Y))
