extends CharacterBody2D

var enemy_type: String
var data = {}
var max_hp: float
var curr_hp: float
var base_speed: float
var buffed_base_speed: float
var speed: float
var level_money_drop: int
var lives_damage: int
var resistances = {}
var path_points = []
var curr_path_idx = 0
var last_hit_by = null # The last tower that hit it
var dmg_taken = 1.0

@onready var sprite = $Sprite2D
@onready var sprite_area = $Sprite2D/Area2D
@onready var slowed_timer = $SlowedTimer

func init(type: String, path_pts: Array[Vector2]):
	enemy_type = type
	path_points = path_pts
	if !path_points.is_empty():
		global_position = path_points[0]
	
	load_stats()
	update_hp()
	
	sprite_area.connect("mouse_entered", func():
		$HP.visible = true
	)
	sprite_area.connect("mouse_exited", func():
		$HP.visible = false
	)
	$SlowedTimer.timeout.connect(func():
		speed = buffed_base_speed	
	)
	
	add_to_group("enemies")
	BuffManager.enemy_buffs_changed.connect(apply_buffs)
	apply_buffs()
		
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
	data = Database.get_enemy_data(enemy_type)
	max_hp = data.get("hp", 100)
	curr_hp = max_hp
	base_speed = data.get("speed", 100)
	buffed_base_speed = base_speed
	speed = buffed_base_speed
	level_money_drop = data.get("level_money_drop", 10)
	lives_damage = data.get("lives_damage", 1)
	resistances = data.get("resistances", {})
	
	var txtr = load(data.get("texture", "res://assets/enemies/default.svg"))
	if not txtr:
		txtr = load("res://assets/enemies/default.svg")
	sprite.texture =	txtr
	var target_size = Vector2(162.5, 162.5)
	var scl = target_size / sprite.texture.get_size()
	sprite.scale = scl
	
# Call this for enemies to take damage
func take_damage(amount: float, tower_type: String):
	var reduction = 1 - resistances.get(tower_type, 0)
	var actual_dmg = amount * reduction * dmg_taken
	curr_hp -= actual_dmg
	if curr_hp <= 0:
		die()

func apply_buffs():
	buffed_base_speed = base_speed * BuffManager.get_enemy_buff_mutli("speed")
	speed = buffed_base_speed
	dmg_taken = BuffManager.get_enemy_buff_mutli("damage_taken")

# Update health bar
func update_hp():
	$HP.text = "%.1f" % curr_hp + " / " +  "%.1f" % max_hp
	
func has_resistance(tower_type) -> bool:
	return resistances.has(tower_type)
	
func get_resistance(tower_type):
	return resistances.get(tower_type, 0)
		
# Slow enemy down
func apply_slow(slow_effect: float):
	speed = buffed_base_speed * (1 - slow_effect)
	slowed_timer.start()
		
# Upon death
func die():
	on_death()
	GameManager.add_level_money(level_money_drop)
	if last_hit_by:
		last_hit_by.on_enemy_killed()
	queue_free()

# Inherit this in child classes for custom logic
func on_death():
	pass
	
# Handle what happens when the enemy reaches player's base
func reached_base():
	GameManager.lose_life(lives_damage)
	queue_free()
