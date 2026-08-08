class_name TerrainView
extends Node2D

func _draw() -> void: # Draws static terrain, resource patches, and trees from deliberately chunky pixel primitives.
    draw_rect(Rect2(0.0, 250.0, 640.0, 110.0), PixelPalette.GROUND, true)
    for x: int in range(0, 640, 19):
        var y: float = 265.0 + float((x * 7) % 71)
        draw_rect(Rect2(float(x), y, 2.0, 1.0), PixelPalette.GROUND_LIGHT, true)
    _draw_iron_patch(Vector2(54.0, 238.0))
    _draw_nickel_patch(Vector2(92.0, 242.0))
    _draw_cobalt_patch(Vector2(128.0, 244.0))
    _draw_tree(Vector2(26.0, 244.0))
    _draw_tree(Vector2(42.0, 246.0))
    _draw_tree(Vector2(157.0, 244.0))

func _draw_iron_patch(origin: Vector2) -> void: # Draws a tiny iron outcrop from block-shaped pixels.
    draw_rect(Rect2(origin + Vector2(0.0, 4.0), Vector2(17.0, 8.0)), PixelPalette.INK, true)
    draw_rect(Rect2(origin + Vector2(2.0, 2.0), Vector2(6.0, 8.0)), PixelPalette.IRON, true)
    draw_rect(Rect2(origin + Vector2(9.0, 5.0), Vector2(6.0, 5.0)), PixelPalette.IRON_LIGHT, true)

func _draw_nickel_patch(origin: Vector2) -> void: # Draws a small nickel outcrop with a cooler highlight.
    draw_rect(Rect2(origin, Vector2(14.0, 8.0)), PixelPalette.INK, true)
    draw_rect(Rect2(origin + Vector2(2.0, -2.0), Vector2(5.0, 8.0)), PixelPalette.NICKEL, true)
    draw_rect(Rect2(origin + Vector2(8.0, 2.0), Vector2(4.0, 4.0)), PixelPalette.IRON_LIGHT, true)

func _draw_cobalt_patch(origin: Vector2) -> void: # Draws a small cobalt outcrop that introduces the palette's muted blue.
    draw_rect(Rect2(origin, Vector2(13.0, 7.0)), PixelPalette.INK, true)
    draw_rect(Rect2(origin + Vector2(2.0, -3.0), Vector2(5.0, 8.0)), PixelPalette.COBALT, true)
    draw_rect(Rect2(origin + Vector2(8.0, 1.0), Vector2(3.0, 4.0)), PixelPalette.COBALT, true)

func _draw_tree(origin: Vector2) -> void: # Draws a tiny tree using only trunk and canopy rectangles.
    draw_rect(Rect2(origin + Vector2(3.0, 2.0), Vector2(3.0, 11.0)), PixelPalette.WOOD, true)
    draw_rect(Rect2(origin + Vector2(0.0, -4.0), Vector2(9.0, 7.0)), PixelPalette.GREEN, true)
    draw_rect(Rect2(origin + Vector2(2.0, -7.0), Vector2(5.0, 4.0)), PixelPalette.GREEN, true)
