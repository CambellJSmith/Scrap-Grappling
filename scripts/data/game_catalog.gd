class_name GameCatalog
extends RefCounted

static func create_buildings() -> Dictionary[StringName, BuildingDefinition]: # Builds the authoritative building catalog.
    var definitions: Dictionary[StringName, BuildingDefinition] = {}
    definitions[BuildingIds.HOUSE] = BuildingDefinition.new(BuildingIds.HOUSE, "house", &"settlement", {ResourceIds.WOOD: 25, ResourceIds.IRON: 4}, &"", 0, 6, 16)
    definitions[BuildingIds.ROAD] = BuildingDefinition.new(BuildingIds.ROAD, "road", &"settlement", {ResourceIds.WOOD: 12, ResourceIds.IRON: 2}, &"", 0, 0, 40)
    definitions[BuildingIds.TRAINING_YARD] = BuildingDefinition.new(BuildingIds.TRAINING_YARD, "training yard", &"settlement", {ResourceIds.WOOD: 30, ResourceIds.IRON: 8}, &"", 0, 0, 18)
    definitions[BuildingIds.IRON_MINE] = BuildingDefinition.new(BuildingIds.IRON_MINE, "iron mine", &"industry", {ResourceIds.WOOD: 18, ResourceIds.IRON: 2}, &"", 4, 0, 18)
    definitions[BuildingIds.LUMBER_CAMP] = BuildingDefinition.new(BuildingIds.LUMBER_CAMP, "lumber camp", &"industry", {ResourceIds.WOOD: 10, ResourceIds.IRON: 2}, &"", 4, 0, 18)
    definitions[BuildingIds.IRON_EXTRACTOR] = BuildingDefinition.new(BuildingIds.IRON_EXTRACTOR, "iron extractor", &"industry", {ResourceIds.WOOD: 18, ResourceIds.IRON: 8}, &"", 3, 0, 18)
    definitions[BuildingIds.FORGE] = BuildingDefinition.new(BuildingIds.FORGE, "plate forge", &"industry", {ResourceIds.WOOD: 22, ResourceIds.IRON: 12}, &"", 3, 0, 18)
    definitions[BuildingIds.BEAM_FORGE] = BuildingDefinition.new(BuildingIds.BEAM_FORGE, "beam forge", &"industry", {ResourceIds.WOOD: 18, ResourceIds.IRON: 10}, &"", 3, 0, 18)
    definitions[BuildingIds.UNIVERSITY] = BuildingDefinition.new(BuildingIds.UNIVERSITY, "university", &"settlement", {ResourceIds.WOOD: 70, ResourceIds.IRON_PLATE: 35}, &"", 4, 0, 20)
    definitions[BuildingIds.NICKEL_MINE] = BuildingDefinition.new(BuildingIds.NICKEL_MINE, "nickel mine", &"industry", {ResourceIds.WOOD: 35, ResourceIds.IRON_PLATE: 14}, ResearchIds.NICKEL_PROCESSING, 4, 0, 18)
    definitions[BuildingIds.NICKEL_EXTRACTOR] = BuildingDefinition.new(BuildingIds.NICKEL_EXTRACTOR, "nickel extractor", &"industry", {ResourceIds.IRON_PLATE: 20, ResourceIds.IRON: 10}, ResearchIds.NICKEL_PROCESSING, 3, 0, 18)
    definitions[BuildingIds.COBALT_MINE] = BuildingDefinition.new(BuildingIds.COBALT_MINE, "cobalt mine", &"industry", {ResourceIds.WOOD: 40, ResourceIds.ALLOY_COMPONENT: 8}, ResearchIds.COBALT_PROCESSING, 4, 0, 18)
    definitions[BuildingIds.COBALT_EXTRACTOR] = BuildingDefinition.new(BuildingIds.COBALT_EXTRACTOR, "cobalt extractor", &"industry", {ResourceIds.IRON_PLATE: 30, ResourceIds.NICKEL: 10}, ResearchIds.COBALT_PROCESSING, 3, 0, 18)
    definitions[BuildingIds.ALLOY_FORGE] = BuildingDefinition.new(BuildingIds.ALLOY_FORGE, "alloy forge", &"industry", {ResourceIds.IRON_PLATE: 35, ResourceIds.NICKEL: 15}, ResearchIds.METALLURGY, 3, 0, 18)
    definitions[BuildingIds.ELECTRONICS_LAB] = BuildingDefinition.new(BuildingIds.ELECTRONICS_LAB, "electronics lab", &"industry", {ResourceIds.ALLOY_COMPONENT: 20, ResourceIds.COBALT: 12}, ResearchIds.ELECTRONICS, 3, 0, 20)
    return definitions

static func create_recipes() -> Array[RecipeDefinition]: # Builds production recipes in deterministic processing order.
    var recipes: Array[RecipeDefinition] = []
    recipes.append(RecipeDefinition.new(&"mine_iron", BuildingIds.IRON_MINE, JobIds.MINER, {}, {ResourceIds.IRON_ORE: 1}, 1.3))
    recipes.append(RecipeDefinition.new(&"harvest_wood", BuildingIds.LUMBER_CAMP, JobIds.LUMBERJACK, {}, {ResourceIds.WOOD: 1}, 1.1))
    recipes.append(RecipeDefinition.new(&"extract_iron", BuildingIds.IRON_EXTRACTOR, JobIds.REFINER, {ResourceIds.IRON_ORE: 2}, {ResourceIds.IRON: 1}, 1.4))
    recipes.append(RecipeDefinition.new(&"forge_plate", BuildingIds.FORGE, JobIds.SMITH, {ResourceIds.IRON: 2}, {ResourceIds.IRON_PLATE: 1}, 1.8))
    recipes.append(RecipeDefinition.new(&"forge_beam", BuildingIds.BEAM_FORGE, JobIds.SMITH, {ResourceIds.IRON: 3}, {ResourceIds.IRON_BEAM: 1}, 2.2))
    recipes.append(RecipeDefinition.new(&"study", BuildingIds.UNIVERSITY, JobIds.SCHOLAR, {}, {ResourceIds.KNOWLEDGE: 1}, 2.5))
    recipes.append(RecipeDefinition.new(&"mine_nickel", BuildingIds.NICKEL_MINE, JobIds.MINER, {}, {ResourceIds.NICKEL_ORE: 1}, 1.8))
    recipes.append(RecipeDefinition.new(&"extract_nickel", BuildingIds.NICKEL_EXTRACTOR, JobIds.REFINER, {ResourceIds.NICKEL_ORE: 2}, {ResourceIds.NICKEL: 1}, 2.0))
    recipes.append(RecipeDefinition.new(&"forge_alloy", BuildingIds.ALLOY_FORGE, JobIds.SMITH, {ResourceIds.IRON_PLATE: 2, ResourceIds.NICKEL: 1}, {ResourceIds.ALLOY_COMPONENT: 1}, 2.6))
    recipes.append(RecipeDefinition.new(&"mine_cobalt", BuildingIds.COBALT_MINE, JobIds.MINER, {}, {ResourceIds.COBALT_ORE: 1}, 2.0))
    recipes.append(RecipeDefinition.new(&"extract_cobalt", BuildingIds.COBALT_EXTRACTOR, JobIds.REFINER, {ResourceIds.COBALT_ORE: 2}, {ResourceIds.COBALT: 1}, 2.3))
    recipes.append(RecipeDefinition.new(&"build_electronics", BuildingIds.ELECTRONICS_LAB, JobIds.ENGINEER, {ResourceIds.IRON_PLATE: 1, ResourceIds.COBALT: 1, ResourceIds.KNOWLEDGE: 2}, {ResourceIds.ELECTRONICS: 1}, 3.0))
    return recipes

static func create_training() -> Dictionary[StringName, TrainingDefinition]: # Builds the authoritative training catalog.
    var definitions: Dictionary[StringName, TrainingDefinition] = {}
    definitions[JobIds.MINER] = TrainingDefinition.new(JobIds.MINER, BuildingIds.TRAINING_YARD, {ResourceIds.WOOD: 3}, 4.0, &"")
    definitions[JobIds.LUMBERJACK] = TrainingDefinition.new(JobIds.LUMBERJACK, BuildingIds.TRAINING_YARD, {ResourceIds.WOOD: 2}, 3.5, &"")
    definitions[JobIds.REFINER] = TrainingDefinition.new(JobIds.REFINER, BuildingIds.TRAINING_YARD, {ResourceIds.WOOD: 2, ResourceIds.IRON: 1}, 5.0, &"")
    definitions[JobIds.SMITH] = TrainingDefinition.new(JobIds.SMITH, BuildingIds.TRAINING_YARD, {ResourceIds.WOOD: 2, ResourceIds.IRON: 2}, 5.5, &"")
    definitions[JobIds.HAULER] = TrainingDefinition.new(JobIds.HAULER, BuildingIds.TRAINING_YARD, {ResourceIds.WOOD: 2}, 3.0, &"")
    definitions[JobIds.SCHOLAR] = TrainingDefinition.new(JobIds.SCHOLAR, BuildingIds.UNIVERSITY, {ResourceIds.IRON_PLATE: 1}, 7.0, &"")
    definitions[JobIds.ENGINEER] = TrainingDefinition.new(JobIds.ENGINEER, BuildingIds.UNIVERSITY, {ResourceIds.IRON_PLATE: 2, ResourceIds.NICKEL: 1}, 9.0, ResearchIds.COBALT_PROCESSING)
    return definitions

static func create_research() -> Dictionary[StringName, ResearchDefinition]: # Builds the authoritative research catalog.
    var definitions: Dictionary[StringName, ResearchDefinition] = {}
    definitions[ResearchIds.METALLURGY] = ResearchDefinition.new(ResearchIds.METALLURGY, "metallurgy", {ResourceIds.KNOWLEDGE: 20, ResourceIds.IRON_PLATE: 8}, [], "unlocks alloy forging")
    definitions[ResearchIds.NICKEL_PROCESSING] = ResearchDefinition.new(ResearchIds.NICKEL_PROCESSING, "nickel processing", {ResourceIds.KNOWLEDGE: 30, ResourceIds.IRON_PLATE: 12}, [ResearchIds.METALLURGY], "unlocks nickel extraction")
    definitions[ResearchIds.COBALT_PROCESSING] = ResearchDefinition.new(ResearchIds.COBALT_PROCESSING, "cobalt processing", {ResourceIds.KNOWLEDGE: 45, ResourceIds.NICKEL: 12}, [ResearchIds.NICKEL_PROCESSING], "unlocks cobalt extraction")
    definitions[ResearchIds.ELECTRONICS] = ResearchDefinition.new(ResearchIds.ELECTRONICS, "electronics", {ResourceIds.KNOWLEDGE: 70, ResourceIds.COBALT: 16, ResourceIds.ALLOY_COMPONENT: 10}, [ResearchIds.COBALT_PROCESSING], "unlocks electronic controls")
    return definitions

static func create_machine_stages() -> Array[MachineStageDefinition]: # Builds machine construction stages from primitive to advanced components.
    var stages: Array[MachineStageDefinition] = []
    stages.append(MachineStageDefinition.new(&"foundation", "foundation", {ResourceIds.IRON_PLATE: 24, ResourceIds.WOOD: 30}, "a rigid base for something far too large"))
    stages.append(MachineStageDefinition.new(&"frame", "frame", {ResourceIds.IRON_BEAM: 35, ResourceIds.IRON_PLATE: 30}, "the machine begins to acquire a silhouette"))
    stages.append(MachineStageDefinition.new(&"drive", "drive assembly", {ResourceIds.ALLOY_COMPONENT: 28, ResourceIds.NICKEL: 18}, "heavy moving parts are fitted to the frame"))
    stages.append(MachineStageDefinition.new(&"control", "control system", {ResourceIds.ELECTRONICS: 24, ResourceIds.ALLOY_COMPONENT: 20, ResourceIds.COBALT: 12}, "the machine receives its first actual thoughts"))
    return stages
