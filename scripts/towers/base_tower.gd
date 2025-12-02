extends StaticBody2D

var tower_type: String
var data: Dictionary = {}
var sprite: Sprite2D

var props: Dictionary
var damage: int
var attack_radius: float
var attack_rate: float
var cell_range: int
var textures: Dictionary

var current_target: Node = null
var target_queue: Array[Node] = []
var kill_count: int = 0
var level: int = 0 # Defaults to 0 --> representing not placed yet!
var cell: Vector2i

func init(type: String, cell_ref: Vector2i = Vector2i(-1, -1)):
	tower_type = type
	level = 1 # Any tower starts from level 1
	data = TowerDatabase.get_tower_data(type)
	load_appearance()
	
	# In the case of previews
	if cell_ref.x == -1 and cell_ref.y == -1:
		level = 0
		return
		
	load_stats()
	
	cell = cell_ref
	
	$AttackRadius.connect("body_entered", func(body: Node):
		if !body.is_in_group("enemies"): return
		
		target_queue.push_back(body)
		if not current_target:
			while !is_instance_valid(target_queue.front()):
				target_queue.pop_front()
				
			current_target = target_queue.front()
			target_queue.pop_front()
	)
	
	$AttackRadius.connect("body_exited", func(body: Node):
		if current_target == body:
			current_target = null
			
		if !target_queue.is_empty():
			if is_instance_valid(target_queue.front()):
				current_target = target_queue.front()
			target_queue.pop_front()
	)
	
	$AttackTimer.connect("timeout", _on_AttackTimer_timeout)
	
	$Sprite2D/Area2D.connect("input_event", func(viewport, event, shape_idx):
		if event is InputEventMouseButton and event.pressed:
			TowerMenu.open_for(self)
	)

# Load the tower stats, which is called upon initialization and upgrades
func load_stats():
	props = data.get("props")["level_%d" % level]
	damage = props.get("damage")
	attack_radius = props.get("attack_radius")
	attack_rate = props.get("attack_rate")
	cell_range = props.get("cell_range")
	
	$AttackTimer.wait_time = attack_rate
	
	load_appearance()

func load_appearance():
	sprite = $Sprite2D
	textures = data.get("textures")["level_%d" % level]
	
	$AttackRadius/CollisionShape2D.shape.radius = attack_radius
	sprite.texture = load(textures.get("base"))
	
	var target_size = Vector2(162.5, 162.5)
	var scl = target_size / sprite.texture.get_size()
	sprite.scale = scl

func can_upgrade() -> bool:
	return data.get("props").has("level_%d" % level)
	
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
		attack()
		
# Override this in inherited scripts for custom attack logic
func attack():
	shoot(current_target)
	
# Default attack pattern (shoot)
func shoot(enemy):
	var proj = preload("res://scenes/projectiles/base_projectile.tscn").instantiate()
	proj.damage = damage
	proj.source_tower = self
	proj.global_position = global_position
	proj.target_enemy = enemy
	
	get_parent().add_child(proj)
