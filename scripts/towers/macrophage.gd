extends "res://scripts/towers/base_tower.gd"

var is_digesting = false
var digest_cooldown: int = -1

func attack():
	if is_digesting: return
	
	# Complete resistance
	if current_target.get_resistance(tower_type) == 1:
		current_target = null
		pop_next_target()
		target_queue.erase(current_target)
		return
	
	var tween = get_tree().create_tween()
	tween.tween_property(current_target, "global_position", global_position, 0.5)
	tween.finished.connect(func():
		if not is_instance_valid(current_target):
			return
			
		current_target.last_hit_by = self
		
		var rd = randf()
		var resisted: bool = rd <= current_target.get_resistance(tower_type)
		
		if resisted: return
			
		current_target.die()
		upd_sprite()
		if kill_count >= 2:
			start_digest_cooldown()
	)
	
func start_digest_cooldown():
	if digest_cooldown <= -1:
		digest_cooldown = props.get("digest_cooldown")
	
	is_digesting = true
	get_tree().create_timer(digest_cooldown).timeout.connect(func():
		is_digesting = false
		kill_count = 0
		upd_sprite()
	)
	
func upd_sprite():
	if kill_count == 1:
		curr_texture_type = "eat_1"
		sprite.offset = Vector2(45, -47)
	elif kill_count == 2:
		curr_texture_type = "eat_2"
		sprite.offset = Vector2(33, -50)
	else:
		curr_texture_type = "base"
		sprite.offset = Vector2(0, 0)
		
	load_appearance()
