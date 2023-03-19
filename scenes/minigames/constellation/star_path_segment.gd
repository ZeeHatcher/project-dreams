tool
extends Node2D


export var length: int = 10
export var filled_percent: float = 0.5

onready var segmented_progress = $"%SegmentedProgress"


func _process(delta):
	update()


func update():
	segmented_progress.max_value = length
	segmented_progress.value = length * filled_percent
