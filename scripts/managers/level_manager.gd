extends Node

@export var level_name: String
@export var grid_manager: Node
@export var enemy_container: Node

var waves = []
var path_cells = []
var current_wave_idx = 0

var game_started: bool = false
var is_spawning: bool = false
var wave_completed: bool = false
var enemies_count: int = 0
var game_over = false

func _ready():
	if !level_name:
		print("[ERROR] Missing level_name in LevelManager")
		return
	if !grid_manager:
		print("[ERROR] Missing grid_manager in LevelManager")
		return
	if !enemy_container:
		print("[ERROR] Missing enemy_container in LevelManager")
		return
		
	GameManager.game_over.connect(_on_game_over)
	load_level()
	enemy_container.child_exiting_tree.connect(func(child: Node):
		if game_over: return
		
		if child.is_in_group("enemies"):
			enemies_count -= 1
			
		if enemies_count <= 0:
			GameManager.complete_wave()
			wave_completed = true
			
			if current_wave_idx >= waves.size():
				GameManager.complete_level()
	)

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
	if is_spawning or current_wave_idx >= waves.size() or game_over:
		return
		
	if !game_started:
		GameManager.start_next_wave()
		spawn_wave(waves[current_wave_idx])
		game_started = true
		current_wave_idx += 1
	else:
		if !wave_completed:
			GameManager.complete_wave()
			
		GameManager.start_next_wave()
		spawn_wave(waves[current_wave_idx])
		wave_completed = false
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
	
	enemy_container.add_child(e)
	enemies_count += 1

# On Game Over
func _on_game_over():
	game_over = true
	enemy_container.queue_free()
