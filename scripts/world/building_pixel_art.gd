class_name BuildingPixelArt
extends RefCounted

static func draw_building(canvas: CanvasItem, building_id: StringName, ground_origin: Vector2, tint: Color = Color.WHITE) -> void: # Draws one reusable side-on building silhouette anchored at its ground contact point.
    if building_id == BuildingIds.HOUSE:
        _draw_house(canvas, ground_origin, tint)
    elif building_id == BuildingIds.ROAD:
        _draw_road(canvas, ground_origin, tint)
    elif building_id == BuildingIds.TRAINING_YARD:
        _draw_training_yard(canvas, ground_origin, tint)
    elif building_id == BuildingIds.UNIVERSITY:
        _draw_university(canvas, ground_origin, tint)
    elif building_id == BuildingIds.IRON_MINE or building_id == BuildingIds.NICKEL_MINE or building_id == BuildingIds.COBALT_MINE:
        _draw_mine(canvas, ground_origin, building_id, tint)
    elif building_id == BuildingIds.LUMBER_CAMP:
        _draw_lumber_camp(canvas, ground_origin, tint)
    elif building_id == BuildingIds.ELECTRONICS_LAB:
        _draw_lab(canvas, ground_origin, tint)
    else:
        _draw_industry(canvas, ground_origin, building_id, tint)

static func visual_height(building_id: StringName) -> float: # Returns the approximate pixel height used to place construction progress indicators.
    if building_id == BuildingIds.UNIVERSITY:
        return 22.0
    if building_id == BuildingIds.HOUSE:
        return 16.0
    if building_id == BuildingIds.ROAD:
        return 2.0
    return 16.0

static func _draw_house(canvas: CanvasItem, origin: Vector2, tint: Color) -> void: # Draws the house from a shared ground-relative profile.
    canvas.draw_rect(Rect2(origin + Vector2(0.0, -10.0), Vector2(13.0, 10.0)), _color(PixelPalette.WOOD, tint), true)
    canvas.draw_colored_polygon(PackedVector2Array([origin + Vector2(-1.0, -10.0), origin + Vector2(6.0, -16.0), origin + Vector2(14.0, -10.0)]), _color(PixelPalette.INK, tint))
    canvas.draw_rect(Rect2(origin + Vector2(5.0, -5.0), Vector2(3.0, 5.0)), _color(PixelPalette.INK, tint), true)

static func _draw_road(canvas: CanvasItem, origin: Vector2, tint: Color) -> void: # Draws one placeable road section along the common ground line.
    for index: int in range(8):
        canvas.draw_rect(Rect2(origin + Vector2(float(index * 5), -2.0), Vector2(4.0, 2.0)), _color(PixelPalette.IRON, tint), true)

static func _draw_training_yard(canvas: CanvasItem, origin: Vector2, tint: Color) -> void: # Draws a fenced training yard anchored to the ground.
    canvas.draw_rect(Rect2(origin + Vector2(0.0, -11.0), Vector2(15.0, 2.0)), _color(PixelPalette.WOOD, tint), true)
    canvas.draw_rect(Rect2(origin + Vector2(0.0, -2.0), Vector2(15.0, 2.0)), _color(PixelPalette.WOOD, tint), true)
    canvas.draw_rect(Rect2(origin + Vector2(7.0, -10.0), Vector2(2.0, 9.0)), _color(PixelPalette.WOOD_LIGHT, tint), true)

static func _draw_university(canvas: CanvasItem, origin: Vector2, tint: Color) -> void: # Draws the university from a shared ground-relative profile.
    canvas.draw_rect(Rect2(origin + Vector2(0.0, -15.0), Vector2(17.0, 15.0)), _color(PixelPalette.IRON, tint), true)
    canvas.draw_colored_polygon(PackedVector2Array([origin + Vector2(-1.0, -15.0), origin + Vector2(8.0, -22.0), origin + Vector2(18.0, -15.0)]), _color(PixelPalette.RESEARCH, tint))
    canvas.draw_rect(Rect2(origin + Vector2(3.0, -11.0), Vector2(3.0, 3.0)), _color(PixelPalette.LIGHT, tint), true)
    canvas.draw_rect(Rect2(origin + Vector2(11.0, -11.0), Vector2(3.0, 3.0)), _color(PixelPalette.LIGHT, tint), true)
    canvas.draw_rect(Rect2(origin + Vector2(7.0, -6.0), Vector2(3.0, 6.0)), _color(PixelPalette.INK, tint), true)

static func _draw_mine(canvas: CanvasItem, origin: Vector2, building_id: StringName, tint: Color) -> void: # Draws one supported mine entrance with a material-specific ore color.
    var ore_color: Color = PixelPalette.IRON
    if building_id == BuildingIds.NICKEL_MINE:
        ore_color = PixelPalette.NICKEL
    elif building_id == BuildingIds.COBALT_MINE:
        ore_color = PixelPalette.COBALT
    canvas.draw_rect(Rect2(origin + Vector2(0.0, -10.0), Vector2(15.0, 10.0)), _color(PixelPalette.INK, tint), true)
    canvas.draw_rect(Rect2(origin + Vector2(2.0, -12.0), Vector2(2.0, 12.0)), _color(PixelPalette.WOOD, tint), true)
    canvas.draw_rect(Rect2(origin + Vector2(11.0, -12.0), Vector2(2.0, 12.0)), _color(PixelPalette.WOOD, tint), true)
    canvas.draw_rect(Rect2(origin + Vector2(4.0, -8.0), Vector2(7.0, 6.0)), _color(ore_color, tint), true)

static func _draw_lumber_camp(canvas: CanvasItem, origin: Vector2, tint: Color) -> void: # Draws one low timber-processing shelter.
    canvas.draw_rect(Rect2(origin + Vector2(1.0, -9.0), Vector2(14.0, 9.0)), _color(PixelPalette.WOOD, tint), true)
    canvas.draw_rect(Rect2(origin + Vector2(0.0, -11.0), Vector2(16.0, 3.0)), _color(PixelPalette.INK, tint), true)
    canvas.draw_rect(Rect2(origin + Vector2(4.0, -5.0), Vector2(8.0, 3.0)), _color(PixelPalette.WOOD_LIGHT, tint), true)

static func _draw_industry(canvas: CanvasItem, origin: Vector2, building_id: StringName, tint: Color) -> void: # Draws one generic processor with a material-specific accent.
    canvas.draw_rect(Rect2(origin + Vector2(0.0, -10.0), Vector2(15.0, 10.0)), _color(PixelPalette.IRON, tint), true)
    canvas.draw_rect(Rect2(origin + Vector2(3.0, -13.0), Vector2(4.0, 4.0)), _color(PixelPalette.IRON_LIGHT, tint), true)
    canvas.draw_rect(Rect2(origin + Vector2(10.0, -14.0), Vector2(2.0, 5.0)), _color(PixelPalette.INK, tint), true)
    var accent: Color = PixelPalette.DANGER
    if building_id == BuildingIds.ALLOY_FORGE or building_id == BuildingIds.NICKEL_EXTRACTOR:
        accent = PixelPalette.NICKEL
    elif building_id == BuildingIds.COBALT_EXTRACTOR:
        accent = PixelPalette.COBALT
    canvas.draw_rect(Rect2(origin + Vector2(5.0, -5.0), Vector2(5.0, 3.0)), _color(accent, tint), true)

static func _draw_lab(canvas: CanvasItem, origin: Vector2, tint: Color) -> void: # Draws the electronics laboratory with sparse indicator pixels.
    canvas.draw_rect(Rect2(origin + Vector2(0.0, -12.0), Vector2(17.0, 12.0)), _color(PixelPalette.IRON, tint), true)
    canvas.draw_rect(Rect2(origin + Vector2(3.0, -9.0), Vector2(11.0, 5.0)), _color(PixelPalette.INK, tint), true)
    canvas.draw_rect(Rect2(origin + Vector2(5.0, -8.0), Vector2(2.0, 2.0)), _color(PixelPalette.ELECTRIC, tint), true)
    canvas.draw_rect(Rect2(origin + Vector2(10.0, -8.0), Vector2(1.0, 1.0)), _color(PixelPalette.COBALT, tint), true)

static func _color(base: Color, tint: Color) -> Color: # Multiplies palette color by a tint so ghosts retain the exact finished silhouette.
    return Color(base.r * tint.r, base.g * tint.g, base.b * tint.b, base.a * tint.a)
