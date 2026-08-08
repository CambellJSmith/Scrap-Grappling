class_name MachineDeliveryEvent
extends RefCounted

var resource_id: StringName # Stores the component type being visually thrown at the machine.
var sequence: int # Stores a monotonically increasing delivery sequence for deterministic visual variation.

func _init(new_resource_id: StringName, new_sequence: int) -> void: # Initializes one machine-delivery visualization event.
    resource_id = new_resource_id
    sequence = new_sequence
