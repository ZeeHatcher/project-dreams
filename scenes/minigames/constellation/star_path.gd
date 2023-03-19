extends Node2D


signal cleared

export var glow: Color = Color(1.8, 1.8, 1.8)
export var tolerance: float = 30.0

var active: bool = false
var cleared: bool = false

var current_node: Node2D
var current_path: Node2D
var target_node: Node2D

var path_length: float
var mouse_distance_to_target: float = 999.0

onready var snd_star = $"%snd_star"


func _ready():
	reset()


func _process(delta):
	if cleared:
		return
	
	mouse_distance_to_target = get_global_mouse_position().distance_to(target_node.global_position)
	
	if not active:
		return
	
	if mouse_distance_to_target < tolerance:
		play_collect_sound()
		if not set_next_target():
			return
	
	current_path.filled_percent = 1.0 - mouse_distance_to_target / path_length


func _unhandled_input(event: InputEvent):
	if cleared:
		return
		
	if not event is InputEventMouseButton:
		return
	
	if event.button_index == 1:
		if event.is_pressed():
			print("left mouse button pressed")
			if mouse_distance_to_target < tolerance:
				set_next_target()
				active = true
				current_node.set_colorhint_strength(1.0)
		
		else:
			print("left mouse button released")
			if active:
				active = false
				reset()


func reset():
	active = false
	cleared = false
	modulate = Color(1.0, 1.0, 1.0)
	target_node = get_node("./StarPathNode")
	target_node.set_colorhint_strength(0.5)
	target_node.sprite.self_modulate = glow
	current_node = null
	current_path = null
	
	var target: Node2D = target_node
	var path: Node2D
	
	while true:
		path = target.get_node("./StarPathSegment")
		if path == null:
			break
		path.filled_percent = 0.0
		
		target = path.get_node("./StarPathNode")
		target.set_colorhint_strength(0.0)
		target.sprite.self_modulate = Color(1.0, 1.0, 1.0)


func play_collect_sound():
	snd_star.global_position = target_node.global_position
	snd_star.play()


func set_next_target() -> bool:
	# fill last path
	if current_path != null:
		current_path.filled_percent = 1.0
	
	# mark target as cleared
	target_node.set_colorhint_strength(1.0)
	target_node.sprite.self_modulate = Color(1.0, 1.0, 1.0)
	
	# set target as current node
	current_node = target_node
	
	# get next path
	current_path = current_node.get_node("./StarPathSegment")
	
	# is there is no next path, the constellation is cleared
	if current_path == null:
		path_cleared()
		return false
	
	# get next target
	target_node = current_path.get_node("./StarPathNode")
	target_node.set_colorhint_strength(0.5)
	target_node.sprite.self_modulate = glow
	
	path_length = current_node.global_position.distance_to(target_node.global_position)
	mouse_distance_to_target = get_global_mouse_position().distance_to(target_node.global_position)
	
	return true


func path_cleared():
	active = false
	cleared = true
	modulate = glow # enables glow
	emit_signal("cleared")
