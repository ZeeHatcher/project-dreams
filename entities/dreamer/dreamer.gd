extends StaticBody2D


signal dream_entered(minigame)

export(Globals.Minigames) var minigame
export(PackedScene) var minigame_scene


func _ready():
	if minigame in MapData.minigames_result:
		set_collision_layer_bit(0, false)
		
		$Polygon2D.color = Color.green if MapData.minigames_result[minigame] else Color.red


func interact():
	emit_signal("dream_entered", minigame_scene)


func highlight():
	print_debug("'highlight' called on '%s'" % self)


func unhighlight():
	print_debug("'unhighlight' called on '%s'" % self)
