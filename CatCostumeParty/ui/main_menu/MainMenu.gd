class_name MainMenu
extends Node2D

signal option_selected(option: Option)

@onready var play_1p_button = $VBoxContainer/Play1pButton
@onready var play_2p_button = $VBoxContainer/Play2pButton
@onready var instructions_button = $VBoxContainer/InstructionsButton
@onready var credits_button = $VBoxContainer/CreditsButton

enum Option { PLAY_1P, PLAY_2P, INSTRUCTIONS, CREDITS }

func _ready():
	AudioManager.play_menu_theme()
	play_1p_button.pressed.connect(_on_button_pressed.bind(Option.PLAY_1P))
	play_2p_button.pressed.connect(_on_button_pressed.bind(Option.PLAY_2P))
	instructions_button.pressed.connect(_on_button_pressed.bind(Option.INSTRUCTIONS))
	credits_button.pressed.connect(_on_button_pressed.bind(Option.CREDITS))

func _on_button_pressed(option: Option) -> void:
	emit_signal("option_selected", option)
