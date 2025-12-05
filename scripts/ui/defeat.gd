extends CanvasLayer

func _ready():
	$Back.pressed.connect(func():
		GameManager.go_back_to_level_select()
		close()
	)
	
	$Again.pressed.connect(func():
		GameManager.restart_current_level()
		close()
	)

func open():
	visible = true
	
func close():
	visible = false
