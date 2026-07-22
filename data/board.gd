class_name Board
extends Resource

@export var position: Vector2i
@export var size: Vector2i


var set_tiles: Dictionary[Vector2i, OurTileData]
var set_characters: Dictionary[Vector2i, Variant]


func is_point_in_bounds(coordinates: Vector2i) -> bool:
	return Rect2i(position, size).has_point(coordinates)


func try_set_tile(tile_data: OurTileData, global_coordinates: Vector2i) -> bool:
	if !is_point_in_bounds(global_coordinates):
		return false
	var local_coords := global_to_local(global_coordinates)
	if set_tiles.has(local_coords):
		return false
	set_tile(tile_data, local_coords)
	return true


func set_tile(tile_data: OurTileData, local_coordinates: Vector2i) -> void:
	set_tiles[local_coordinates] = tile_data


func local_to_global(local_coordinates: Vector2i) -> Vector2i:
	return local_coordinates + position


func global_to_local(global_coordinates: Vector2i) -> Vector2i:
	return global_coordinates - position
