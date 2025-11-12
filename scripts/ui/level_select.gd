extends Control

func _ready():
	$VBoxContainer/Level_1.pressed.connect(func(): _start_level("level_1"))
	$VBoxContainer/Level_2.pressed.connect(func(): _start_level("level_2"))
	$VBoxContainer/Back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main_menu.tscn"))

func _start_level(level_name: String):
	get_tree().change_scene_to_file("res://scenes/levels/%s.tscn" % level_name)
