extends "res://scripts/enemies/base_enemy.gd"

func on_death():
	var cnt = 3
	var radius = 100.0
	
	for i in range(cnt):
		var angle = (TAU / cnt) * i
		var offset = Vector2.RIGHT.rotated(angle) * radius
		
		var ppts: Array[Vector2] = path_points.slice(curr_path_idx, path_points.size())
		if ppts.size() > 0:
			ppts[0] += offset
			
		GameManager.spawn_enemy_externally.emit("fluvirus", ppts)
