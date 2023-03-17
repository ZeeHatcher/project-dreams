tool
extends Node
# plays a sound multiple times concurrently without cutting off
# for godot 4 just increase max_polyphony of the AudioStreamPlayer


export var count: int = 3

var players: Array
var next: int = 0


func _get_configuration_warning() -> String:
	if count < 2:
		return "SoundQueue doesn't make sense with a count less than 2"
	
	if get_child_count() == 0:
		return "SoundQueue needs an AudioStreamPlayer as child"
	
	if not get_child(0) is AudioStreamPlayer:
		return "SoundQueue can only handle AudioStreamPlayer"
	
	return ""


func _ready():
	if count < 2:
		return
	
	if get_child_count() == 0:
		return
	
	var child = get_child(0)
	
	if not child is AudioStreamPlayer:
		return
	
	players.append(child)
	
	for i in range(count - 1):
		var duplicate := child.duplicate() as AudioStreamPlayer
		add_child(duplicate)
		players.append(duplicate)


func play():
	players[next].play()
	
	next += 1
	next %= count
