extends Control


const content = [
	"To dream...\nSlipping into the void, a previewing of Elysium...",
	"Mortals spend their lives,\nattempting to glimpse our power...",
	"Blessed have you been, my acolyte...\nTo move as a whisper among their minds...",
	"Omens parted to the slumbering, on your shoulders,\ntheir miniscule worlds will carry...",
	"Now show me how you wield those burdens...",
	"ARROW KEYS/WASD\nto move\n\nSPACEBAR to enter dreams of slumberers",
]

var _index = -1

onready var _label = $CenterContainer/Label
onready var _animation_player = $AnimationPlayer
onready var _audio_player = $AudioStreamPlayer
onready var _timer = $Timer


func _ready():
	_audio_player.play()
	var tween = create_tween()
	_audio_player.volume_db = -80
	tween.tween_property(_audio_player, "volume_db", -24, 2)
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
		_end()
		return
	
	_label.text = content[_index]
	_animation_player.play("fade_in")
	yield(_animation_player, "animation_finished")
	_timer.start()


func _end():
	get_tree().change_scene("res://scenes/map/map.tscn")


func _on_Timer_timeout():
	_next()
