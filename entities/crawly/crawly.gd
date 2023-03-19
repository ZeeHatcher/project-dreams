extends Area2D


signal found

var _found = false


func _on_Area2D_input_event(viewport, event, shape_idx):
	if _found or not event is InputEventMouseButton:
		return
	
	if event.button_index == BUTTON_LEFT and event.pressed:
		_found = true
		$AnimationPlayer.play("fade_out")
		emit_signal("found")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
