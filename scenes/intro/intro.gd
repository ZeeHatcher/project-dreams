extends Control


func _on_Cutscene_end():
	get_tree().change_scene("res://scenes/map/map.tscn")
