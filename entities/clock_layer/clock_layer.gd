extends Node2D


onready var _slots = $Slots.get_children()


func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		for slot in _slots:
			print(slot._piece)
