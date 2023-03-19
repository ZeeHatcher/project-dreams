extends Node2D


var _current_layer = 0
var _run = false

onready var _layers = $Layers.get_children()
onready var _total_layers = _layers.size()
onready var _layer_buttons = $CanvasLayer/LayerButtons
onready var _label = $"%Label"


func _ready():
	_show_layer(0)


func _show_layer(idx):
	for i in range(_total_layers):
		var layer = _layers[i]
		var show = i == idx
		
		layer.visible = show
		var mechanism = layer.get_node("ClockLayer")
		mechanism.activate(show) 
		
	_label.text = "Layer %d" % (idx + 1)


func _on_RunButton_pressed():
	_run = not _run
	_activate(_run)


func _activate(on):
	for layer in _layers:
		var mechanism = layer.get_node("ClockLayer")
		mechanism.run = on

	_layer_buttons.visible = not on
	
	var pieces = get_tree().get_nodes_in_group("clock_pieces")
	for piece in pieces:
		piece.input_pickable = not on
	
	if on:
		for layer in _layers:
			layer.visible = true
			var mechanism = layer.get_node("ClockLayer")
			mechanism.activate(false) 
	else:
		for layer in _layers:
			layer.get_node("ClockLayer").reset()
		
		_show_layer(_current_layer)


func _on_NextButton_pressed():
	if _current_layer >= _total_layers - 1:
		return
	
	_current_layer += 1
	_show_layer(_current_layer)


func _on_BackButton_pressed():
	if _current_layer <= 0:
		return
	
	_current_layer -= 1
	_show_layer(_current_layer)


func _on_EndLine_area_entered(area):
	var hands = $EndArea.get_overlapping_areas()
	
	if hands.size() == 3:
		MapData.save_minigame_result(Globals.Minigames.CLOCKSMITH, 1)
	
	_run = false
	_activate(_run)
