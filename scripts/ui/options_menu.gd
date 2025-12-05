extends CanvasLayer

@onready var master_slider: HSlider = $Options/Container/Master/MasterSlider
@onready var bgm_slider: HSlider = $Options/Container/BGM/BGMSlider
@onready var sfx_slider: HSlider = $Options/Container/SFX/SFXSlider

var settings: Dictionary = {}

func _ready():
	settings = SaveManager.save_data["settings"]
	master_slider.value = settings.get("master_volume", 1.0)
	bgm_slider.value = settings.get("bgm_volume", 1.0)
	sfx_slider.value = settings.get("sfx_volume", 1.0)
	
	master_slider.value_changed.connect(_on_master_slider_changed)
	bgm_slider.value_changed.connect(_on_bgm_slider_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_changed)
	$Close.pressed.connect(close)
	
func _on_master_slider_changed(val):
	SaveManager.save_data["settings"]["master_volume"] = val
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		linear_to_db(val)
	)
	SaveManager.save_game()
	
func _on_bgm_slider_changed(val):
	SaveManager.save_data["settings"]["bgm_volume"] = val
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("BGM"),
		linear_to_db(val)
	)
	SaveManager.save_game()

func _on_sfx_slider_changed(val):
	SaveManager.save_data["settings"]["sfx_volume"] = val
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"),
		linear_to_db(val)
	)
	SaveManager.save_game()
	
func open():
	visible = true
	
func close():
	visible = false
