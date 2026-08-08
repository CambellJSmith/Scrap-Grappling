class_name MachineSystem
extends RefCounted

var _stages: Array[MachineStageDefinition] # Stores ordered machine construction stages.
var _stage_index: int = 0 # Stores the currently active construction stage index.
var _delivered: Dictionary[StringName, int] = {} # Stores components already accepted for the current stage.
var _delivery_progress: float = 0.0 # Accumulates time until the next component throw can occur.
var _delivery_events: Array[MachineDeliveryEvent] = [] # Stores presentation events waiting for the world renderer.
var _delivery_sequence: int = 0 # Produces deterministic IDs for visual delivery variation.

func _init(stages: Array[MachineStageDefinition]) -> void: # Initializes machine construction with ordered stage definitions.
    _stages = stages

func tick(delta: float, inventory: Inventory, workforce: Workforce, settlement: Settlement) -> void: # Feeds available required components into the machine at the current logistics rate.
    if is_complete():
        return
    _delivery_progress += delta * delivery_rate(workforce, settlement)
    while _delivery_progress >= 1.0:
        var resource_id: StringName = _find_deliverable_resource(inventory)
        if resource_id == &"":
            _delivery_progress = minf(_delivery_progress, 1.0)
            return
        if not inventory.remove(resource_id, 1):
            return
        _delivery_progress -= 1.0
        _delivered[resource_id] = delivered_amount(resource_id) + 1
        _delivery_sequence += 1
        _delivery_events.append(MachineDeliveryEvent.new(resource_id, _delivery_sequence))
        if _stage_is_complete():
            _advance_stage()
            return

func delivery_rate(workforce: Workforce, settlement: Settlement) -> float: # Calculates components thrown per second from haulers and road infrastructure.
    var haulers: int = workforce.get_count(JobIds.HAULER)
    var roads: int = settlement.get_count(BuildingIds.ROAD)
    return 0.45 + float(haulers) * 0.22 + float(roads) * 0.08

func current_stage() -> MachineStageDefinition: # Returns the current construction stage or null after final completion.
    if is_complete():
        return null
    return _stages[_stage_index]

func current_stage_index() -> int: # Returns the zero-based stage index used by the machine renderer.
    return _stage_index

func stage_count() -> int: # Returns the total number of defined construction stages.
    return _stages.size()

func delivered_amount(resource_id: StringName) -> int: # Returns how many components of one type reached the current stage.
    return int(_delivered.get(resource_id, 0))

func required_amount(resource_id: StringName) -> int: # Returns the current-stage requirement for one component type.
    var stage: MachineStageDefinition = current_stage()
    if stage == null:
        return 0
    return int(stage.requirements.get(resource_id, 0))

func stage_progress_ratio() -> float: # Returns total delivered components divided by total current-stage requirements.
    var stage: MachineStageDefinition = current_stage()
    if stage == null:
        return 1.0
    var required_total: int = 0
    var delivered_total: int = 0
    for resource_id: StringName in stage.requirements:
        required_total += stage.requirements[resource_id]
        delivered_total += mini(delivered_amount(resource_id), stage.requirements[resource_id])
    if required_total <= 0:
        return 1.0
    return clampf(float(delivered_total) / float(required_total), 0.0, 1.0)

func consume_delivery_events() -> Array[MachineDeliveryEvent]: # Moves pending delivery events out of simulation for one-time presentation.
    var events: Array[MachineDeliveryEvent] = _delivery_events.duplicate()
    _delivery_events.clear()
    return events

func is_complete() -> bool: # Checks whether every machine stage has been completed.
    return _stage_index >= _stages.size()

func _find_deliverable_resource(inventory: Inventory) -> StringName: # Finds the first still-needed component currently available in inventory.
    var stage: MachineStageDefinition = current_stage()
    if stage == null:
        return &""
    for resource_id: StringName in stage.requirements:
        if delivered_amount(resource_id) >= stage.requirements[resource_id]:
            continue
        if inventory.get_amount(resource_id) > 0:
            return resource_id
    return &""

func _stage_is_complete() -> bool: # Checks whether every requirement for the current stage has been delivered.
    var stage: MachineStageDefinition = current_stage()
    if stage == null:
        return true
    for resource_id: StringName in stage.requirements:
        if delivered_amount(resource_id) < stage.requirements[resource_id]:
            return false
    return true

func _advance_stage() -> void: # Clears stage-local delivery state and reveals the next machine section.
    _stage_index += 1
    _delivered.clear()
    _delivery_progress = 0.0
