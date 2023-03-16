extends Label
class_name Clock


export(NodePath) var timer_path

onready var _timer = get_node(timer_path)


func _process(delta):
	var current_time = _timer.time_left
	var minutes = _get_minute_part(current_time)
	var seconds = _get_second_part(current_time)
	text = "%d:%02d" % [minutes, seconds]


func _get_minute_part(time):
	return time / 60.0


func _get_second_part(time):
	return int(time) % 60
