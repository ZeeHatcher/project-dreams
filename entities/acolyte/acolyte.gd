extends KinematicBody2D


export (float) var acceleration_weight = 0.05
export (int) var max_speed = 200

var dir = Vector2()
var velocity = Vector2()


func _physics_process(delta):
	_get_input()
	_move()


func _get_input():
	dir = Vector2()
	
	if Input.is_action_pressed("move_right"):
		dir.x += 1
	if Input.is_action_pressed("move_left"):
		dir.x -= 1
	if Input.is_action_pressed("move_down"):
		dir.y += 1
	if Input.is_action_pressed("move_up"):
		dir.y -= 1
		
	dir = dir.normalized()


func _move():
	var target_velocity = dir * max_speed
	velocity = velocity.linear_interpolate(target_velocity, acceleration_weight)
	velocity = move_and_slide(velocity)
