class_name WorldCamera
extends Camera2D

var _dragging: bool = false # Tracks whether a world drag gesture is currently active.
var _viewport_size: Vector2 = Vector2.ZERO # Stores the logical viewport size used to clamp camera movement.
var _world_input_blocked: Callable # Reports whether another world interaction currently owns left-click input.

func _ready() -> void: # Configures the side-scrolling camera from the shared world dimensions.
    _viewport_size = get_viewport_rect().size
    position = Vector2(_viewport_size.x * 0.5, _viewport_size.y * 0.5)
    limit_left = 0
    limit_right = int(SideViewLayout.WORLD_WIDTH)
    limit_top = 0
    limit_bottom = int(_viewport_size.y)
    position_smoothing_enabled = false
    make_current()

func setup(world_input_blocked: Callable) -> void: # Supplies a reusable blocker such as active building placement without coupling to its concrete node type.
    _world_input_blocked = world_input_blocked

func _input(event: InputEvent) -> void: # Guarantees a drag ends even when the mouse is released over interface controls.
    if not _dragging:
        return
    if event is InputEventMouseButton:
        var mouse_button: InputEventMouseButton = event
        if mouse_button.button_index == MOUSE_BUTTON_LEFT and not mouse_button.pressed:
            _dragging = false

func _unhandled_input(event: InputEvent) -> void: # Starts and updates horizontal world dragging only when no higher-priority world interaction owns the mouse.
    if _is_world_input_blocked():
        _dragging = false
        return
    if event is InputEventMouseButton:
        var mouse_button: InputEventMouseButton = event
        if mouse_button.button_index == MOUSE_BUTTON_LEFT and mouse_button.pressed:
            _dragging = true
            get_viewport().set_input_as_handled()
            return
    if event is InputEventMouseMotion and _dragging:
        var mouse_motion: InputEventMouseMotion = event
        _move_horizontal(-mouse_motion.relative.x)
        get_viewport().set_input_as_handled()

func _is_world_input_blocked() -> bool: # Evaluates the injected interaction guard only when one has been supplied.
    if not _world_input_blocked.is_valid():
        return false
    return bool(_world_input_blocked.call())

func _move_horizontal(amount: float) -> void: # Moves only along the world X axis and prevents exposing space outside the level.
    var half_view_width: float = _viewport_size.x * 0.5
    var minimum_x: float = half_view_width
    var maximum_x: float = SideViewLayout.WORLD_WIDTH - half_view_width
    position.x = clampf(position.x + amount, minimum_x, maximum_x)
    position.y = _viewport_size.y * 0.5
