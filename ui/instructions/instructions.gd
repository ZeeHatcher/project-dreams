tool
extends CenterContainer


signal closed

export(String) var title
export(String, MULTILINE) var description


func _draw():
	$"%Title".text = title
	$"%Description".text = description


func _input(event):
	if event.is_action_pressed("interact"):
		emit_signal("closed")
		queue_free()
