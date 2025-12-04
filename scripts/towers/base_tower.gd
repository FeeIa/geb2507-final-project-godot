extends StaticBody2D

var tower_type: String
var data: Dictionary = {}
var sprite: Sprite2D

var props: Dictionary
var cell_range: int
var textures: Dictionary
var base_damage: int
var curr_damage: int
var base_attack_radius: float
var curr_attack_radius: float
var base_attack_cooldown: float
var curr_attack_cooldown: float

var current_target: Node = null
var target_queue: Array[Node] = []
var kill_count: int = 0
var level: int = 0 # Defaults to 0 --> representing not placed yet!
var cell: Vector2i
var curr_texture_type = "base"

func _process(_delta):
	validate_curr_target()

func init(type: String, cell_ref: Vector2i = Vector2i(-1, -1)):
	tower_type = type
	level = 1 # Any tower starts from level 1
	data = Database.get_tower_data(type)
	load_appearance()
	
	# In the case of previews, do NOTHING FURTHER
	if cell_ref.x == -1 and cell_ref.y == -1:
		level = 0
		return
		
	cell = cell_ref
	global_position = GridManager.grid_to_world(cell)
	
	load_stats()
	BuffManager.buffs_changed.connect(apply_buffs)
	
	# Anything that enters will be pushed to the queue
	$AttackRadius.connect("body_entered", func(body: Node):
		if not body.is_in_group("enemies"): return
		
		target_queue.push_front(body)
		if not current_target or not is_instance_valid(current_target):
			pop_next_target()
	)
	
	# Anything that exits will be attempted to be erased from the queue
	$AttackRadius.connect("body_exited", func(body: Node):
		target_queue.erase(body)
		if current_target == body:
			current_target = null
			pop_next_target()
	)
	
	$AttackTimer.connect("timeout", _on_AttackTimer_timeout)
	
	await get_tree().create_timer(0.1).timeout
	$Sprite2D/Area2D.connect("input_event", func(_viewport, event, _shape_idx):
		if event is InputEventMouseButton and event.pressed:
			TowerMenu.open_for(self)
	)

func validate_curr_target():
	if not current_target or not is_instance_valid(current_target) or not is_body_in_cell_range(current_target):
		current_target = null
		pop_next_target()

func is_body_in_cell_range(body: Node) -> bool:
	var target_cell = GridManager.world_to_grid(body.global_position)
	var dx = abs(target_cell.x - cell.x)
	var dy = abs(target_cell.y - cell.y)
	var mx = max(dx, dy)
	var mn = min(dx, dy)
	var dist = (mx - mn) + mn
	# Shortest path algo
	
	return dist <= cell_range

func pop_next_target():
	var to_delete: Array = []
	var found: bool = false
	
	for e in target_queue:
		if not is_instance_valid(e):
			to_delete.push_back(e)
			continue
		if not is_body_in_cell_range(e):
			continue
		
		current_target = e
		found = true
		
	for e in to_delete:
		target_queue.erase(e)
	to_delete.clear()
	
	if not found:
		current_target = null
# Load the tower stats, which is called upon initialization and upgrades
func load_stats():
	props = data.get("props")["level_%d" % level]
	base_damage = props.get("damage")
	base_attack_radius = props.get("attack_radius")
	base_attack_cooldown = props.get("attack_cooldown")
	cell_range = props.get("cell_range")
	
	load_appearance()
	apply_buffs()

func load_appearance():
	sprite = $Sprite2D
	textures = data.get("textures")["level_%d" % level]
	var txtr = load(textures.get(curr_texture_type, "res://assets/towers/default.svg"))
	if not txtr:
		txtr = load("res://assets/towers/default.svg")
		
	sprite.texture = txtr
	
	var target_size = Vector2(162.5, 162.5)
	var scl = target_size / sprite.texture.get_size()
	sprite.scale = scl
	
func apply_buffs():
	curr_damage = int(base_damage * BuffManager.get_buff_mutli("damage"))
	curr_attack_cooldown = base_attack_cooldown * BuffManager.get_buff_mutli("attack_cooldown")
	curr_attack_radius = base_attack_radius * BuffManager.get_buff_mutli("attack_radius")	
	
	$AttackTimer.wait_time = curr_attack_cooldown
	$AttackRadius/CollisionShape2D.shape.radius = curr_attack_radius

func can_upgrade() -> bool:
	return data.get("props").has("level_%d" % (level + 1))
	
func get_next_level_cost() -> int:
	return data.get("props")["level_%d" % (level + 1)]["cost"]
	
func upgrade():
	if not can_upgrade():
		print("No more upgrades. Max already reached!")
		return
		
	var next_cost = data.get("props")["level_%d" % (level + 1)]["cost"]
	if GameManager.level_money < next_cost:
		print("Not enough ATP to upgrade!")
		return
		
	GameManager.spend_level_money(next_cost)
	level += 1
	load_stats()

# Sell value is half the cost
func sell_value() -> int:
	return data.get("props")["level_%d" % level]["cost"] * 0.5

func on_enemy_killed():
	kill_count += 1

func _on_AttackTimer_timeout():
	if current_target:
		is_attacking = true
		attack()
	else:
		is_attacking = false
	change_state_visual()
		
# IMPORTANT!!!
var is_attacking = false
# Override this in inherited scripts for custom attack logic
func attack():
	shoot(current_target)
# Override this in inherited scripts for custom attack logic
func change_state_visual():
	pass
	
# Default attack pattern (shoot)
func shoot(enemy):
	var proj = load("res://scenes/projectiles/base_projectile.tscn").instantiate()
	proj.init_for(self, enemy)
	proj.global_position = global_position
	
	get_parent().add_child(proj)
