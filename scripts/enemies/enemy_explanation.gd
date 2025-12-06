extends CanvasLayer

var enemy_type: String = "null"

func _ready() -> void:
	$Close.pressed.connect(func():
		AudioManager.play_button_click_sfx()
		close()
	)

func open_for(type: String):
	AudioManager.play_sfx("res://assets/audio/sfx/notif.wav")
	enemy_type = type
	$Explanation.texture = load(Database.get_enemy_data(enemy_type).get("explanation"))
	visible = true
	GameManager.pause_game()

func close():
	enemy_type = "null"
	visible = false
	GameManager.unpause_game()
