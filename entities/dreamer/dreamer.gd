extends StaticBody2D


export(PackedScene) var minigame


func interact():
	get_tree().change_scene_to(minigame)


func highlight():
	print_debug("'highlight' called on '%s'" % self)


func unhighlight():
	print_debug("'unhighlight' called on '%s'" % self)
