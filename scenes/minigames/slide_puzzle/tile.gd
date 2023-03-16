extends Node2D


signal tile_clicked(number, grid_position)
signal tile_rightclicked(number, grid_position)

var number: int
var grid_position: Vector2

onready var sprite: Sprite = $"%Sprite"
onready var collision: CollisionShape2D = $"%CollisionShape2D"
onready var shape: RectangleShape2D = collision.shape
onready var label: Label = $"%Label"
onready var move_up: Tween = $"%move_up"



func _ready():
	label.text = str(number)
	
	

func _on_Tile_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.pressed):
		if event.button_index == BUTTON_LEFT:
			emit_signal("tile_clicked", number, grid_position)
		elif event.button_index == BUTTON_RIGHT:
			emit_signal("tile_rightclicked", number, grid_position)
