extends Area2D

@export var speed: float = 400.0
var target = null
var damage: int
var damage_type: String = "phagocyte"

func _process(delta: float) -> void:
	if not is_instance_valid(target):
		queue_free()
		return
		
	var dir = (target.global_position - global_position).normalized()
	global_position += dir * speed * delta
	
	if global_position.distance_to(target.global_position) < 10:
		if is_instance_valid(target):
			target.take_damage(damage, damage_type)
			
		queue_free()
