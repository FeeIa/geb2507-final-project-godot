extends CanvasLayer

func _ready():
	$Back.pressed.connect(func():
		GameManager.go_back_to_level_select()
		close()
	)
	$Restart.pressed.connect(func():
		GameManager.restart_current_level()
		close()
	)
	$Close.pressed.connect(close)
	
func open():
	visible = true
	GameManager.pause_game()
	
func close():
	visible = false
	GameManager.unpause_game()
