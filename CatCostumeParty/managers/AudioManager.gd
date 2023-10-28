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

func _process(delta):
	if not sfx_queue.empty() and not available_players.empty():
		available_players[0].stream = load(sfx_queue.pop_front())
		available_players[0].play()
		available_players.pop_front()
