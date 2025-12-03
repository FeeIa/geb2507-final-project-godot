extends CanvasLayer

func _ready():
	$Back.pressed.connect(func():
		LevelHud.close()
		TowerMenu.close()
		EnemyExplanation.close()
		FadeTransition.transition_to_scene("res://scenes/ui/level_select.tscn")
		close()
	)
	
	$Again.pressed.connect(func():
		LevelHud.close()
		TowerMenu.close()
		EnemyExplanation.close()
		GameManager.load_level_scene(GameManager.current_playing_level)
		close()
	)

func open():
	visible = true
	
func close():
	visible = false
