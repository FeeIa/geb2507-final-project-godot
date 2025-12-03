extends Node

@export var level: int
@export var enemy_container: Node2D

var waves = []
var path_cells = []
var current_wave_idx = 0
var discovered_enemies: Array[String] = []

var game_started: bool = false
var is_spawning: bool = false
var wave_completed: bool = false
var enemies_count: int = 0
var game_over = false
var max_lives: int

func _ready():
	if !level:
		print("[ERROR] Missing level in LevelManager")
		return
	if !enemy_container:
		print("[ERROR] Missing enemy_container in LevelManager")
		return
		
	GameManager.game_over.connect(_on_game_over)
	GameManager.level_completed.connect(_on_level_completed)
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
	var file = FileAccess.open("res://data/levels/level_%s.json" % level, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		if not data:
			print("[ERROR] Empty JSON data for level " + str(level))
			return

		GameManager.level_money = data.get("level_money", 50)
		GameManager.lives = data.get("lives", 20)
		max_lives = GameManager.lives
		waves = data.get("waves")
		path_cells = data.get("path")
		
		var c_off = data.get("grid_center_offset")
		GridManager.init_grid(Vector2(c_off[0], c_off[1]))
		for cell in path_cells:
			GridManager.turn_cell_to_blocked(Vector2i(cell[0], cell[1]))
		
		file.close()
	else:
		print("[ERROR] No JSON file for level " + str(level) + " was found!")
		return
		
	GameManager.current_playing_level = level
	GameManager.current_wave = current_wave_idx
	GameManager.level_money_changed.emit()
	GameManager.lives_changed.emit()
	
	LevelHud.init_hud()
	LevelHud.open()

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
func spawn_wave(wave_data: Array):
	is_spawning = true
	
	for dict in wave_data:
		enemies_count += dict["count"]
	
	for dict: Dictionary in wave_data:
		var t = dict["type"]
		for i in range(dict["count"]):
			spawn_enemy(t)
			await get_tree().create_timer(dict["interval"]).timeout
		
	is_spawning = false
	
# Spawn the enemy
func spawn_enemy(enemy_id: String):
	if not is_instance_valid(enemy_container): return
	
	if not discovered_enemies.has(enemy_id):
		discovered_enemies.push_back(enemy_id)
		EnemyExplanation.open_for(enemy_id)
	
	var e = preload("res://scenes/enemies/base_enemy.tscn").instantiate()
	e.enemy_type = enemy_id
	
	for cell in path_cells:
		var world_pos: Vector2 = GridManager.grid_to_world(Vector2i(cell[0], cell[1]))
		e.path_points.append(world_pos)
	
	enemy_container.add_child(e)

# On game over
func _on_game_over():
	game_over = true
	enemy_container.queue_free()
	Defeat.open()
	
# On level completed
func _on_level_completed():
	var pass_level: int
	var lives = GameManager.lives
	
	if lives >= 0.7 * max_lives:
		pass_level = 3
	elif lives >= 0.4 * max_lives:
		pass_level = 2
	elif lives >= 1:
		pass_level = 1
	
	GameManager.add_global_money(pass_level)
	Victory.open(pass_level)
