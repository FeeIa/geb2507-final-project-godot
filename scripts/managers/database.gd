extends Node

var default_tower_file = FileAccess.open("res://data/towers/default.json", FileAccess.READ)
var default_enemy_file = FileAccess.open("res://data/enemies/default.json", FileAccess.READ)

var towers: Dictionary = {}
var enemies: Dictionary = {}

func get_tower_data(type: String) -> Dictionary:
	if towers.has(type):
		return towers[type]
		
	var file = FileAccess.open("res://data/towers/%s.json" % type, FileAccess.READ)
	if not file:
		print("[ERROR] No JSON file found for tower " + type + ". Returning default JSON data instead.")
		return JSON.parse_string(default_tower_file.get_as_text())
	
	towers[type] = JSON.parse_string(file.get_as_text())
	
	return towers[type]

func get_enemy_data(type: String) -> Dictionary:
	if enemies.has(type):
		return enemies[type]
		
	var file = FileAccess.open("res://data/enemies/%s.json" % type, FileAccess.READ)
	if not file:
		print("[ERROR] No JSON file found for enemy " + type + ". Returning default JSON data instead.")
		return JSON.parse_string(default_enemy_file.get_as_text())
	
	enemies[type] = JSON.parse_string(file.get_as_text())
	
	return enemies[type]
