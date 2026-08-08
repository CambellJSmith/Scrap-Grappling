class_name JobIds
extends RefCounted

const GENERAL: StringName = &"general" # Identifies untrained scraplings available for specialization.
const MINER: StringName = &"miner" # Identifies scraplings trained for mineral extraction.
const LUMBERJACK: StringName = &"lumberjack" # Identifies scraplings trained for timber harvesting.
const REFINER: StringName = &"refiner" # Identifies scraplings trained for ore extraction buildings.
const SMITH: StringName = &"smith" # Identifies scraplings trained for forging work.
const HAULER: StringName = &"hauler" # Identifies scraplings trained to move machine components quickly.
const SCHOLAR: StringName = &"scholar" # Identifies university scraplings producing knowledge.
const ENGINEER: StringName = &"engineer" # Identifies advanced scraplings operating electronics industry.

static func ordered() -> Array[StringName]: # Returns jobs in a stable UI order.
    return [GENERAL, MINER, LUMBERJACK, REFINER, SMITH, HAULER, SCHOLAR, ENGINEER]

static func display_name(job_id: StringName) -> String: # Converts a job ID into readable UI text.
    return String(job_id).replace("_", " ")
