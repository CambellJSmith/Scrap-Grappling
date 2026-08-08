class_name ResourcePanel
extends VBoxContainer

var _game_state: GameState # Stores the simulation source displayed by the resource summary.
var _label: Label # Stores the compact multi-resource text node created by the scene.
var _refresh_accumulator: float = 0.0 # Limits text rebuilding frequency independently of frame rate.

func setup(game_state: GameState, label: Label) -> void: # Supplies game state and the editor-created label used for presentation.
    _game_state = game_state
    _label = label
    _refresh()

func _process(delta: float) -> void: # Refreshes resource text at a low cadence to avoid unnecessary string churn.
    if _game_state == null or _label == null:
        return
    _refresh_accumulator += delta
    if _refresh_accumulator < 0.2:
        return
    _refresh_accumulator = 0.0
    _refresh()

func _refresh() -> void: # Builds a two-line summary containing only currently meaningful resources.
    var first_line: PackedStringArray = PackedStringArray()
    var second_line: PackedStringArray = PackedStringArray()
    var visible_resources: Array[StringName] = [ResourceIds.WOOD, ResourceIds.IRON_ORE, ResourceIds.IRON, ResourceIds.IRON_PLATE, ResourceIds.IRON_BEAM, ResourceIds.NICKEL, ResourceIds.COBALT, ResourceIds.ALLOY_COMPONENT, ResourceIds.KNOWLEDGE, ResourceIds.ELECTRONICS]
    for index: int in range(visible_resources.size()):
        var resource_id: StringName = visible_resources[index]
        var amount: int = _game_state.inventory.get_amount(resource_id)
        if amount <= 0 and index > 4:
            continue
        var entry: String = ResourceIds.display_name(resource_id) + " " + NumberFormatter.compact(amount)
        if index < 5:
            first_line.append(entry)
        else:
            second_line.append(entry)
    _label.text = "   ".join(first_line) + "\n" + "   ".join(second_line)
