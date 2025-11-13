extends Node

@export var path: Path2D
@export var level_name: String
var waves = []
var current_wave_idx = 0

var is_spawning: bool = false

func _ready():
	if level_name:
		load_waves()
	else:
		print("[ERROR] Missing level_name in WaveManager")

# Load wave from JSON file
# Params: level_name
func load_waves():
	var file = FileAccess.open("res://data/levels/%s.json" % level_name, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		waves = data["waves"]
		file.close()

# Start the next wave when called
func start_next_wave():
	if current_wave_idx >= waves.size():
		GameManager.complete_level()
		return
		
	spawn_wave(waves[current_wave_idx])
	current_wave_idx += 1

# Spawn the wave
func spawn_wave(wave_data: Dictionary):
	if is_spawning:
		return
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
	
	var pf = PathFollow2D.new()
	path.add_child(pf)
	pf.loop = false
	pf.progress_ratio = 0.0
	
	e.path_follow = pf
	pf.add_child(e)
