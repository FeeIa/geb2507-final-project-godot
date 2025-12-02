extends Node

var default_tower_file = FileAccess.open("res://data/towers/default.json", FileAccess.READ)

func get_tower_data(type: String) -> Dictionary:
	var file = FileAccess.open("res://data/towers/%s.json" % type, FileAccess.READ)
	if not file:
		print("[ERROR] No JSON file found for tower " + type + ". Returning default JSON data instead.")
		return JSON.parse_string(default_tower_file.get_as_text())
		
	return JSON.parse_string(file.get_as_text())
