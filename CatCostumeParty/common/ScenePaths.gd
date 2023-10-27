class_name ScenePaths
extends Node

static var costume_piece = "res://costume_pieces/CostumePiece.tscn"
static var costume_cat = "res://costume_cats/CostumeCat.tscn"
static var dracula_costume_cat = "res://costume_cats/dracula_cat/DraculaCostumeCat.tscn"

static var costume_piece_packed_scene = preload("res://costume_pieces/CostumePiece.tscn")
static var costume_cat_packed_scene = preload("res://costume_cats/CostumeCat.tscn")
static var dracula_costume_cat_packed_scene = preload("res://costume_cats/dracula_cat/DraculaCostumeCat.tscn")

static var all_costume_cats_packed_scenes = [dracula_costume_cat_packed_scene]
