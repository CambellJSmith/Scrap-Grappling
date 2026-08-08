class_name NumberFormatter
extends RefCounted

static func compact(value: int) -> String: # Formats large integer quantities without hiding small incremental changes.
    if value < 1000:
        return str(value)
    if value < 1000000:
        return "%.1fk" % (float(value) / 1000.0)
    if value < 1000000000:
        return "%.1fm" % (float(value) / 1000000.0)
    return "%.1fb" % (float(value) / 1000000000.0)
