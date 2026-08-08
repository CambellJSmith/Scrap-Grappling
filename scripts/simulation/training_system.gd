class_name TrainingSystem
extends RefCounted

var _queue: Array[TrainingEntry] = [] # Stores trainees currently unavailable while learning a specialization.

func can_start(definition: TrainingDefinition, settlement: Settlement, research: ResearchSystem, workforce: Workforce, inventory: Inventory) -> bool: # Validates facility, research, population, cost, and training-slot requirements.
    if settlement.get_count(definition.facility_id) <= 0:
        return false
    if not research.is_completed(definition.required_research):
        return false
    if workforce.get_count(JobIds.GENERAL) <= 0:
        return false
    if not inventory.has_cost(definition.cost):
        return false
    return _queue.size() < training_capacity(settlement)

func start(definition: TrainingDefinition, settlement: Settlement, research: ResearchSystem, workforce: Workforce, inventory: Inventory) -> bool: # Moves one general scrapling into a paid training course.
    if not can_start(definition, settlement, research, workforce, inventory):
        return false
    if not inventory.spend(definition.cost):
        return false
    if not workforce.remove(JobIds.GENERAL, 1):
        return false
    _queue.append(TrainingEntry.new(definition.job_id, definition.seconds))
    return true

func tick(delta: float, workforce: Workforce) -> void: # Advances every active course and returns completed trainees to the workforce.
    var index: int = _queue.size() - 1
    while index >= 0:
        var entry: TrainingEntry = _queue[index]
        entry.remaining_seconds -= delta
        if entry.remaining_seconds <= 0.0:
            workforce.add(entry.job_id, 1)
            _queue.remove_at(index)
        index -= 1

func training_capacity(settlement: Settlement) -> int: # Calculates simultaneous training slots from training infrastructure.
    var basic_slots: int = settlement.get_count(BuildingIds.TRAINING_YARD) * 2
    var university_slots: int = settlement.get_count(BuildingIds.UNIVERSITY) * 3
    return basic_slots + university_slots

func queued_count() -> int: # Returns the number of scraplings currently training.
    return _queue.size()

func queued_for(job_id: StringName) -> int: # Returns how many active courses will produce one job.
    var count: int = 0
    for entry: TrainingEntry in _queue:
        if entry.job_id == job_id:
            count += 1
    return count
