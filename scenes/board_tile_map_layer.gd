class_name BoardTileMapLayer
extends TileMapLayer

@export var board: Board

@onready var signal_manager: SignalManager = $SignalManager
@onready var tile_swapper: TileSwapper = $TileSwapper


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	const CROSS_WIRE = preload("uid://cv5ftp81ddrmr")
	
	signal_manager.created_signal.connect(_on_signal_created)
	
	for i in board.size.x:
		for j in board.size.y:
			set_tile(Tile.new_tile(CROSS_WIRE), Vector2i(i, j))
	signal_manager.create_signal(Vector2i(0, 0))


func set_tile(tile: Tile, target_position: Vector2i) -> void:
	if !board.try_set_tile(tile.get_tile_data(), target_position):
		return
	add_child(tile, true)
	tile.position = map_to_local(target_position)
	tile.left_clicked.connect(tile_swapper.mark_tile.bind(tile))
	tile.right_clicked.connect(signal_manager.spread_signal.bind(target_position))


func _on_signal_created(tile_position: Vector2i, tile_signal: TileSignal) -> void:
	var test := TestSignalShower.from_signal(tile_signal)
	add_child(test)
	test.position = map_to_local(tile_position)
