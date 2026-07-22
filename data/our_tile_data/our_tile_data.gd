class_name OurTileData
extends Resource


enum Side{
	RIGHT,
	BOTTOM,
	LEFT,
	TOP
}


const SIDE_TO_VECTOR: Dictionary[OurTileData.Side, Vector2i] = {
	Side.RIGHT : Vector2i.RIGHT,
	Side.BOTTOM : Vector2i.DOWN,
	Side.LEFT : Vector2i.LEFT,
	Side.TOP : Vector2i.UP
}


@export var atlas_position: Vector2i
@export var connections: Dictionary[Side, bool]
