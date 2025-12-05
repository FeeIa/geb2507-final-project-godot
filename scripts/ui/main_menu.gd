extends Control

@onready var play = $Play
@onready var options = $Options

func _ready():
	play.pressed.connect(_on_play_pressed)
	options.pressed.connect(_on_options_pressed)
	
func _on_play_pressed():
	print("PLAY BUTTON PRESSED")
	FadeTransition.transition_to_scene("res://scenes/ui/level_select.tscn")
	
func _on_options_pressed():
	print("OPTIONS PRESSED")
