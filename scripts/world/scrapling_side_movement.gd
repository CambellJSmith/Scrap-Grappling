class_name ScraplingSideMovement
extends RefCounted

const GRAVITY: float = 118.0 # Defines downward acceleration for visible scrapling hops.
const BASE_JUMP_SPEED: float = 43.0 # Defines the upward launch speed used for profile-view jumping.
const TARGET_EPSILON: float = 0.75 # Defines how close a scrapling must be before reaching a horizontal destination.

func update(agent: ScraplingVisualAgent, delta: float) -> bool: # Advances one lightweight visual agent and reports whether it reached its horizontal target.
    var distance_to_target: float = agent.target_x - agent.position.x
    var reached_target: bool = absf(distance_to_target) <= TARGET_EPSILON
    var movement_direction: float = 0.0
    if not reached_target:
        movement_direction = signf(distance_to_target)
        agent.facing_right = movement_direction > 0.0
        agent.position.x = move_toward(agent.position.x, agent.target_x, agent.speed * delta)
    _update_jump(agent, delta, movement_direction != 0.0)
    return reached_target

func _update_jump(agent: ScraplingVisualAgent, delta: float, is_moving: bool) -> void: # Applies vertical-only gravity and periodic hops while preserving one shared ground plane.
    agent.jump_cooldown = maxf(agent.jump_cooldown - delta, 0.0)
    var on_ground: bool = agent.position.y >= SideViewLayout.SCRAPLING_GROUND_Y
    if on_ground:
        agent.position.y = SideViewLayout.SCRAPLING_GROUND_Y
        agent.vertical_velocity = 0.0
        if is_moving and agent.jump_cooldown <= 0.0:
            _start_jump(agent)
            return
    agent.vertical_velocity += GRAVITY * delta
    agent.position.y += agent.vertical_velocity * delta
    if agent.position.y > SideViewLayout.SCRAPLING_GROUND_Y:
        agent.position.y = SideViewLayout.SCRAPLING_GROUND_Y
        agent.vertical_velocity = 0.0

func _start_jump(agent: ScraplingVisualAgent) -> void: # Starts a deterministic hop and spaces later hops so the swarm does not synchronize.
    var jump_variation: float = float((agent.jump_count + int(agent.phase * 10.0)) % 4) * 2.0
    agent.vertical_velocity = -(BASE_JUMP_SPEED + jump_variation)
    agent.jump_count += 1
    agent.jump_cooldown = 0.8 + agent.phase * 1.1 + float(agent.jump_count % 3) * 0.18
