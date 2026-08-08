class_name Settlement
extends RefCounted

const BASE_POPULATION_CAPACITY: int = 6 # Defines capacity supplied by the primitive starting camp.

var _buildings: Dictionary[StringName, int] = {} # Stores constructed building counts by stable ID.

func get_count(building_id: StringName) -> int: # Returns how many instances of a building have been constructed.
    return int(_buildings.get(building_id, 0))

func construct(definition: BuildingDefinition, inventory: Inventory) -> bool: # Pays a building cost and records one completed structure.
    if not inventory.spend(definition.cost):
        return false
    _buildings[definition.id] = get_count(definition.id) + 1
    return true

func population_capacity(buildings: Dictionary[StringName, BuildingDefinition]) -> int: # Calculates population capacity supplied by the camp and housing.
    var capacity: int = BASE_POPULATION_CAPACITY
    for building_id: StringName in _buildings:
        var definition: BuildingDefinition = buildings[building_id]
        capacity += definition.housing_capacity * _buildings[building_id]
    return capacity

func snapshot() -> Dictionary[StringName, int]: # Returns a detached building-count copy for presentation or saving.
    return _buildings.duplicate()
