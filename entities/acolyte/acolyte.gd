extends KinematicBody2D


export (float) var acceleration_weight = 0.05
export (int) var max_speed = 200

var _dir = Vector2()
var _velocity = Vector2()
var _target

onready var _interact_area = $InteractArea
onready var _sprite = $AnimatedSprite
onready var _particles = $Particles2D


func _process(delta):
	if _dir.x != 0:
		_sprite.flip_h = _dir.x < 0

func _physics_process(delta):
	_get_movement_input()
	_move()
	_animate()


func _unhandled_input(event):
	if _target and event.is_action_pressed("interact"):
		if _target.has_method("interact"):
			_target.interact()


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


func _animate():
	if _dir != Vector2.ZERO:
		_sprite.play()
		_particles.emitting = true
	elif _sprite.playing:
		_sprite.frame = 0
		_sprite.stop()
		_particles.emitting = false
		

func _on_InteractArea_body_entered(body):
	if (body.has_method("highlight")):
		body.highlight()
		_target = body


func _on_InteractArea_body_exited(body):
	if (body.has_method("unhighlight")):
		body.unhighlight()
		_target = null
