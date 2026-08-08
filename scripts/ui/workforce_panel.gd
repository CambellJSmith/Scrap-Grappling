class_name WorkforcePanel
extends VBoxContainer

var _game_state: GameState # Stores the simulation source modified by occupational training actions.
var _summary_label: Label # Stores the editor-created population summary label.
var _button_container: VBoxContainer # Stores editor-backed layout receiving training buttons.
var _buttons: Dictionary[StringName, ActionButton] = {} # Stores one training button per trainable job.
var _refresh_accumulator: float = 0.0 # Limits text and enabled-state refresh frequency.

func setup(game_state: GameState, summary_label: Label, button_container: VBoxContainer) -> void: # Supplies state and editor-created child controls before building training actions.
    _game_state = game_state
    _summary_label = summary_label
    _button_container = button_container
    _create_buttons()
    _refresh()

func _process(delta: float) -> void: # Refreshes workforce presentation at a low fixed cadence.
    if _game_state == null:
        return
    _refresh_accumulator += delta
    if _refresh_accumulator < 0.25:
        return
    _refresh_accumulator = 0.0
    _refresh()

func _create_buttons() -> void: # Creates direct-action training buttons from the data catalog.
    for job_id: StringName in _game_state.training_definitions:
        var button: ActionButton = ActionButton.new()
        button.setup("", Callable(self, "_request_training").bind(job_id))
        _button_container.add_child(button)
        _buttons[job_id] = button

func _refresh() -> void: # Updates population totals, job counts, queued trainees, and course availability.
    var occupied: int = _game_state.workforce.total_population() + _game_state.training.queued_count()
    var lines: PackedStringArray = PackedStringArray()
    lines.append("scraplings " + str(occupied) + "/" + str(_game_state.population_capacity()))
    for job_id: StringName in JobIds.ordered():
        var count: int = _game_state.workforce.get_count(job_id)
        if count > 0 or job_id == JobIds.GENERAL:
            lines.append(JobIds.display_name(job_id) + " " + str(count))
    if _game_state.training.queued_count() > 0:
        lines.append("training " + str(_game_state.training.queued_count()))
    _summary_label.text = "\n".join(lines)
    for job_id: StringName in _buttons:
        var button: ActionButton = _buttons[job_id]
        var definition: TrainingDefinition = _game_state.training_definitions[job_id]
        var queued: int = _game_state.training.queued_for(job_id)
        button.text = "train " + JobIds.display_name(job_id) + " (" + str(queued) + ")\n" + CostFormatter.format(definition.cost)
        button.disabled = not _game_state.can_train(job_id)

func _request_training(job_id: StringName) -> void: # Forwards one training request to the simulation layer.
    _game_state.try_train(job_id)
    _refresh()
