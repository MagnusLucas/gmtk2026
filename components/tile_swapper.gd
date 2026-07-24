class_name TileSwapper
extends Node

@export var board: Board

var marked_tile: Tile
var marked_tile_position: Vector2i


func mark_tile(tile: Tile, tile_position: Vector2i) -> void:
	if marked_tile:
		marked_tile.set_marked(false)
		var marked_tile_data := marked_tile.get_tile_data()
		board.set_tile(tile.get_tile_data(), marked_tile_position)
		board.set_tile(marked_tile_data, tile_position)
		marked_tile.set_tile_data(tile.get_tile_data())
		tile.set_tile_data(marked_tile_data)
		marked_tile = null
	else:
		marked_tile = tile
		marked_tile_position = tile_position
		marked_tile.set_marked(true)
