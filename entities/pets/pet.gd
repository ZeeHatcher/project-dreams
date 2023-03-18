extends Sprite


signal satisfied
signal angered

export(float) var happiness = 50 setget set_happiness
export(float) var happiness_decay = 5
export(Texture) var happy_texture
export(Texture) var angry_texture

var _active = true

onready var _timer = $TextureResetTimer
onready var _neutral_texture = texture


func _ready():
	var spots = $Spots.get_children()
	
	for spot in spots:
		spot.connect("stroked", self, "_on_PettingSpot_stroked")


func _physics_process(delta):
	if not _active:
		return
	
	self.happiness -= happiness_decay * delta
	
	if happiness == 0:
		_active = false
		emit_signal("angered")


func _on_PettingSpot_stroked(enjoyment):
	if not _active:
		return
	
	self.happiness += enjoyment
	
	if enjoyment > 0:
		texture = happy_texture
	elif enjoyment < 0:
		texture = angry_texture
	
	_timer.start()
	
	if happiness == 100:
		_active = false
		emit_signal("satisfied")


func set_happiness(val):
	happiness = clamp(val, 0, 100)


func _on_TextureResetTimer_timeout():
	texture = _neutral_texture
