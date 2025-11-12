extends Node

# Signals
signal money_changed
signal lives_changed
signal wave_started
signal wave_cleared
signal game_over_signal

# Variables
var money: int = 100
var lives: int = 10
var current_wave: int = 0
var is_game_over: bool = false

func add_money(amt: int):
	money += amt
	emit_signal("money_changed", money)
	
func deduct_money(amt: int):
	add_money(-amt)
	
func lose_life():
	lives -= 1
	emit_signal("lives_changed", lives)
	if lives <= 0:
		game_over()
		
func start_wave():
	current_wave += 1
	emit_signal("wave_started", current_wave)
	
func clear_wave():
	emit_signal("wave_cleared", current_wave)
		
func game_over():
	print("GAME OVER!")	
	emit_signal("game_over_signal")
