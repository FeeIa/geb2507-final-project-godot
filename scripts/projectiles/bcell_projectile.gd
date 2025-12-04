extends "res://scripts/projectiles/base_projectile.gd"

func do_something_after_hit():
	if target_enemy and is_instance_valid(target_enemy):
		var slow_effect = source_tower.props.get("slow_effect")
		target_enemy.apply_slow(slow_effect)
