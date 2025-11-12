extends CharacterBody2D

@export var speed: float = 100.0
@export var max_health: int = 50
@export var resistances = {"phagocyte": 1.0, "antibody": 1.0}
var health: int
var path_follow: PathFollow2D

func _ready():
	health = max_health
	add_to_group("enemies")
	
func _process(delta: float) -> void:
	if path_follow:
		path_follow.progress_ratio += speed * delta / 1000.0
		global_position = path_follow.global_position

		if path_follow.progress_ratio >= 0.98:
			reached_base()
	
func take_damage(amt: float, type: String):
	var mult = resistances.get(type, 1.0)
	
	health -= amt * mult
	if health <= 0:
		die()
		
func die():
	GameManager.add_money(10)
	queue_free()

func reached_base():
	GameManager.lose_life()
	queue_free()
