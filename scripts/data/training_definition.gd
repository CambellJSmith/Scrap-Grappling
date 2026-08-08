class_name TrainingDefinition
extends RefCounted

var job_id: StringName # Stores the job produced by this training course.
var facility_id: StringName # Stores the building required to run the course.
var cost: Dictionary[StringName, int] # Stores materials consumed when training begins.
var seconds: float # Stores training duration before specialization completes.
var required_research: StringName # Stores research required before the course becomes available.

func _init(new_job_id: StringName, new_facility_id: StringName, new_cost: Dictionary[StringName, int], new_seconds: float, new_required_research: StringName) -> void: # Initializes reusable training data.
    job_id = new_job_id
    facility_id = new_facility_id
    cost = new_cost
    seconds = new_seconds
    required_research = new_required_research
