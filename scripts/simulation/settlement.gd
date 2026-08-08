class_name Settlement
extends RefCounted

const BASE_POPULATION_CAPACITY: int = 6 # Defines capacity supplied by the primitive starting camp.

var _building_counts: Dictionary[StringName, int] = {} # Stores completed building counts by stable ID for fast simulation queries.
var _instances: Array[PlacedBuilding] = [] # Stores the world positions of completed buildings only.

func get_count(building_id: StringName) -> int: # Returns how many completed instances of a building currently provide benefits.
    return int(_building_counts.get(building_id, 0))

func complete_construction(site: ConstructionSite) -> void: # Converts one fully supplied construction site into an active settlement building.
    _instances.append(PlacedBuilding.new(site.building_id, site.x))
    _building_counts[site.building_id] = get_count(site.building_id) + 1

func instances() -> Array[PlacedBuilding]: # Returns a detached list of completed positioned buildings for presentation and targeting.
    return _instances.duplicate()

func population_capacity(buildings: Dictionary[StringName, BuildingDefinition]) -> int: # Calculates population capacity supplied only by completed housing.
    var capacity: int = BASE_POPULATION_CAPACITY
    for building_id: StringName in _building_counts:
        var definition: BuildingDefinition = buildings[building_id]
        capacity += definition.housing_capacity * _building_counts[building_id]
    return capacity

func snapshot() -> Dictionary[StringName, int]: # Returns a detached completed-building count copy for presentation or saving.
    return _building_counts.duplicate()
