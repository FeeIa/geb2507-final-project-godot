extends CanvasLayer

func _ready():
	$Back.pressed.connect(func():
		AudioManager.play_button_click_sfx()
		GameManager.go_back_to_level_select()
		close()
	)
	$Restart.pressed.connect(func():
		AudioManager.play_button_click_sfx()
		GameManager.restart_current_level()
		close()
	)
	$Close.pressed.connect(func():
		AudioManager.play_button_click_sfx()
		close()
	)
	
func open():
	visible = true
	GameManager.pause_game()
	
func close():
	visible = false
	GameManager.unpause_game()
