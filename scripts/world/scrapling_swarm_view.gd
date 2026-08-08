class_name ScraplingSwarmView
extends Node2D

const MAX_VISIBLE_SCRAPLINGS: int = 260 # Caps expensive individual display agents while simulation population remains unrestricted.

var _game_state: GameState # Stores the simulation source read by the swarm renderer.
var _agents: Array[ScraplingVisualAgent] = [] # Stores lightweight visual agents without physics nodes.
var _visual_time: float = 0.0 # Drives deterministic target variation and two-frame walking animation.
var _last_job_signature: String = "" # Avoids rebuilding visual job assignments unless workforce counts change.

func setup(game_state: GameState) -> void: # Supplies the authoritative game state after scene construction.
    _game_state = game_state
    _sync_agents(true)

func _process(delta: float) -> void: # Updates lightweight agent positions and queues one batched redraw for the entire swarm.
    if _game_state == null:
        return
    _visual_time += delta
    _sync_agents(false)
    for index: int in range(_agents.size()):
        var agent: ScraplingVisualAgent = _agents[index]
        if agent.position.distance_squared_to(agent.target) < 9.0:
            agent.target = _target_for(agent.job_id, index, agent.phase)
        agent.position = agent.position.move_toward(agent.target, agent.speed * delta)
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
        var start: Vector2 = Vector2(188.0 + float((index * 13) % 92), 236.0 + float((index * 11) % 38))
        _agents.append(ScraplingVisualAgent.new(start, JobIds.GENERAL, phase, 14.0 + float(index % 6)))
    while _agents.size() > desired_jobs.size():
        _agents.pop_back()
    for index: int in range(desired_jobs.size()):
        _agents[index].job_id = desired_jobs[index]
        if _agents[index].target == _agents[index].position:
            _agents[index].target = _target_for(desired_jobs[index], index, _agents[index].phase)

func _create_job_signature() -> String: # Creates a compact workforce signature used to detect presentation changes.
    var parts: PackedStringArray = PackedStringArray()
    for job_id: StringName in JobIds.ordered():
        parts.append(String(job_id) + ":" + str(_game_state.workforce.get_count(job_id)))
    return "|".join(parts)

func _target_for(job_id: StringName, index: int, phase: float) -> Vector2: # Chooses a job-appropriate activity area without pathfinding or physics overhead.
    var wobble_x: float = sin(_visual_time * 0.7 + phase * TAU) * 11.0
    var wobble_y: float = cos(_visual_time * 0.5 + phase * TAU) * 5.0
    if job_id == JobIds.MINER:
        return Vector2(78.0 + wobble_x, 242.0 + wobble_y)
    if job_id == JobIds.LUMBERJACK:
        return Vector2(42.0 + wobble_x, 240.0 + wobble_y)
    if job_id == JobIds.REFINER:
        return Vector2(220.0 + wobble_x, 240.0 + wobble_y)
    if job_id == JobIds.SMITH:
        return Vector2(265.0 + wobble_x, 238.0 + wobble_y)
    if job_id == JobIds.SCHOLAR:
        return Vector2(305.0 + wobble_x, 220.0 + wobble_y)
    if job_id == JobIds.ENGINEER:
        return Vector2(335.0 + wobble_x, 238.0 + wobble_y)
    if job_id == JobIds.HAULER:
        var lane_offset: float = float(index % 7) * 3.0
        return Vector2(425.0 + wobble_x * 2.0, 241.0 + lane_offset)
    return Vector2(195.0 + wobble_x * 2.0, 235.0 + wobble_y)

func _draw() -> void: # Draws every visible scrapling from a few rectangles with no sprite textures or per-agent CanvasItems.
    for index: int in range(_agents.size()):
        _draw_scrapling(_agents[index], index)

func _draw_scrapling(agent: ScraplingVisualAgent, index: int) -> void: # Draws one tiny occupation-readable scrapling and a two-frame walking offset.
    var base: Vector2 = agent.position.floor()
    var foot_offset: float = 0.0
    if int(floor(_visual_time * 5.0 + float(index))) % 2 == 0:
        foot_offset = 1.0
    draw_rect(Rect2(base + Vector2(1.0, 0.0), Vector2(4.0, 4.0)), PixelPalette.LIGHT, true)
    draw_rect(Rect2(base + Vector2(0.0, 4.0), Vector2(6.0, 4.0)), PixelPalette.LIGHT, true)
    draw_rect(Rect2(base + Vector2(1.0, 8.0 + foot_offset), Vector2(1.0, 2.0)), PixelPalette.LIGHT, true)
    draw_rect(Rect2(base + Vector2(4.0, 8.0 - foot_offset), Vector2(1.0, 2.0)), PixelPalette.LIGHT, true)
    draw_rect(Rect2(base + Vector2(2.0, 1.0), Vector2(1.0, 1.0)), PixelPalette.INK, true)
    draw_rect(Rect2(base + Vector2(4.0, 1.0), Vector2(1.0, 1.0)), PixelPalette.INK, true)
    _draw_job_pixels(base, agent.job_id)

func _draw_job_pixels(base: Vector2, job_id: StringName) -> void: # Adds minimal equipment pixels so occupations remain readable at tiny scale.
    if job_id == JobIds.MINER:
        draw_rect(Rect2(base + Vector2(-2.0, 2.0), Vector2(3.0, 1.0)), PixelPalette.IRON_LIGHT, true)
        draw_rect(Rect2(base + Vector2(-1.0, 1.0), Vector2(1.0, 5.0)), PixelPalette.WOOD, true)
    elif job_id == JobIds.LUMBERJACK:
        draw_rect(Rect2(base + Vector2(6.0, 2.0), Vector2(1.0, 5.0)), PixelPalette.WOOD_LIGHT, true)
        draw_rect(Rect2(base + Vector2(5.0, 1.0), Vector2(3.0, 2.0)), PixelPalette.IRON, true)
    elif job_id == JobIds.REFINER:
        draw_rect(Rect2(base + Vector2(0.0, -1.0), Vector2(6.0, 1.0)), PixelPalette.IRON, true)
    elif job_id == JobIds.SMITH:
        draw_rect(Rect2(base + Vector2(6.0, 1.0), Vector2(3.0, 2.0)), PixelPalette.IRON_LIGHT, true)
        draw_rect(Rect2(base + Vector2(7.0, 3.0), Vector2(1.0, 4.0)), PixelPalette.WOOD, true)
    elif job_id == JobIds.HAULER:
        draw_rect(Rect2(base + Vector2(1.0, -3.0), Vector2(4.0, 2.0)), PixelPalette.IRON_LIGHT, true)
    elif job_id == JobIds.SCHOLAR:
        draw_rect(Rect2(base + Vector2(1.0, 1.0), Vector2(2.0, 1.0)), PixelPalette.RESEARCH, true)
        draw_rect(Rect2(base + Vector2(4.0, 1.0), Vector2(2.0, 1.0)), PixelPalette.RESEARCH, true)
    elif job_id == JobIds.ENGINEER:
        draw_rect(Rect2(base + Vector2(0.0, -1.0), Vector2(6.0, 2.0)), PixelPalette.ELECTRIC, true)
