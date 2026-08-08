class_name ResearchSystem
extends RefCounted

var _completed: Dictionary[StringName, bool] = {} # Stores completed research unlocks by stable ID.

func is_completed(research_id: StringName) -> bool: # Checks whether a specific research topic has been completed.
    if research_id == &"":
        return true
    return bool(_completed.get(research_id, false))

func prerequisites_met(definition: ResearchDefinition) -> bool: # Checks whether every prerequisite research topic is complete.
    for prerequisite: StringName in definition.prerequisites:
        if not is_completed(prerequisite):
            return false
    return true

func complete(definition: ResearchDefinition, inventory: Inventory) -> bool: # Pays the research cost and records a newly completed topic.
    if is_completed(definition.id):
        return false
    if not prerequisites_met(definition):
        return false
    if not inventory.spend(definition.cost):
        return false
    _completed[definition.id] = true
    return true

func snapshot() -> Dictionary[StringName, bool]: # Returns a detached research completion copy for presentation or saving.
    return _completed.duplicate()
