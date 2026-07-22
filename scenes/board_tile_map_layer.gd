class_name BoardTileMapLayer
extends TileMapLayer

@export var board: Board

@onready var tile_swapper: TileSwapper = $TileSwapper


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	const TOP_LEFT = preload("uid://duikbvl75hybn")
	const TOP_RIGHT = preload("uid://bipschdun40ay")
	
	set_tile(Tile.new_tile(TOP_LEFT), Vector2i(0, 0))
	set_tile(Tile.new_tile(TOP_RIGHT), Vector2i(2, 2))
	set_tile(Tile.new_tile(TOP_RIGHT), Vector2i(6, 6))


func set_tile(tile: Tile, target_position: Vector2i) -> void:
	add_child(tile, true)
	tile.position = map_to_local(target_position)
	tile.left_clicked.connect(tile_swapper.mark_tile.bind(tile))
