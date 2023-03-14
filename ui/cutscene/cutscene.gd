extends VBoxContainer


signal end

var content = [] setget set_content

var _page = 0

onready var _image = $Image
onready var _description = $PanelContainer/Description


func _ready():
	_show_page(_page)


func next_page():
	_page += 1
		
	if _page < content.size():
		_show_page(_page)
	else:
		emit_signal("end")


func set_content(val):
	content = val
	_page = 0
	_show_page(0)


func _show_page(page):
	if page >= content.size():
		return
	
	var cont = content[page]
	_image.texture = load(cont["image"])
	_description.text = cont["text"]
