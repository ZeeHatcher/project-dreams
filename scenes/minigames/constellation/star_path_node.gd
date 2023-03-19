extends Node2D


onready var sprite = $"%AnimatedSprite"
onready var shader = sprite.material as ShaderMaterial


func set_colorhint_strength(strength: float):
	shader.set_shader_param("strength", strength)


func set_colorhint(color: Color):
	shader.set_shader_param("color_hint", color)
