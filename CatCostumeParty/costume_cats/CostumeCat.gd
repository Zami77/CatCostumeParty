class_name CostumeCat
extends Area2D

signal costume_completed

@export var initial_cat_texture: Texture
@export var costumed_cat_texture: Texture
@export var costume_pieces_required: Array[CostumePiece.CostumeComponent]
@export var cat_name: String = "Sample Cat Name"

@onready var texture_rect: TextureRect = get_node("TextureRect")
@onready var costume_piece_area: Node2D = get_node("CostumePieceArea")
@onready var cat_name_label: Label = get_node("CatNameLabel")

var costume_pieces_still_left = []
var costume_state = CostumeState.INITIAL

enum CostumeState { INITIAL, COMPLETE }

func _ready():
	texture_rect.texture = initial_cat_texture
	costume_pieces_still_left = costume_pieces_required.duplicate(true)
	_setup_cat_costume_pieces()
	body_entered.connect(_on_body_entered)
	cat_name_label.text = cat_name

func add_piece(piece: CostumePiece.CostumeComponent):
	if piece in costume_pieces_still_left:
		costume_pieces_still_left.erase(piece)
		_setup_cat_costume_pieces()
	_check_costume_complete()
	
func _setup_cat_costume_pieces() -> void:
	for child in costume_piece_area.get_children():
		costume_piece_area.remove_child(child)
		
	for i in len(costume_pieces_still_left):
		var costume_piece = UtilHelper.create_costume_piece(costume_pieces_still_left[i])
		costume_piece_area.add_child(costume_piece)
		costume_piece.position = Vector2(i * Dimensions.costume_piece_width, 0)

func _check_costume_complete() -> void:
	if costume_pieces_still_left:
		return
	_handle_cat_costume_complete()

func _handle_cat_costume_complete() -> void:
	texture_rect.texture = costumed_cat_texture
	costume_state = CostumeState.COMPLETE
	emit_signal("costume_completed")

func _on_body_entered(_body: Node2D) -> void:
	# TODO: use this if going with click and drag
	pass
