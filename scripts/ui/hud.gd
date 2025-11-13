extends Control

@export var placement_manager_path: NodePath
var placement_manager: Node

func _ready():
	GameManager.connect("level_money_changed", _update_level_money)
	GameManager.connect("lives_changed", _update_lives)
	$StartWave.pressed.connect(_on_start_button_pressed)
	_update_level_money()
	_update_lives()
	
	placement_manager = get_node(placement_manager_path)
	if placement_manager:
		$Place.pressed.connect(_on_place_button)
		
func _on_place_button():
	placement_manager.start_placing("phagocyte")
	
func _update_level_money():
	$LevelMoney.text = "Money: %d" % GameManager.level_money

func _update_lives():
	$Lives.text = "Lives: %d" % GameManager.lives

func _on_start_button_pressed():
	var level_manager = get_tree().current_scene.get_node("LevelManager")
	if level_manager:
		level_manager.start_next_wave()
	else:
		print("[Error] LevelManager is not found!")	
