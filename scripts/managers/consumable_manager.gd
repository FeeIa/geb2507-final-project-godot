extends Node2D

func activate_consumable(id: String):
	match id:
		"EnergyBar":
			print("Added 100 ATP from EnergyBar")
			GameManager.add_level_money(100)
		"FeverMedicine":
			print("Enemies now take 20% more damage and slower by 10% from FeverMedicine")
			BuffManager.apply_enemy_buff_multi("damage_taken", 1.2)
			BuffManager.apply_enemy_buff_multi("speed", 0.9)
		"GoodSleep":
			print("Gained 3 lives from GoodSleep")
			GameManager.lose_life(-3)
		"VitaminC":
			print("Towers now do 20% more damage and attacks 10% faster from VitaminC")
			BuffManager.apply_tower_buff_multi("damage", 1.2)
			BuffManager.apply_tower_buff_multi("attack_cooldown", 0.9)
			
