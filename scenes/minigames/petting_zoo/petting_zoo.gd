extends Node2D


export(Array, PackedScene) var pets

var _score = 0

onready var _conveyor = $Conveyor
onready var _total_pets = pets.size()


func _on_Pet_satisfied():
	_score += 1
	_next_pet()


func _on_Instructions_closed():
	_next_pet()


func _next_pet():
	_add_pet_to_conveyor()
	_conveyor.next()


func _add_pet_to_conveyor():
	var scene = pets.pop_front()
	
	if scene == null:
		_game_over()
		return
	
	var pet = scene.instance()
	pet.connect("satisfied", self, "_on_Pet_satisfied")
	pet.connect("angered", self, "_next_pet")
	_conveyor.add_item(pet)


func _game_over():
	var result = 1 if _score > _total_pets * 0.75 else -1
	MapData.save_minigame_result(Globals.Minigames.PETTING_ZOO, result)
