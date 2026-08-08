class_name SideViewLayout
extends RefCounted

const WORLD_WIDTH: float = 1600.0 # Defines the full horizontal world span available to the side-scrolling camera.
const GROUND_Y: float = 250.0 # Defines the single world ground line used by every side-on visual system.
const SCRAPLING_HEIGHT: float = 10.0 # Defines the rendered scrapling height used to place feet exactly on the ground.
const SCRAPLING_GROUND_Y: float = GROUND_Y - SCRAPLING_HEIGHT # Defines the grounded top-left Y position for every scrapling.
const MACHINE_LEFT_X: float = 1390.0 # Defines where the central machine begins on the side-on world axis.
const SETTLEMENT_MIN_X: float = 18.0 # Defines the left movement boundary for visible scraplings.
const SETTLEMENT_MAX_X: float = MACHINE_LEFT_X - 30.0 # Defines the right movement boundary before the machine construction zone.

static func activity_center_x(job_id: StringName) -> float: # Returns the horizontal center of the work area used by one occupation.
    if job_id == JobIds.LUMBERJACK:
        return 92.0
    if job_id == JobIds.MINER:
        return 300.0
    if job_id == JobIds.REFINER:
        return 790.0
    if job_id == JobIds.SMITH:
        return 1020.0
    if job_id == JobIds.SCHOLAR:
        return 1190.0
    if job_id == JobIds.ENGINEER:
        return 1280.0
    if job_id == JobIds.HAULER:
        return 1310.0
    return 610.0

static func activity_span(job_id: StringName) -> float: # Returns the horizontal roaming range around an occupation's activity center.
    if job_id == JobIds.MINER:
        return 150.0
    if job_id == JobIds.HAULER:
        return 260.0
    if job_id == JobIds.GENERAL:
        return 220.0
    if job_id == JobIds.REFINER:
        return 105.0
    if job_id == JobIds.SMITH:
        return 120.0
    return 28.0

static func target_x_for(job_id: StringName, index: int, visit: int) -> float: # Produces a deterministic side-on destination without introducing any depth-axis variation.
    var center: float = activity_center_x(job_id)
    var span: float = activity_span(job_id)
    var step: int = (index * 11 + visit * 7) % 17
    var normalized: float = (float(step) / 16.0) * 2.0 - 1.0
    return clampf(center + normalized * span, SETTLEMENT_MIN_X, SETTLEMENT_MAX_X)

static func building_origin(building_id: StringName) -> Vector2: # Returns a profile-view building origin whose lowest pixel sits on the common ground line.
    if building_id == BuildingIds.LUMBER_CAMP:
        return Vector2(68.0, 236.0)
    if building_id == BuildingIds.IRON_MINE:
        return Vector2(205.0, 240.0)
    if building_id == BuildingIds.NICKEL_MINE:
        return Vector2(305.0, 240.0)
    if building_id == BuildingIds.COBALT_MINE:
        return Vector2(405.0, 240.0)
    if building_id == BuildingIds.HOUSE:
        return Vector2(535.0, 236.0)
    if building_id == BuildingIds.TRAINING_YARD:
        return Vector2(625.0, 239.0)
    if building_id == BuildingIds.IRON_EXTRACTOR:
        return Vector2(720.0, 236.0)
    if building_id == BuildingIds.NICKEL_EXTRACTOR:
        return Vector2(790.0, 236.0)
    if building_id == BuildingIds.COBALT_EXTRACTOR:
        return Vector2(860.0, 236.0)
    if building_id == BuildingIds.FORGE:
        return Vector2(950.0, 236.0)
    if building_id == BuildingIds.BEAM_FORGE:
        return Vector2(1020.0, 236.0)
    if building_id == BuildingIds.ALLOY_FORGE:
        return Vector2(1090.0, 236.0)
    if building_id == BuildingIds.UNIVERSITY:
        return Vector2(1180.0, 232.0)
    if building_id == BuildingIds.ELECTRONICS_LAB:
        return Vector2(1270.0, 235.0)
    if building_id == BuildingIds.ROAD:
        return Vector2(510.0, GROUND_Y - 2.0)
    return Vector2(610.0, 236.0)
