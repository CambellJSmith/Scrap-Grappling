class_name CostFormatter
extends RefCounted

static func format(cost: Dictionary[StringName, int]) -> String: # Formats a resource cost into compact comma-separated UI text.
    if cost.is_empty():
        return "free"
    var parts: PackedStringArray = PackedStringArray()
    for resource_id: StringName in cost:
        parts.append(str(cost[resource_id]) + " " + ResourceIds.display_name(resource_id))
    return ", ".join(parts)
