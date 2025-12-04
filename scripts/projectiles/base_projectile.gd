extends Area2D

var speed: float = 400.0
var source_tower: Node
var damage: int
var target_enemy: Node = null
@onready var sprite: Sprite2D = $Sprite2D

func init_for(tower, enemy):
	source_tower = tower
	target_enemy = enemy
	
func change_visual(texture_path, target_size):
	if texture_path:
		sprite.texture = load(texture_path)
	var scl = target_size / sprite.texture.get_size()
	sprite.scale = scl
	
func _process(delta):
	if target_enemy and target_enemy.is_inside_tree():
		var dir = (target_enemy.global_position - global_position).normalized()
		global_position += dir * speed * delta
		if global_position.distance_to(target_enemy.global_position) < 10:
			if not is_instance_valid(source_tower):
				queue_free()
				return
				
			target_enemy.last_hit_by = source_tower
			target_enemy.take_damage(source_tower.curr_damage, source_tower.tower_type)
			do_something_after_hit()
			queue_free()
	else:
		queue_free()

# Inherit in child
func do_something_after_hit():
	pass
