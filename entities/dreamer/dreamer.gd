extends StaticBody2D


signal dream_entered(minigame)

const Happy = preload("res://entities/dreamer/happy.png")
const Sad = preload("res://entities/dreamer/sad.png")

export(Globals.Minigames) var minigame
export(PackedScene) var minigame_scene

var _completed = false


func _ready():
	$AnimatedSprite.frame = randi() % 4
	
	if not minigame in MapData.minigames_result:
		MapData.minigames_result[minigame] = 0
	elif MapData.minigames_result[minigame] != 0:
#		set_collision_layer_bit(0, false)
		_completed = true
		$Emotion.texture = Happy if MapData.minigames_result[minigame] == 1 else Sad


func interact():
	if _completed:
		return
	
	emit_signal("dream_entered", minigame_scene)


func highlight():
	create_tween().tween_property($Emotion, "modulate", Color.white, 0.5)


func unhighlight():
	create_tween().tween_property($Emotion, "modulate", Color.transparent, 0.5)
