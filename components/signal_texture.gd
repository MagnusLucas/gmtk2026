@tool
class_name SignalTexture
extends GradientTexture2D

signal animation_finished

const MINIMUM_POINT_DISTANCE = 0.001

@export_category("Data")
@export_range(0, 1) var signal_strength := 1.0 : set = _set_signal_strength
@export var animation_time := 0.2

@export_category("Visuals")
@export var signal_colour: Color = Color.WHITE : set = _set_signal_colour
@export_range(0.001, 0.25) var signal_size_relative: float = 0.25
@export_range(0, 1) var animation_time_modifier := 0.5
@export_range(0, 1) var pulse_size_relative := 0.5

@export_tool_button("Generate gradient")
var generate_gradient_action = _generate_gradient

var currently_animating := false
var current_animation_speed := 0.0
var tile_signal: TileSignal
var time_since_animation_started := 0.0


func _init() -> void:
	fill = GradientTexture2D.FILL_RADIAL
	fill_from = Vector2.ONE / 2
	width = 128
	height = 128
	_generate_gradient()


func process(delta: float) -> void:
	if _is_receiving_signal():
		_animate_inward(delta)
	elif _is_spreading_signal():
		_animate_outward(delta)
	elif tile_signal:
		_set_signal_strength(tile_signal.calculate_strength())


func set_tile_signal(new_tile_signal: TileSignal) -> void:
	tile_signal = new_tile_signal
	animation_time = (1.0 - TileSignal.max_inaccuracy) * animation_time_modifier
	animation_time *= tile_signal.perfect_seconds()
	if animation_time > 0:
		_calculate_animation_speed()
		currently_animating = true
	else:
		push_warning("Animation time for ", self, " negative! Omitting animation")
	tile_signal.died.connect(_on_signal_died)


func animate_spreading_signal() -> void:
	currently_animating = true
	_calculate_animation_speed()
	tile_signal = null


func _range_size() -> float:
	return 1.0 - MINIMUM_POINT_DISTANCE * 2 - signal_size_relative


func _calculate_animation_speed() -> void:
	
	current_animation_speed = _calculate_visual_value() / animation_time


func _calculate_visual_value() -> float:
	var current_visual_value: float
	
	var middle_point_position := gradient.get_offset(2)
	var offset := MINIMUM_POINT_DISTANCE + signal_size_relative / 2
	
	current_visual_value = (middle_point_position - offset) / _range_size()
	return current_visual_value


func _stop_animating() -> void:
	currently_animating = false
	current_animation_speed = 0.0
	time_since_animation_started = 0
	animation_finished.emit()


func _animation_time_passed() -> bool:
	return time_since_animation_started > animation_time


func _on_signal_died() -> void:
	tile_signal = null
	_hide_signal()


func _is_receiving_signal() -> bool:
	return tile_signal && currently_animating


func _is_spreading_signal() -> bool:
	return !tile_signal && currently_animating


func _generate_gradient() -> void:
	gradient = Gradient.new()
	gradient.add_point(0.5 - signal_size_relative / 2, Color.BLACK)
	gradient.add_point(0.5, signal_colour)
	gradient.add_point(0.5 + signal_size_relative / 2, Color.BLACK)
	gradient.set_color(4, Color.BLACK)
	_hide_signal()


func _set_signal_colour(value: Color) -> void:
	signal_colour = value
	if gradient.get_point_count() > 2:
		gradient.set_color(2, value)


func _set_signal_strength(value: float) -> void:
	signal_strength = value
	
	var max_pulse_move_distance := _range_size() * pulse_size_relative
	
	var move_by := max_pulse_move_distance * signal_strength
	_show_signal()
	
	for point in range(3, 0, -1):
		gradient.set_offset(point, gradient.get_offset(point) + move_by)


func _animate_outward(delta: float) -> void:
	var animation_piece := delta / animation_time
	var offset := animation_piece * _range_size()
	for i in range(3, 0, -1):
		gradient.set_offset(i, gradient.get_offset(i) + offset)
	time_since_animation_started += delta
	if gradient.get_offset(3) + MINIMUM_POINT_DISTANCE + offset >= 1:
		_stop_animating()


func _animate_inward(delta: float) -> void:
	var animation_piece := delta / animation_time
	var offset := animation_piece * _range_size()
	for i in range(1, 4):
		gradient.set_offset(i, gradient.get_offset(i) - offset)
	time_since_animation_started += delta
	if _animation_time_passed() or gradient.get_offset(1) - MINIMUM_POINT_DISTANCE - offset < 0:
		_stop_animating()


func _show_signal() -> void:
	for i in range(1, 4):
		_set_point_start(i)


func _hide_signal() -> void:
	for i in range (3, 0, -1):
		_set_point_end(i)


func _set_point_start(point: int) -> void:
	var point_offset := signal_size_relative / 2 * (point - 1)
	gradient.set_offset(point, MINIMUM_POINT_DISTANCE + point_offset)


func _set_point_end(point: int) -> void:
	var point_offset := signal_size_relative / 2 * (3 - point)
	gradient.set_offset(point, 1 - MINIMUM_POINT_DISTANCE - point_offset)
