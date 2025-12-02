extends CharacterBody2D

var enemy_type: String
var data = {}
var max_hp: int
var curr_hp: int
var speed: float
var level_money_drop: int
var lives_damage: int
var resistances = {}
var path_points = []
var curr_path_idx = 0
var last_hit_by = null # The last tower that hit it

func _ready():
	if enemy_type:
		load_stats()
		
	if !path_points.is_empty():
		global_position = path_points[0]
	
	update_hp()
	add_to_group("enemies")
		
func _process(delta: float):
	if curr_path_idx >= path_points.size():
		reached_base()
		queue_free()
		return
		
	update_hp()
		
	var target = path_points[curr_path_idx]
	var dir = (target - global_position).normalized()
	global_position += dir * speed * delta
	
	if global_position.distance_to(target) < 2.5:
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
	max_hp = data.get("hp", 100)
	curr_hp = max_hp
	speed = data.get("speed", 100)
	level_money_drop = data.get("level_money_drop", 10)
	lives_damage = data.get("lives_damage", 1)
	resistances = data.get("resistances", {})
	
	$Sprite2D.texture = load(data.get("texture", "res://assets/enemies/default.svg"))

# Call this for enemies to take damage
func take_damage(amount: int, tower_type: String):
	var reduction = 1 - resistances.get(tower_type, 0)
	var actual_dmg = amount * reduction
	curr_hp -= actual_dmg
	if curr_hp <= 0:
		die()
		
# Update health bar
func update_hp():
	$HPBar.value = float(curr_hp) / max_hp * 100
		
# Upon death
func die():
	GameManager.add_level_money(level_money_drop)
	if last_hit_by:
		last_hit_by.on_enemy_killed()
	queue_free()
	
# Handle what happens when the enemy reaches player's base
func reached_base():
	GameManager.lose_life(lives_damage)
	queue_free()
