extends CanvasLayer


onready var _volume_slider = $Control/CenterContainer/VBoxContainer/VBoxContainer/HSlider
onready var _master_bus = AudioServer.get_bus_index("Master")

func _ready():
	visible = false
	_volume_slider.value = db2linear(AudioServer.get_bus_volume_db(_master_bus))


func _input(event):
	if (
			event is InputEventKey
			and event.scancode == KEY_ESCAPE
			and event.pressed
	):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused
		get_tree().set_input_as_handled()


func _on_Button_pressed():
	get_tree().change_scene("res://scenes/main_menu/main_menu.tscn")


func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(_master_bus, linear2db(value))
	print(AudioServer.get_bus_volume_db(_master_bus))
