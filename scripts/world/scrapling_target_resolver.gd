class_name ScraplingTargetResolver
extends RefCounted

static func target_x(game_state: GameState, job_id: StringName, index: int, visit: int) -> float: # Resolves one visible scrapling destination from placed construction sites or completed workplaces.
    if job_id == JobIds.GENERAL or job_id == JobIds.HAULER:
        var construction_target: float = _construction_target(game_state, index, visit)
        if construction_target >= 0.0:
            return construction_target
    var workplace_target: float = _workplace_target(game_state, job_id, index, visit)
    if workplace_target >= 0.0:
        return workplace_target
    return SideViewLayout.fallback_target_x(job_id, index, visit)

static func _construction_target(game_state: GameState, index: int, visit: int) -> float: # Sends general workers and haulers near active blueprints while materials are being delivered.
    var sites: Array[ConstructionSite] = game_state.construction.sites()
    if sites.is_empty():
        return -1.0
    var site: ConstructionSite = sites[(index + visit) % sites.size()]
    var offset_step: int = (index * 5 + visit * 3) % 7
    var offset: float = float(offset_step - 3) * 4.0
    return clampf(site.x + offset, SideViewLayout.SETTLEMENT_MIN_X, SideViewLayout.SETTLEMENT_MAX_X)

static func _workplace_target(game_state: GameState, job_id: StringName, index: int, visit: int) -> float: # Sends specialized workers to the actual player-placed buildings that can employ them.
    var accepted_ids: Array[StringName] = _building_ids_for_job(job_id)
    if accepted_ids.is_empty():
        return -1.0
    var matches: Array[PlacedBuilding] = []
    for placed: PlacedBuilding in game_state.settlement.instances():
        if accepted_ids.has(placed.building_id):
            matches.append(placed)
    if matches.is_empty():
        return -1.0
    var chosen: PlacedBuilding = matches[(index + visit) % matches.size()]
    var definition: BuildingDefinition = game_state.buildings[chosen.building_id]
    var center_x: float = chosen.x + float(definition.footprint_width) * 0.5
    var local_offset: float = float(((index * 7 + visit * 5) % 5) - 2) * 3.0
    return clampf(center_x + local_offset, SideViewLayout.SETTLEMENT_MIN_X, SideViewLayout.SETTLEMENT_MAX_X)

static func _building_ids_for_job(job_id: StringName) -> Array[StringName]: # Maps visual occupations to the building types where those scraplings actually work.
    if job_id == JobIds.MINER:
        return [BuildingIds.IRON_MINE, BuildingIds.NICKEL_MINE, BuildingIds.COBALT_MINE]
    if job_id == JobIds.LUMBERJACK:
        return [BuildingIds.LUMBER_CAMP]
    if job_id == JobIds.REFINER:
        return [BuildingIds.IRON_EXTRACTOR, BuildingIds.NICKEL_EXTRACTOR, BuildingIds.COBALT_EXTRACTOR]
    if job_id == JobIds.SMITH:
        return [BuildingIds.FORGE, BuildingIds.BEAM_FORGE, BuildingIds.ALLOY_FORGE]
    if job_id == JobIds.SCHOLAR:
        return [BuildingIds.UNIVERSITY]
    if job_id == JobIds.ENGINEER:
        return [BuildingIds.ELECTRONICS_LAB, BuildingIds.UNIVERSITY]
    return []
