extends Control


const content = [
	{
		"image": "res://scenes/intro/placeholder_1.png",
		"text": "Once upon a time..."
	},
	{
		"image": "res://scenes/intro/placeholder_2.png",
		"text": "The end."
	},
]

var _page = 0

onready var _cutscene = $Cutscene


func _ready():
	_cutscene.content = content


func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		_cutscene.next_page()


func _on_Cutscene_end():
	get_tree().change_scene("res://scenes/map/map.tscn")
