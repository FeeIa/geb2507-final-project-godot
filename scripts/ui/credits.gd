extends CanvasLayer

func _ready():
	$Close.pressed.connect(func():
		AudioManager.play_button_click_sfx()
		close()
	)

func open():
	visible = true
	
func close():
	visible = false
