extends Node2D


export(int) var rotation_
export(int) var teeth_count
export(Array, NodePath) var drivers

var run = false
var _drivers = []
var _original_rotations = []

onready var _slots = $Slots.get_children()
onready var _edge = $Edge


func _ready():
	for path in drivers:
		_drivers.append(get_node(path))
	
	for slot in _slots:
		_original_rotations.append(slot.rotation_degrees)


func _physics_process(delta):
	if not run or _drivers.empty():
		return
	
	var rot = rotation_ * delta
	_edge.rotation_degrees = wrapf(_edge.rotation_degrees + rot, 0, 360)
	
	for driver in _drivers:
		driver.rotate_gear(rot, teeth_count)


func activate(active):
	for slot in _slots:
		var shape = slot.get_node("CollisionShape2D")
		shape.set_deferred("disabled", not active)


func reset():
	for i in range(_slots.size()):
		var slot = _slots[i]
		slot.rotation_degrees = _original_rotations[i]
