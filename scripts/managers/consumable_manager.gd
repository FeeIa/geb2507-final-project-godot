extends Node2D

func activate_consumable(id: String):
	match id:
		"EnergyBar":
			print("EB")
			GameManager.add_level_money(100)
		"FeverMedicine":
			print("FM")
		"GoodSleep":
			print("GS")
			GameManager.lose_life(-3)
		"VitaminC":
			print("VC")
			BuffManager.apply_buff_multi("damage", 1.2)
			
