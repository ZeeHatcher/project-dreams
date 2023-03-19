extends Control


const endings = {
	"good": [
		"Merging the hope, dreams, and escapes of the ethreal,\ngiving sight to turn their world...",
		"You have done well in guiding these villagers...\nTheir eyes will gleam the brighter...",
		"Creation & innovation shall pour from here...\nRefreshing well quenching thirtst of barbarity...",
		"You take the first steps,\ntowards becoming a paragon of civilization...",
		"Good Ending\nSweet Dreams"
	],
	"neutral": [
		"Each life holds a vision...\nAmbitions driving them, striving towards it...",
		"Some will fail, others succeed...\nNatural pattern of life...",
		"To see the individual for who they are...\nTo sculpt accordingly, can be wise...",
		"Neutral Ending"
	],
	"bad": [
		"Into the bowls of Tartarus your mind wanders...",
		"Echoes of this village will ring,\ntainting the land itself...",
		"Base creatures can sense these things...",
		"Despair seeps into earth...\nDreams turning to dust...\nSpirit decaying before the body...",
		"Even Hades would be proud...\nYour nightmare spreads...",
		"Evil Ending\nNightmare"
	],
}

onready var _cutscene = $Cutscene


func _ready():
	var minigames_count = MapData.minigames_result.size()
	
	var score = 0
	for res in MapData.minigames_result.values():
		score += res
	
	var outcome = "neutral"
	if score >= minigames_count - 1:
		outcome = "good"
	elif score <= -(minigames_count - 1):
		outcome = "bad"
	
	_cutscene.content = endings[outcome]
	
	_cutscene.play()


func _on_Cutscene_end():
	get_tree().change_scene("res://scenes/credits/credits.tscn")
