class_name ProductionSystem
extends RefCounted

var _recipes: Array[RecipeDefinition] # Stores production recipes in deterministic allocation order.
var _buildings: Dictionary[StringName, BuildingDefinition] # Stores building metadata needed for worker capacities.
var _progress: Dictionary[StringName, float] = {} # Stores accumulated worker-seconds for each recipe.

func _init(recipes: Array[RecipeDefinition], buildings: Dictionary[StringName, BuildingDefinition]) -> void: # Initializes production with shared catalog data.
    _recipes = recipes
    _buildings = buildings

func tick(delta: float, settlement: Settlement, workforce: Workforce, inventory: Inventory) -> void: # Allocates workers without duplication and advances every active recipe.
    for job_id: StringName in JobIds.ordered():
        if job_id == JobIds.GENERAL or job_id == JobIds.HAULER:
            continue
        _tick_job(delta, job_id, settlement, workforce, inventory)

func _tick_job(delta: float, job_id: StringName, settlement: Settlement, workforce: Workforce, inventory: Inventory) -> void: # Distributes one job pool proportionally across compatible buildings.
    var active_recipes: Array[RecipeDefinition] = []
    var capacities: Array[int] = []
    var total_capacity: int = 0
    for recipe: RecipeDefinition in _recipes:
        if recipe.required_job != job_id:
            continue
        var building_definition: BuildingDefinition = _buildings[recipe.building_id]
        var capacity: int = settlement.get_count(recipe.building_id) * building_definition.worker_capacity
        if capacity <= 0:
            continue
        active_recipes.append(recipe)
        capacities.append(capacity)
        total_capacity += capacity
    if total_capacity <= 0:
        return
    var available_workers: int = mini(workforce.get_count(job_id), total_capacity)
    if available_workers <= 0:
        return
    var assignments: Array[int] = []
    var assigned_workers: int = 0
    for capacity: int in capacities:
        var share: int = int(floor(float(available_workers * capacity) / float(total_capacity)))
        share = mini(share, capacity)
        assignments.append(share)
        assigned_workers += share
    var remainder: int = available_workers - assigned_workers
    var allocation_index: int = 0
    while remainder > 0 and not assignments.is_empty():
        if assignments[allocation_index] < capacities[allocation_index]:
            assignments[allocation_index] += 1
            remainder -= 1
        allocation_index = (allocation_index + 1) % assignments.size()
    for index: int in range(active_recipes.size()):
        _advance_recipe(delta, active_recipes[index], assignments[index], inventory)

func _advance_recipe(delta: float, recipe: RecipeDefinition, assigned_workers: int, inventory: Inventory) -> void: # Converts worker-seconds into completed recipe cycles while respecting input stock.
    if assigned_workers <= 0:
        return
    var progress: float = float(_progress.get(recipe.id, 0.0))
    progress += delta * float(assigned_workers)
    var possible_cycles: int = int(floor(progress / recipe.seconds_per_cycle))
    if possible_cycles <= 0:
        _progress[recipe.id] = progress
        return
    var completed_cycles: int = _execute_cycles(recipe, possible_cycles, inventory)
    progress -= float(completed_cycles) * recipe.seconds_per_cycle
    if completed_cycles < possible_cycles:
        progress = minf(progress, recipe.seconds_per_cycle)
    _progress[recipe.id] = progress

func _execute_cycles(recipe: RecipeDefinition, requested_cycles: int, inventory: Inventory) -> int: # Runs as many whole recipe cycles as current input stock permits.
    var completed: int = 0
    while completed < requested_cycles:
        if not inventory.has_cost(recipe.inputs):
            break
        if not inventory.spend(recipe.inputs):
            break
        for output_id: StringName in recipe.outputs:
            inventory.add(output_id, recipe.outputs[output_id])
        completed += 1
    return completed

func progress_ratio(recipe_id: StringName) -> float: # Returns partial progress for one recipe when presentation needs it.
    for recipe: RecipeDefinition in _recipes:
        if recipe.id == recipe_id:
            return clampf(float(_progress.get(recipe_id, 0.0)) / recipe.seconds_per_cycle, 0.0, 1.0)
    return 0.0
