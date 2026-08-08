class_name ScraplingVisualAgent
extends RefCounted

var position: Vector2 # Stores the current simulated display position for one visible scrapling.
var target: Vector2 # Stores the point this scrapling is currently walking toward.
var job_id: StringName # Stores the visual occupation represented by equipment pixels.
var phase: float # Stores deterministic movement variation used to avoid synchronized motion.
var speed: float # Stores the display movement rate for this visible scrapling.

func _init(new_position: Vector2, new_job_id: StringName, new_phase: float, new_speed: float) -> void: # Initializes one lightweight visual scrapling agent.
    position = new_position
    target = new_position
    job_id = new_job_id
    phase = new_phase
    speed = new_speed
