extends Control


const endings = {
	"good": [
		{
			"image": "res://scenes/ending/placeholder_good.png",
			"text": "Good ending. You are the best acolyte, and you made everyone happy"
		},
	],
	"neutral": [
		{
			"image": "res://scenes/ending/placeholder_neutral.png",
			"text": "Neutral ending. Being an acolyte's hard work, but you're trying your best."
		},
	],
	"bad": [
		{
			"image": "res://scenes/ending/placeholder_bad.png",
			"text": "Bad ending. You're quite the mischievious one, giving everyone bad dreams."
		},
	],
}

onready var _cutscene = $Cutscene


func _ready():
	var minigames_count = MapData.minigames_result.size()
	
	var score = 0
	for res in MapData.minigames_result.values():
		score += res
	
	var outcome = "neutral"
	if score == minigames_count:
		outcome = "good"
	elif score == -minigames_count:
		outcome = "bad"
	
	_cutscene.content = endings[outcome]


func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		_cutscene.next_page()


func _on_Cutscene_end():
	get_tree().change_scene("res://scenes/credits/credits.tscn")
