class_name ResourceIds
extends RefCounted

const IRON_ORE: StringName = &"iron_ore" # Identifies mined iron-bearing material.
const IRON: StringName = &"iron" # Identifies refined iron used by industry.
const IRON_PLATE: StringName = &"iron_plate" # Identifies forged structural plate.
const IRON_BEAM: StringName = &"iron_beam" # Identifies forged structural beam.
const WOOD: StringName = &"wood" # Identifies harvested timber used for construction.
const NICKEL_ORE: StringName = &"nickel_ore" # Identifies mined nickel-bearing material.
const NICKEL: StringName = &"nickel" # Identifies extracted nickel used by metallurgy.
const COBALT_ORE: StringName = &"cobalt_ore" # Identifies mined cobalt-bearing material.
const COBALT: StringName = &"cobalt" # Identifies extracted cobalt used by advanced industry.
const ALLOY_COMPONENT: StringName = &"alloy_component" # Identifies durable machine components forged from mixed metals.
const KNOWLEDGE: StringName = &"knowledge" # Identifies accumulated academic research output.
const ELECTRONICS: StringName = &"electronics" # Identifies manufactured electronic control components.

static func ordered() -> Array[StringName]: # Returns resources in a stable display order.
    return [IRON_ORE, IRON, IRON_PLATE, IRON_BEAM, WOOD, NICKEL_ORE, NICKEL, COBALT_ORE, COBALT, ALLOY_COMPONENT, KNOWLEDGE, ELECTRONICS]

static func display_name(resource_id: StringName) -> String: # Converts a resource ID into compact UI text.
    return String(resource_id).replace("_", " ")
