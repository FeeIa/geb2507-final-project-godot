extends Control

func _ready():
	GameManager.connect("level_money_changed", _update_level_money)
	GameManager.connect("lives_changed", _update_lives)
	$StartWave.pressed.connect(_on_start_button_pressed)
	_update_level_money()
	_update_lives()
	
func _update_level_money():
	$LevelMoney.text = "Money: %d" % GameManager.level_money

func _update_lives():
	$Lives.text = "Lives: %d" % GameManager.lives

func _on_start_button_pressed():
	var wave_manager = get_tree().current_scene.get_node("WaveManager")
	if wave_manager:
		wave_manager.start_next_wave()
	else:
		print("[Error] WaveManager is not found!")	
