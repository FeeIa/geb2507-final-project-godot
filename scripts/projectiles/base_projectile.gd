extends Area2D

@export var speed: float = 400.0
var source_tower: Node
var damage: int
var target_enemy: Node = null

func _process(delta):
	if target_enemy and target_enemy.is_inside_tree():
		var dir = (target_enemy.global_position - global_position).normalized()
		global_position += dir * speed * delta
		if global_position.distance_to(target_enemy.global_position) < 10:
			if not is_instance_valid(source_tower):
				queue_free()
				return
				
			target_enemy.last_hit_by = source_tower
			target_enemy.take_damage(damage, source_tower.tower_type)
			queue_free()
	else:
		queue_free()
