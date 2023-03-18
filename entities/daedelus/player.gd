extends KinematicBody2D


export var speed := 128

var _velocity := Vector2.ZERO


func _ready():
	$Daedelus/AnimationPlayer.play("run_right")
	set_physics_process(true)


func _physics_process(_delta):
	var mov_x = \
		int(Input.is_action_pressed("move_right")) - \
		int(Input.is_action_pressed("move_left"))
	var mov_y = \
		int(Input.is_action_pressed("move_down")) - \
		int(Input.is_action_pressed("move_up"))
	
	if abs(mov_x) != abs(mov_y):
		if mov_x > 0: $Daedelus/AnimationPlayer.play("run_right")
		elif mov_x < 0: $Daedelus/AnimationPlayer.play("run_left")
		
		if mov_y > 0: $Daedelus/AnimationPlayer.play("run_down")
		elif mov_y < 0: $Daedelus/AnimationPlayer.play("run_up")
	
	_velocity = Vector2(mov_x * speed, mov_y * speed)
	
	# warning-ignore:return_value_discarded
	move_and_slide(_velocity)
