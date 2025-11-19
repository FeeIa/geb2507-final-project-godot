extends Control

func _ready():
	for i in range(GameManager.highest_level_completed + 2, 6):
		get_node("Level_%d" % i).modulate.a = 0.75
	
	$Level_1.pressed.connect(func(): GameManager.load_level_scene(1))
	$Level_2.pressed.connect(func(): GameManager.load_level_scene(2))
	$Level_3.pressed.connect(func(): GameManager.load_level_scene(3))
	$Level_4.pressed.connect(func(): GameManager.load_level_scene(4))
	$Level_5.pressed.connect(func(): GameManager.load_level_scene(5))
	$Back.pressed.connect(func(): FadeTransition.transition_to_scene("res://scenes/ui/main_menu.tscn"))
