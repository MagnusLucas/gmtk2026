class_name TileSwapper
extends Node

var marked_tile: Tile


func mark_tile(tile: Tile) -> void:
	if marked_tile:
		marked_tile.set_marked(false)
		var marked_position = marked_tile.position
		marked_tile.position = tile.position
		tile.position = marked_position
		marked_tile = null
	else:
		marked_tile = tile
		marked_tile.set_marked(true)
