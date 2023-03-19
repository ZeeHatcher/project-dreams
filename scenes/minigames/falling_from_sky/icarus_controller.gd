class_name IcarusBody2D
extends KinematicBody2D

signal hurt()

export (float) var acceleration_weight = 0.05
export (int) var max_speed = 200

var _dir = Vector2()
var _velocity = Vector2()
var _target

func _physics_process(delta):
	_get_movement_input()
	_move()

func _unhandled_input(event):
	if _target and event.is_action_pressed("interact"):
		if _target.has_method("interact"):
			_target.interact()

func hit():
	emit_signal("hurt")


func _get_movement_input():
	_dir = Vector2()
	
	if Input.is_action_pressed("move_right"):
		_dir.x += 1
	if Input.is_action_pressed("move_left"):
		_dir.x -= 1
	if Input.is_action_pressed("move_down"):
		_dir.y += 1
	if Input.is_action_pressed("move_up"):
		_dir.y -= 1
		
	_dir = _dir.normalized()
	

func _move():
	var target__velocity = _dir * max_speed
	_velocity = _velocity.linear_interpolate(target__velocity, acceleration_weight)
	_velocity = move_and_slide(_velocity)

