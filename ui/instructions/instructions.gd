tool
extends CenterContainer


signal closed

export(String) var title
export(String, MULTILINE) var description

var _is_initial = true


func _draw():
	$"%Title".text = title
	$"%Description".text = description


func _input(event):
	if visible and event is InputEventKey and event.pressed:
		if _is_initial:
			emit_signal("closed")
			_is_initial = false
			
		visible = false
		get_tree().set_input_as_handled()
	elif (
			event is InputEventKey
			and event.scancode == KEY_TAB
			and event.pressed
	):
		visible = true
