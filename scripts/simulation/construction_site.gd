class_name ConstructionSite
extends RefCounted

var id: int # Stores a stable runtime identifier for one placed construction site.
var building_id: StringName # Stores the building type being assembled at this site.
var x: float # Stores the left edge of the site on the side-on world axis.
var requirements: Dictionary[StringName, int] # Stores the full material requirements copied from building data.
var delivered: Dictionary[StringName, int] = {} # Stores materials that scraplings have already thrown into the site.

func _init(new_id: int, new_building_id: StringName, new_x: float, new_requirements: Dictionary[StringName, int]) -> void: # Initializes one placed blueprint without consuming its materials.
    id = new_id
    building_id = new_building_id
    x = new_x
    requirements = new_requirements.duplicate()

func delivered_amount(resource_id: StringName) -> int: # Returns how much of one required material has reached this site.
    return int(delivered.get(resource_id, 0))

func remaining_amount(resource_id: StringName) -> int: # Returns the undelivered quantity for one material.
    return maxi(int(requirements.get(resource_id, 0)) - delivered_amount(resource_id), 0)

func find_deliverable_resource(inventory: Inventory) -> StringName: # Finds the first still-needed material that currently exists in settlement storage.
    for resource_id: StringName in requirements:
        if remaining_amount(resource_id) <= 0:
            continue
        if inventory.get_amount(resource_id) > 0:
            return resource_id
    return &""

func deliver(resource_id: StringName) -> bool: # Records one delivered unit when that material is still required.
    if remaining_amount(resource_id) <= 0:
        return false
    delivered[resource_id] = delivered_amount(resource_id) + 1
    return true

func progress_ratio() -> float: # Returns total delivered materials divided by total site requirements.
    var required_total: int = 0
    var delivered_total: int = 0
    for resource_id: StringName in requirements:
        required_total += requirements[resource_id]
        delivered_total += mini(delivered_amount(resource_id), requirements[resource_id])
    if required_total <= 0:
        return 1.0
    return clampf(float(delivered_total) / float(required_total), 0.0, 1.0)

func is_complete() -> bool: # Checks whether every building material has reached the blueprint.
    for resource_id: StringName in requirements:
        if remaining_amount(resource_id) > 0:
            return false
    return true
