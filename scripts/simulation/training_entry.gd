class_name TrainingEntry
extends RefCounted

var job_id: StringName # Stores the specialization the trainee will receive.
var remaining_seconds: float # Stores time remaining before the trainee becomes available.

func _init(new_job_id: StringName, seconds: float) -> void: # Initializes one queued training operation.
    job_id = new_job_id
    remaining_seconds = seconds
