extends Node

# Signals
signal level_money_changed
signal global_money_changed
signal lives_changed
signal level_completed
signal game_over

# Constants
const DEFAULT_LEVEL_MONEY = 10
const DEFAULT_LIVES = 10

# Global currency
var global_money: int = 0

# Level-specific currency & stats
var level_money: int = 0
var lives: int = 0
var current_level: String = "" 
	
# Add level money
# Params: amount
func add_level_money(amount: int):
	level_money += amount
	level_money_changed.emit()
	
func spend_level_money(amount: int) -> bool:
	if level_money >= amount:
		add_level_money(-amount)
		return true
	return false

# Add global money
func add_global_money(amount: int):
	global_money += amount
	global_money_changed.emit()
	
func spend_global_money(amount: int) -> bool:
	if global_money >= amount:
		add_level_money(-amount)
		return true
	return false
	
# Take away life
# Params: amount (optional)
func lose_life(amount: int = 1):
	lives -= amount
	lives_changed.emit()
	
	if lives <= 0:
		game_over.emit()

# Level completed/finished
func complete_level():
	level_completed.emit()

#func _ready():
	#load_level("level_1")
	#print(level_money)
	#print(lives)	
