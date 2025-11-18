extends CanvasLayer

@onready var anim = $AnimationPlayer

func fade_out():
	visible = true
	anim.play("fade_out")
	await anim.animation_finished
	visible = false
	
func fade_in():
	visible = true
	anim.play("fade_in")
	await anim.animation_finished
	visible = false

func transition_to_scene(path: String):
	await fade_out()
	get_tree().change_scene_to_file(path)
	await fade_in()
