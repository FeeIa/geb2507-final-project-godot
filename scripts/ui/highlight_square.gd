extends Node2D

var size = GridManager.cell_size
var color = Color(1, 1, 1)

func _draw():
	draw_rect(Rect2(-float(size) / 2, -float(size) / 2, size, size), color, false, 3.0)
