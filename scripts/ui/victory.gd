extends CanvasLayer

func _ready():
	$Next.pressed.connect(func():
		GameManager.load_level_scene(GameManager.current_playing_level + 1)
		close()
	)
	
	$Again.pressed.connect(func():
		GameManager.load_level_scene(GameManager.current_playing_level)
		close()
	)

func open():
	visible = true
	
func close():
	visible = false
