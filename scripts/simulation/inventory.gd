class_name Inventory
extends RefCounted

var _amounts: Dictionary[StringName, int] = {} # Stores authoritative integer resource quantities.

func get_amount(resource_id: StringName) -> int: # Returns the current quantity of one resource.
    return int(_amounts.get(resource_id, 0))

func add(resource_id: StringName, amount: int) -> void: # Adds a positive quantity to one resource stack.
    if amount <= 0:
        return
    _amounts[resource_id] = get_amount(resource_id) + amount

func has_cost(cost: Dictionary[StringName, int]) -> bool: # Checks whether every resource in a cost can be paid.
    for resource_id: StringName in cost:
        if get_amount(resource_id) < cost[resource_id]:
            return false
    return true

func spend(cost: Dictionary[StringName, int]) -> bool: # Atomically removes a cost when all required resources are available.
    if not has_cost(cost):
        return false
    for resource_id: StringName in cost:
        _amounts[resource_id] = get_amount(resource_id) - cost[resource_id]
    return true

func remove(resource_id: StringName, amount: int) -> bool: # Removes a single resource quantity when enough stock exists.
    if amount <= 0:
        return true
    if get_amount(resource_id) < amount:
        return false
    _amounts[resource_id] = get_amount(resource_id) - amount
    return true

func snapshot() -> Dictionary[StringName, int]: # Returns a detached inventory copy for presentation or saving.
    return _amounts.duplicate()
