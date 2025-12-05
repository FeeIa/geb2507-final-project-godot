extends Node2D

func _ready():
	$ClickableArea.connect("input_event", _on_input_event)
	
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		GameManager.intro_viewed = true
		SaveManager.save_data["intro_viewed"] = true
		SaveManager.save_game()
		self.visible = false
