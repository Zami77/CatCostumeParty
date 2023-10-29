class_name GameManager
extends Node2D

@export var default_scene = "res://ui/main_menu/MainMenu.tscn"

@onready var transition_screen: TransitionScreen = $TransitionScreen

var current_scene = null
var is_ai = false

func _ready():
	transition_screen.visible = false
	_load_scene(default_scene)

func _load_scene(scene_path: String):
	transition_screen.fade_to_black()
	await transition_screen.faded_to_black
	
	var new_packed_scene = load(scene_path) as PackedScene
	var new_scene = new_packed_scene.instantiate()
	
	if current_scene:
		current_scene.queue_free()
	
	current_scene = new_scene
	transition_screen.fade_to_scene()
	add_child(new_scene)
	
	if current_scene is MainMenu:
		current_scene.option_selected.connect(_on_main_menu_button_pressed)
	if current_scene is MatchManager:
		current_scene.is_ai = is_ai
		current_scene.load_scene.connect(_on_load_scene)
	if current_scene is InstructionsScreen:
		current_scene.load_scene.connect(_on_load_scene)
	
	await transition_screen.faded_to_scene

func _on_main_menu_button_pressed(option: MainMenu.Option) -> void:
	match option:
		MainMenu.Option.PLAY_1P:
			is_ai = true
			_load_scene(ScenePaths.match_manager)
		MainMenu.Option.PLAY_2P:
			is_ai = false
			_load_scene(ScenePaths.match_manager)
		MainMenu.Option.INSTRUCTIONS:
			_load_scene(ScenePaths.instructions_screen)
		MainMenu.Option.CREDITS:
			_load_scene(ScenePaths.credits_screen)

func _on_load_scene(scene_path) -> void:
	_load_scene(scene_path)
