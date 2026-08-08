class_name ResourcePanel
extends GridContainer

var _game_state: GameState # Stores the simulation source displayed by the persistent resource header.
var _labels: Dictionary[StringName, Label] = {} # Stores editor-created labels keyed by stable resource identifiers.
var _refresh_accumulator: float = 0.0 # Limits header text rebuilding frequency independently of frame rate.

func setup(game_state: GameState) -> void: # Supplies game state and maps the editor-created resource cells once.
    _game_state = game_state
    _labels[ResourceIds.WOOD] = $Wood as Label
    _labels[ResourceIds.IRON_ORE] = $IronOre as Label
    _labels[ResourceIds.IRON] = $Iron as Label
    _labels[ResourceIds.IRON_PLATE] = $IronPlate as Label
    _labels[ResourceIds.IRON_BEAM] = $IronBeam as Label
    _labels[ResourceIds.NICKEL_ORE] = $NickelOre as Label
    _labels[ResourceIds.NICKEL] = $Nickel as Label
    _labels[ResourceIds.COBALT_ORE] = $CobaltOre as Label
    _labels[ResourceIds.COBALT] = $Cobalt as Label
    _labels[ResourceIds.ALLOY_COMPONENT] = $AlloyComponent as Label
    _labels[ResourceIds.KNOWLEDGE] = $Knowledge as Label
    _labels[ResourceIds.ELECTRONICS] = $Electronics as Label
    _refresh()

func _process(delta: float) -> void: # Refreshes all persistent header counters at a low cadence.
    if _game_state == null:
        return
    _refresh_accumulator += delta
    if _refresh_accumulator < 0.2:
        return
    _refresh_accumulator = 0.0
    _refresh()

func _refresh() -> void: # Writes compact stored-resource values into their fixed header cells.
    for resource_id: StringName in _labels:
        var label: Label = _labels[resource_id]
        var amount: int = _game_state.inventory.get_amount(resource_id)
        label.text = _short_name(resource_id) + " " + NumberFormatter.compact(amount)

func _short_name(resource_id: StringName) -> String: # Returns concise labels sized for the always-visible header bar.
    if resource_id == ResourceIds.IRON_PLATE:
        return "plates"
    if resource_id == ResourceIds.IRON_BEAM:
        return "beams"
    if resource_id == ResourceIds.ALLOY_COMPONENT:
        return "alloy"
    return ResourceIds.display_name(resource_id)
