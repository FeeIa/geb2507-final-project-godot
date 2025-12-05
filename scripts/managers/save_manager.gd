extends Node

# It will be saved to Godot's default user path
const SAVE_PATH = "user://game_save.json"

var save_data = {
	"highest_level_completed": 0,
	"global_money": 0,
	"intro_viewed": false,
	
	"consumables": {
		"EnergyBar": 0,
		"FeverMedicine": 0,
		"VitaminC": 0,
		"GoodSleep": 0
	},
	
	"settings": {
		"master_volume": 1.0,
		"bgm_volume": 1.0,
		"sfx_volume": 1.0
	}
}

func _ready():
	load_game()
	
func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()
		print("[SaveManager] Saved successfully")
	else:
		push_error("[SaveManager] Failed to save! Save file couldn't be opened")
		

func reconcile(defaults: Dictionary, loaded: Dictionary) -> Dictionary:
	var result = defaults.duplicate(true) # deep copy
	for key in loaded.keys():
		if loaded[key] is Dictionary and key in result and result[key] is Dictionary:
			# recursively merge nested dictionaries
			result[key] = reconcile(result[key], loaded[key])
		else:
			result[key] = loaded[key]
	return result

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("[SaveManager] No save found, using defaults")
		apply_to_game_manager()
		return
		
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_error("[SaveManager] Failed to load")
		return
		
	var text = file.get_as_text()
	file.close()
	
	var json = JSON.parse_string(text)
	if typeof(json) != TYPE_DICTIONARY:
		push_error("[SaveManager] Save corrupted, reverting to defaults")
		return
	
	save_data = reconcile(save_data, json)
	save_game()
	print("[SaveManager] Data loaded")
	apply_to_game_manager()
	apply_to_consumable_inventory()
	apply_settings()
	
func apply_to_game_manager():
	GameManager.global_money = save_data["global_money"]
	GameManager.highest_level_completed = save_data["highest_level_completed"]
	GameManager.intro_viewed = save_data["intro_viewed"]

func apply_to_consumable_inventory():
	ConsumableInventory.consumables = save_data["consumables"]

func apply_settings():
	var s = save_data["settings"]
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear_to_db(s["master_volume"])
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("BGM"),
		linear_to_db(s["bgm_volume"])
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"),
		linear_to_db(s["sfx_volume"])
	)
