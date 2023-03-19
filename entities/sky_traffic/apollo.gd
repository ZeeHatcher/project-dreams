extends Area2D

const MAX_HORSE_COUNT := 5
const FRAME_SECONDS := 0.16

export var horse_count := 1 setget _set_horse_count

var _frame_times := [ 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ]

export var direction: Vector2
export var speed: float

onready var starting_point = global_position
var total_travel_dist = 1800.0

func _ready():
	set_process(true)
	_set_horse_visibility()

func _physics_process(delta):
	position += direction * speed * delta

func _process(delta : float):
	if starting_point.distance_to(global_position) > total_travel_dist:
		queue_free()

	for i in _frame_times.size():
		_frame_times[i] += delta
		
		if _frame_times[i] >= FRAME_SECONDS:
			match i:
				0:
					$Horse0.frame = 8 if $Horse0.frame != 8 else 9
				1:
					$Horses/Horse1.frame = \
						8 if $Horses/Horse1.frame != 8 else 9
				2:
					$Horses/Horse2.frame = \
						8 if $Horses/Horse2.frame != 8 else 9
				3:
					$Horses/Horse3.frame = \
						8 if $Horses/Horse3.frame != 8 else 9
				4:
					$Horses/Horse4.frame = \
						8 if $Horses/Horse4.frame != 8 else 9
				_:
					$Chariot.frame = 10 if $Chariot.frame != 10 else 11
			
			_frame_times[i] = 0


func flip():
	scale.x = -scale.x

func _set_horse_count(value : int):
	if value < 1:
		horse_count = 1
	elif value >= MAX_HORSE_COUNT:
		horse_count = MAX_HORSE_COUNT
	else:
		horse_count = value
	
	_set_horse_visibility()

func _set_horse_visibility():
	for i in _frame_times.size():
		_frame_times[i] = randf() * 0.14
	
	$Horse0.position.x = horse_count * -128
	$Horses/Horse1.visible = not horse_count < 2 
	$Horses/Horse2.visible = not horse_count < 3 
	$Horses/Horse3.visible = not horse_count < 4
	$Horses/Horse4.visible = not horse_count < 5

func _on_Apollo_body_entered(body):
	if body is IcarusBody2D:
		body.hit()
