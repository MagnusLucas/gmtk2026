@tool
class_name SignalTexture
extends GradientTexture2D

signal animation_finished

const MINIMUM_POINT_DISTANCE = 0.001

@export var signal_colour: Color = Color.WHITE : set = _set_signal_colour
@export_range(0.001, 0.25) var signal_size_relative: float = 0.25
@export var animation_time := 0.2
@export_tool_button("Generate gradient")
var generate_gradient_action = _generate_gradient


var half_move_range: float


func _init() -> void:
	fill = GradientTexture2D.FILL_RADIAL
	fill_from = Vector2.ONE / 2
	width = 128
	height = 128
	half_move_range = 0.5 - signal_size_relative - MINIMUM_POINT_DISTANCE
	_generate_gradient()


func _generate_gradient() -> void:
	gradient = Gradient.new()
	gradient.add_point(0.5 - signal_size_relative, Color.BLACK)
	gradient.add_point(0.5, signal_colour)
	gradient.add_point(0.5 + signal_size_relative, Color.BLACK)
	gradient.set_color(4, Color.BLACK)
	set_signal(false)


func _set_signal_colour(value: Color) -> void:
	signal_colour = value
	if gradient.get_point_count() > 2:
		gradient.set_color(2, value)


func animate_outward(delta: float) -> void:
	var animation_piece := delta / animation_time
	var offset := animation_piece * half_move_range
	for i in range(3, 0, -1):
		gradient.set_offset(i, gradient.get_offset(i) + offset)
	if gradient.get_offset(3) + MINIMUM_POINT_DISTANCE + offset >= 1:
		animation_finished.emit()


func animate_inward(delta: float) -> void:
	var animation_piece := delta / animation_time
	var offset := animation_piece * half_move_range
	for i in range(1, 4):
		gradient.set_offset(i, gradient.get_offset(i) - offset)
	if gradient.get_offset(1) - MINIMUM_POINT_DISTANCE - offset <= 0:
		animation_finished.emit()


func set_signal(has_tile_signal: bool) -> void:
	if has_tile_signal:
		for i in range(1, 4):
			_set_point_start(i)
	else:
		for i in range (3, 0, -1):
			_set_point_end(i)


func _set_point_start(point: int) -> void:
	var point_offset := signal_size_relative / 2 * (point - 1)
	gradient.set_offset(point, MINIMUM_POINT_DISTANCE + point_offset)


func _set_point_end(point: int) -> void:
	var point_offset := signal_size_relative / 2 * (3 - point)
	gradient.set_offset(point, 1 - MINIMUM_POINT_DISTANCE - point_offset)
