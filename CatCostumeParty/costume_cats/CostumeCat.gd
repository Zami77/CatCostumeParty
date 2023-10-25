class_name CostumeCat
extends Area2D

signal costume_completed

@export var initial_cat_texture: Texture
@export var costumed_cat_texture: Texture
@export var costume_pieces_required: Array[CostumePiece.CostumeComponent]

@onready var texture_rect: TextureRect = get_node("TextureRect")

var costume_pieces_still_left = []
var costume_state = CostumeState.INITIAL

enum CostumeState { INITIAL, COMPLETE }

func _ready():
	texture_rect.texture = initial_cat_texture
	costume_pieces_still_left = costume_pieces_required.duplicate(true)
	body_entered.connect(_on_body_entered)

func add_piece(piece: CostumePiece.CostumeComponent):
	if piece in costume_pieces_still_left:
		costume_pieces_still_left.erase(piece)

func _check_costume_complete() -> void:
	if costume_pieces_still_left:
		return

func _handle_cat_costume_complete() -> void:
	texture_rect.texture = costumed_cat_texture
	costume_state = CostumeState.COMPLETE
	emit_signal("costume_completed")

func _on_body_entered(_body: Node2D) -> void:
	# TODO: use this if going with click and drag
	pass
