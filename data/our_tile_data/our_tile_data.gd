class_name OurTileData
extends Resource


enum Side{
	RIGHT,
	BOTTOM,
	LEFT,
	TOP
}

const SIDE_STRING: Dictionary[OurTileData.Side, String] = {
	Side.RIGHT : "right",
	Side.BOTTOM : "bottom",
	Side.LEFT : "left",
	Side.TOP : "top"
}


const SIDE_TO_VECTOR: Dictionary[OurTileData.Side, Vector2i] = {
	Side.RIGHT : Vector2i.RIGHT,
	Side.BOTTOM : Vector2i.DOWN,
	Side.LEFT : Vector2i.LEFT,
	Side.TOP : Vector2i.UP
}

#@export var atlas_position: Vector2i


# sad
# https://github.com/godotengine/godot/issues/94395
@export var connections: Dictionary[Side, bool] :
	set(value):
		connections = {}
		for side in value.keys():
			connections[(int(side) + 2) % 4 as OurTileData.Side] = true
