class_name Hud
extends Control

@onready var _resource_panel: ResourcePanel = $HeaderBar/Margin/ResourcePanel # References the always-visible stored-resource header.
@onready var _drawer_panel: PanelContainer = $DrawerPanel # References the single expandable gameplay drawer.
@onready var _build_panel: BuildPanel = $DrawerPanel/Margin/Content/BuildPanel # References the construction drawer content.
@onready var _build_buttons: GridContainer = $DrawerPanel/Margin/Content/BuildPanel/Scroll/Buttons # References the construction action grid.
@onready var _workforce_panel: WorkforcePanel = $DrawerPanel/Margin/Content/WorkforcePanel # References the scrapling workforce drawer content.
@onready var _workforce_summary: Label = $DrawerPanel/Margin/Content/WorkforcePanel/Content/Summary # References the compact workforce summary.
@onready var _training_buttons: GridContainer = $DrawerPanel/Margin/Content/WorkforcePanel/Content/Training/Scroll/Buttons # References the training action grid.
@onready var _research_panel: ResearchPanel = $DrawerPanel/Margin/Content/ResearchPanel # References the research drawer content.
@onready var _research_buttons: GridContainer = $DrawerPanel/Margin/Content/ResearchPanel/Scroll/Buttons # References the research action grid.
@onready var _machine_panel: MachinePanel = $DrawerPanel/Margin/Content/MachinePanel # References the machine construction drawer content.
@onready var _machine_label: Label = $DrawerPanel/Margin/Content/MachinePanel/Status # References the machine status text.
@onready var _build_tab: ActionButton = $BottomBar/Margin/Nav/Build # References the construction drawer navigation button.
@onready var _workforce_tab: ActionButton = $BottomBar/Margin/Nav/Workforce # References the workforce drawer navigation button.
@onready var _research_tab: ActionButton = $BottomBar/Margin/Nav/Research # References the research drawer navigation button.
@onready var _machine_tab: ActionButton = $BottomBar/Margin/Nav/Machine # References the machine drawer navigation button.

var _active_panel: Control # Stores the currently selected drawer content or remains null while the drawer is closed.

func setup(game_state: GameState, begin_building_placement: Callable) -> void: # Composes specialized game UI systems and configures one-at-a-time drawer navigation.
    _resource_panel.setup(game_state)
    _build_panel.setup(game_state, _build_buttons, begin_building_placement, Callable(self, "_close_drawer"))
    _workforce_panel.setup(game_state, _workforce_summary, _training_buttons)
    _research_panel.setup(game_state, _research_buttons)
    _machine_panel.setup(game_state, _machine_label)
    _build_tab.setup("build", Callable(self, "_toggle_panel").bind(_build_panel))
    _workforce_tab.setup("scraplings", Callable(self, "_toggle_panel").bind(_workforce_panel))
    _research_tab.setup("research", Callable(self, "_toggle_panel").bind(_research_panel))
    _machine_tab.setup("machine", Callable(self, "_toggle_panel").bind(_machine_panel))
    _close_drawer()

func _toggle_panel(panel: Control) -> void: # Opens one gameplay drawer or closes it when its active navigation button is pressed again.
    if _drawer_panel.visible and _active_panel == panel:
        _close_drawer()
        return
    _active_panel = panel
    _drawer_panel.visible = true
    _build_panel.visible = panel == _build_panel
    _workforce_panel.visible = panel == _workforce_panel
    _research_panel.visible = panel == _research_panel
    _machine_panel.visible = panel == _machine_panel
    _refresh_navigation()

func _close_drawer() -> void: # Hides all optional gameplay panels while keeping the persistent header and dock visible.
    _active_panel = null
    _drawer_panel.visible = false
    _build_panel.visible = false
    _workforce_panel.visible = false
    _research_panel.visible = false
    _machine_panel.visible = false
    _refresh_navigation()

func _refresh_navigation() -> void: # Marks the currently open drawer in the compact bottom navigation bar.
    _build_tab.text = _tab_label("build", _build_panel)
    _workforce_tab.text = _tab_label("scraplings", _workforce_panel)
    _research_tab.text = _tab_label("research", _research_panel)
    _machine_tab.text = _tab_label("machine", _machine_panel)

func _tab_label(label_text: String, panel: Control) -> String: # Creates a small active-state marker without introducing extra UI state nodes.
    if _drawer_panel.visible and _active_panel == panel:
        return "> " + label_text
    return label_text
