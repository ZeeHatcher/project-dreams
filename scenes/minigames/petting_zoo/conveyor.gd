extends Path2D


var _index = 0
var _prev
var _current


func _physics_process(delta):
	if _prev:
		_prev.unit_offset = lerp(_prev.unit_offset, 1, 0.1)
	
	if _current:
		_current.unit_offset = lerp(_current.unit_offset, 0.5, 0.1)


func next():
	_prev = _current
	_current = null
	
	var items = get_children()
	
	if _index >= items.size():
		return
	
	_current = items[_index]
	_index += 1


func add_item(item):
	var point = PathFollow2D.new()
	point.rotate = false
	point.add_child(item)
	add_child(point)
