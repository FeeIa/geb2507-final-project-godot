extends StaticBody2D

@export var damage = 10
@export var fire_rate = 1.0
@export var detection_range = 250.0
@export var damage_type = "phagocyte"

@onready var area = $Area2D
@onready var fire_timer = $FireTimer
var target = null
var projectile_scene: PackedScene = preload("res://scenes/projectiles/projectile.tscn")

func _ready():
	area.connect("body_entered", _on_body_entered)
	area.connect("body_exited", _on_body_exited)
	$Area2D/CollisionShape2D.shape.radius = detection_range
	fire_timer.wait_time = 1.0 / fire_rate
	fire_timer.connect("timeout", _on_fire_timer_timeout)
	fire_timer.start()
	
func _on_body_entered(body):
	if body.is_in_group("enemies") and target == null:
		target = body
	
func _on_body_exited(body):
	if body == target:
		target = null
	
func _on_fire_timer_timeout():
	if is_instance_valid(target):
		shoot_projectile(target)
	
func shoot_projectile(enemy):
	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	projectile.target = enemy
	projectile.damage = damage
	projectile.damage_type = damage_type
	get_tree().current_scene.add_child(projectile)
