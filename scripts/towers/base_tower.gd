extends StaticBody2D

@export var tower_type: String
var data = {}
var damage: int
var fire_rate: float
var attack_radius: float

var current_target: Node = null
var target_queue: Array[Node] = []

func _ready():
	if tower_type:
		load_stats()
		$Area2D.connect("body_entered", func(body: Node):
			if !body.is_in_group("enemies"): return
			
			target_queue.push_back(body)
			if not current_target:
				current_target = target_queue.front()
				target_queue.pop_front()
		)
		$Area2D.connect("body_exited", func(body: Node):
			if current_target == body:
				current_target = null
				
			if !target_queue.is_empty():
				current_target = target_queue.front()
				target_queue.pop_front()
		)
		$FireTimer.connect("timeout", _on_FireTimer_timeout)

# Load the tower stats
func load_stats():
	if not tower_type:
		print("[ERROR] Tower type is not yet set!")
		return
		
	var file = FileAccess.open("res://data/towers/%s.json" % tower_type, FileAccess.READ)
	if not file:
		print("[ERROR] No JSON file found for tower " + str(tower_type))
		return
	
	data = JSON.parse_string(file.get_as_text())
	damage = data.get("damage", 20)
	attack_radius = data.get("attach_radius", 150.0)
	fire_rate = data.get("fire_rate", 1.0)
	
	$Area2D/CollisionShape2D.shape.radius = attack_radius
	$Sprite2D.texture = load(data.get("texture", "res://assets/towers/default.svg"))

func _on_FireTimer_timeout():
	if current_target:
		shoot(current_target)
		
func shoot(enemy):
	var proj = preload("res://scenes/projectiles/base_projectile.tscn").instantiate()
	proj.damage = damage
	proj.tower_type = tower_type
	proj.global_position = global_position
	proj.target = current_target
	
	get_parent().add_child(proj)
