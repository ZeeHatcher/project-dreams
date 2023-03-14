extends Node


var player_position
var minigames_result = {} # true for passed, false for failed, non-existent key means not completed


func save_minigame_result(minigame, success):
	minigames_result[minigame] = success
	get_tree().change_scene("res://scenes/map/map.tscn")
