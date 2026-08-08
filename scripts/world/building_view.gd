class_name BuildingView
extends Node2D

var _game_state: GameState # Stores the simulation source used to determine visible constructed buildings.
var _last_signature: String = "" # Avoids redraw work when building counts have not changed.

func setup(game_state: GameState) -> void: # Supplies the authoritative settlement state after scene construction.
    _game_state = game_state
    queue_redraw()

func _process(_delta: float) -> void: # Redraws the building layer only when settlement composition changes.
    if _game_state == null:
        return
    var signature: String = _building_signature()
    if signature != _last_signature:
        _last_signature = signature
        queue_redraw()

func _building_signature() -> String: # Creates a compact building-count signature for redraw detection.
    var parts: PackedStringArray = PackedStringArray()
    for building_id: StringName in _game_state.buildings:
        parts.append(String(building_id) + ":" + str(_game_state.settlement.get_count(building_id)))
    return "|".join(parts)

func _draw() -> void: # Draws one strict profile silhouette per constructed building type with no depth stacking.
    if _game_state == null:
        return
    for building_id: StringName in _game_state.buildings:
        var count: int = _game_state.settlement.get_count(building_id)
        if count <= 0:
            continue
        var origin: Vector2 = SideViewLayout.building_origin(building_id)
        if building_id == BuildingIds.ROAD:
            _draw_road(origin, count)
            continue
        _draw_building(building_id, origin)
        if count > 1:
            _draw_stack_marker(origin + Vector2(2.0, -7.0), count)

func _draw_building(building_id: StringName, origin: Vector2) -> void: # Routes one building ID to a tiny reusable side-profile silhouette.
    if building_id == BuildingIds.HOUSE:
        _draw_house(origin)
    elif building_id == BuildingIds.TRAINING_YARD:
        _draw_training_yard(origin)
    elif building_id == BuildingIds.UNIVERSITY:
        _draw_university(origin)
    elif building_id == BuildingIds.IRON_MINE or building_id == BuildingIds.NICKEL_MINE or building_id == BuildingIds.COBALT_MINE:
        _draw_mine(origin, building_id)
    elif building_id == BuildingIds.LUMBER_CAMP:
        _draw_lumber_camp(origin)
    elif building_id == BuildingIds.ELECTRONICS_LAB:
        _draw_lab(origin)
    else:
        _draw_industry(origin, building_id)

func _draw_house(origin: Vector2) -> void: # Draws a compact timber house sitting exactly on the common ground line.
    draw_rect(Rect2(origin + Vector2(0.0, 4.0), Vector2(13.0, 10.0)), PixelPalette.WOOD, true)
    draw_colored_polygon(PackedVector2Array([origin + Vector2(-1.0, 4.0), origin + Vector2(6.0, -2.0), origin + Vector2(14.0, 4.0)]), PixelPalette.INK)
    draw_rect(Rect2(origin + Vector2(5.0, 9.0), Vector2(3.0, 5.0)), PixelPalette.INK, true)

func _draw_road(origin: Vector2, count: int) -> void: # Draws road infrastructure horizontally along the same world ground axis.
    var segment_count: int = mini(8 + count * 3, 58)
    for index: int in range(segment_count):
        draw_rect(Rect2(origin + Vector2(float(index * 5), 0.0), Vector2(4.0, 2.0)), PixelPalette.IRON, true)

func _draw_training_yard(origin: Vector2) -> void: # Draws a fenced side-on yard with a training post rooted on the ground line.
    draw_rect(Rect2(origin, Vector2(15.0, 2.0)), PixelPalette.WOOD, true)
    draw_rect(Rect2(origin + Vector2(0.0, 9.0), Vector2(15.0, 2.0)), PixelPalette.WOOD, true)
    draw_rect(Rect2(origin + Vector2(7.0, 1.0), Vector2(2.0, 9.0)), PixelPalette.WOOD_LIGHT, true)

func _draw_university(origin: Vector2) -> void: # Draws the university as a taller profile-view academic structure.
    draw_rect(Rect2(origin + Vector2(0.0, 3.0), Vector2(17.0, 15.0)), PixelPalette.IRON, true)
    draw_colored_polygon(PackedVector2Array([origin + Vector2(-1.0, 3.0), origin + Vector2(8.0, -4.0), origin + Vector2(18.0, 3.0)]), PixelPalette.RESEARCH)
    draw_rect(Rect2(origin + Vector2(3.0, 7.0), Vector2(3.0, 3.0)), PixelPalette.LIGHT, true)
    draw_rect(Rect2(origin + Vector2(11.0, 7.0), Vector2(3.0, 3.0)), PixelPalette.LIGHT, true)
    draw_rect(Rect2(origin + Vector2(7.0, 12.0), Vector2(3.0, 6.0)), PixelPalette.INK, true)

func _draw_mine(origin: Vector2, building_id: StringName) -> void: # Draws a supported mine entrance in profile and colors its exposed ore by resource type.
    var ore_color: Color = PixelPalette.IRON
    if building_id == BuildingIds.NICKEL_MINE:
        ore_color = PixelPalette.NICKEL
    elif building_id == BuildingIds.COBALT_MINE:
        ore_color = PixelPalette.COBALT
    draw_rect(Rect2(origin, Vector2(15.0, 10.0)), PixelPalette.INK, true)
    draw_rect(Rect2(origin + Vector2(2.0, -2.0), Vector2(2.0, 12.0)), PixelPalette.WOOD, true)
    draw_rect(Rect2(origin + Vector2(11.0, -2.0), Vector2(2.0, 12.0)), PixelPalette.WOOD, true)
    draw_rect(Rect2(origin + Vector2(4.0, 2.0), Vector2(7.0, 6.0)), ore_color, true)

func _draw_lumber_camp(origin: Vector2) -> void: # Draws a low timber-processing shelter entirely from side-on pixel shapes.
    draw_rect(Rect2(origin + Vector2(1.0, 5.0), Vector2(14.0, 9.0)), PixelPalette.WOOD, true)
    draw_rect(Rect2(origin + Vector2(0.0, 3.0), Vector2(16.0, 3.0)), PixelPalette.INK, true)
    draw_rect(Rect2(origin + Vector2(4.0, 9.0), Vector2(8.0, 3.0)), PixelPalette.WOOD_LIGHT, true)

func _draw_industry(origin: Vector2, building_id: StringName) -> void: # Draws a generic processing machine sitting on the shared ground line.
    draw_rect(Rect2(origin + Vector2(0.0, 4.0), Vector2(15.0, 10.0)), PixelPalette.IRON, true)
    draw_rect(Rect2(origin + Vector2(3.0, 1.0), Vector2(4.0, 4.0)), PixelPalette.IRON_LIGHT, true)
    draw_rect(Rect2(origin + Vector2(10.0, 0.0), Vector2(2.0, 5.0)), PixelPalette.INK, true)
    var accent: Color = PixelPalette.DANGER
    if building_id == BuildingIds.ALLOY_FORGE or building_id == BuildingIds.NICKEL_EXTRACTOR:
        accent = PixelPalette.NICKEL
    elif building_id == BuildingIds.COBALT_EXTRACTOR:
        accent = PixelPalette.COBALT
    draw_rect(Rect2(origin + Vector2(5.0, 9.0), Vector2(5.0, 3.0)), accent, true)

func _draw_lab(origin: Vector2) -> void: # Draws an electronics laboratory with sparse side-facing indicator pixels.
    draw_rect(Rect2(origin + Vector2(0.0, 3.0), Vector2(17.0, 12.0)), PixelPalette.IRON, true)
    draw_rect(Rect2(origin + Vector2(3.0, 6.0), Vector2(11.0, 5.0)), PixelPalette.INK, true)
    draw_rect(Rect2(origin + Vector2(5.0, 7.0), Vector2(2.0, 2.0)), PixelPalette.ELECTRIC, true)
    draw_rect(Rect2(origin + Vector2(10.0, 7.0), Vector2(1.0, 1.0)), PixelPalette.COBALT, true)

func _draw_stack_marker(origin: Vector2, count: int) -> void: # Shows quantity without drawing extra structures behind or above the profile-view building.
    draw_rect(Rect2(origin, Vector2(10.0, 6.0)), PixelPalette.INK, true)
    draw_string(ThemeDB.fallback_font, origin + Vector2(1.0, 5.0), "x" + str(count), HORIZONTAL_ALIGNMENT_LEFT, -1.0, 6, PixelPalette.LIGHT)
