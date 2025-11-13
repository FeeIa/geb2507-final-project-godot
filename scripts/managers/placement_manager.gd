extends Node2D

@export var grid_manager_path: NodePath
@export var tower_base_scene: PackedScene = preload("res://scenes/towers/base_tower.tscn")

var grid_manager: Node
var is_placing: bool = false
var preview_instance: Node2D

func _ready():
	grid_manager = get_node(grid_manager_path)
	
# Start placing a tower
func start_placing(tower_type: String):
	if is_placing:
		cancel_placement()
	is_placing = true
	show_preview(tower_type)
	
func show_preview(tower_type: String):
	if preview_instance:
		preview_instance.queue_free()
		
	# Instantiate the preview
	preview_instance = tower_base_scene.instantiate()
	preview_instance.tower_type = tower_type
	preview_instance.modulate = Color(1, 1, 1, 0.5)
	add_child(preview_instance)
	
func cancel_placement():
	if preview_instance:
		preview_instance.queue_free()
		
	preview_instance = null
	is_placing = false
	
func _process(delta):
	if not is_placing or not preview_instance:
		return
		
	var mouse_pos = get_global_mouse_position()
	var cell = grid_manager.world_to_grid(mouse_pos)
	preview_instance.position = grid_manager.grid_to_world(cell)
	
	if grid_manager.is_cell_valid(cell):
		preview_instance.modulate = Color(0, 1, 0, 0.5)
	else:
		preview_instance.modulate = Color(1, 0, 0 ,0.5)
		
func _unhandled_input(event):
	if not is_placing:
		return
		
	if event is InputEventMouseButton and event.pressed:
		var cell = grid_manager.world_to_grid(get_global_mouse_position())
		
		if event.button_index == 1:
			if grid_manager.is_cell_valid(cell):
				place_tower(cell)
				cancel_placement()
		elif event.button_index == 2:
			cancel_placement()

func place_tower(cell: Vector2i):
	# If not enough money, then do nothing
	if !GameManager.spend_level_money(preview_instance.cost):
		return
		
	grid_manager.occupy_cell(cell)
	
	var tower_instance = tower_base_scene.instantiate()
	tower_instance.tower_type = preview_instance.tower_type
	tower_instance.position = grid_manager.grid_to_world(cell)
	
	get_parent().add_child(tower_instance)
