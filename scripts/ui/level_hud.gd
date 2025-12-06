extends CanvasLayer

@onready var atp_label: Label = $ATP/Amount
signal use_consumable(id: String, c: Button)

func _ready() -> void:
	GameManager.level_money_changed.connect(_update_level_money)
	GameManager.lives_changed.connect(func():
		$Lives/Amount.text = str(GameManager.lives)
	)
	use_consumable.connect(func(slot):
		AudioManager.play_button_click_sfx()
		var id = slot.name
		if ConsumableInventory.use_consumable(id):
			var c: Button = slot.get_node("Clickable")
			ConsumableManager.activate_consumable(id)
			update_slot(slot)
			c.disabled = true
	)
	for slot: TextureRect in $ConsumableSlots.get_children():
		var c: Button = slot.get_node("Clickable")
		c.pressed.connect(func():
			use_consumable.emit(slot)
		)
		update_slot(slot)
		
	$ATP.connect("mouse_entered", func():
		Tip.open_for("atp")
	)
	$ATP.connect("mouse_exited", func():
		Tip.close()
	)
	$Pause.pressed.connect(func():
		AudioManager.play_button_click_sfx()
		PauseMenu.open()
	)

func update_slot(slot):
	var id = slot.name
	var c: Button = slot.get_node("Clickable")
	var amt: Label = slot.get_node("Amount")
	amt.text = "x" + str(ConsumableInventory.get_consumable_cnt(id))
	c.disabled = false
	
	if not ConsumableInventory.has_consumable(id):
		c.disabled = true

func init_hud():
	for slot: TextureRect in $ConsumableSlots.get_children():
		update_slot(slot)

func open():
	visible = true
	
func close():
	visible = false
	
func _update_level_money():
	atp_label.text = str(GameManager.level_money)
