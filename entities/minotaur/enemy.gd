extends Area2D


export var path_to_player := NodePath()
export var speed := 64

var _velocity := Vector2.ZERO
var _player : KinematicBody2D = null


func _ready():
	if path_to_player == "":
		print("(minotaur/enemy.gd) Error: Enemy not assigned a player to chase")
		return
	
	_player = get_node(path_to_player)
	if not _player or not visible:
		print("(minotaur/enemy.gd) Error: Enemy not initialized!")
		return
	
	# warning-ignore:return_value_discarded
	$Timer.connect("timeout", self, "_update_pathfinding")
	$Minotaur/AnimationPlayer.play("run_right")
	_update_pathfinding()
	set_physics_process(true)


func _physics_process(delta):
	if $NavigationAgent2D.is_navigation_finished():
		return
	
	var dir := global_position.direction_to(
		$NavigationAgent2D.get_next_location()
	)
	
	var mov := dir * speed
	
	if abs(mov.x) > abs(mov.y):
		if mov.x > 0: $Minotaur/AnimationPlayer.play("run_right")
		elif mov.x < 0: $Minotaur/AnimationPlayer.play("run_left")
	elif abs(mov.x) < abs(mov.y):
		if mov.y > 0: $Minotaur/AnimationPlayer.play("run_down")
		elif mov.y < 0: $Minotaur/AnimationPlayer.play("run_up")
	
	_velocity = Vector2(mov)
	
	position += _velocity * delta


func _update_pathfinding():
	$NavigationAgent2D.set_target_location(_player.global_position)
