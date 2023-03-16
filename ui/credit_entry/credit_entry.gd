tool
extends VBoxContainer


export(String) var title setget set_title
export(Array, String) var contributors setget set_contributors

onready var _list = $Contributors


func _ready():
	_update()


func set_title(val):
	title = val
	
	if $Title != null:
		$Title.text = val


func set_contributors(val):
	contributors = val
	
	if _list != null:
		_clear_contributors()
		_populate_contributors()


func _update():
	$Title.text = title
	
	_clear_contributors()
	_populate_contributors()


func _clear_contributors():
	for child in _list.get_children():
		child.queue_free()


func _populate_contributors():
	for name in contributors:
		var label = Label.new()
		label.text = name
		label.align = ALIGN_CENTER
		_list.add_child(label)
