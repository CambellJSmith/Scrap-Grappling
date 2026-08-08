class_name Hud
extends Control

@onready var _resource_panel: ResourcePanel = $TopPanel/Margin/ResourcePanel # References the editor-created resource panel.
@onready var _resource_label: Label = $TopPanel/Margin/ResourcePanel/Resources # References the editor-created resource label.
@onready var _build_panel: BuildPanel = $LeftPanel/Margin/BuildPanel # References the editor-created building panel.
@onready var _build_buttons: VBoxContainer = $LeftPanel/Margin/BuildPanel/Scroll/Buttons # References the editor-created construction button container.
@onready var _workforce_panel: WorkforcePanel = $RightPanel/Margin/RightColumn/WorkforcePanel # References the editor-created workforce panel.
@onready var _workforce_summary: Label = $RightPanel/Margin/RightColumn/WorkforcePanel/Summary # References the editor-created workforce summary label.
@onready var _training_buttons: VBoxContainer = $RightPanel/Margin/RightColumn/WorkforcePanel/TrainingScroll/Buttons # References the editor-created training button container.
@onready var _research_panel: ResearchPanel = $RightPanel/Margin/RightColumn/ResearchPanel # References the editor-created research panel.
@onready var _research_buttons: VBoxContainer = $RightPanel/Margin/RightColumn/ResearchPanel/ResearchScroll/Buttons # References the editor-created research button container.
@onready var _machine_panel: MachinePanel = $BottomPanel/Margin/MachinePanel # References the editor-created machine panel.
@onready var _machine_label: Label = $BottomPanel/Margin/MachinePanel/Status # References the editor-created machine status label.

func setup(game_state: GameState) -> void: # Composes specialized UI panels around one shared authoritative game state.
    _resource_panel.setup(game_state, _resource_label)
    _build_panel.setup(game_state, _build_buttons)
    _workforce_panel.setup(game_state, _workforce_summary, _training_buttons)
    _research_panel.setup(game_state, _research_buttons)
    _machine_panel.setup(game_state, _machine_label)
