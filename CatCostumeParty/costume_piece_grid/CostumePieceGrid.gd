class_name CostumePieceGrid
extends Node2D

signal piece_component_selected(selected_piece_component: CostumePiece.CostumeComponent)

@export var num_rows: int = 3
@export var num_cols: int = 3

var grid = []
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	_setup_grid() 

func _setup_grid():
	for row in num_rows:
		grid.append([])
		for col in num_cols:
			var rand_piece: CostumePiece = UtilHelper.create_random_costume_piece()
			grid[row].append(rand_piece)
			rand_piece.position = Vector2(row, col) * Dimensions.costume_piece_vec2
			add_child(rand_piece)
			rand_piece.piece_selected.connect(_on_piece_selected)

func _on_piece_selected(costume_piece: CostumePiece) -> void:
	print("CostumePiece %s selected with costume_component: %s" % [costume_piece, CostumePiece.CostumeComponent.keys()[costume_piece.costume_component]])
	emit_signal("piece_component_selected")
