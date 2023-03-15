extends Object


var filled_dimensions: Vector2 setget set_filled_dimensions, get_filled_dimensions
var empty_dimensions: Vector2 setget set_empty_dimensions, get_empty_dimensions


func _init(filled_dimensions_: Vector2 = Vector2.ZERO, empty_dimensions_: Vector2 = Vector2.ZERO) -> void:
	filled_dimensions = filled_dimensions_
	empty_dimensions = empty_dimensions_


func get_initial_position(value: int, max_value: int) -> Vector2:
	return _get_initial_position(value, max_value)


func advance(pos: Vector2, texture_dimensions: Vector2) -> Vector2:
	return _advance(pos, texture_dimensions)


func calculate_rect_size(value: int, max_value: int) -> Vector2:
	return _calculate_rect_size(value, max_value)


func set_filled_dimensions(val: Vector2) -> void:
	filled_dimensions = val


func get_filled_dimensions() -> Vector2:
	return filled_dimensions


func set_empty_dimensions(val: Vector2) -> void:
	empty_dimensions = val


func get_empty_dimensions() -> Vector2:
	return empty_dimensions


# Virtual methods to be overriden by child classes
func _get_initial_position(_value: int, _max_value: int) -> Vector2:
	return Vector2()


func _advance(_pos: Vector2, _texture_dimensions: Vector2) -> Vector2:
	return Vector2()


func _calculate_rect_size(_value: int, _max_value: int) -> Vector2:
	return Vector2()
