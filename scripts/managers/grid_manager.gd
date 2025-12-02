extends Node2D

# Config
var grid_width: int
var grid_height: int
var cell_size: int
var center_offset: Vector2

# States
@onready var viewport_size = get_viewport_rect().size
var occupied_cells: Array[Vector2i] = [] # where towers exist
var blocked_cells: Array[Vector2i] = [] # path/obstacles
var hover_cell := Vector2i(-1, -1)
var offset

# Reinitalizes the grid to be reused!
func init_grid(
	c_off: Vector2 = Vector2(0, 0),
	w: int = 10, h: int = 5, 
	c_sz: int = 130
):
	center_offset = c_off
	grid_width = w
	grid_height = h
	cell_size = c_sz
	offset = (viewport_size - Vector2(grid_width * cell_size, grid_height * cell_size)) / 2 + center_offset
	
	occupied_cells.clear()
	blocked_cells.clear()

func is_cell_inside(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < grid_width and cell.y >= 0 and cell.y < grid_height

func is_cell_valid(cell: Vector2i) -> bool:
	return is_cell_inside(cell) and cell not in occupied_cells and cell not in blocked_cells

# Converts world position to grid position
func world_to_grid(world_pos: Vector2) -> Vector2i:
	var local_pos: Vector2 = world_pos - offset
	return Vector2i(floor(local_pos.x) / cell_size, floor(local_pos.y) / cell_size)

# Converts grid position to world position (center point of the cell)
func grid_to_world(cell: Vector2i) -> Vector2:
	return Vector2(cell.x * cell_size + float(cell_size) / 2, cell.y * cell_size + float(cell_size) / 2) + offset

# Make a cell as blocked
func turn_cell_to_blocked(cell: Vector2i):
	if is_cell_valid(cell):
		blocked_cells.append(cell)

# Occupy a cell
func occupy_cell(cell: Vector2i):
	if is_cell_valid(cell):
		occupied_cells.append(cell)

# Free a cell
func free_cell(cell: Vector2i):
	if cell in occupied_cells:
		occupied_cells.erase(cell)

# JUST FOR VISUALIZATION
#func _ready():
	#occupy_cell(Vector2i(0, 0))
	#occupy_cell(Vector2i(0, 1))
	#blocked_cells.append(Vector2i(3,4))

func _draw():
	for x in range(grid_width):
		for y in range(grid_height):
			var rect = Rect2(Vector2(x, y) * cell_size + offset, Vector2(cell_size, cell_size))
			draw_rect(rect, Color(1,1,1,0.05), true)
			draw_rect(rect, Color(1,1,1,0.2), false)

	for cell in blocked_cells:
		var rect = Rect2(Vector2(cell) * cell_size + offset, Vector2(cell_size, cell_size))
		draw_rect(rect, Color(1,0,0,0.6), true)

	for cell in occupied_cells:
		var rect = Rect2(Vector2(cell) * cell_size + offset, Vector2(cell_size, cell_size))
		draw_rect(rect, Color(0,0,1,0.6), true)
