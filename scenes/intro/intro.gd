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

onready var _image = $VBoxContainer/Image
onready var _description = $VBoxContainer/PanelContainer/Description


func _ready():
	_show_page(_page)


func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		_page += 1
		
		if _page < content.size():
			_show_page(_page)
		else:
			get_tree().change_scene("res://scenes/main.tscn")


func _show_page(page):
	if page > content.size():
		return
	
	var cont = content[page]
	_image.texture = load(cont["image"])
	_description.text = cont["text"]
