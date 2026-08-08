class_name BuildPanel
extends VBoxContainer

var _game_state: GameState # Stores the simulation source modified by construction actions.
var _button_container: VBoxContainer # Stores editor-backed UI layout receiving generated action buttons.
var _buttons: Dictionary[StringName, ActionButton] = {} # Stores one reusable action button per building definition.
var _refresh_accumulator: float = 0.0 # Limits button text and enabled-state updates.

func setup(game_state: GameState, button_container: VBoxContainer) -> void: # Supplies game state and populates the editor-created button container.
    _game_state = game_state
    _button_container = button_container
    _create_buttons()
    _refresh()

func _process(delta: float) -> void: # Refreshes affordability and lock state without signals or per-frame reconstruction.
    if _game_state == null:
        return
    _refresh_accumulator += delta
    if _refresh_accumulator < 0.25:
        return
    _refresh_accumulator = 0.0
    _refresh()

func _create_buttons() -> void: # Creates one small reusable button for every data-defined building.
    for building_id: StringName in _game_state.buildings:
        var button: ActionButton = ActionButton.new()
        button.setup("", Callable(self, "_request_build").bind(building_id))
        _button_container.add_child(button)
        _buttons[building_id] = button

func _refresh() -> void: # Updates building counts, costs, research locks, and affordability.
    for building_id: StringName in _buttons:
        var button: ActionButton = _buttons[building_id]
        var definition: BuildingDefinition = _game_state.buildings[building_id]
        var count: int = _game_state.settlement.get_count(building_id)
        if not _game_state.research.is_completed(definition.required_research):
            button.text = definition.display_name + " [research locked]"
            button.disabled = true
        else:
            button.text = definition.display_name + " x" + str(count) + "\n" + CostFormatter.format(definition.cost)
            button.disabled = not _game_state.can_build(building_id)

func _request_build(building_id: StringName) -> void: # Forwards one construction request to the simulation layer.
    _game_state.try_build(building_id)
    _refresh()
