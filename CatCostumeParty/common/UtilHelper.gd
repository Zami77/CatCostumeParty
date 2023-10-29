extends Node

var rng = RandomNumberGenerator.new()
var costume_piece_bag = []
var costume_cat_bag = []

func _ready():
	rng.randomize()
	_fill_bags()

func _fill_bags() -> void:
	_fill_costume_piece_bag()
	_fill_costume_cat_bag()

func _fill_costume_piece_bag() -> void:
	if not costume_piece_bag:
		costume_piece_bag = CostumePiece.CostumeComponent.values() + CostumePiece.CostumeComponent.values()

func _fill_costume_cat_bag() -> void:
	if not costume_cat_bag:
		costume_cat_bag = ScenePaths.all_costume_cats_packed_scenes + ScenePaths.all_costume_cats_packed_scenes

func create_random_costume_piece() -> CostumePiece:
	_fill_bags()
	rng.randomize()
	var rand_costume_component: CostumePiece.CostumeComponent = costume_piece_bag.pop_at(rng.randi_range(0, len(costume_piece_bag) - 1)) as CostumePiece.CostumeComponent
	var costume_piece: CostumePiece = ScenePaths.costume_piece_packed_scene.instantiate()
	costume_piece.costume_component = rand_costume_component
	return costume_piece

func create_costume_piece(costume_component: CostumePiece.CostumeComponent) -> CostumePiece:
	var costume_piece: CostumePiece = ScenePaths.costume_piece_packed_scene.instantiate()
	costume_piece.costume_component = costume_component
	return costume_piece

func create_random_costume_cat() -> CostumeCat:
	_fill_bags()
	rng.randomize()
	return costume_cat_bag.pop_at(rng.randi_range(0, len(costume_cat_bag) - 1)).instantiate()
