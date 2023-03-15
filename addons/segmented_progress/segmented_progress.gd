tool
extends Control


signal changed
signal value_changed(value)

enum FillMode {
	LEFT_TO_RIGHT,
	RIGHT_TO_LEFT,
	TOP_TO_BOTTOM,
	BOTTOM_TO_TOP,
}

const Filler := preload("fillers/filler.gd")
const LeftToRightFiller := preload("fillers/left_to_right_filler.gd")
const RightToLeftFiller := preload("fillers/right_to_left_filler.gd")
const TopToBottomFiller := preload("fillers/top_to_bottom_filler.gd")
const BottomToTopFiller := preload("fillers/bottom_to_top_filler.gd")

export(FillMode) var fill_mode: int setget set_fill_mode, get_fill_mode
export var filled: Texture setget set_filled, get_filled
export var filled_tint := Color.white setget set_filled_tint, get_filled_tint
export var empty: Texture setget set_empty, get_empty
export var empty_tint := Color.white setget set_empty_tint, get_empty_tint
export var max_value: int setget set_max_value, get_max_value
export var value: int setget set_value, get_value

var _filler: Filler = LeftToRightFiller.new()


func _draw() -> void:
	var pos := _filler.get_initial_position(value, max_value)
	
	for n in range(max_value):
		var is_filled := n + 1 <= value
		var texture: Texture = filled if is_filled else empty
		var tint: Color = filled_tint if is_filled else empty_tint
		
		if not texture:
			continue
		
		draw_texture(texture, pos, tint)
		pos = _filler.advance(pos, texture.get_size())


func update() -> void:
	rect_min_size = _filler.calculate_rect_size(value, max_value)
	rect_size = rect_min_size
	
	.update()


func set_fill_mode(val: int) -> void:
	fill_mode = val
	
	if _filler and is_instance_valid(_filler):
		_filler.free()
	
	
	var filled_dimensions := filled.get_size() if filled else Vector2.ZERO
	var empty_dimensions := empty.get_size() if empty else Vector2.ZERO
		
	match fill_mode:
		FillMode.RIGHT_TO_LEFT:
			_filler = RightToLeftFiller.new(filled_dimensions, empty_dimensions)
		FillMode.TOP_TO_BOTTOM:
			_filler = TopToBottomFiller.new(filled_dimensions, empty_dimensions)
		FillMode.BOTTOM_TO_TOP:
			_filler = BottomToTopFiller.new(filled_dimensions, empty_dimensions)			
		_:
			_filler = LeftToRightFiller.new(filled_dimensions, empty_dimensions)
	
	update()


func get_fill_mode() -> int:
	return fill_mode


func set_filled(val: Texture) -> void:
	filled = val
	_filler.filled_dimensions = val.get_size() if val else Vector2.ZERO
	update()


func get_filled() -> Texture:
	return filled


func set_empty(val: Texture) -> void:
	empty = val
	_filler.empty_dimensions = val.get_size() if val else Vector2.ZERO
	update()


func get_empty() -> Texture:
	return empty


func set_filled_tint(val: Color) -> void:
	filled_tint = val
	update()


func get_filled_tint() -> Color:
	return filled_tint


func set_empty_tint(val: Color) -> void:
	empty_tint = val
	update()


func get_empty_tint() -> Color:
	return empty_tint


func set_max_value(val: int) -> void:
	max_value = max(0, val)
	emit_signal("changed")
	update()


func get_max_value() -> int:
	return max_value


func set_value(val: int) -> void:
	var prev := value
	value = clamp(val, 0, max_value)
	
	if value == prev:
		return
		
	emit_signal("value_changed", value)
	update()


func get_value() -> int:
	return value
