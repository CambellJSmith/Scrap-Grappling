class_name DeliveryVisual
extends RefCounted

var resource_id: StringName # Stores the component type represented by the projectile pixels.
var start: Vector2 # Stores the launch point near the settlement.
var end: Vector2 # Stores the impact point on the machine.
var progress: float = 0.0 # Stores normalized travel progress along the throw arc.
var speed: float # Stores normalized travel speed for this projectile.

func _init(new_resource_id: StringName, new_start: Vector2, new_end: Vector2, new_speed: float) -> void: # Initializes one lightweight component throw visualization.
    resource_id = new_resource_id
    start = new_start
    end = new_end
    speed = new_speed
