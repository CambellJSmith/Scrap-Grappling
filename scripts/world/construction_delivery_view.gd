class_name ConstructionDeliveryView
extends Node2D

var _game_state: GameState # Stores the construction system supplying one-time material throw events.
var _deliveries: Array[DeliveryVisual] = [] # Stores only currently visible building-material projectiles.

func setup(game_state: GameState) -> void: # Supplies authoritative construction state after scene construction.
    _game_state = game_state

func _process(delta: float) -> void: # Consumes new site-delivery events and advances their lightweight ballistic arcs.
    if _game_state == null:
        return
    var events: Array[ConstructionDeliveryEvent] = _game_state.construction.consume_delivery_events()
    for event: ConstructionDeliveryEvent in events:
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

func _spawn_delivery(event: ConstructionDeliveryEvent) -> void: # Launches one resource from a nearby scrapling staging point into the placed blueprint.
    var direction: float = -1.0
    if event.target_x < 80.0:
        direction = 1.0
    var launch_distance: float = 28.0 + float(event.sequence % 5) * 4.0
    var start: Vector2 = Vector2(event.target_x + direction * launch_distance, SideViewLayout.GROUND_Y - 13.0)
    var end: Vector2 = Vector2(event.target_x + 7.0 + float(event.sequence % 5), SideViewLayout.GROUND_Y - 9.0 - float(event.sequence % 6))
    var speed: float = 1.7 + float(event.sequence % 4) * 0.12
    _deliveries.append(DeliveryVisual.new(event.resource_id, start, end, speed))

func _draw() -> void: # Draws each building material as a tiny colored cluster moving through a strict side-on throw arc.
    for delivery: DeliveryVisual in _deliveries:
        var t: float = clampf(delivery.progress, 0.0, 1.0)
        var position: Vector2 = delivery.start.lerp(delivery.end, t)
        position.y -= sin(t * PI) * 18.0
        position = position.floor()
        var color: Color = PixelPalette.resource_color(delivery.resource_id)
        draw_rect(Rect2(position, Vector2(4.0, 3.0)), color, true)
        draw_rect(Rect2(position + Vector2(1.0, 3.0), Vector2(2.0, 1.0)), PixelPalette.INK, true)
