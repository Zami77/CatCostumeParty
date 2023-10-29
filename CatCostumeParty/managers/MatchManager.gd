class_name MatchManager
extends Node2D

signal completed_cat_animation_finished
signal completed_selected_pieces_animation_finished
signal load_scene(scene_path)

@export var dressed_cats_to_win = 5
@export var timer_wait_between_turns = 1.0
@export var timer_wait_on_costume_cat_completed = 1.0
@export var timer_wait_on_start_of_ai_turn = 1.0
@export var piece_movement_tween_duration = 0.35
@export var dressed_cat_tween_duration = 0.35
@export var is_ai = false

@onready var costume_piece_grid: CostumePieceGrid = get_node("CostumePieceGrid")
@onready var costume_cat_area_p1: Node2D = get_node("CostumeCatAreaP1")
@onready var costume_cat_area_p2: Node2D = get_node("CostumeCatAreaP2")
@onready var dressed_cat_area_p1: Node2D = get_node("DressedCatAreaP1")
@onready var dressed_cat_area_p2: Node2D = get_node("DressedCatAreaP2")
@onready var game_end_panel: GameEndPanel = get_node("CanvasLayer/GameEndPanel")
@onready var turn_label: Label = get_node("TurnLabel")

enum TurnState { P1, P2, GAME_END, NONE }
var turn_state = TurnState.P1
var winning_player = TurnState.NONE

var p1_dressed_cats = 0
var p2_dressed_cats = 0

func _ready():
	costume_piece_grid.pieces_selected.connect(_on_pieces_selected)
	game_end_panel.game_end_panel_option_selected.connect(_on_game_end_panel_option_selected)
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
	_check_for_game_win()
	
	if turn_state == TurnState.GAME_END:
		return
	
	turn_label.text = TurnState.keys()[turn_state] + " TURN"
	
	if is_ai and turn_state == TurnState.P2:
		costume_piece_grid.select_disabled = true
		_execute_ai_turn()
	else:
		costume_piece_grid.select_disabled = false

func _check_for_game_win() -> void:
	p1_dressed_cats = dressed_cat_area_p1.get_child_count()
	p2_dressed_cats = dressed_cat_area_p2.get_child_count()
	
	if p1_dressed_cats >= dressed_cats_to_win:
		turn_state = TurnState.GAME_END
		winning_player = TurnState.P1
	if p2_dressed_cats >= dressed_cats_to_win:
		turn_state = TurnState.GAME_END
		winning_player = TurnState.P2
	
	if turn_state == TurnState.GAME_END:
		_execute_game_win()

func _execute_game_win() -> void:
	AudioManager.play_game_end()
	game_end_panel.set_winning_player(winning_player)
	game_end_panel.visible = true
	costume_piece_grid.select_disabled = true

func _execute_ai_turn() -> void:
	# add delay before doing turn
	await get_tree().create_timer(timer_wait_on_start_of_ai_turn).timeout
	
	var selectable_options: Dictionary = costume_piece_grid.get_selectable_options()
	var ai_costume_cat: CostumeCat = costume_cat_area_p2.get_child(0)
	var best_match_count = 0
	var best_match_index = [true, 0]
	for option in selectable_options:
		if not option[0] == costume_piece_grid.disabled_aisle[0] and option[1] == costume_piece_grid.disabled_aisle[1]:
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
	
	# TODO: Somewhere here the logic is wrong, but it gets the correct result
	costume_piece_grid.select_row_or_col(\
		not best_match_index[0], \
		best_match_index[1], \
		costume_piece_grid.determine_selector_button(\
			best_match_index[0], \
			best_match_index[1]\
		)\
	)
	

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

	costume_piece_grid.select_disabled = true
	
	_handle_turn_logic(selected_pieces)

func _handle_turn_logic(selected_pieces: Array):
	costume_piece_grid.select_disabled = true
	var costume_cat_area = _get_costume_cat_and_dressed_area(turn_state).costume_cat_area
	_handle_selected_pieces_animation(selected_pieces.duplicate(true), costume_cat_area)
	await completed_selected_pieces_animation_finished
	
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
			
			if not child.costume_pieces_still_left:
				await completed_cat_animation_finished
	while not costume_piece_grid.grid_pieces_replenished:
		await get_tree().create_timer(0.1).timeout
	
	# swap turns and a small wait buffer between turns
	turn_state = TurnState.P2 if turn_state == TurnState.P1 else TurnState.P1
	await get_tree().create_timer(timer_wait_between_turns).timeout
	_update_turn()

func _handle_selected_pieces_animation(selected_pieces: Array, costume_cat_area: Node2D) -> void:
	for piece in selected_pieces:
		var old_global_position = piece.global_position
		piece.global_position = old_global_position
		var piece_tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
		piece_tween.tween_property(piece, "global_position", costume_cat_area.global_position + Dimensions.costume_cat_vec2 / 2, piece_movement_tween_duration)
		AudioManager.play_collect_costume_piece()
		await piece_tween.finished
		costume_piece_grid.remove_child(piece)
	emit_signal("completed_selected_pieces_animation_finished")
	costume_piece_grid._on_completed_selected_pieces_animation_finished()

func _on_costume_completed(completed_cat: CostumeCat, owning_player: TurnState) -> void:
	var costume_cat_area_and_dressed_area = _get_costume_cat_and_dressed_area(owning_player)
	var costume_cat_area: Node2D = costume_cat_area_and_dressed_area.costume_cat_area
	var dressed_cat_area: Node2D = costume_cat_area_and_dressed_area.dressed_cat_area

	AudioManager.play_costume_cat_completed()
	await get_tree().create_timer(timer_wait_on_costume_cat_completed).timeout
	var old_costume_cat_global_pos = completed_cat.global_position
	costume_cat_area.remove_child(completed_cat)
	_add_dressed_cat(completed_cat, old_costume_cat_global_pos, dressed_cat_area, owning_player)
	await completed_cat_animation_finished
	_setup_costume_cat_areas()

func _add_dressed_cat(completed_cat: CostumeCat, old_global_position: Vector2, dressed_cat_area: Node2D, owning_player: TurnState) -> void:
	var width_pos = dressed_cat_area.get_child_count() * Dimensions.costume_piece_width
	dressed_cat_area.add_child(completed_cat)
	completed_cat.global_position = old_global_position
	var new_scale = Vector2(0.33, 0.33)
	var new_position = Vector2(\
		width_pos * (1 if owning_player == TurnState.P1 else - 1),\
		0\
	)
	
	var dressed_cat_position_tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	var dressed_cat_scale_tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	dressed_cat_position_tween.tween_property(completed_cat, "position", new_position, dressed_cat_tween_duration)
	dressed_cat_scale_tween.tween_property(completed_cat, "scale", new_scale, dressed_cat_tween_duration)
	AudioManager.play_dressed_cat_move()
	await dressed_cat_position_tween.finished
	await dressed_cat_scale_tween.finished
	
	emit_signal("completed_cat_animation_finished")

func _on_game_end_panel_option_selected(option: GameEndPanel.Option) -> void:
	match option:
		GameEndPanel.Option.PLAY:
			emit_signal("load_scene", ScenePaths.match_manager)
		GameEndPanel.Option.MAIN_MENU:
			emit_signal("load_scene", ScenePaths.main_menu)
