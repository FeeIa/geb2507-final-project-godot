extends "res://scripts/towers/base_tower.gd"

var proj_scene = preload("res://scenes/projectiles/base_projectile.tscn")

func attack():
	spawn_proj(global_position)
	
func spawn_proj(pos: Vector2):
	var proj = proj_scene.instantiate()
	proj.set_script(load("res://scripts/projectiles/bcell_projectile.gd"))
	proj.init_for(self, current_target)
	proj.damage = curr_damage
	proj.speed = 375
	proj.global_position = pos
	get_parent().add_child(proj)
	proj.change_visual("res://assets/projectiles/!!!level2_tower_Bcell_bullet!!!.png", Vector2(50, 50))
