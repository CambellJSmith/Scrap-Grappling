class_name ScraplingSwarmView
extends Node2D

const MAX_VISIBLE_SCRAPLINGS: int = 260 # Caps individual display agents while simulation population remains unrestricted.

var _game_state: GameState # Stores the simulation source read by the swarm renderer.
var _agents: Array[ScraplingVisualAgent] = [] # Stores lightweight side-on visual agents without per-scrapling nodes.
var _movement: ScraplingSideMovement = ScraplingSideMovement.new() # Owns horizontal walking and vertical jumping for visible agents.
var _visual_time: float = 0.0 # Drives the two-frame profile walking animation.
var _last_job_signature: String = "" # Avoids rebuilding visual job assignments unless workforce counts change.

func setup(game_state: GameState) -> void: # Supplies the authoritative game state after scene construction.
    _game_state = game_state
    _sync_agents(true)

func _process(delta: float) -> void: # Advances side-on motion and queues one batched redraw for the entire visible swarm.
    if _game_state == null:
        return
    _visual_time += delta
    _sync_agents(false)
    for index: int in range(_agents.size()):
        var agent: ScraplingVisualAgent = _agents[index]
        if _movement.update(agent, delta):
            _assign_next_target(agent, index)
    queue_redraw()

func _sync_agents(force: bool) -> void: # Rebuilds only the cheap visual representation when population or job composition changes.
    var signature: String = _create_job_signature()
    if not force and signature == _last_job_signature:
        return
    _last_job_signature = signature
    var desired_jobs: Array[StringName] = []
    for job_id: StringName in JobIds.ordered():
        var count: int = _game_state.workforce.get_count(job_id)
        var remaining_visual_slots: int = MAX_VISIBLE_SCRAPLINGS - desired_jobs.size()
        var visible_for_job: int = mini(count, remaining_visual_slots)
        for ignored_index: int in range(visible_for_job):
            desired_jobs.append(job_id)
        if desired_jobs.size() >= MAX_VISIBLE_SCRAPLINGS:
            break
    while _agents.size() < desired_jobs.size():
        var index: int = _agents.size()
        var phase: float = float((index * 37) % 100) / 100.0
        var start_x: float = 166.0 + float((index * 13) % 230)
        var start: Vector2 = Vector2(start_x, SideViewLayout.SCRAPLING_GROUND_Y)
        var agent: ScraplingVisualAgent = ScraplingVisualAgent.new(start, JobIds.GENERAL, phase, 14.0 + float(index % 6))
        _agents.append(agent)
        _assign_next_target(agent, index)
    while _agents.size() > desired_jobs.size():
        _agents.pop_back()
    for index: int in range(desired_jobs.size()):
        var agent: ScraplingVisualAgent = _agents[index]
        if agent.job_id != desired_jobs[index]:
            agent.job_id = desired_jobs[index]
            _assign_next_target(agent, index)

func _assign_next_target(agent: ScraplingVisualAgent, index: int) -> void: # Assigns a destination at an active construction site or actual player-placed workplace.
    agent.target_visit += 1
    agent.target_x = ScraplingTargetResolver.target_x(_game_state, agent.job_id, index, agent.target_visit)

func _create_job_signature() -> String: # Creates a compact workforce signature used to detect presentation changes.
    var parts: PackedStringArray = PackedStringArray()
    for job_id: StringName in JobIds.ordered():
        parts.append(String(job_id) + ":" + str(_game_state.workforce.get_count(job_id)))
    return "|".join(parts)

func _draw() -> void: # Draws every visible scrapling in strict profile from a few pixel rectangles.
    for index: int in range(_agents.size()):
        _draw_scrapling(_agents[index], index)

func _draw_scrapling(agent: ScraplingVisualAgent, index: int) -> void: # Draws one side-facing scrapling with walking legs or tucked jumping legs.
    var base: Vector2 = agent.position.floor()
    var is_airborne: bool = agent.position.y < SideViewLayout.SCRAPLING_GROUND_Y - 0.25
    var is_walking: bool = absf(agent.target_x - agent.position.x) > 1.0
    var foot_offset: float = 0.0
    if is_walking and not is_airborne and int(floor(_visual_time * 6.0 + float(index))) % 2 == 0:
        foot_offset = 1.0
    _draw_profile_rect(base, Rect2(1.0, 0.0, 4.0, 4.0), agent.facing_right, PixelPalette.LIGHT)
    _draw_profile_rect(base, Rect2(5.0, 2.0, 1.0, 1.0), agent.facing_right, PixelPalette.LIGHT)
    _draw_profile_rect(base, Rect2(4.0, 1.0, 1.0, 1.0), agent.facing_right, PixelPalette.INK)
    _draw_profile_rect(base, Rect2(1.0, 4.0, 4.0, 4.0), agent.facing_right, PixelPalette.LIGHT)
    if is_airborne:
        _draw_profile_rect(base, Rect2(1.0, 8.0, 2.0, 1.0), agent.facing_right, PixelPalette.LIGHT)
        _draw_profile_rect(base, Rect2(4.0, 8.0, 2.0, 1.0), agent.facing_right, PixelPalette.LIGHT)
    else:
        _draw_profile_rect(base, Rect2(1.0, 8.0 + foot_offset, 1.0, 2.0), agent.facing_right, PixelPalette.LIGHT)
        _draw_profile_rect(base, Rect2(4.0, 8.0 - foot_offset, 1.0, 2.0), agent.facing_right, PixelPalette.LIGHT)
    _draw_job_pixels(base, agent.job_id, agent.facing_right)

func _draw_profile_rect(base: Vector2, local_rect: Rect2, facing_right: bool, color: Color) -> void: # Mirrors one pixel rectangle horizontally so every scrapling remains a true side profile.
    var draw_position: Vector2 = local_rect.position
    if not facing_right:
        draw_position.x = 6.0 - local_rect.position.x - local_rect.size.x
    draw_rect(Rect2(base + draw_position, local_rect.size), color, true)

func _draw_job_pixels(base: Vector2, job_id: StringName, facing_right: bool) -> void: # Adds minimal profile-view equipment pixels so occupations remain readable.
    if job_id == JobIds.MINER:
        _draw_profile_rect(base, Rect2(-2.0, 2.0, 3.0, 1.0), facing_right, PixelPalette.IRON_LIGHT)
        _draw_profile_rect(base, Rect2(-1.0, 1.0, 1.0, 5.0), facing_right, PixelPalette.WOOD)
    elif job_id == JobIds.LUMBERJACK:
        _draw_profile_rect(base, Rect2(6.0, 2.0, 1.0, 5.0), facing_right, PixelPalette.WOOD_LIGHT)
        _draw_profile_rect(base, Rect2(5.0, 1.0, 3.0, 2.0), facing_right, PixelPalette.IRON)
    elif job_id == JobIds.REFINER:
        _draw_profile_rect(base, Rect2(0.0, -1.0, 6.0, 1.0), facing_right, PixelPalette.IRON)
    elif job_id == JobIds.SMITH:
        _draw_profile_rect(base, Rect2(6.0, 1.0, 3.0, 2.0), facing_right, PixelPalette.IRON_LIGHT)
        _draw_profile_rect(base, Rect2(7.0, 3.0, 1.0, 4.0), facing_right, PixelPalette.WOOD)
    elif job_id == JobIds.HAULER:
        _draw_profile_rect(base, Rect2(1.0, -3.0, 4.0, 2.0), facing_right, PixelPalette.IRON_LIGHT)
    elif job_id == JobIds.SCHOLAR:
        _draw_profile_rect(base, Rect2(3.0, 1.0, 2.0, 1.0), facing_right, PixelPalette.RESEARCH)
    elif job_id == JobIds.ENGINEER:
        _draw_profile_rect(base, Rect2(0.0, -1.0, 6.0, 2.0), facing_right, PixelPalette.ELECTRIC)
