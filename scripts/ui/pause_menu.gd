extends CanvasLayer

func _ready():
	$Back.pressed.connect(func():
		LevelHud.close()
		TowerMenu.close()
		EnemyExplanation.close()
		PlacementManager.close_menu()
		PlacementManager.turn_off()
		FadeTransition.transition_to_scene("res://scenes/ui/level_select.tscn")
		close()
	)
	$Restart.pressed.connect(func():
		LevelHud.close()
		TowerMenu.close()
		EnemyExplanation.close()
		GameManager.load_level_scene(GameManager.current_playing_level)
		close()
	)
	$Close.pressed.connect(close)
	
func open():
	visible = true
	GameManager.pause_game()
	
func close():
	visible = false
	GameManager.unpause_game()
