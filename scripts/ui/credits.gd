extends CanvasLayer

func _ready():
	$Close.pressed.connect(close)

func open():
	visible = true
	
func close():
	visible = false
