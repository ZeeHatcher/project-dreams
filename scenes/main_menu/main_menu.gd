extends Control


func _ready():
	MapData.reset()


func _on_PlayButton_pressed():
	get_tree().change_scene("res://scenes/intro/intro.tscn")


func _on_CreditsButton_pressed():
	get_tree().change_scene("res://scenes/credits/credits.tscn")
