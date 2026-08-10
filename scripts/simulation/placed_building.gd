class_name PlacedBuilding
extends RefCounted

var building_id: StringName # Stores the stable building type for one completed world structure.
var x: float # Stores the left edge of the completed building on the side-on world axis.

func _init(new_building_id: StringName, new_x: float) -> void: # Initializes one completed building instance.
    building_id = new_building_id
    x = new_x
