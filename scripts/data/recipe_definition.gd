class_name RecipeDefinition
extends RefCounted

var id: StringName # Stores the stable recipe identifier.
var building_id: StringName # Stores the building that can execute the recipe.
var required_job: StringName # Stores the worker specialization required by the recipe.
var inputs: Dictionary[StringName, int] # Stores resources consumed by each production cycle.
var outputs: Dictionary[StringName, int] # Stores resources created by each production cycle.
var seconds_per_cycle: float # Stores the base duration of one worker production cycle.

func _init(new_id: StringName, new_building_id: StringName, new_required_job: StringName, new_inputs: Dictionary[StringName, int], new_outputs: Dictionary[StringName, int], new_seconds_per_cycle: float) -> void: # Initializes immutable-style recipe data.
    id = new_id
    building_id = new_building_id
    required_job = new_required_job
    inputs = new_inputs
    outputs = new_outputs
    seconds_per_cycle = new_seconds_per_cycle
