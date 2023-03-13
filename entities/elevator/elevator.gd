extends Path2D


signal floor_reached(building_floor)

export(int) var speed = 100

var passenger

var _dir = 1

onready var _point = $PathFollow2D
onready var _length = curve.get_baked_length()


func _physics_process(delta):
	if _point.offset == _length || _point.offset == 0:
		_on_end_reached()
	
	_move(delta)
	
	if passenger:
		passenger.position = _point.global_position


func _on_end_reached():
	_dir *= -1


func _move(delta):
	_point.offset += speed * delta * _dir


func _on_Platform_area_entered(area):
	emit_signal("floor_reached", area)
