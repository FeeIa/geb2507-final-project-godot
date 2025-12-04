extends CharacterBody2D

var enemy_type: String
var data = {}
var max_hp: int
var curr_hp: int
var base_speed: float
var speed: float
var level_money_drop: int
var lives_damage: int
var resistances = {}
var path_points = []
var curr_path_idx = 0
var last_hit_by = null # The last tower that hit it

@onready var sprite = $Sprite2D
@onready var sprite_area = $Sprite2D/Area2D
@onready var slowed_timer = $SlowedTimer

func _ready():
	if enemy_type:
		load_stats()
		
	if !path_points.is_empty():
		global_position = path_points[0]
	
	update_hp()
	add_to_group("enemies")
	
	sprite_area.connect("mouse_entered", func():
		$HP.visible = true
	)
	sprite_area.connect("mouse_exited", func():
		$HP.visible = false
	)
	
	$SlowedTimer.timeout.connect(func():
		speed = base_speed	
	)
		
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
	
	data = Database.get_enemy_data(enemy_type)
	max_hp = data.get("hp", 100)
	curr_hp = max_hp
	base_speed = data.get("speed", 100)
	speed = base_speed
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
func take_damage(amount: int, tower_type: String):
	var reduction = 1 - resistances.get(tower_type, 0)
	var actual_dmg = amount * reduction
	curr_hp -= actual_dmg
	if curr_hp <= 0:
		die()
		
# Update health bar
func update_hp():
	$HP.text = str(curr_hp) + " / " + str(max_hp)
	
func has_resistance(tower_type) -> bool:
	return resistances.has(tower_type)
	
func get_resistance(tower_type):
	return resistances.get(tower_type, 0)
		
# Slow enemy down
func apply_slow(slow_effect: float):
	speed = base_speed * (1 - slow_effect)
	slowed_timer.start()
		
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
