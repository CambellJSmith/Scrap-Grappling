class_name BuildPanel
extends VBoxContainer

var _game_state: GameState # Stores the simulation source displayed by construction actions.
var _button_container: Container # Stores editor-backed UI layout receiving generated action buttons.
var _begin_placement: Callable # Starts world placement without coupling this panel to a specific world node type.
var _placement_started: Callable # Lets the composing HUD close itself after a building type is selected.
var _buttons: Dictionary[StringName, ActionButton] = {} # Stores one reusable action button per building definition.
var _refresh_accumulator: float = 0.0 # Limits button text and lock-state updates.

func setup(game_state: GameState, button_container: Container, begin_placement: Callable, placement_started: Callable) -> void: # Supplies state, layout, and reusable placement actions before creating buttons.
    _game_state = game_state
    _button_container = button_container
    _begin_placement = begin_placement
    _placement_started = placement_started
    _create_buttons()
    _refresh()

func _process(delta: float) -> void: # Refreshes completed and queued counts without reconstructing controls.
    if _game_state == null:
        return
    _refresh_accumulator += delta
    if _refresh_accumulator < 0.25:
        return
    _refresh_accumulator = 0.0
    _refresh()

func _create_buttons() -> void: # Creates one small reusable placement button for every data-defined building.
    for building_id: StringName in _game_state.buildings:
        var button: ActionButton = ActionButton.new()
        button.setup("", Callable(self, "_request_placement").bind(building_id))
        _button_container.add_child(button)
        _buttons[building_id] = button

func _refresh() -> void: # Updates completed counts, queued site counts, material requirements, and research locks.
    for building_id: StringName in _buttons:
        var button: ActionButton = _buttons[building_id]
        var definition: BuildingDefinition = _game_state.buildings[building_id]
        var completed_count: int = _game_state.settlement.get_count(building_id)
        var queued_count: int = _game_state.construction.site_count(building_id)
        if not _game_state.research.is_completed(definition.required_research):
            button.text = definition.display_name + " [research locked]"
            button.disabled = true
            continue
        var count_text: String = " x" + str(completed_count)
        if queued_count > 0:
            count_text += " +" + str(queued_count) + " building"
        button.text = "place " + definition.display_name + count_text + "\n" + CostFormatter.format(definition.cost)
        button.disabled = false

func _request_placement(building_id: StringName) -> void: # Starts a ground-level ghost instead of spending materials immediately.
    if not _begin_placement.is_valid():
        return
    var started: bool = bool(_begin_placement.call(building_id))
    if started and _placement_started.is_valid():
        _placement_started.call()
    _refresh()
