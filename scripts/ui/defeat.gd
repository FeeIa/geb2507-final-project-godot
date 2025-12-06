extends CanvasLayer

func _ready():
	$Back.pressed.connect(func():
		AudioManager.play_button_click_sfx()
		GameManager.go_back_to_level_select()
		close()
	)
	
	$Again.pressed.connect(func():
		AudioManager.play_button_click_sfx()
		GameManager.restart_current_level()
		close()
	)

func open():
	visible = true
	await get_tree().create_timer(1.5).timeout
	AudioManager.play_sfx("res://assets/audio/sfx/defeat.wav")
	
func close():
	visible = false
