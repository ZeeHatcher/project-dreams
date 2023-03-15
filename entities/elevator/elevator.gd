extends Path2D


signal floor_reached(building_floor)
signal stopped()

export(int) var speed = 100

var passenger

var _dir = 1
var _is_moving = true
var _target

onready var _point = $PathFollow2D
onready var _stand_point = $PathFollow2D/Platform/StandPoint
onready var _length = curve.get_baked_length()


func _physics_process(delta):
	if _target != null:
		_move_to_target()
	elif _is_moving:
		_move(delta)
	
	if passenger:
		passenger.global_position = _stand_point.global_position


func go_to_level(target_level, total_levels):
	var offset = 0
	
	if total_levels - 1 != 0:
		offset = lerp(0, _length, target_level / float(total_levels - 1))
		
	_target = offset


func start():
	_is_moving = true


func _on_end_reached():
	_dir *= -1


func _move(delta):
	if _point.offset == _length || _point.offset == 0:
		_on_end_reached()
	
	_point.offset += speed * delta * _dir


func _move_to_target():
	_point.offset = lerp(_point.offset, _target, 0.1)
	
	if _is_target_reached():
		_target = null
		_is_moving = false
		emit_signal("stopped")


func _is_target_reached():
	return abs(_point.offset - _target) < 0.5


func _on_Platform_area_entered(area):
	emit_signal("floor_reached", area)
