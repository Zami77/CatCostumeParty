class_name MatchManager
extends Node2D

@onready var costume_piece_grid: CostumePieceGrid = get_node("CostumePieceGrid")
@onready var costume_cat_area: Node2D = get_node("CostumeCatArea")

func _ready():
	costume_piece_grid.pieces_selected.connect(_on_pieces_selected)

func _on_pieces_selected(selected_pieces) -> void:
	for child in costume_cat_area.get_children():
		if child is CostumeCat:
			var pieces_left = child.costume_pieces_still_left.duplicate(true)
			var pieces_to_add = []
			for piece in selected_pieces:
				if piece.costume_component in pieces_left:
					pieces_to_add.append(piece.costume_component)
					pieces_left.erase(piece.costume_component)
			for add_piece in pieces_to_add:
				child.add_piece(add_piece)
