extends Node2D

@onready var bgm_player = $BGMPlayer
@onready var sfx_player = $SFXPlayer

func play_bgm(path: String):
	bgm_player.stream = load(path)
	bgm_player.play()
	
func stop_bgm():
	bgm_player.stop()
	
func play_sfx(path: String):
	sfx_player.stream = load(path)
	sfx_player.play()
