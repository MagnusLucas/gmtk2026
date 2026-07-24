@tool
class_name SignalTexture
extends GradientTexture2D

signal animation_finished

const MINIMUM_POINT_DISTANCE = 0.001

@export var signal_colour: Color = Color.WHITE
@export_range(0.001, 0.25) var signal_size_relative: float = 0.1
@export var animation_time := 0.2

var half_move_range: float


func _init() -> void:
	fill = GradientTexture2D.FILL_RADIAL
	fill_from = Vector2.ONE / 2
	gradient = Gradient.new()
	gradient.add_point(0.5 - signal_size_relative, Color.BLACK)
	gradient.add_point(0.5, signal_colour)
	gradient.add_point(0.5 + signal_size_relative, Color.BLACK)
	gradient.set_color(4, Color.BLACK)
	width = 128
	height = 128
	half_move_range = 0.5 - signal_size_relative - MINIMUM_POINT_DISTANCE


func animate_outward(delta: float) -> void:
	var animation_piece := delta / animation_time
	var offset := animation_piece * half_move_range
	for i in range(1, 4):
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
	for i in range(1, 4):
		if has_tile_signal:
			_set_point_start(i)
		else:
			_set_point_end(i)


func _set_point_start(point: int) -> void:
	var point_offset := signal_size_relative / 2 * (point - 1)
	gradient.set_offset(point, MINIMUM_POINT_DISTANCE + point_offset)


func _set_point_end(point: int) -> void:
	var point_offset := signal_size_relative / 2 * (3 - point)
	gradient.set_offset(point, 1 - MINIMUM_POINT_DISTANCE - point_offset)
