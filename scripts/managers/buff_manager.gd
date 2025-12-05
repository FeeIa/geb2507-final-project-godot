extends Node2D

var tower_buffs_multi = {
	"damage": 1.0,
	"attack_cooldown": 1.0,
	"attack_range": 1.0
}
var enemy_buffs_multi = {
	"damage_taken": 1.0,
	"speed": 1.0
}

signal tower_buffs_changed
signal enemy_buffs_changed

func reset_all_buffs():
	for key in tower_buffs_multi.keys():
		tower_buffs_multi[key] = 1.0
	for key in enemy_buffs_multi.keys():
		enemy_buffs_multi[key] = 1.0
	tower_buffs_changed.emit()
	enemy_buffs_changed.emit()

# Towers
func apply_tower_buff_multi(buff_name: String, val: float):
	tower_buffs_multi[buff_name] *= val
	tower_buffs_changed.emit()
	
func set_tower_buff_multi(buff_name: String, val: float):
	tower_buffs_multi[buff_name] = val
	tower_buffs_changed.emit()
	
func remove_tower_buff_multi(buff_name: String, val: float):
	tower_buffs_multi[buff_name] /= val
	tower_buffs_changed.emit()
	
func get_tower_buff_mutli(buff_name: String) -> float:
	return tower_buffs_multi.get(buff_name, 1.0)

# Enemies
func apply_enemy_buff_multi(buff_name: String, val: float):
	enemy_buffs_multi[buff_name] *= val
	enemy_buffs_changed.emit()
	
func set_enemy_buff_multi(buff_name: String, val: float):
	enemy_buffs_multi[buff_name] = val
	enemy_buffs_changed.emit()
	
func remove_enemy_buff_multi(buff_name: String, val: float):
	enemy_buffs_multi[buff_name] /= val
	enemy_buffs_changed.emit()
	
func get_enemy_buff_mutli(buff_name: String) -> float:
	return enemy_buffs_multi.get(buff_name, 1.0)
