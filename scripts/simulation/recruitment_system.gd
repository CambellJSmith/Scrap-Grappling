class_name RecruitmentSystem
extends RefCounted

const BASE_INTERVAL_SECONDS: float = 12.0 # Defines the baseline interval between new arrivals when housing is available.

var _progress_seconds: float = 0.0 # Accumulates recruitment progress while the settlement has free capacity.

func tick(delta: float, settlement: Settlement, buildings: Dictionary[StringName, BuildingDefinition], workforce: Workforce, training: TrainingSystem) -> void: # Attracts general scraplings into available housing over time.
    var capacity: int = settlement.population_capacity(buildings)
    var occupied: int = workforce.total_population() + training.queued_count()
    if occupied >= capacity:
        _progress_seconds = 0.0
        return
    _progress_seconds += delta
    var interval: float = _recruitment_interval(settlement)
    while _progress_seconds >= interval and occupied < capacity:
        _progress_seconds -= interval
        workforce.add(JobIds.GENERAL, 1)
        occupied += 1

func _recruitment_interval(settlement: Settlement) -> float: # Reduces arrival time modestly as road infrastructure improves access.
    var road_count: int = settlement.get_count(BuildingIds.ROAD)
    return maxf(4.0, BASE_INTERVAL_SECONDS - float(road_count) * 0.6)

func progress_ratio(settlement: Settlement) -> float: # Returns normalized progress toward the next arriving scrapling.
    var interval: float = _recruitment_interval(settlement)
    if interval <= 0.0:
        return 0.0
    return clampf(_progress_seconds / interval, 0.0, 1.0)
