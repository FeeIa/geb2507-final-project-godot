extends Control

func _ready():
	$VBoxContainer/Start.pressed.connect(start_game)
	$VBoxContainer/Quit.pressed.connect(quit_game)
	
func start_game():
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")
	
func quit_game():
	get_tree().quit()
