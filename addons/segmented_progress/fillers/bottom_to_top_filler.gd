extends "filler.gd"


func _init(
		filled_dimensions_: Vector2 = Vector2.ZERO,
		empty_dimensions_: Vector2 = Vector2.ZERO
).(filled_dimensions_, empty_dimensions_) -> void:
	pass


func _get_initial_position(value: int, max_value: int) -> Vector2:
	var size := _calculate_rect_size(value, max_value)
	var max_height = max(filled_dimensions.y, empty_dimensions.y)
	
	return Vector2(0, size.y - max_height)


func _advance(pos: Vector2, texture_dimensions: Vector2) -> Vector2:
	return Vector2(pos.x, pos.y - texture_dimensions.y)


func _calculate_rect_size(value: int, max_value: int) -> Vector2:
	var height := max(filled_dimensions.y, empty_dimensions.y) * max_value
	var width := max(filled_dimensions.x, empty_dimensions.x)
	
	return Vector2(width, height)
