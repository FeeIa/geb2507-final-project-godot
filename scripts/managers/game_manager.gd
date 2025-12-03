extends Node

# Signals
signal level_money_changed
signal global_money_changed
signal lives_changed
signal wave_completed
signal wave_changed
signal level_completed
signal game_over

# Constants
const DEFAULT_LEVEL_MONEY = 10
const DEFAULT_LIVES = 10

# Global states
var global_money: int = 100
var highest_level_completed: int = 0
var current_playing_level: int = 0
var intro_viewed: bool = false

# Level-specific currency & stats
var level_money: int = 0
var lives: int = 0
var current_wave: int = 0

# Load level scene
# Params: level_name
func load_level_scene(level: int):
	if level <= highest_level_completed + 1:
		FadeTransition.transition_to_scene("res://scenes/levels/level_%d/prep.tscn" % level)
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
	add_level_money(100)
	wave_completed.emit()

# Start next wave
func start_next_wave():
	current_wave += 1
	wave_changed.emit()

# Level completed/finished
func complete_level():
	highest_level_completed = max(highest_level_completed, current_playing_level)
	level_completed.emit()

#func _ready():
	#load_level("level_1")
	#print(level_money)
	#print(lives)	
