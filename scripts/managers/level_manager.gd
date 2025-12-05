extends Node

@export var level: int
@export var enemy_container: Node2D
@export var tower_container: Node2D

var waves = []
var paths = []
var current_wave_idx = 0
var discovered_enemies: Array[String] = []

var game_started: bool = false
var is_spawning: bool = false
var wave_completed: bool = false
var enemies_count: int = 0
var game_over = false
var max_lives: int

@onready var wave_timer = $WaveTimer

func _ready():
	if !level:
		print("[ERROR] Missing level in LevelManager")
		return
	if !enemy_container:
		print("[ERROR] Missing enemy_container in LevelManager")
		return
	if !tower_container:
		print("[ERROR] Missing tower_container in LevelManager")
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
			wave_timer.start()
			wave_completed = true
			
			if current_wave_idx >= waves.size():
				GameManager.complete_level()
	)
	
	GameManager.spawn_enemy_externally.connect(func(enemy_name: String, path: Array[Vector2]):
		spawn_enemy(enemy_name, path, true)
	)
	
	wave_timer.timeout.connect(func():
		start_next_wave()
	)

# Load specific level based on the JSON data
# Params: level_name
func load_level():
	var file = FileAccess.open("res://data/levels/level_%s.json" % level, FileAccess.READ)
	if file:
		var data: Dictionary = JSON.parse_string(file.get_as_text())
		if not data:
			print("[ERROR] Empty JSON data for level " + str(level))
			return

		GameManager.level_money = data.get("level_money", 50)
		GameManager.lives = data.get("lives", 20)
		GameManager.money_gain_per_wave = data.get("money_gain_per_wave", 0)
			
		max_lives = GameManager.lives
		waves = data.get("waves")
		paths = data.get("paths")
		
		wave_timer.wait_time = data.get("delay_per_wave", 5.0)
		
		var c_off = data.get("grid_center_offset")
		GridManager.init_grid(Vector2(c_off[0], c_off[1]))
		for path_cells in paths:
			for cell in path_cells:
				GridManager.turn_cell_to_blocked(Vector2i(cell[0], cell[1]))
		
		var avail_towers: Array = data.get("available_towers")
		for key in PlacementManager.available_towers.keys():
			PlacementManager.available_towers[key] = avail_towers.has(key)
		PlacementManager.init(tower_container, GridManager.cell_size)
		
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
	
	BuffManager.reset_all_buffs()
	wave_timer.start()

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
			await get_tree().create_timer(dict["interval"], false).timeout
		
	is_spawning = false
	
# Spawn the enemy
func spawn_enemy(enemy_type: String, optional_path_points: Array[Vector2] = [], is_external: bool = false):
	if not is_instance_valid(enemy_container): return
	
	if not discovered_enemies.has(enemy_type):
		discovered_enemies.push_back(enemy_type)
		EnemyExplanation.open_for(enemy_type)
		
	if is_external:
		enemies_count += 1
	
	var e = preload("res://scenes/enemies/base_enemy.tscn").instantiate()
	var scr_path = "res://scripts/enemies/%s.gd" % enemy_type
	if ResourceLoader.exists(scr_path):
		e.set_script(load(scr_path))
	
	var path_points: Array[Vector2] = optional_path_points
	if path_points.is_empty():
		var path_cells = paths.pick_random()
		for cell in path_cells:
			var world_pos: Vector2 = GridManager.grid_to_world(Vector2i(cell[0], cell[1]))
			path_points.push_back(world_pos)
	
	enemy_container.add_child(e)
	e.init(enemy_type, path_points)

# On game over
func _on_game_over():
	game_over = true
	enemy_container.queue_free()
	Defeat.open()
	PlacementManager.turn_off()
	
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
	PlacementManager.turn_off()

# Placement purposes
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_viewport().get_mouse_position()
		var cell = GridManager.world_to_grid(mouse_pos)
		
		if GridManager.is_cell_valid(cell):
			PlacementManager.open_menu_for(cell)
