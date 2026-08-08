class_name SideViewLayout
extends RefCounted

const WORLD_WIDTH: float = 1600.0 # Defines the full horizontal world span available to the side-scrolling camera.
const GROUND_Y: float = 250.0 # Defines the single world ground line used by every side-on visual system.
const SCRAPLING_HEIGHT: float = 10.0 # Defines the rendered scrapling height used to place feet exactly on the ground.
const SCRAPLING_GROUND_Y: float = GROUND_Y - SCRAPLING_HEIGHT # Defines the grounded top-left Y position for every scrapling.
const MACHINE_LEFT_X: float = 1390.0 # Defines where the central machine begins on the side-on world axis.
const BUILDABLE_MIN_X: float = 24.0 # Defines the leftmost edge available for player-placed buildings.
const BUILDABLE_MAX_X: float = MACHINE_LEFT_X - 36.0 # Defines the right edge of the settlement construction zone.
const SETTLEMENT_MIN_X: float = 18.0 # Defines the left movement boundary for visible scraplings.
const SETTLEMENT_MAX_X: float = MACHINE_LEFT_X - 30.0 # Defines the right movement boundary before the machine construction zone.

static func fallback_activity_center_x(job_id: StringName) -> float: # Returns a sensible roaming center before the relevant player-placed workplace exists.
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
        return 930.0
    return 610.0

static func fallback_activity_span(job_id: StringName) -> float: # Returns the roaming range used only when no relevant placed target exists.
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

static func fallback_target_x(job_id: StringName, index: int, visit: int) -> float: # Produces a deterministic fallback destination without introducing any depth-axis variation.
    var center: float = fallback_activity_center_x(job_id)
    var span: float = fallback_activity_span(job_id)
    var step: int = (index * 11 + visit * 7) % 17
    var normalized: float = (float(step) / 16.0) * 2.0 - 1.0
    return clampf(center + normalized * span, SETTLEMENT_MIN_X, SETTLEMENT_MAX_X)
