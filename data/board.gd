class_name Board
extends Resource

@export var size: Vector2i

var set_tiles: Dictionary[Vector2i, OurTileData]
@export var unit_attributes_dict: Dictionary[Vector2i, UnitAttributes]


func is_point_in_bounds(coordinates: Vector2i) -> bool:
	return Rect2i(Vector2i.ZERO, size).has_point(coordinates)


func try_set_tile(tile_data: OurTileData, coordinates: Vector2i) -> bool:
	if !is_point_in_bounds(coordinates):
		return false
	if set_tiles.has(coordinates):
		return false
	set_tile(tile_data, coordinates)
	return true


func set_tile(tile_data: OurTileData, coordinates: Vector2i) -> void:
	set_tiles[coordinates] = tile_data


func has_unit_at(coordinates: Vector2i) -> bool:
	return unit_attributes_dict.has(coordinates)


func clear() -> void:
	set_tiles = {}
	unit_attributes_dict = {}
