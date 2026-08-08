class_name DeliveryView
extends Node2D

var _game_state: GameState # Stores the simulation source supplying one-time delivery events.
var _deliveries: Array[DeliveryVisual] = [] # Stores only currently visible component projectiles.

func setup(game_state: GameState) -> void: # Supplies the machine simulation after scene construction.
    _game_state = game_state

func _process(delta: float) -> void: # Consumes new delivery events and advances active side-on projectile arcs.
    if _game_state == null:
        return
    var events: Array[MachineDeliveryEvent] = _game_state.machine.consume_delivery_events()
    for event: MachineDeliveryEvent in events:
        _spawn_delivery(event)
    var index: int = _deliveries.size() - 1
    while index >= 0:
        var delivery: DeliveryVisual = _deliveries[index]
        delivery.progress += delta * delivery.speed
        if delivery.progress >= 1.0:
            _deliveries.remove_at(index)
        index -= 1
    if not _deliveries.is_empty() or not events.is_empty():
        queue_redraw()

func _spawn_delivery(event: MachineDeliveryEvent) -> void: # Creates a deterministic profile-view throw from the settlement toward the machine.
    var start_height: float = float(event.sequence % 3)
    var target_height: float = float(event.sequence % 24)
    var start: Vector2 = Vector2(SideViewLayout.MACHINE_LEFT_X - 54.0, SideViewLayout.GROUND_Y - 15.0 - start_height)
    var end: Vector2 = Vector2(SideViewLayout.MACHINE_LEFT_X + 18.0 + float(event.sequence % 48), SideViewLayout.GROUND_Y - 28.0 - target_height)
    var speed: float = 0.9 + float(event.sequence % 5) * 0.07
    _deliveries.append(DeliveryVisual.new(event.resource_id, start, end, speed))

func _draw() -> void: # Draws every active component as a tiny pixel cluster following a genuine vertical throw arc.
    for delivery: DeliveryVisual in _deliveries:
        var t: float = clampf(delivery.progress, 0.0, 1.0)
        var position: Vector2 = delivery.start.lerp(delivery.end, t)
        position.y -= sin(t * PI) * 42.0
        position = position.floor()
        var color: Color = PixelPalette.resource_color(delivery.resource_id)
        draw_rect(Rect2(position, Vector2(4.0, 3.0)), color, true)
        draw_rect(Rect2(position + Vector2(1.0, 3.0), Vector2(2.0, 1.0)), PixelPalette.INK, true)
