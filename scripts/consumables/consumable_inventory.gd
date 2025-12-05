extends Node2D

var consumables := {
	"EnergyBar": 0,
	"FeverMedicine": 0,
	"VitaminC": 0,
	"GoodSleep": 0
}

signal consumables_changed(consumable_name)
		
func add_consumable(id: String):
	if not valid_consumable(id):
		print("[ERROR] No consumables with id " + str(id))
		return
	consumables[id] += 1
	consumables_changed.emit(id)
	
func use_consumable(id: String) -> bool:
	if has_consumable(id):
		consumables[id] -= 1
		consumables_changed.emit(id)
		return true
	return false
	
func get_consumable_cnt(id: String) -> int:
	if not valid_consumable(id):
		return -1
	return consumables[id]

func valid_consumable(id: String) -> bool:
	return consumables.has(id)

func has_consumable(id: String) -> bool:
	return valid_consumable(id) and consumables[id] > 0
