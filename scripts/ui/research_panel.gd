class_name ResearchPanel
extends VBoxContainer

var _game_state: GameState # Stores the simulation source modified by research actions.
var _button_container: VBoxContainer # Stores editor-backed layout receiving research buttons.
var _buttons: Dictionary[StringName, ActionButton] = {} # Stores one research action per research definition.
var _refresh_accumulator: float = 0.0 # Limits lock and affordability refresh frequency.

func setup(game_state: GameState, button_container: VBoxContainer) -> void: # Supplies state and populates the editor-created research list.
    _game_state = game_state
    _button_container = button_container
    _create_buttons()
    _refresh()

func _process(delta: float) -> void: # Refreshes research state at a low cadence.
    if _game_state == null:
        return
    _refresh_accumulator += delta
    if _refresh_accumulator < 0.25:
        return
    _refresh_accumulator = 0.0
    _refresh()

func _create_buttons() -> void: # Creates direct-action buttons from the research data catalog.
    for research_id: StringName in _game_state.research_definitions:
        var button: ActionButton = ActionButton.new()
        button.setup("", Callable(self, "_request_research").bind(research_id))
        _button_container.add_child(button)
        _buttons[research_id] = button

func _refresh() -> void: # Updates completion, prerequisite, university, and cost state for every research action.
    for research_id: StringName in _buttons:
        var button: ActionButton = _buttons[research_id]
        var definition: ResearchDefinition = _game_state.research_definitions[research_id]
        if _game_state.research.is_completed(research_id):
            button.text = definition.display_name + " [done]"
            button.disabled = true
        elif _game_state.settlement.get_count(BuildingIds.UNIVERSITY) <= 0:
            button.text = definition.display_name + " [needs university]"
            button.disabled = true
        elif not _game_state.research.prerequisites_met(definition):
            button.text = definition.display_name + " [prerequisite]"
            button.disabled = true
        else:
            button.text = definition.display_name + "\n" + CostFormatter.format(definition.cost)
            button.disabled = not _game_state.can_research(research_id)

func _request_research(research_id: StringName) -> void: # Forwards one research request to the simulation layer.
    _game_state.try_research(research_id)
    _refresh()
