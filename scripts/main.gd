class_name Main
extends Node

@onready var _game_state: GameState = $GameState # References the authoritative simulation node.
@onready var _building_view: BuildingView = $World/BuildingView # References the settlement pixel-art renderer.
@onready var _scrapling_view: ScraplingSwarmView = $World/ScraplingSwarmView # References the batched scrapling renderer.
@onready var _machine_view: MachineView = $World/MachineView # References the central machine renderer.
@onready var _delivery_view: DeliveryView = $World/DeliveryView # References thrown-component visualization.
@onready var _hud: Hud = $UILayer/Hud # References the composed Control-based interface.

func _ready() -> void: # Injects shared simulation state into independent rendering and UI systems.
    _building_view.setup(_game_state)
    _scrapling_view.setup(_game_state)
    _machine_view.setup(_game_state)
    _delivery_view.setup(_game_state)
    _hud.setup(_game_state)
