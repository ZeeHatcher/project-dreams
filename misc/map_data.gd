extends Node


var player_position
var minigames_result = {} # 1 for passed, 0 for not complete, -1 for failed


func save_minigame_result(minigame, success):
	minigames_result[minigame] = success
	DreamTransition.transition("res://scenes/map/map.tscn")


func reset():
	player_position = null
	minigames_result = {}
