class_name GameState
extends Node

const SIMULATION_STEP_SECONDS: float = 0.1 # Defines a fixed simulation cadence to keep large populations inexpensive.

var buildings: Dictionary[StringName, BuildingDefinition] = GameCatalog.create_buildings() # Exposes immutable-style building metadata to presentation systems.
var training_definitions: Dictionary[StringName, TrainingDefinition] = GameCatalog.create_training() # Exposes training metadata to UI systems.
var research_definitions: Dictionary[StringName, ResearchDefinition] = GameCatalog.create_research() # Exposes research metadata to UI systems.
var inventory: Inventory = Inventory.new() # Owns all settlement resource quantities.
var workforce: Workforce = Workforce.new(6) # Owns all available and specialized scraplings.
var settlement: Settlement = Settlement.new() # Owns constructed building counts.
var research: ResearchSystem = ResearchSystem.new() # Owns completed research unlocks.
var training: TrainingSystem = TrainingSystem.new() # Owns active occupational training.
var recruitment: RecruitmentSystem = RecruitmentSystem.new() # Owns settlement population growth timing.
var production: ProductionSystem = ProductionSystem.new(GameCatalog.create_recipes(), buildings) # Owns worker allocation and material production.
var machine: MachineSystem = MachineSystem.new(GameCatalog.create_machine_stages()) # Owns central machine construction progression.
var machine_delivery_enabled: bool = true # Stores whether scraplings are currently allowed to spend stock on the central machine.
var _simulation_accumulator: float = 0.0 # Accumulates frame time for fixed-step simulation updates.

func _ready() -> void: # Seeds a small salvaged stockpile that lets the first industries be constructed without a deadlock.
    inventory.add(ResourceIds.WOOD, 90)
    inventory.add(ResourceIds.IRON, 35)
    inventory.add(ResourceIds.IRON_ORE, 18)

func _process(delta: float) -> void: # Advances game systems at a fixed cadence independent of rendering frame rate.
    _simulation_accumulator += delta
    while _simulation_accumulator >= SIMULATION_STEP_SECONDS:
        _simulation_accumulator -= SIMULATION_STEP_SECONDS
        _tick_simulation(SIMULATION_STEP_SECONDS)

func _tick_simulation(delta: float) -> void: # Runs systems in a stable order so resource ownership remains deterministic.
    training.tick(delta, workforce)
    recruitment.tick(delta, settlement, buildings, workforce, training)
    production.tick(delta, settlement, workforce, inventory)
    if machine_delivery_enabled:
        machine.tick(delta, inventory, workforce, settlement)

func try_build(building_id: StringName) -> bool: # Validates unlock state and attempts construction of one building.
    if not buildings.has(building_id):
        return false
    var definition: BuildingDefinition = buildings[building_id]
    if not research.is_completed(definition.required_research):
        return false
    return settlement.construct(definition, inventory)

func can_build(building_id: StringName) -> bool: # Checks whether a building is unlocked and affordable without changing game state.
    if not buildings.has(building_id):
        return false
    var definition: BuildingDefinition = buildings[building_id]
    if not research.is_completed(definition.required_research):
        return false
    return inventory.has_cost(definition.cost)

func try_train(job_id: StringName) -> bool: # Attempts to begin one occupational training course.
    if not training_definitions.has(job_id):
        return false
    var definition: TrainingDefinition = training_definitions[job_id]
    return training.start(definition, settlement, research, workforce, inventory)

func can_train(job_id: StringName) -> bool: # Checks whether one occupational training course can begin without changing game state.
    if not training_definitions.has(job_id):
        return false
    var definition: TrainingDefinition = training_definitions[job_id]
    return training.can_start(definition, settlement, research, workforce, inventory)

func try_research(research_id: StringName) -> bool: # Attempts to complete one research topic through the university.
    if settlement.get_count(BuildingIds.UNIVERSITY) <= 0:
        return false
    if not research_definitions.has(research_id):
        return false
    var definition: ResearchDefinition = research_definitions[research_id]
    return research.complete(definition, inventory)

func can_research(research_id: StringName) -> bool: # Checks university, prerequisite, and resource requirements for research.
    if settlement.get_count(BuildingIds.UNIVERSITY) <= 0:
        return false
    if not research_definitions.has(research_id):
        return false
    var definition: ResearchDefinition = research_definitions[research_id]
    if research.is_completed(research_id):
        return false
    if not research.prerequisites_met(definition):
        return false
    return inventory.has_cost(definition.cost)

func population_capacity() -> int: # Returns current housing capacity for UI and world presentation.
    return settlement.population_capacity(buildings)

func toggle_machine_delivery() -> void: # Lets the player reserve materials for settlement growth by pausing or resuming component throws.
    machine_delivery_enabled = not machine_delivery_enabled
