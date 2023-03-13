extends Node2D

signal passed
signal failed

const PassengerScene = preload("res://entities/passenger/passenger.tscn")

export(int) var pass_requirement = 3
export(int) var health = 3
export(int) var speed_scale = 150

var _successes = 0
var _current_floor

onready var _elevator = $Elevator
onready var _spawn_point = $SpawnPoint
onready var _wait_point = $WaitPoint
onready var _target_level_label = $TargetLevel


func _ready():
	_spawn_passenger()
	

func _unhandled_input(event):
	if event.is_action_pressed("interact") and _elevator.passenger and _current_floor:
		_check_level()
		_exit_passenger()
		_check_game_over()


func _on_Elevator_floor_reached(building_floor):
	_current_floor = building_floor


func _on_Passenger_tree_exited():
	_spawn_passenger()


func _on_ElevatorDoor_area_entered(passenger):
	_target_level_label.text = passenger.target_level
	_elevator.passenger = passenger


func _spawn_passenger():
	var passenger = PassengerScene.instance()
	passenger.position = _spawn_point.position
	passenger.connect("tree_exited", self, "_on_Passenger_tree_exited")
	call_deferred("add_child", passenger)
	
	passenger.move_to(_wait_point.position)


func _check_level():
	if _current_floor.level == _elevator.passenger.target_level:
		_elevator.speed += speed_scale
		_successes += 1
	else:
		health -= 1


func _check_game_over():
	if _successes >= pass_requirement:
		emit_signal("passed")
	elif health <= 0:
		emit_signal("failed")


func _exit_passenger():
	var passenger = _elevator.passenger
	_elevator.passenger = null
	_target_level_label.text = "-"
	passenger.move_to(passenger.position + Vector2.RIGHT * 1000)
