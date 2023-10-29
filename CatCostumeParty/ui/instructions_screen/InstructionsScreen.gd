class_name InstructionsScreen
extends Node2D

signal load_scene(scene_path)

@onready var back_to_main_menu_button: Button = get_node("BackToMainMenuButton")
# Called when the node enters the scene tree for the first time.
func _ready():
	back_to_main_menu_button.pressed.connect(_on_back_to_main_menu_button_pressed)

func _on_back_to_main_menu_button_pressed() -> void:
	emit_signal("load_scene", ScenePaths.main_menu)
