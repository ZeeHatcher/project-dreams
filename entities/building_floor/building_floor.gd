extends Area2D

export(int) var level


func _ready():
	$Label.text = Globals.LEVELS[level]
