extends Area2D
class_name ClockPieceSlot


export(NodePath) var next_path

var _piece
var _next_slot


func _ready():
	if not next_path.is_empty():
		_next_slot = get_node(next_path)
	

func insert(piece):
	piece.global_position = global_position
	_piece = piece


func detach():
	_piece = null


func empty():
	return _piece == null


func rotate_gear(rot, driver_teeth):
	if _piece == null:
		return
		
	var ratio = driver_teeth / float(_piece.teeth_count)
	rot = rot * ratio * -1
	var wrap_rot = wrapf(rotation_degrees + rot, 0, 360)
	rotation_degrees = wrap_rot
	_piece.rotation_degrees = wrap_rot
	
	if _next_slot:
		_next_slot.rotate_gear(rot, _piece.teeth_count)
	
