extends Node

@export var enemy_scene: PackedScene
@export var enemies_per_wave: int = 5
@export var spawn_delay_per_enemy: float = 1.0
@export var path: Path2D

var is_spawning: bool = false

func start_wave():
	if is_spawning:
		return
		
	is_spawning = true
	GameManager.start_wave()
	
	await _spawn_wave()
	
	GameManager.emit_signal("wave_cleared")
	is_spawning = false
	
func _spawn_wave():
	for i in range(enemies_per_wave):
		spawn_enemy()
		await get_tree().create_timer(spawn_delay_per_enemy).timeout
	
func spawn_enemy():
	var pf = PathFollow2D.new()
	path.add_child(pf)
	
	var enemy: PhysicsBody2D = enemy_scene.instantiate()
	pf.add_child(enemy)
	enemy.path_follow = pf
	pf.progress_ratio = 0.0
