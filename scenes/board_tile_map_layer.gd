class_name BoardTileMapLayer
extends TileMapLayer

@export var board: Board
@export var player_unit_arr: Array[PlayerUnit]

@onready var signal_manager: SignalManager = $SignalManager
@onready var tile_swapper: TileSwapper = $TileSwapper

const EMITTER_POSITION := Vector2i(-1, 0)

const CROSS_WIRE = preload("uid://cv5ftp81ddrmr")
const TOP_LEFT = preload("uid://duikbvl75hybn")
const TOP_RIGHT = preload("uid://bipschdun40ay")
const RIGHT_WIRE = preload("uid://c6ks63mdpjw26")

var tile_data_array: Array[OurTileData] = [CROSS_WIRE, TOP_LEFT, TOP_RIGHT]
var tile_dict: Dictionary[Vector2i, Tile]


## This shouldn't be here TODO
var units: Dictionary[Vector2i, PlayerUnit]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	board.clear()
	
	for i in board.size.x:
		for j in board.size.y:
			set_tile(Tile.new_tile(random_tile_data()), Vector2i(i, j))
	
	set_emitter(EMITTER_POSITION)
	
	signal_manager.signal_created.connect(_on_signal_created)
	
	for player_unit in player_unit_arr:
		var unit_map_position := local_to_map(player_unit.position)
		if !board.is_point_in_bounds(unit_map_position):
			printerr(player_unit, " is out of board bounds!")
			continue
		board.unit_attributes_dict[unit_map_position] = player_unit.stats
		player_unit.position = map_to_local(unit_map_position)
		units[unit_map_position] = player_unit


func random_tile_data() -> OurTileData:
	return tile_data_array.pick_random()


func set_emitter(target_position: Vector2i) -> void:
	var emitter := SignalEmitterTile.new_emitter(RIGHT_WIRE)
	add_child(emitter)
	emitter.position = map_to_local(target_position)
	emitter.signal_created.connect(_on_emitter_signal_created.bind(target_position, emitter.tile_data))


func _on_emitter_signal_created(time_seconds: float, coords: Vector2i, tile_data: OurTileData) -> void:
	SignalManager.Instance.spread_emitter_signal(coords, tile_data, time_seconds)


func set_tile(tile: Tile, target_position: Vector2i) -> void:
	if !board.try_set_tile(tile.get_tile_data(), target_position):
		print_debug("tile occupied!")
		return
	add_child(tile, true)
	tile.position = map_to_local(target_position)
	tile.left_clicked.connect(tile_swapper.mark_tile.bind(tile, target_position))
	tile.right_clicked.connect(signal_manager.spread_signal.bind(target_position))
	tile.right_clicked.connect(_on_tile_right_clicked.bind(target_position))
	tile_dict[target_position] = tile


func _on_signal_created(tile_position: Vector2i, tile_signal: TileSignal) -> void:
	var test := TestSignalShower.from_signal(tile_signal)
	add_child(test)
	test.position = map_to_local(tile_position)
	tile_dict[tile_position].set_signal(true)


# This should be a unit manager :v TODO
func _on_tile_right_clicked(tile_position: Vector2i) -> void:
	if !board.has_unit_at(tile_position):
		return
	
	var attack_strength := SignalManager.Instance.get_signal_strength(tile_position)
	
	if is_zero_approx(attack_strength):
		return
	
	units[tile_position].attack(attack_strength)
