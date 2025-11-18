extends Control

func _ready():
	$Level_1.pressed.connect(func(): GameManager.load_level_scene("level_1"))
	$Level_2.pressed.connect(func(): GameManager.load_level_scene("level_2"))
	$Level_3.pressed.connect(func(): GameManager.load_level_scene("level_3"))
	$Level_4.pressed.connect(func(): GameManager.load_level_scene("level_4"))
	$Level_5.pressed.connect(func(): GameManager.load_level_scene("level_5"))
	$Back.pressed.connect(func(): FadeTransition.transition_to_scene("res://scenes/ui/main_menu.tscn"))
