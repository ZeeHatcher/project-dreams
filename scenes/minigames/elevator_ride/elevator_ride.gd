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
onready var _failure_markers = $"%FailureMarkers"
onready var _total_levels = $Floors.get_child_count()


func _ready():
	_failure_markers.max_value = health
	_failure_markers.value = 0
	
	DreamTransition.connect("finished", self, "_on_DreamTransition_finished")
	

func _unhandled_input(event):
	if event.is_action_pressed("interact") and _elevator.passenger and _current_floor:
		_elevator.connect("stopped", self, "_on_Elevator_stopped_at_floor")
		_elevator.go_to_level(_current_floor.level, _total_levels)


func _on_Elevator_floor_reached(building_floor):
	_current_floor = building_floor


func _on_Passenger_tree_exited():
	var is_game_over = _check_game_over()
	
	if not is_game_over:
		_elevator.connect("stopped", self, "_on_Elevator_stopped_at_entrance")
		_elevator.go_to_level(0, _total_levels)


func _on_ElevatorDoor_area_entered(passenger):
	_target_level_label.text = Globals.LEVELS[passenger.target_level]
	_elevator.passenger = passenger
	_elevator.start()


func _on_ElevatorRide_end(success):
	print(success)
	MapData.save_minigame_result(Globals.Minigames.ELEVATOR_RIDE, success)


func _on_Elevator_stopped_at_floor():
	_check_level()
	_exit_passenger()
	_elevator.disconnect("stopped", self, "_on_Elevator_stopped_at_floor")


func _on_Elevator_stopped_at_entrance():
	_spawn_passenger()
	_elevator.disconnect("stopped", self, "_on_Elevator_stopped_at_entrance")


func _on_DreamTransition_finished():
	_spawn_passenger()


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
		_failure_markers.value += 1


func _check_game_over():
	if _successes >= pass_requirement:
		emit_signal("passed")
		return true
	elif health <= 0:
		emit_signal("failed")
		return true
	
	return false


func _exit_passenger():
	var passenger = _elevator.passenger
	_elevator.passenger = null
	_target_level_label.text = "-"
	passenger.move_to(passenger.position + Vector2.RIGHT * 1000)
