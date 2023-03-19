extends ProgressBar


var pet


func _process(delta):
	if pet:
		value = pet.happiness
