extends Label
class_name Counter


export var max_value = 0 setget set_max_value
export var value = 0 setget set_value


func _ready():
	_update()


func set_max_value(val):
	max_value = val
	value = clamp(value, 0, max_value)
	_update()


func set_value(val):
	value = clamp(val, 0, max_value)
	_update()


func _update():
	text = "%d/%d" % [value, max_value]
