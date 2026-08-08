class_name ActionButton
extends Button

var _action: Callable # Stores one direct UI action without connecting a Godot signal.

func setup(label_text: String, action: Callable) -> void: # Configures reusable button text and direct press behavior.
    text = label_text
    _action = action
    custom_minimum_size.y = 20.0
    add_theme_font_size_override(&"font_size", 9)

func _pressed() -> void: # Executes the configured action through BaseButton's virtual press hook.
    if _action.is_valid():
        _action.call()
