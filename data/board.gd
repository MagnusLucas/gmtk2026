class_name Board
extends Resource

@export var position: Vector2i
@export var size: Vector2i


func is_point_in_bounds(coordinates: Vector2i) -> bool:
	return Rect2i(position, size).has_point(coordinates)
