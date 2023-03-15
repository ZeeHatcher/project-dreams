extends "filler.gd"


func _init(
		filled_dimensions_: Vector2 = Vector2.ZERO,
		empty_dimensions_: Vector2 = Vector2.ZERO
).(filled_dimensions_, empty_dimensions_) -> void:
	pass


func _get_initial_position(value: int, max_value: int) -> Vector2:
	return Vector2.ZERO


func _advance(pos: Vector2, texture_dimensions: Vector2) -> Vector2:
	return Vector2(pos.x + texture_dimensions.x, pos.y)


func _calculate_rect_size(value: int, max_value: int) -> Vector2:
	var height := max(filled_dimensions.y, empty_dimensions.y)
	var width := max(filled_dimensions.x, empty_dimensions.x) * max_value
	
	return Vector2(width, height)
