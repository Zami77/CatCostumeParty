class_name ScenePaths
extends Node

static var main_menu = "res://ui/main_menu/MainMenu.tscn"
static var match_manager = "res://managers/MatchManager.tscn"
static var credits_screen = "res://ui/credits_screen/CreditsScreen.tscn"
static var instructions_screen = "res://ui/instructions_screen/InstructionsScreen.tscn"

static var costume_piece = "res://costume_pieces/CostumePiece.tscn"
static var costume_cat = "res://costume_cats/CostumeCat.tscn"
static var dracula_costume_cat = "res://costume_cats/dracula_cat/DraculaCostumeCat.tscn"
static var pirate_costume_cat = "res://costume_cats/pirate_cat/PirateCostumeCat.tscn"
static var wizard_costume_cat = "res://costume_cats/wizard_cat/WizardCostumeCat.tscn"

static var costume_piece_packed_scene = preload("res://costume_pieces/CostumePiece.tscn")
static var costume_cat_packed_scene = preload("res://costume_cats/CostumeCat.tscn")
static var dracula_costume_cat_packed_scene = preload("res://costume_cats/dracula_cat/DraculaCostumeCat.tscn")
static var pirate_costume_cat_packed_scene = preload("res://costume_cats/pirate_cat/PirateCostumeCat.tscn")
static var wizard_costume_cat_packed_scene = preload("res://costume_cats/wizard_cat/WizardCostumeCat.tscn")

static var all_costume_cats_packed_scenes = [dracula_costume_cat_packed_scene, pirate_costume_cat_packed_scene, wizard_costume_cat_packed_scene]
