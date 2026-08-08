class_name ScraplingVisualAgent
extends RefCounted

var position: Vector2 # Stores the current profile-view position for one visible scrapling.
var target_x: float # Stores the next horizontal destination on the single world axis.
var job_id: StringName # Stores the visual occupation represented by equipment pixels.
var phase: float # Stores deterministic variation used to stagger movement and hopping.
var speed: float # Stores the horizontal display movement rate for this visible scrapling.
var vertical_velocity: float = 0.0 # Stores vertical-only jump velocity without representing depth.
var jump_cooldown: float # Stores the remaining delay before this scrapling may hop again.
var jump_count: int = 0 # Stores deterministic hop variation state for this scrapling.
var target_visit: int = 0 # Stores how many horizontal destinations this scrapling has visited.
var facing_right: bool = true # Stores the profile direction used when drawing the scrapling.

func _init(new_position: Vector2, new_job_id: StringName, new_phase: float, new_speed: float) -> void: # Initializes one lightweight side-on visual scrapling agent.
    position = new_position
    target_x = new_position.x
    job_id = new_job_id
    phase = new_phase
    speed = new_speed
    jump_cooldown = 0.35 + new_phase * 1.4
