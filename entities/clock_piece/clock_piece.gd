extends Area2D


var _is_held = false
var _slot


func _physics_process(delta):
	if _is_held:
		global_position = get_global_mouse_position()


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		_is_held = false
		
		var slots = get_overlapping_areas()
		if not slots.empty() and slots[0].empty():
			_slot = slots[0]
			_slot.insert(self)


func _on_ClockPiece_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if not get_tree().is_input_handled():
			_is_held = true
			
			if _slot:
				_slot.detach()
				_slot = null
			
			get_tree().set_input_as_handled()
