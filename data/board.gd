class_name Board
extends Resource

@export var size: Vector2i


var set_tiles: Dictionary[Vector2i, OurTileData]
var set_characters: Dictionary[Vector2i, Variant]


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
