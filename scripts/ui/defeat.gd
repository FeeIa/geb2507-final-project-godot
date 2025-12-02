extends CanvasLayer

func _ready():
	$Back.pressed.connect(func():
		FadeTransition.transition_to_scene("res://scenes/ui/level_select.tscn")
		close()
		LevelHud.close()
	)
	
	$Again.pressed.connect(func():
		GameManager.load_level_scene(GameManager.current_playing_level)
		close()
	)

func open():
	visible = true
	
func close():
	visible = false
