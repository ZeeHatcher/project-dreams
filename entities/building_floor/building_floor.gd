extends Area2D


export(String) var level

func _ready():
	$Label.text = level
