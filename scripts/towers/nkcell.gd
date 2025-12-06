extends "res://scripts/towers/base_tower.gd"

var proj_scene = preload("res://scenes/projectiles/base_projectile.tscn")
var proj_offset = 25

func attack():
	var dir = (current_target.global_position - global_position).normalized()
	var angle = dir.angle()
	sprite.rotation = angle
		
	var perp = Vector2(-dir.y, dir.x) * proj_offset
	
	AudioManager.play_sfx("res://assets/audio/sfx/laser_shot.wav")
	spawn_proj(global_position + perp)
	spawn_proj(global_position - perp)
	
func spawn_proj(pos: Vector2):
	var proj = proj_scene.instantiate()
	proj.init_for(self, current_target)
	proj.damage = curr_damage / 2.0
	proj.speed = 1500
	proj.global_position = pos
	get_parent().add_child(proj)
	proj.change_visual("res://assets/projectiles/WX_circle_white.png", Vector2(25, 25))
	proj.get_node("Sprite2D").modulate = Color(0.294, 0.506, 1.0, 0.729)  # semi-transparent blue
