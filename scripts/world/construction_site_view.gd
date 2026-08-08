class_name ConstructionSiteView
extends Node2D

var _game_state: GameState # Stores the construction state displayed by this blueprint renderer.
var _last_signature: String = "" # Avoids redraw work when no site progress or placement changed.

func setup(game_state: GameState) -> void: # Supplies authoritative construction state after scene construction.
    _game_state = game_state
    queue_redraw()

func _process(_delta: float) -> void: # Redraws only when active sites or delivered material totals change.
    if _game_state == null:
        return
    var signature: String = _site_signature()
    if signature != _last_signature:
        _last_signature = signature
        queue_redraw()

func _site_signature() -> String: # Builds a compact deterministic signature from every active construction site.
    var parts: PackedStringArray = PackedStringArray()
    for site: ConstructionSite in _game_state.construction.sites():
        parts.append(str(site.id) + ":" + String(site.building_id) + ":" + str(site.x) + ":" + str(int(site.progress_ratio() * 100.0)))
    return "|".join(parts)

func _draw() -> void: # Draws translucent placed blueprints and a small delivered-material progress bar above each one.
    if _game_state == null:
        return
    for site: ConstructionSite in _game_state.construction.sites():
        var origin: Vector2 = Vector2(site.x, SideViewLayout.GROUND_Y)
        BuildingPixelArt.draw_building(self, site.building_id, origin, Color(1.0, 1.0, 1.0, 0.32))
        var bar_y: float = SideViewLayout.GROUND_Y - BuildingPixelArt.visual_height(site.building_id) - 6.0
        var bar_width: float = 18.0
        draw_rect(Rect2(site.x, bar_y, bar_width, 3.0), Color(PixelPalette.INK, 0.8), true)
        draw_rect(Rect2(site.x + 1.0, bar_y + 1.0, floor((bar_width - 2.0) * site.progress_ratio()), 1.0), PixelPalette.LIGHT, true)
