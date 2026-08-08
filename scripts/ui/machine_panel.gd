class_name MachinePanel
extends VBoxContainer

var _game_state: GameState # Stores the simulation source displayed by the machine requirement panel.
var _label: Label # Stores the editor-created machine status label.
var _delivery_button: ActionButton # Stores the direct-action control used to pause or resume machine material spending.
var _refresh_accumulator: float = 0.0 # Limits requirement string rebuilding frequency.

func setup(game_state: GameState, label: Label) -> void: # Supplies game state and the editor-created status label.
    _game_state = game_state
    _label = label
    _delivery_button = ActionButton.new()
    _delivery_button.setup("", Callable(self, "_toggle_delivery"))
    add_child(_delivery_button)
    _refresh()

func _process(delta: float) -> void: # Refreshes machine requirements at a modest cadence.
    if _game_state == null:
        return
    _refresh_accumulator += delta
    if _refresh_accumulator < 0.2:
        return
    _refresh_accumulator = 0.0
    _refresh()

func _refresh() -> void: # Displays the active stage and exact delivered component requirements.
    if _game_state.machine.is_complete():
        _label.text = "machine complete\nfor now."
        _delivery_button.text = "construction complete"
        _delivery_button.disabled = true
        return
    var stage: MachineStageDefinition = _game_state.machine.current_stage()
    var requirements: PackedStringArray = PackedStringArray()
    for resource_id: StringName in stage.requirements:
        requirements.append(ResourceIds.display_name(resource_id) + " " + str(_game_state.machine.delivered_amount(resource_id)) + "/" + str(stage.requirements[resource_id]))
    _label.text = "machine: " + stage.display_name + "\n" + "   ".join(requirements)
    _delivery_button.disabled = false
    if _game_state.machine_delivery_enabled:
        _delivery_button.text = "pause machine deliveries"
    else:
        _delivery_button.text = "resume machine deliveries"

func _toggle_delivery() -> void: # Changes whether the central machine may consume manufactured resources.
    _game_state.toggle_machine_delivery()
    _refresh()
