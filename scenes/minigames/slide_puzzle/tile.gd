extends Node2D


signal clicked(number)

var number: int

onready var sprite: Sprite = $"%Sprite"
onready var shape: RectangleShape2D = $"%CollisionShape2D".shape


func _on_Tile_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton && event.pressed):
		emit_signal("clicked")
