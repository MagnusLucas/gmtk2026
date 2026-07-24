class_name BoardTileMapLayer
extends TileMapLayer

@export var board: Board

@onready var signal_manager: SignalManager = $SignalManager
@onready var tile_swapper: TileSwapper = $TileSwapper

const CROSS_WIRE = preload("uid://cv5ftp81ddrmr")
const TOP_LEFT = preload("uid://duikbvl75hybn")
const TOP_RIGHT = preload("uid://bipschdun40ay")

var tile_data_array: Array[OurTileData] = [CROSS_WIRE, TOP_LEFT, TOP_RIGHT]
var tile_dict: Dictionary[Vector2i, Tile]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	signal_manager.signal_created.connect(_on_signal_created)
	
	for i in board.size.x:
		for j in board.size.y:
			set_tile(Tile.new_tile(random_tile_data()), Vector2i(i, j))
	signal_manager.create_signal(Vector2i.ZERO, OurTileData.Side.TOP, 1.0, 3.0)


func random_tile_data() -> OurTileData:
	return tile_data_array.pick_random()


func set_tile(tile: Tile, target_position: Vector2i) -> void:
	if !board.try_set_tile(tile.get_tile_data(), target_position):
		return
	add_child(tile, true)
	tile.position = map_to_local(target_position)
	tile.left_clicked.connect(tile_swapper.mark_tile.bind(tile, target_position))
	tile.right_clicked.connect(signal_manager.spread_signal.bind(target_position))
	tile_dict[target_position] = tile


func _on_signal_created(tile_position: Vector2i, tile_signal: TileSignal) -> void:
	var test := TestSignalShower.from_signal(tile_signal)
	add_child(test)
	test.position = map_to_local(tile_position)
	tile_dict[tile_position].receiving_signal = true
	tile_dict[tile_position].animating = true
