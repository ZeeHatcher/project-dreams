extends Node2D


var constellations: Array
var cleared_consteallations: int
var restarts: int

onready var end_timer = $"%EndTimer"
onready var timer = $"%Timer"
onready var hud = $"%Hud"
onready var bgm = $"%Bgm"
onready var snd_cleared = $"%snd_cleared"
onready var snd_time_up = $"%snd_time_up"


func _ready():
	for child in get_children():
		if child.name.begins_with("StarPath"):
			constellations.append(child)


func start_game():
	timer.start()
	bgm.play()


func _on_StarPath_cleared():
	snd_cleared.play()
	cleared_consteallations += 1
	if cleared_consteallations == constellations.size():
		game_won()
		

func game_won():
	timer.stop()
	hud.visible = false
	for c in constellations:
		c.modulate = Color(2.0, 2.0, 2.0)
	end_timer.start()


func _on_EndTimer_timeout():
	if restarts < 3:
		MapData.save_minigame_result(Globals.Minigames.CONSTELLATION, 1)
	else:
		MapData.save_minigame_result(Globals.Minigames.CONSTELLATION, -1)


func _on_Timer_timeout():
	restarts += 1
	
	if restarts == 3:
		game_won()
		return
	
	snd_time_up.play()
	cleared_consteallations = 0
	for c in constellations:
		c.reset()


func _on_Instructions_closed():
	start_game()
