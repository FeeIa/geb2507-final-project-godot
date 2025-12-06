extends Node

# Signals
signal level_money_changed
signal global_money_changed
signal lives_changed
signal wave_completed
signal wave_changed
signal level_completed
signal game_over
signal spawn_enemy_externally(enemy_type: String, path_points: Array[Vector2])

# Constants
const DEFAULT_LEVEL_MONEY = 10
const DEFAULT_LIVES = 10

# Global states
var global_money: int = 10
var highest_level_completed: int = 0
var current_playing_level: int = 0
var intro_viewed: bool = false

# Level-specific currency & stats
var level_money: int = 0
var lives: int = 0
var current_wave: int = 0
var money_gain_per_wave: int = 0

func _ready():
	AudioManager.play_bgm("res://assets/audio/music/Home.mp3")

# Load level scene
# Params: level_name
func load_level_scene(level: int):
	if level <= highest_level_completed + 1:
		var scene_path = "res://scenes/levels/level_%d/prep.tscn" % level
		if ResourceLoader.exists(scene_path):
			FadeTransition.transition_to_scene(scene_path)
		else:
			FadeTransition.transition_to_scene("res://scenes/ui/level_select.tscn")
	else:
		print("Please complete the previous level first!")
		
# Add level money
# Params: amount
func add_level_money(amount: int):
	level_money += amount
	level_money_changed.emit()

# Spend level money
func spend_level_money(amount: int) -> bool:
	if level_money >= amount:
		add_level_money(-amount)
		return true
	return false

# Add global money
func add_global_money(amount: int):
	global_money += amount
	global_money_changed.emit()
	SaveManager.save_data["global_money"] = global_money
	SaveManager.save_game()
	
# Spend global mmoney
func spend_global_money(amount: int) -> bool:
	if global_money >= amount:
		add_global_money(-amount)
		return true
	return false
	
# Take away life
# Params: amount (optional)
func lose_life(amount: int = 1):
	lives -= amount
	lives_changed.emit()
	
	if lives <= 0:
		game_over.emit()

# Complete wave and reward monyy
func complete_wave():
	add_level_money(money_gain_per_wave)
	wave_completed.emit()

# Start next wave
func start_next_wave():
	current_wave += 1
	wave_changed.emit()

# Level completed/finished
func complete_level():
	highest_level_completed = max(highest_level_completed, current_playing_level)
	SaveManager.save_data["highest_level_completed"] = highest_level_completed
	SaveManager.save_game()
	level_completed.emit()

func pause_game():
	get_tree().paused = true
	
func unpause_game():
	get_tree().paused = false

func turn_off_all_uis_autoload():
	LevelHud.close()
	TowerMenu.close()
	EnemyExplanation.close()
	PlacementManager.close_menu()
	PlacementManager.turn_off()

func go_back_to_level_select():
	turn_off_all_uis_autoload()
	FadeTransition.transition_to_scene("res://scenes/ui/level_select.tscn")
	
func restart_current_level():
	turn_off_all_uis_autoload()
	load_level_scene(current_playing_level)

func go_next_level():
	turn_off_all_uis_autoload()
	load_level_scene(current_playing_level + 1)

#func _ready():
	#load_level("level_1")
	#print(level_money)
	#print(lives)	
