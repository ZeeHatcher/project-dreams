extends Node2D


signal tile_clicked(number, grid_position)

var number: int
var grid_position: Vector2

onready var sprite: Sprite = $"%Sprite"
onready var shape: RectangleShape2D = $"%CollisionShape2D".shape
onready var label: Label = $"%Label"


func _ready():
	label.text = str(number)


func _on_Tile_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton && event.pressed):
		emit_signal("tile_clicked", number, grid_position)
