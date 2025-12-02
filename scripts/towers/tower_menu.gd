extends CanvasLayer

var selected_tower = null

func _ready() -> void:
	$Upgrade.pressed.connect(func():
		selected_tower.upgrade()
		close()
	)
	$Sell.pressed.connect(func():
		var val = selected_tower.sell_value()
		GameManager.add_level_money(val)
		
		# REMOVE TOWER FROM GridManager occupancy!!!!
		GridManager.free_cell(selected_tower.cell)
		
		selected_tower.queue_free()
		close()
	)

func open_for(tower):
	selected_tower = tower
	print(selected_tower)
	visible = true
	$Name.text  = tower.tower_type
	$Upgrade.disabled = not tower.can_upgrade()

func close():
	selected_tower = null
	visible = false
