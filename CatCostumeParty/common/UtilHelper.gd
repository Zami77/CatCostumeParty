class_name UtilHelper
extends Node

static func create_random_costume_piece() -> CostumePiece:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rand_costume_component: CostumePiece.CostumeComponent = rng.randi_range(0, len(CostumePiece.CostumeComponent) - 1) as CostumePiece.CostumeComponent
	var costume_piece: CostumePiece = ScenePaths.costume_piece_packed_scene.instantiate()
	costume_piece.costume_component = rand_costume_component
	return costume_piece

static func create_costume_piece(costume_component: CostumePiece.CostumeComponent) -> CostumePiece:
	var costume_piece: CostumePiece = ScenePaths.costume_piece_packed_scene.instantiate()
	costume_piece.costume_component = costume_component
	return costume_piece

static func create_random_costume_cat() -> CostumeCat:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return ScenePaths.all_costume_cats_packed_scenes[rng.randi_range(0, len(ScenePaths.all_costume_cats_packed_scenes) - 1)].instantiate()
