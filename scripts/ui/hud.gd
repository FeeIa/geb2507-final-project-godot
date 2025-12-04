extends Control

@export var placement_manager_path: NodePath
var placement_manager: Node

func _ready():
	GameManager.connect("level_money_changed", _update_level_money)
	GameManager.connect("lives_changed", _update_lives)
	GameManager.connect("wave_changed", _update_current_wave)
	GameManager.connect("wave_completed", _on_wave_completed)
	GameManager.connect("level_completed", _on_level_commpleted)
	GameManager.connect("game_over", _on_game_over)
	$StartWave.pressed.connect(_on_start_button_pressed)
	$Back.pressed.connect(func():
		get_tree().change_scene_to_file("res://scenes/ui/level_select.tscn")
	)
	_update_level_money()
	_update_lives()
	_update_current_wave()
		
func _on_place_button():
	placement_manager.start_placing("macrophage")
	
func _update_level_money():
	$LevelMoney.text = "Money: %d" % GameManager.level_money

func _update_lives():
	$Lives.text = "Lives: %d" % GameManager.lives
	
func _update_current_wave():
	$Waves.text = "Wave: %d" % GameManager.current_wave
	
func _on_wave_completed():
	$Announcement.text = "Wave Completed!"
	await get_tree().create_timer(2.5).timeout
	$Announcement.text = ""

func _on_start_button_pressed():
	var level_manager = get_tree().current_scene.get_node("LevelManager")
	if level_manager:
		level_manager.start_next_wave()
	else:
		print("[Error] LevelManager is not found!")	
		
func _on_level_commpleted():
	$Announcement.text = "Level Completed! You Won!"
	await get_tree().create_timer(2.5).timeout
	$Announcement.text = ""

func _on_game_over():
	$Announcement.text = "You Lost! :("
	await get_tree().create_timer(2.5).timeout
	$Announcement.text = ""
