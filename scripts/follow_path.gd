extends Path2D

@export var speed = 0.05

func _process(delta):
	$PathFollow2D.progress_ratio += speed * delta
