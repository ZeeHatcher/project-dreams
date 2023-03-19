extends Area2D


var _is_held = false


func _physics_process(delta):
	if _is_held:
		global_position = get_global_mouse_position()


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		_is_held = false


func _on_ClockPiece_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if not get_tree().is_input_handled():
			_is_held = true
			get_tree().set_input_as_handled()
