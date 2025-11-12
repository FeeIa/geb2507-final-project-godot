extends Control

@onready var money_label: Label = $MoneyLabel
@onready var lives_label: Label = $LivesLabel
@onready var start_button: Button = $StartWave

func _ready():
	GameManager.money_changed.connect(_update_money)
	GameManager.lives_changed.connect(_update_lives)
	start_button.pressed.connect(_on_start_button_pressed)
	_update_money(GameManager.money)
	_update_lives(GameManager.lives)
	
func _update_money(money):
	money_label.text = "Money: " + str(money)
	
func _update_lives(lives):
	lives_label.text = "Lives: " + str(lives)
	
func _on_start_button_pressed():
	var wave_manager = get_tree().current_scene.get_node("WaveManager")
	if wave_manager:
		wave_manager.start_wave()
	else:
		print("[Error] WaveManager is not found!")	
	
	
	
	
