class_name ResearchDefinition
extends RefCounted

var id: StringName # Stores the stable research identifier.
var display_name: String # Stores the player-facing research name.
var cost: Dictionary[StringName, int] # Stores resources consumed to complete the research.
var prerequisites: Array[StringName] # Stores research that must already be completed.
var description: String # Stores concise unlock information for the UI.

func _init(new_id: StringName, new_display_name: String, new_cost: Dictionary[StringName, int], new_prerequisites: Array[StringName], new_description: String) -> void: # Initializes reusable research data.
    id = new_id
    display_name = new_display_name
    cost = new_cost
    prerequisites = new_prerequisites
    description = new_description
