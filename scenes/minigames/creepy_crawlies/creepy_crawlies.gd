extends Node2D


signal passed
signal failed

onready var _crawlies = $Crawlies.get_children()
onready var _crawlies_left = _crawlies.size()
onready var _timer = $Timer


func _ready():
	for crawly in _crawlies:
		crawly.connect("found", self, "_on_Crawly_found")
	
	_timer.start()


func _on_Crawly_found():
	_crawlies_left -= 1
	_check_win_condition()


func _on_Timer_timeout():
	emit_signal("failed")


func _on_CreepyCrawlies_passed():
	print("passed!")


func _check_win_condition():
	if _crawlies_left == 0:
		emit_signal("passed")
