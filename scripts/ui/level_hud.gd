extends Node2D

@export var Intro: Node
@onready var ATPLabel: Label = $ATP/Amount

func _ready() -> void:
	if !Intro:
		print("[ERROR] No Intro scene found in LevelHUD")
		return
	
	GameManager.connect("level_money_changed", _update_level_money)
	Intro.get_node("ClickableArea").connect("input_event", _on_input_event)
	_update_level_money()
	
func _update_level_money():
	ATPLabel.text = str(GameManager.level_money)
	
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		Intro.queue_free()
