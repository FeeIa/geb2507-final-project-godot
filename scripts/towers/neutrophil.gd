extends "res://scripts/towers/base_tower.gd"

# Specific for neutrophil (its a custom projectile)
func attack():
	var proj = load("res://scenes/projectiles/base_projectile.tscn").instantiate()
	proj.init_for(self, current_target)
	proj.damage = curr_damage
	proj.speed = 750
	proj.global_position = global_position
	get_parent().add_child(proj)
	proj.change_visual(textures["base"], Vector2(100, 100))

# Specific for neutrphil
func change_state_visual():
	if not is_attacking:
		sprite.texture = load(textures["base"])
		sprite.offset = Vector2(0, 0)
	else:
		sprite.texture = load(textures["attack"])
		sprite.offset = Vector2(50, 0)
