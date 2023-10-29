extends Node

enum BgmPlaying { MAIN_MENU, MATCH }

var num_players = 16
var bus_master = "Master"
var bus_sound_effects = "SoundEffects"
var bus_music = "Music"

var bgm_player = AudioStreamPlayer.new()
var bgm_playing = BgmPlaying.MAIN_MENU
var available_players = []  
var sfx_queue = []  

var rng = RandomNumberGenerator.new()

var costume_cat_completed = "res://costume_cats/costume_cat_sound_fx/LQ_Positive_Notification.wav"

var whoosh = [
	"res://costume_pieces/costume_piece_sound_fx/FA_Whoosh_1_1.wav", 
	"res://costume_pieces/costume_piece_sound_fx/FA_Whoosh_1_2.wav", 
	"res://costume_pieces/costume_piece_sound_fx/FA_Whoosh_1_3.wav"
]

var piece_added_to_grid = [
	"res://costume_pieces/costume_piece_sound_fx/piece_added_to_grid/CGM3_Bubble_Button_01_3.wav", 
	"res://costume_pieces/costume_piece_sound_fx/piece_added_to_grid/CGM3_Bubble_Button_01_4.wav", 
	"res://costume_pieces/costume_piece_sound_fx/piece_added_to_grid/CGM3_Bubble_Button_01_5.wav"
]

var game_end = "res://common/sound_fx/game_end.mp3"
var button_press = "res://ui/button_sfx/FA_Confirm_Button_1_1.wav"
var button_hover = "res://ui/button_sfx/button_hover.wav"

func _ready():
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available_players.append(p)
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = bus_sound_effects
	
	bgm_player.bus = bus_music
	bgm_player.finished.connect(_on_bgm_player_finished)
	add_child(bgm_player)
		
	rng.randomize()

func _on_stream_finished(stream) -> void:
	stream.stop()
	available_players.append(stream)

func _on_bgm_player_finished():
	match bgm_playing:
		BgmPlaying.MAIN_MENU:
			pass
		BgmPlaying.MATCH:
			play_battle_theme()

func play_battle_theme() -> void:
	pass

func play_sfx(sound_path):
	sfx_queue.append(sound_path)

func _fadeout_bgm():
	bgm_player.stop()

func play_collect_costume_piece() -> void:
	play_sfx(whoosh[rng.randi_range(0, len(whoosh) - 1)])

func play_costume_cat_completed() -> void:
	play_sfx(costume_cat_completed)

func play_dressed_cat_move() -> void:
	play_sfx(whoosh[rng.randi_range(0, len(whoosh) - 1)])

func play_piece_added_to_grid() -> void:
	play_sfx(piece_added_to_grid[rng.randi_range(0, len(piece_added_to_grid) - 1)])

func play_game_end() -> void:
	play_sfx(game_end)

func play_button_press() -> void:
	play_sfx(button_press)

func play_button_hover() -> void:
	play_sfx(button_hover)

func _process(delta):
	if not sfx_queue.is_empty() and not available_players.is_empty():
		available_players[0].stream = load(sfx_queue.pop_front())
		available_players[0].play()
		available_players.pop_front()
