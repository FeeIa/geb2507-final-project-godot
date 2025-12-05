extends CanvasLayer

const COSTS = {
	"EnergyBar": 2,
	"FeverMedicine": 3,
	"VitaminC": 3,
	"GoodSleep": 2
}

var prev_node = null
signal buy_req(consumable_id: String)

func _ready():
	$Close.pressed.connect(close)
	buy_req.connect(buy)
	for desc: TextureRect in $Descriptions.get_children():
		var b: Button = desc.get_node("Button")
		b.pressed.connect(func():
			buy_req.emit(desc.name)
		)
	
func open(consumable_name: String):
	var node: TextureRect = $Descriptions.get_node(consumable_name)
	if not node:
		print("[ERROR] There is no consumable named " + str(consumable_name))
		return
		
	if prev_node and prev_node != node:
		prev_node.visible = false
	node.visible = true
	prev_node = node
	$Close.visible = true
	visible = true

func buy(id: String) -> bool:
	var price = COSTS.get(id, -1)
	if price <= -1:
		print("[ERROR] Attempted to buy a non-existent consumable " + id)
		return false
		
	if GameManager.spend_global_money(price):
		ConsumableInventory.add_consumable(id)
		SaveManager.save_data["consumables"] = ConsumableInventory.consumables
		SaveManager.save_game()
		return true
	else:
		print("Not enough global money to buy consumable!")
		return false

func close():
	prev_node.visible = false
	prev_node = null
	$Close.visible = false
	visible = false
