class_name CostumePiece
extends Area2D

enum CostumeComponent { CLOAK, FANGS, BROOM, EYE_PATCH, HOOK, PIRATE_HAT, WIZARD_HAT, WAND, GOBLET }

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
		CostumeComponent.WIZARD_HAT:
			texture_rect.texture = CostumePieceTextures.wizard_hat
		CostumeComponent.WAND:
			texture_rect.texture = CostumePieceTextures.wand
		CostumeComponent.EYE_PATCH:
			texture_rect.texture = CostumePieceTextures.eye_patch
		CostumeComponent.HOOK:
			texture_rect.texture = CostumePieceTextures.hook
		CostumeComponent.PIRATE_HAT:
			texture_rect.texture = CostumePieceTextures.pirate_hat
		CostumeComponent.GOBLET:
			texture_rect.texture = CostumePieceTextures.goblet

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		emit_signal("piece_selected", self)
