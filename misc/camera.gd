extends Camera2D


export(NodePath) var tracked

onready var _target = get_node(tracked)


func _physics_process(_delta):
	if not _target:
		return
	
	position = _target.position
