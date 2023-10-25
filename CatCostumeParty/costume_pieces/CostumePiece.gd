class_name CostumePiece
extends Area2D

enum CostumeComponent { CLOAK, FANGS, BROOM }

signal piece_selected(selected_piece: CostumePiece)

@export var costume_component: CostumeComponent :
	set(value):
		costume_component = value
		_load_costume_piece_image()

@onready var texture_rect: TextureRect = get_node("TextureRect")

func _ready():
	_load_costume_piece_image()
	input_event.connect(_on_input_event)

func _load_costume_piece_image():
	match costume_component:
		CostumeComponent.CLOAK:
			pass
		CostumeComponent.FANGS:
			pass
		CostumeComponent.BROOM:
			pass

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		emit_signal("piece_selected", self)
