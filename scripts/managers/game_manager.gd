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

# Load specific level based on the JSON data
# Params: level_name
func load_level(level_name: String):
	var file = FileAccess.open("res://data/levels/%s.json" % level_name, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		if not data:
			print("[ERROR] Empty JSON data for " + str(level_name))
			return

		level_money = data.get("level_money", DEFAULT_LEVEL_MONEY)
		lives = data.get("lives", DEFAULT_LIVES)

		file.close()
	else:
		print("[ERROR] No JSON file for " + str(level_name) + " was found!")
		return
		
	current_level = level_name
	level_money_changed.emit()
	lives_changed.emit()
	
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
