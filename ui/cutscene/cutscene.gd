extends Control


signal end()

export(Array, String, MULTILINE) var content

var _index = -1

onready var _label = $CenterContainer/Label
onready var _animation_player = $AnimationPlayer
onready var _audio_player = $AudioStreamPlayer
onready var _timer = $Timer


func _ready():
	_audio_player.play()
	var tween = create_tween()
	_audio_player.volume_db = -80
	tween.tween_property(_audio_player, "volume_db", -24, 1)
	_next()


func _input(event):
	var is_mouse_click = (
			event is InputEventMouseButton
			and event.button_index == BUTTON_LEFT
			and event.pressed
	)
	
	if event.is_action_pressed("interact") or is_mouse_click:
		_timer.stop()
		_next()
	
	get_tree().set_input_as_handled()


func _next():
	_animation_player.play("fade_out")
	_index += 1
	
	if _index >= content.size():
		var tween = create_tween()
		tween.tween_property(_audio_player, "volume_db", -80, 2)
	
	yield(_animation_player, "animation_finished")
	_label.text = ""
	
	if _index >= content.size():
		emit_signal("end")
		return
	
	_label.text = content[_index]
	_animation_player.play("fade_in")
	yield(_animation_player, "animation_finished")
	_timer.start()


func _on_Timer_timeout():
	_next()
