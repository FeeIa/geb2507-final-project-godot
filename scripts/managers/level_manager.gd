extends Node

@export var level_name: String
@export var grid_manager: Node

var waves = []
var path_cells = []
var current_wave_idx = 0

var is_spawning: bool = false
var can_spawn: bool = true

func _ready():
	if level_name:
		load_level()
	else:
		print("[ERROR] Missing level_name in LevelManager")

# Load specific level based on the JSON data
# Params: level_name
func load_level():
	var file = FileAccess.open("res://data/levels/%s.json" % level_name, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		if not data:
			print("[ERROR] Empty JSON data for " + str(level_name))
			return

		GameManager.level_money = data.get("level_money", 50)
		GameManager.lives = data.get("lives", 20)
		waves = data["waves"]
		path_cells = data["path"]
		
		for cell in path_cells:
			grid_manager.turn_cell_to_blocked(Vector2i(cell[0], cell[1]))
		
		file.close()
	else:
		print("[ERROR] No JSON file for " + str(level_name) + " was found!")
		return
		
	GameManager.current_wave = current_wave_idx
	GameManager.current_level = level_name
	GameManager.level_money_changed.emit()
	GameManager.lives_changed.emit()

# Start the next wave when called
func start_next_wave():
	if is_spawning or !can_spawn:
		return
		
	if current_wave_idx >= waves.size():
		GameManager.complete_level()
		return
		
	GameManager.complete_wave()
	spawn_wave(waves[current_wave_idx])
	current_wave_idx += 1

# Spawn the wave
func spawn_wave(wave_data: Dictionary):
	is_spawning = true
	
	var t = wave_data["type"]
	for i in range(wave_data["count"]):
		spawn_enemy(t)
		await get_tree().create_timer(wave_data["interval"]).timeout
		
	is_spawning = false
	
# Spawn the enemy
func spawn_enemy(enemy_id: String):
	var e = preload("res://scenes/enemies/base_enemy.tscn").instantiate()
	e.enemy_type = enemy_id
	
	for cell in path_cells:
		var world_pos: Vector2 = grid_manager.grid_to_world(Vector2i(cell[0], cell[1]))
		e.path_points.append(world_pos)
	
	get_parent().add_child(e)
