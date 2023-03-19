extends Area2D
class_name ClockPieceSlot


var _piece


func insert(piece):
	piece.global_position = global_position
	_piece = piece


func detach():
	_piece = null


func empty():
	return _piece == null
