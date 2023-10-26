class_name CostumePieceGrid
extends Node2D

signal piece_component_selected(selected_piece_component: CostumePiece.CostumeComponent)
signal pieces_selected(selected_pieces: Array[CostumePiece])

@export var num_rows: int = 3
@export var num_cols: int = 3

@onready var row_selector_zero: TextureButton = get_node("RowSelector0")
@onready var row_selector_one: TextureButton = get_node("RowSelector1")
@onready var row_selector_two: TextureButton = get_node("RowSelector2")
@onready var col_selector_zero: TextureButton = get_node("ColSelector0")
@onready var col_selector_one: TextureButton = get_node("ColSelector1")
@onready var col_selector_two: TextureButton = get_node("ColSelector2")

var grid = []
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	_setup_grid()
	_setup_selectors()

func _setup_grid():
	for row in num_rows:
		grid.append([])
		for col in num_cols:
			grid[row].append(0)
			_add_random_piece(row, col)
			

func _setup_selectors() -> void:
	row_selector_zero.pressed.connect(_on_selector_pressed.bind(true, 0, row_selector_zero))
	row_selector_one.pressed.connect(_on_selector_pressed.bind(true, 1, row_selector_one))
	row_selector_two.pressed.connect(_on_selector_pressed.bind(true, 2, row_selector_two))
	col_selector_zero.pressed.connect(_on_selector_pressed.bind(false, 0, col_selector_zero))
	col_selector_one.pressed.connect(_on_selector_pressed.bind(false, 1, col_selector_one))
	col_selector_two.pressed.connect(_on_selector_pressed.bind(false, 2, col_selector_two))

func _on_selector_pressed(is_row: bool, row_col_num: int, selector_btn: TextureButton) -> void:
	for child in get_children():
		if child is TextureButton:
			child.disabled = false
	var pieces_selected_in_row_col = []
	if is_row:
		for row in num_rows:
			var piece: CostumePiece = grid[row][row_col_num]
			pieces_selected_in_row_col.append(piece)
			_add_random_piece(row, row_col_num)
	else:
		for col in num_cols:
			var piece: CostumePiece = grid[row_col_num][col]
			pieces_selected_in_row_col.append(piece)
			_add_random_piece(row_col_num, col)
	
	selector_btn.disabled = true
	
	print("selector got these pieces")
	for costume_piece in pieces_selected_in_row_col:
		print(CostumePiece.CostumeComponent.keys()[costume_piece.costume_component])
	
	emit_signal("pieces_selected", pieces_selected_in_row_col)

func _add_random_piece(row, col) -> void:
	var rand_piece: CostumePiece = UtilHelper.create_random_costume_piece()
	rand_piece.position = Vector2(row, col) * Dimensions.costume_piece_vec2
	add_child(rand_piece)
	rand_piece.piece_selected.connect(_on_piece_selected)
	
	if grid[row][col] is CostumePiece:
		remove_child(grid[row][col])
	grid[row][col] = rand_piece

func _on_piece_selected(costume_piece: CostumePiece) -> void:
	print("CostumePiece %s selected with costume_component: %s" % [costume_piece, CostumePiece.CostumeComponent.keys()[costume_piece.costume_component]])
	emit_signal("piece_component_selected")
