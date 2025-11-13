extends CharacterBody2D

@export var enemy_type: String
var data = {}
var hp: int
var speed: float
var level_money_drop: int
var lives_damage: int
var resistances = {}
var path_points = []
var curr_path_idx = 0

func _ready():
	if enemy_type:
		load_stats()
		
	if !path_points.is_empty():
		global_position = path_points[0]
	
	add_to_group("enemies")
		
func _process(delta: float):
	if curr_path_idx >= path_points.size():
		reached_base()
		queue_free()
		return
		
	var target = path_points[curr_path_idx]
	var dir = (target - global_position).normalized()
	global_position += dir * speed * delta
	
	if global_position.distance_to(target) < 10:
		curr_path_idx += 1

# Load the enemy stats
func load_stats():
	if not enemy_type:
		print("[ERROR] Enemy type is not yet set!")
		return
		
	var file = FileAccess.open("res://data/enemies/%s.json" % enemy_type, FileAccess.READ)
	if not file:
		print("[ERROR] No JSON file found for enemy " + str(enemy_type))
		return
	
	data = JSON.parse_string(file.get_as_text())
	hp = data.get("hp", 100)
	speed = data.get("speed", 100)
	level_money_drop = data.get("level_money_drop", 10)
	lives_damage = data.get("lives_damage", 1)
	resistances = data.get("resistances", {})
	
	$Sprite2D.texture = load(data.get("texture", "res://assets/enemies/default.svg"))

# Call this for enemies to take damage
func take_damage(amount: int, tower_type: String):
	var reduction = 1 - resistances.get(tower_type, 0)
	var actual_dmg = amount * reduction
	hp -= actual_dmg
	if hp <= 0:
		die()
		
# Upon death
func die():
	GameManager.add_level_money(level_money_drop)
	queue_free()
	
# Handle what happens when the enemy reaches player's base
func reached_base():
	GameManager.lose_life(lives_damage)
	queue_free()
