class_name MachineStageDefinition
extends RefCounted

var id: StringName # Stores the stable construction-stage identifier.
var display_name: String # Stores the player-facing stage name.
var requirements: Dictionary[StringName, int] # Stores components that must be thrown at the machine.
var description: String # Stores a concise description of the stage being assembled.

func _init(new_id: StringName, new_display_name: String, new_requirements: Dictionary[StringName, int], new_description: String) -> void: # Initializes reusable machine-stage data.
    id = new_id
    display_name = new_display_name
    requirements = new_requirements
    description = new_description
