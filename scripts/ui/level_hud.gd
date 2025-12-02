extends CanvasLayer

var current_intro: Node
@onready var atp_label: Label = $ATP/Amount

func init_for(level: int):
	var ps = load("res://scenes/levels/level_%d/intro.tscn" % level)
	if not ps:
		print("[ERROR] Failed to fetch intro packed scene for level %d" % level)
		return
	
	current_intro = ps.instantiate()
	add_child(current_intro)

	current_intro.get_node("ClickableArea").connect("input_event", _on_input_event)

func open():
	visible = true
	
func close():
	visible = false

func _ready() -> void:
	GameManager.connect("level_money_changed", _update_level_money)
	
func _update_level_money():
	atp_label.text = str(GameManager.level_money)
	
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		current_intro.queue_free()
