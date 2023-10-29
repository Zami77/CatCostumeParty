class_name GameEndPanel
extends Node2D

signal game_end_panel_option_selected(option: Option)

@onready var play_button: Button = $VBoxContainer/PlayButton
@onready var main_menu_button: Button = $VBoxContainer/MainMenuButton
@onready var winner_label: Label = $WinnerLabel

enum Option { PLAY, MAIN_MENU }

func _ready():
	play_button.pressed.connect(_on_button_pressed.bind(Option.PLAY))
	main_menu_button.pressed.connect(_on_button_pressed.bind(Option.MAIN_MENU))

func set_winning_player(winning_player: MatchManager.TurnState) -> void:
	winner_label.text = "%s WINS!" % MatchManager.TurnState.keys()[winning_player]

func _on_button_pressed(option: Option) -> void:
	emit_signal("game_end_panel_option_selected", option)
