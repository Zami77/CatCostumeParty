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
	if not texture_rect:
		return
	match costume_component:
		CostumeComponent.CLOAK:
			texture_rect.texture = CostumePieceTextures.cloak
		CostumeComponent.FANGS:
			texture_rect.texture = CostumePieceTextures.fangs
		CostumeComponent.BROOM:
			texture_rect.texture = CostumePieceTextures.broom

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		emit_signal("piece_selected", self)
