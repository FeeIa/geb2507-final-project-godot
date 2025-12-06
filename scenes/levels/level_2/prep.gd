extends Node2D

func _ready():
	ConsumableInventory.consumables_changed.connect(func(id):
		var item = $CanvasGroup.get_node(id)
		if not item: return
		
		var amt: Label = item.get_node("Amount")
		amt.text = "x" + str(ConsumableInventory.get_consumable_cnt(id))
	)
	
	for item: Button in $CanvasGroup.get_children():
		var id = item.name
		var amt: Label = item.get_node("Amount")
		amt.text = "x" + str(ConsumableInventory.get_consumable_cnt(id))
		
		item.pressed.connect(func():
			AudioManager.play_button_click_sfx()
			ConsumableShop.open(id)
		)
	
	$Start.pressed.connect(func():
		AudioManager.play_button_click_sfx()
		FadeTransition.transition_to_scene("res://scenes/levels/level_2/map.tscn")
	)
	
	$Star/Amount.text = str(GameManager.global_money)
	$Star.connect("mouse_entered", func():
		Tip.open_for("health_point")
	)
	$Star.connect("mouse_exited", func():
		Tip.close()	
	)
	GameManager.global_money_changed.connect(func():
		$Star/Amount.text = str(GameManager.global_money)
	)
