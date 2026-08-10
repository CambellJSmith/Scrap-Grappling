class_name ConstructionSystem
extends RefCounted

const FOOTPRINT_GAP: float = 6.0 # Reserves a small readable gap between independently placed buildings.

var _buildings: Dictionary[StringName, BuildingDefinition] # Stores building metadata used for footprints and material requirements.
var _sites: Array[ConstructionSite] = [] # Stores every placed blueprint that is still waiting for materials.
var _delivery_events: Array[ConstructionDeliveryEvent] = [] # Stores one-time material throws waiting for presentation.
var _delivery_progress: float = 0.0 # Accumulates fractional construction deliveries between fixed simulation ticks.
var _delivery_sequence: int = 0 # Produces deterministic visual variation for construction throws.
var _next_site_id: int = 1 # Produces stable runtime IDs for placed construction sites.
var _site_cursor: int = 0 # Rotates delivery attention across multiple queued construction sites.

func _init(buildings: Dictionary[StringName, BuildingDefinition]) -> void: # Initializes construction with shared immutable-style building metadata.
    _buildings = buildings

func tick(delta: float, inventory: Inventory, workforce: Workforce, settlement: Settlement) -> void: # Sends available required materials to placed blueprints at the current logistics rate.
    if _sites.is_empty():
        _delivery_progress = 0.0
        return
    _delivery_progress += delta * delivery_rate(workforce, settlement)
    while _delivery_progress >= 1.0:
        if not _deliver_one(inventory, settlement):
            _delivery_progress = minf(_delivery_progress, 1.0)
            return
        _delivery_progress -= 1.0

func place_site(definition: BuildingDefinition, x: float, settlement: Settlement) -> bool: # Places a free blueprint when its footprint does not overlap another building or site.
    if not can_place(definition, x, settlement):
        return false
    _sites.append(ConstructionSite.new(_next_site_id, definition.id, x, definition.cost))
    _next_site_id += 1
    return true

func can_place(definition: BuildingDefinition, x: float, settlement: Settlement) -> bool: # Validates one prospective footprint without changing construction state.
    for placed: PlacedBuilding in settlement.instances():
        var placed_definition: BuildingDefinition = _buildings[placed.building_id]
        if _footprints_overlap(x, definition.footprint_width, placed.x, placed_definition.footprint_width):
            return false
    for site: ConstructionSite in _sites:
        var site_definition: BuildingDefinition = _buildings[site.building_id]
        if _footprints_overlap(x, definition.footprint_width, site.x, site_definition.footprint_width):
            return false
    return true

func sites() -> Array[ConstructionSite]: # Returns a detached site list for renderers and targeting logic.
    return _sites.duplicate()

func site_count(building_id: StringName) -> int: # Returns how many incomplete blueprints exist for one building type.
    var count: int = 0
    for site: ConstructionSite in _sites:
        if site.building_id == building_id:
            count += 1
    return count

func consume_delivery_events() -> Array[ConstructionDeliveryEvent]: # Moves pending construction throws out of simulation for one-time presentation.
    var events: Array[ConstructionDeliveryEvent] = _delivery_events.duplicate()
    _delivery_events.clear()
    return events

func delivery_rate(workforce: Workforce, settlement: Settlement) -> float: # Calculates thrown building materials per second from general workers, haulers, and roads.
    var general_workers: int = workforce.get_count(JobIds.GENERAL)
    var haulers: int = workforce.get_count(JobIds.HAULER)
    var roads: int = settlement.get_count(BuildingIds.ROAD)
    return 0.8 + float(general_workers) * 0.12 + float(haulers) * 0.35 + float(roads) * 0.08

func _deliver_one(inventory: Inventory, settlement: Settlement) -> bool: # Finds one available required material, consumes it, emits a throw, and completes finished sites.
    if _sites.is_empty():
        return false
    var site_count_value: int = _sites.size()
    for offset: int in range(site_count_value):
        var index: int = (_site_cursor + offset) % site_count_value
        var site: ConstructionSite = _sites[index]
        var resource_id: StringName = site.find_deliverable_resource(inventory)
        if resource_id == &"":
            continue
        if not inventory.remove(resource_id, 1):
            continue
        if not site.deliver(resource_id):
            inventory.add(resource_id, 1)
            continue
        _delivery_sequence += 1
        _delivery_events.append(ConstructionDeliveryEvent.new(resource_id, site.id, site.x, _delivery_sequence))
        if site.is_complete():
            settlement.complete_construction(site)
            _sites.remove_at(index)
            if _sites.is_empty():
                _site_cursor = 0
            else:
                _site_cursor = index % _sites.size()
        else:
            _site_cursor = (index + 1) % _sites.size()
        return true
    return false

func _footprints_overlap(first_x: float, first_width: int, second_x: float, second_width: int) -> bool: # Checks horizontal overlap while preserving a small visual gap between structures.
    var first_right: float = first_x + float(first_width) + FOOTPRINT_GAP
    var second_right: float = second_x + float(second_width) + FOOTPRINT_GAP
    return first_x < second_right and second_x < first_right
