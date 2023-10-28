class_name MatchManager
extends Node2D

@export var is_ai = false

@onready var costume_piece_grid: CostumePieceGrid = get_node("CostumePieceGrid")
@onready var costume_cat_area_p1: Node2D = get_node("CostumeCatAreaP1")
@onready var costume_cat_area_p2: Node2D = get_node("CostumeCatAreaP2")
@onready var dressed_cat_area_p1: Node2D = get_node("DressedCatAreaP1")
@onready var dressed_cat_area_p2: Node2D = get_node("DressedCatAreaP2")

@onready var turn_label: Label = get_node("TurnLabel")
enum TurnState { P1, P2, GAME_END }
var turn_state = TurnState.P1

func _ready():
	costume_piece_grid.pieces_selected.connect(_on_pieces_selected)
	_setup_costume_cat_areas()
	_update_turn()

func _setup_costume_cat_areas() -> void:
	if not costume_cat_area_p1.get_child_count():
		var rand_costume_cat = UtilHelper.create_random_costume_cat()
		costume_cat_area_p1.add_child(rand_costume_cat)
		rand_costume_cat.costume_completed.connect(_on_costume_completed.bind(rand_costume_cat, TurnState.P1))
	if not costume_cat_area_p2.get_child_count():
		var rand_costume_cat = UtilHelper.create_random_costume_cat()
		costume_cat_area_p2.add_child(rand_costume_cat)
		rand_costume_cat.costume_completed.connect(_on_costume_completed.bind(rand_costume_cat, TurnState.P2))


func _update_turn() -> void:
	turn_label.text = TurnState.keys()[turn_state]
	costume_piece_grid.select_disabled = false
	
	if is_ai and turn_state == TurnState.P2:
		costume_piece_grid.select_disabled = true
		_execute_ai_turn()
		
func _execute_ai_turn() -> void:
	# add delay before doing turn
	await get_tree().create_timer(1.0).timeout
	
	var selectable_options: Dictionary = costume_piece_grid.get_selectable_options()
	var ai_costume_cat: CostumeCat = costume_cat_area_p2.get_child(0)
	var best_match_count = 0
	var best_match_index = [true, 0]
	for option in selectable_options:
		if option == costume_piece_grid.disabled_aisle:
			continue
		var current_match_count = 0
		var dupe_costume_pieces_left = ai_costume_cat.costume_pieces_still_left.duplicate(true)
		for piece in selectable_options[option]:
			if piece in dupe_costume_pieces_left:
				current_match_count += 1
			dupe_costume_pieces_left.erase(piece)
		if current_match_count >= best_match_count:
			best_match_count = current_match_count
			best_match_index = option
	
	costume_piece_grid.select_row_or_col(\
		not best_match_index[0], \
		best_match_index[1], \
		costume_piece_grid.determine_selector_button(\
			best_match_index[0], \
			best_match_index[1]\
		)\
	)
	
	costume_piece_grid.select_disabled = false

func _get_costume_cat_and_dressed_area(player: TurnState) -> Dictionary:
	var costume_cat_area
	var dressed_cat_area
	if player == TurnState.P1:
		costume_cat_area = costume_cat_area_p1
		dressed_cat_area = dressed_cat_area_p1
	elif player == TurnState.P2:
		costume_cat_area = costume_cat_area_p2
		dressed_cat_area = dressed_cat_area_p2
	return {
		"costume_cat_area": costume_cat_area,
		"dressed_cat_area": dressed_cat_area
	}

func _on_pieces_selected(selected_pieces) -> void:
	if turn_state == TurnState.GAME_END:
		return
	_handle_turn_logic(selected_pieces)

func _handle_turn_logic(selected_pieces):
	var costume_cat_area = _get_costume_cat_and_dressed_area(turn_state).costume_cat_area
		
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
	# swap turns
	turn_state = TurnState.P2 if turn_state == TurnState.P1 else TurnState.P1
	_update_turn()

func _on_costume_completed(completed_cat: CostumeCat, owning_player: TurnState) -> void:
	var costume_cat_area_and_dressed_area = _get_costume_cat_and_dressed_area(owning_player)
	var costume_cat_area: Node2D = costume_cat_area_and_dressed_area.costume_cat_area
	var dressed_cat_area: Node2D = costume_cat_area_and_dressed_area.dressed_cat_area
	# temp timer to see cat in costume, TODO: tween animation
	await get_tree().create_timer(1.0).timeout
	costume_cat_area.remove_child(completed_cat)
	_add_dressed_cat(completed_cat, dressed_cat_area, owning_player)
	_setup_costume_cat_areas()

func _add_dressed_cat(completed_cat: CostumeCat, dressed_cat_area: Node2D, owning_player: TurnState) -> void:
	var width_pos = dressed_cat_area.get_child_count() * Dimensions.costume_piece_width
	dressed_cat_area.add_child(completed_cat)
	completed_cat.scale = Vector2(0.33, 0.33)
	completed_cat.position = Vector2(\
		width_pos * (1 if owning_player == TurnState.P1 else - 1),\
		0\
	)
