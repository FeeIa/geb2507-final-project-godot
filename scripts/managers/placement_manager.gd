extends CanvasLayer

var tower_container: Node2D
var tower_base_scene: PackedScene = preload("res://scenes/towers/base_tower.tscn")
var tower_icon_scene: PackedScene = preload("res://scenes/ui/tower_place_icon.tscn")
var selected_cell: Vector2i
var available_towers = {
	"macrophage": false,
	"neutrophil": false,
	"nkcell": false,
	"bcell": false
}
var is_on: bool = false
@onready var highlight = $HighlightSquare
@onready var place_menu = $PlaceMenu
@onready var icon_holder = $PlaceMenu/Container

func init(tower_cont: Node2D, cell_sz: int):
	is_on = true
	highlight.size = cell_sz
	tower_container = tower_cont

func _ready() -> void:
	highlight.visible = false
		
	$PlaceMenu/Close.pressed.connect(close_menu)
	
func generate_tower_buttons():
	for c in icon_holder.get_children():
		c.queue_free()
		
	for tower_name in available_towers.keys():
		if not available_towers[tower_name]: continue
		
		var atp: TextureRect = tower_icon_scene.instantiate()
		atp.name = tower_name
		var btn: Button = atp.get_node("Icon")
		
		var txtr = load(Database.get_tower_data(tower_name).get("textures").get("level_1").get("base", "res://assets/towers/default.svg"))
		if not txtr:
			txtr = load("res://assets/towers/default.svg")
			
		btn.icon = txtr
		atp.get_node("Amount").text = str(int(Database.get_tower_data(tower_name).get("props").get("level_1").get("cost")))
		btn.pressed.connect(func():
			place_tower(tower_name)
		)
		
		icon_holder.add_child(atp)
		
func _process(_delta) -> void:
	if not is_on: return
	
	var mouse_pos = get_viewport().get_mouse_position()
	var cell = GridManager.world_to_grid(mouse_pos)
	
	if not GridManager.is_cell_valid(cell):
		highlight.visible = false
		return
		
	highlight.visible = true
	highlight.position = GridManager.grid_to_world(cell)
	highlight.color = Color(0, 1, 0)
		
	highlight.queue_redraw()

func open_menu_for(cell: Vector2i):
	selected_cell = cell
	place_menu.global_position = GridManager.grid_to_world(cell)
	place_menu.visible = true
	generate_tower_buttons()
	
func place_tower(tower_type: String):
	if not tower_container and not is_instance_valid(tower_container):
		return
	if selected_cell == Vector2i(-1, -1) or not available_towers.get(tower_type):
		return
	if not GridManager.is_cell_valid(selected_cell):
		return
		
	# If not enough money, then do nothing
	if !GameManager.spend_level_money(Database.get_tower_data(tower_type).get("props").get("level_1").get("cost")):
		print("Not enough money to place!")
		return
		
	GridManager.occupy_cell(selected_cell)
	
	var tower_instance = tower_base_scene.instantiate()
	var scr = load("res://scripts/towers/%s.gd" % tower_type)
	if scr:
		tower_instance.set_script(scr)
		
	tower_container.add_child(tower_instance)
	tower_instance.init(tower_type, selected_cell)
	
	close_menu()
	
func close_menu():
	selected_cell = Vector2i(-1, -1)
	place_menu.visible = false
	
func turn_off():
	is_on = false

# HOVER PLACEMENT VERSION
#extends Node2D
#
#@export var tower_container: Node2D
#
#var is_placing: bool = false
#var preview_instance: Node2D
#var tower_base_scene: PackedScene = preload("res://scenes/towers/base_tower.tscn")
#
#func _ready():
	#if !tower_container:
		#print("[ERROR] Missing tower_container in PlacementManager")
		#return
	#
## Start placing a tower
#func start_placing(tower_type: String):
	#if is_placing:
		#cancel_placement()
	#is_placing = true
	#show_preview(tower_type)
	#
#func show_preview(tower_type: String):
	#if preview_instance:
		#preview_instance.queue_free()
		#
	## Instantiate the preview
	#preview_instance = tower_base_scene.instantiate()
	#preview_instance.init(tower_type)
	#preview_instance.modulate = Color(1, 1, 1, 0.5)
	#add_child(preview_instance)
	#
#func cancel_placement():
	#if preview_instance:
		#preview_instance.queue_free()
		#
	#preview_instance = null
	#is_placing = false
	#
#func _process(_delta):
	#if not is_placing or not preview_instance:
		#return
		#
	#var mouse_pos = get_global_mouse_position()
	#var cell = GridManager.world_to_grid(mouse_pos)
	#preview_instance.position = GridManager.grid_to_world(cell)
	#
	#if GridManager.is_cell_valid(cell):
		#preview_instance.modulate = Color(0, 1, 0, 0.5)
	#else:
		#preview_instance.modulate = Color(1, 0, 0 ,0.5)
		#
#func _unhandled_input(event):
	#if not is_placing:
		#return
		#
	#if event is InputEventMouseButton and event.pressed:
		#var cell = GridManager.world_to_grid(get_global_mouse_position())
		#
		#if event.button_index == 1:
			#if GridManager.is_cell_valid(cell):
				#place_tower(cell)
				#cancel_placement()
		#elif event.button_index == 2:
			#cancel_placement()
#
#func place_tower(cell: Vector2i):
	## If not enough money, then do nothing
	#if !GameManager.spend_level_money(preview_instance.get_next_level_cost()):
		#print("Not enough money to place!")
		#return
		#
	#GridManager.occupy_cell(cell)
	#
	#var tower_type = preview_instance.tower_type
	#var tower_instance = tower_base_scene.instantiate()
	#var scr = load("res://scripts/towers/%s.gd" % tower_type)
	#if scr:
		#tower_instance.set_script(scr)
		#
	#tower_container.add_child(tower_instance)
	#tower_instance.init(tower_type, cell)
