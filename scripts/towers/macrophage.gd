extends "res://scripts/towers/base_tower.gd"

var is_attacking: bool = false
var buff_active: bool = false
var buff_timer: Timer
var base_damage: int

func init(type: String, cell_ref: Vector2i = Vector2i(-1, -1)):
	super(type, cell_ref)
	base_damage = damage
	
	buff_timer = Timer.new()
	buff_timer.wait_time = 5.0
	buff_timer.one_shot = true
	buff_timer.timeout.connect(_on_buff_timeout)
	
	add_child(buff_timer)
	
func on_enemy_killed():
	super()
	if kill_count == 1:
		activate_buff(1)
	elif kill_count == 2:
		activate_buff(2)
	
func activate_buff(level: int):
	if buff_active:
		buff_timer.stop()
	
	if level == 1 or level == 2:
		buff_active = true
		
		if level == 1:
			damage = base_damage + 10
			sprite.offset = Vector2(45, -47)
		elif level == 2:
			damage = base_damage + 20
			sprite.offset = Vector2(33, -50)
	
	if buff_active:
		sprite.texture = load(textures["eat_%d" % level])
		buff_timer.start()
	
func _on_buff_timeout():
	buff_active = false
	kill_count = 0
	damage = base_damage
	sprite.texture = load(textures["base"])
	sprite.offset = Vector2(0, 0)
