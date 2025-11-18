extends Control

@onready var play = $Play
@onready var options = $Options
@onready var cont = $Continue
@onready var levels = $Levels

func _ready():
	play.pressed.connect(_on_play_pressed)
	options.pressed.connect(_on_options_pressed)
	cont.pressed.connect(_on_cont_pressed)	
	levels.pressed.connect(_on_levels_pressed)
	
func _on_play_pressed():
	print("PLAY BUTTON PRESSED")
	
func _on_options_pressed():
	print("OPTIONS PRESSED")
	
func _on_cont_pressed():
	print("CONTINUE PRESSED")
	
func _on_levels_pressed():
	FadeTransition.transition_to_scene("res://scenes/ui/level_select.tscn")
