class_name Main
extends Node

@onready var _game_state: GameState = $GameState # References the authoritative simulation node.
@onready var _building_view: BuildingView = $World/BuildingView # References the completed-building pixel-art renderer.
@onready var _construction_site_view: ConstructionSiteView = $World/ConstructionSiteView # References incomplete blueprint rendering.
@onready var _scrapling_view: ScraplingSwarmView = $World/ScraplingSwarmView # References the batched scrapling renderer.
@onready var _machine_view: MachineView = $World/MachineView # References the central machine renderer.
@onready var _delivery_view: DeliveryView = $World/DeliveryView # References machine component throw visualization.
@onready var _construction_delivery_view: ConstructionDeliveryView = $World/ConstructionDeliveryView # References building material throw visualization.
@onready var _placement_controller: BuildingPlacementController = $World/BuildingPlacementController # References mouse-driven building blueprint placement.
@onready var _world_camera: WorldCamera = $World/WorldCamera # References horizontal world dragging.
@onready var _hud: Hud = $UILayer/Hud # References the composed Control-based interface.

func _ready() -> void: # Injects shared simulation state into independent rendering, interaction, camera, and UI systems.
    _building_view.setup(_game_state)
    _construction_site_view.setup(_game_state)
    _scrapling_view.setup(_game_state)
    _machine_view.setup(_game_state)
    _delivery_view.setup(_game_state)
    _construction_delivery_view.setup(_game_state)
    _placement_controller.setup(_game_state)
    _world_camera.setup(Callable(_placement_controller, "is_active"))
    _hud.setup(_game_state, Callable(_placement_controller, "begin_placement"))
