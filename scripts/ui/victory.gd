extends CanvasLayer

@onready var victory_logo = $TextureRect
@onready var exc = preload("res://assets/ui/game_finish/victory_defeatUI_EXCELLENT.png")
@onready var good = preload("res://assets/ui/game_finish/victory_defeatUI_GOOD.png")
@onready var pas = preload("res://assets/ui/game_finish/victory_defeatUI_PASS.png")

func _ready():
	$Next.pressed.connect(func():
		GameManager.go_next_level()
		close()
	)
	
	$Back.pressed.connect(func():
		GameManager.go_back_to_level_select()
		close()
	)

func open(pass_lvl: int):
	match pass_lvl:
		1:
			victory_logo.texture = pas
		2:
			victory_logo.texture = good
		3:
			victory_logo.texture = exc
		
	visible = true
	
func close():
	visible = false
