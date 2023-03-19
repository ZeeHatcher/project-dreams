class_name LinearRandSpawner
extends Node2D

onready var upper_pos = $Upper.global_position
onready var lower_pos = $Lower.global_position

func _ready():
	$Upper.queue_free()
	$Lower.queue_free()

func rand_loc():
	return lerp(upper_pos, lower_pos, randf())
