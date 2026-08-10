class_name ConstructionDeliveryEvent
extends RefCounted

var resource_id: StringName # Stores the material represented by this one-time throw event.
var site_id: int # Stores the construction site receiving the material.
var target_x: float # Stores the site position so presentation remains valid after immediate completion.
var sequence: int # Stores a deterministic sequence used to vary throw visuals.

func _init(new_resource_id: StringName, new_site_id: int, new_target_x: float, new_sequence: int) -> void: # Initializes one construction material delivery event.
    resource_id = new_resource_id
    site_id = new_site_id
    target_x = new_target_x
    sequence = new_sequence
