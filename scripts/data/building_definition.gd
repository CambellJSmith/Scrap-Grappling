class_name BuildingDefinition
extends RefCounted

var id: StringName # Stores the stable building identifier.
var display_name: String # Stores the player-facing building name.
var category: StringName # Stores the UI grouping used for this building.
var cost: Dictionary[StringName, int] # Stores the resources required to construct one building.
var required_research: StringName # Stores research that must be completed before construction.
var worker_capacity: int # Stores how many matching workers one building can employ.
var housing_capacity: int # Stores population capacity contributed by one building.

func _init(new_id: StringName, new_display_name: String, new_category: StringName, new_cost: Dictionary[StringName, int], new_required_research: StringName, new_worker_capacity: int, new_housing_capacity: int) -> void: # Initializes reusable building data.
    id = new_id
    display_name = new_display_name
    category = new_category
    cost = new_cost
    required_research = new_required_research
    worker_capacity = new_worker_capacity
    housing_capacity = new_housing_capacity
