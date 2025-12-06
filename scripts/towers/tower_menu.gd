extends CanvasLayer

var selected_tower = null

func _ready() -> void:
	$Upgrade.pressed.connect(func():
		if not selected_tower: return
		if selected_tower.upgrade():
			AudioManager.play_sfx("res://assets/audio/sfx/buy_something.wav")
		else:
			AudioManager.play_sfx("res://assets/audio/sfx/reject.wav")
			
		update_stats()
	)
	$Sell.pressed.connect(func():
		if not selected_tower: return
		AudioManager.play_button_click_sfx()
		var val = selected_tower.sell_value()
		GameManager.add_level_money(val)
		GridManager.free_cell(selected_tower.cell)
		selected_tower.queue_free()
		close()
	)
	$Close.pressed.connect(func():
		AudioManager.play_button_click_sfx()
		close()
	)
	BuffManager.tower_buffs_changed.connect(update_stats)

func open_for(tower):
	selected_tower = tower
	$Explanation.texture = load(Database.get_tower_data(selected_tower.tower_type).get("explanation"))
	visible = true
	update_stats()

func update_stats():
	if not selected_tower or not is_instance_valid(selected_tower):
		return
		
	$Stats.text = "Damage: " + str(selected_tower.curr_damage) + " | Range: " + str(selected_tower.cell_range) + " | Cooldown: " + str(selected_tower.curr_attack_cooldown) + "s"
	$Upgrade.disabled = not selected_tower.can_upgrade()
	if not selected_tower.can_upgrade():
		$UpgradeCost.text = ""
	else:
		$UpgradeCost.text = "-" + str(selected_tower.get_next_level_cost()) + " ATP"
		
	$SellGain.text = "+" + str(selected_tower.sell_value()) + " ATP"

func close():
	selected_tower = null
	visible = false
	
