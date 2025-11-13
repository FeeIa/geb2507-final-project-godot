extends Area2D

@export var speed: float = 400.0
var tower_type: String
var damage: int
var target: Node = null

func _process(delta):
	if target and target.is_inside_tree():
		var dir = (target.global_position - global_position).normalized()
		global_position += dir * speed * delta
		if global_position.distance_to(target.global_position) < 10:
			target.take_damage(damage, tower_type)
			queue_free()
	else:
		queue_free()
