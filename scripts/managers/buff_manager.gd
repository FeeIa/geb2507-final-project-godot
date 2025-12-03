extends Node2D

var buffs_multi = {
	"damage": 1.0,
	"attack_cooldown": 1.0,
	"attack_range": 1.0
}

signal buffs_changed

func apply_buff_multi(buff_name: String, val: float):
	buffs_multi[buff_name] *= val
	buffs_changed.emit()
	
func set_buff_multi(buff_name: String, val: float):
	buffs_multi[buff_name] = val
	buffs_changed.emit()
	
func remove_buff_multi(buff_name: String, val: float):
	buffs_multi[buff_name] /= val
	buffs_changed.emit()
	
func get_buff_mutli(buff_name: String) -> float:
	return buffs_multi.get(buff_name, 1.0)
