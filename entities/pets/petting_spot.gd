extends Area2D
class_name PettingSpot


signal stroked(enjoyment)

export(float) var enjoyment

var _is_stroking = false


func _ready():
	connect("input_event", self, "_on_PettingSpot_input_event")


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		_is_stroking = event.pressed


func _on_PettingSpot_input_event(viewport, event, shape_idx):
	if event is InputEventMouseMotion and _is_stroking:
		emit_signal("stroked", enjoyment)
