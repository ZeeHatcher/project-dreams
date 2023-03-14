extends Node2D


onready var _player = $Player


func _ready():
	if MapData.player_position != null:
		_player.position = MapData.player_position
	
	var dreamers = get_tree().get_nodes_in_group("dreamers")
	for dreamer in dreamers:
		dreamer.connect("dream_entered", self, "_on_Dreamer_dream_entered")


func _on_Dreamer_dream_entered(minigame):
	MapData.player_position = _player.position
	get_tree().change_scene_to(minigame)


func _on_Exit_body_entered(body):
	if not _can_end():
		return
	
	get_tree().change_scene("res://scenes/ending/ending.tscn")


func _can_end():
	for val in MapData.minigames_result.values():
		if val == 0:
			return false
	
	return true
