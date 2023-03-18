extends CanvasLayer


signal finished

onready var _animation_player = $AnimationPlayer

var _scene


func transition(path):
	_scene = load(path)
	_animation_player.play("in")


func transition_to(scene):
	_scene = scene
	_animation_player.play("in")


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"in":
			get_tree().change_scene_to(_scene)
			_animation_player.play("out")
		"out":
			emit_signal("finished")
