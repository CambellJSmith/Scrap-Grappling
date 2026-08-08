class_name ResourcePanel
extends GridContainer

var _game_state: GameState # Stores the simulation source displayed by the persistent resource header.
var _labels: Dictionary[StringName, Label] = {} # Stores editor-created labels keyed by stable resource identifiers.
var _refresh_accumulator: float = 0.0 # Limits header text rebuilding frequency independently of frame rate.

func setup(game_state: GameState) -> void: # Supplies game state and maps the editor-created resource cells once.
    _game_state = game_state
    _labels[ResourceIds.WOOD] = $Wood
    _labels[ResourceIds.IRON_ORE] = $IronOre
    _labels[ResourceIds.IRON] = $Iron
    _labels[ResourceIds.IRON_PLATE] = $IronPlate
    _labels[ResourceIds.IRON_BEAM] = $IronBeam
    _labels[ResourceIds.NICKEL_ORE] = $NickelOre
    _labels[ResourceIds.NICKEL] = $Nickel
    _labels[ResourceIds.COBALT_ORE] = $CobaltOre
    _labels[ResourceIds.COBALT] = $Cobalt
    _labels[ResourceIds.ALLOY_COMPONENT] = $AlloyComponent
    _labels[ResourceIds.KNOWLEDGE] = $Knowledge
    _labels[ResourceIds.ELECTRONICS] = $Electronics
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
