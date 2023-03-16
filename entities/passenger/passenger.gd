extends Area2D


export(int) var speed = 150

var _target_position
var _moving = false

onready var target_level = randi() % Globals.LEVELS.size()


func _physics_process(delta):
	if _moving:
		_move(delta)


func move_to(pos):
	_target_position = pos
	_moving = true


func warp(pos):
	position = pos
	_moving = false


func _move(delta):
	var sp = speed * delta
	
	if position.distance_to(_target_position) > sp:
		position += position.direction_to(_target_position) * sp
	else:
		position = _target_position
		_moving = false


func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	queue_free()
