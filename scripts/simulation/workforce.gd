class_name Workforce
extends RefCounted

var _counts: Dictionary[StringName, int] = {} # Stores population counts grouped by occupational specialization.

func _init(starting_general: int) -> void: # Creates the initial untrained population.
    _counts[JobIds.GENERAL] = maxi(starting_general, 0)

func get_count(job_id: StringName) -> int: # Returns the number of scraplings assigned to one job.
    return int(_counts.get(job_id, 0))

func add(job_id: StringName, amount: int) -> void: # Adds scraplings to one occupational group.
    if amount <= 0:
        return
    _counts[job_id] = get_count(job_id) + amount

func remove(job_id: StringName, amount: int) -> bool: # Removes scraplings from one occupational group when enough exist.
    if amount <= 0:
        return true
    if get_count(job_id) < amount:
        return false
    _counts[job_id] = get_count(job_id) - amount
    return true

func total_population() -> int: # Returns the complete population including scraplings currently working in every job.
    var total: int = 0
    for job_id: StringName in _counts:
        total += _counts[job_id]
    return total

func snapshot() -> Dictionary[StringName, int]: # Returns a detached workforce copy for presentation or saving.
    return _counts.duplicate()
