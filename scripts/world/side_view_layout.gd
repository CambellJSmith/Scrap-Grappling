class_name SideViewLayout
extends RefCounted

const GROUND_Y: float = 250.0 # Defines the single world ground line used by every side-on visual system.
const SCRAPLING_HEIGHT: float = 10.0 # Defines the rendered scrapling height used to place feet exactly on the ground.
const SCRAPLING_GROUND_Y: float = GROUND_Y - SCRAPLING_HEIGHT # Defines the grounded top-left Y position for every scrapling.
const MACHINE_LEFT_X: float = 466.0 # Defines where the central machine begins on the side-on world axis.
const SETTLEMENT_MIN_X: float = 18.0 # Defines the left movement boundary for visible scraplings.
const SETTLEMENT_MAX_X: float = 454.0 # Defines the right movement boundary before the machine construction zone.

static func activity_center_x(job_id: StringName) -> float: # Returns the horizontal center of the work area used by one occupation.
    if job_id == JobIds.LUMBERJACK:
        return 38.0
    if job_id == JobIds.MINER:
        return 94.0
    if job_id == JobIds.REFINER:
        return 244.0
    if job_id == JobIds.SMITH:
        return 300.0
    if job_id == JobIds.SCHOLAR:
        return 350.0
    if job_id == JobIds.ENGINEER:
        return 382.0
    if job_id == JobIds.HAULER:
        return 414.0
    return 194.0

static func activity_span(job_id: StringName) -> float: # Returns the horizontal roaming range around an occupation's activity center.
    if job_id == JobIds.HAULER:
        return 72.0
    if job_id == JobIds.GENERAL:
        return 42.0
    return 18.0

static func target_x_for(job_id: StringName, index: int, visit: int) -> float: # Produces a deterministic side-on destination without introducing any depth-axis variation.
    var center: float = activity_center_x(job_id)
    var span: float = activity_span(job_id)
    var step: int = (index * 11 + visit * 7) % 17
    var normalized: float = (float(step) / 16.0) * 2.0 - 1.0
    return clampf(center + normalized * span, SETTLEMENT_MIN_X, SETTLEMENT_MAX_X)

static func building_origin(building_id: StringName) -> Vector2: # Returns a profile-view building origin whose lowest pixel sits on the common ground line.
    if building_id == BuildingIds.LUMBER_CAMP:
        return Vector2(26.0, 236.0)
    if building_id == BuildingIds.IRON_MINE:
        return Vector2(58.0, 240.0)
    if building_id == BuildingIds.NICKEL_MINE:
        return Vector2(88.0, 240.0)
    if building_id == BuildingIds.COBALT_MINE:
        return Vector2(118.0, 240.0)
    if building_id == BuildingIds.HOUSE:
        return Vector2(158.0, 236.0)
    if building_id == BuildingIds.TRAINING_YARD:
        return Vector2(180.0, 239.0)
    if building_id == BuildingIds.IRON_EXTRACTOR:
        return Vector2(212.0, 236.0)
    if building_id == BuildingIds.NICKEL_EXTRACTOR:
        return Vector2(234.0, 236.0)
    if building_id == BuildingIds.COBALT_EXTRACTOR:
        return Vector2(256.0, 236.0)
    if building_id == BuildingIds.FORGE:
        return Vector2(280.0, 236.0)
    if building_id == BuildingIds.BEAM_FORGE:
        return Vector2(302.0, 236.0)
    if building_id == BuildingIds.ALLOY_FORGE:
        return Vector2(324.0, 236.0)
    if building_id == BuildingIds.UNIVERSITY:
        return Vector2(348.0, 232.0)
    if building_id == BuildingIds.ELECTRONICS_LAB:
        return Vector2(374.0, 235.0)
    if building_id == BuildingIds.ROAD:
        return Vector2(154.0, GROUND_Y - 2.0)
    return Vector2(200.0, 236.0)
