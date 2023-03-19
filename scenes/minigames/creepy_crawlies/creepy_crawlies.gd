extends Node2D


signal passed
signal failed

onready var _crawlies = $Crawlies.get_children()
onready var _crawlies_left = _crawlies.size()
onready var _timer = $Timer
onready var _counter = $"%Counter"


func _ready():
	for crawly in _crawlies:
		crawly.connect("found", self, "_on_Crawly_found")
	
	_counter.text = str(_crawlies_left)


func _on_Crawly_found():
	_crawlies_left -= 1
	_counter.text = str(_crawlies_left)
	_check_win_condition()


func _on_Timer_timeout():
	emit_signal("failed")
	MapData.save_minigame_result(Globals.Minigames.CREEPY_CRAWLIES, -1)


func _on_CreepyCrawlies_end(success):
	_timer.stop()
	

func _check_win_condition():
	if _crawlies_left == 0:
		$AnimationPlayer.play("snapshot")
		emit_signal("passed")


func _on_Instructions_closed():
	_timer.start()


func _on_AnimationPlayer_animation_finished(anim_name):
	MapData.save_minigame_result(Globals.Minigames.CREEPY_CRAWLIES, 1)
