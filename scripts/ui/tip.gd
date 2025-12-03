extends CanvasLayer

var textures = {
	"atp": preload("res://assets/ui/misc/atp_explanation.png"),
	"health_point": preload("res://assets/ui/misc/healthpoint_explanation.png")
}
var off: Vector2 = Vector2(-322.0, -205.0)

func _process(_delta) -> void:
	if not visible:
		return
	$TextureRect.global_position = get_viewport().get_mouse_position() + off

func open_for(type: String):
	if not textures.has(type.to_lower()):
		return
	
	$TextureRect.texture = textures[type]
	visible = true
	
func close():
	visible = false
