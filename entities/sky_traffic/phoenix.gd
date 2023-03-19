extends Area2D

export var direction: Vector2
export var speed: float

onready var sprite = $Phoenix

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	position += direction * speed * delta

func _process(_delta):
	if direction.dot(Vector2.LEFT) < 0:
		sprite.flip_h = true
	

func _on_Phoenix_body_entered(body):
	if body is IcarusBody2D:
		body.hit()
		direction = direction.reflect(Vector2.UP)

func _on_Phoenix_area_entered(area):
	if area is SkyFallingBorderBody2D:
		queue_free()
