extends Control


func _ready():
	$Cutscene.play()


func _on_Cutscene_end():
	get_tree().change_scene("res://scenes/map/map.tscn")
