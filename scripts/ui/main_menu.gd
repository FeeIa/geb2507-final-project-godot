extends Control

@onready var play = $Play
@onready var options = $Options
@onready var exit = $Exit
@onready var credits = $Credits

func _ready():
	play.pressed.connect(_on_play_pressed)
	options.pressed.connect(_on_options_pressed)
	exit.pressed.connect(_on_exit_pressed)
	credits.pressed.connect(_on_credits_pressed)
	
func _on_play_pressed():
	AudioManager.play_button_click_sfx()
	FadeTransition.transition_to_scene("res://scenes/ui/level_select.tscn")
	
func _on_options_pressed():
	AudioManager.play_button_click_sfx()
	OptionsMenu.open()

func _on_exit_pressed():
	AudioManager.play_button_click_sfx()
	FadeTransition.fade_out()
	await get_tree().create_timer(0.195).timeout
	get_tree().quit()

func _on_credits_pressed():
	AudioManager.play_button_click_sfx()
	Credits.open()
	
