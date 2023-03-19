extends StaticBody2D


signal dream_entered(minigame)

export(Globals.Minigames) var minigame
export(PackedScene) var minigame_scene


func _ready():
	$AnimatedSprite.frame = randi() % 4
	
	if not minigame in MapData.minigames_result:
		MapData.minigames_result[minigame] = 0
	elif MapData.minigames_result[minigame] != 0:
		set_collision_layer_bit(0, false)


func interact():
	emit_signal("dream_entered", minigame_scene)


func highlight():
	print_debug("'highlight' called on '%s'" % self)


func unhighlight():
	print_debug("'unhighlight' called on '%s'" % self)
