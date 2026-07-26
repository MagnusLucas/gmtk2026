class_name SignalManager
extends Node2D

const REVERSE_DIRECTION: Dictionary[OurTileData.Side, OurTileData.Side] = {
	OurTileData.Side.RIGHT : OurTileData.Side.LEFT,
	OurTileData.Side.LEFT : OurTileData.Side.RIGHT,
	OurTileData.Side.BOTTOM : OurTileData.Side.TOP,
	OurTileData.Side.TOP : OurTileData.Side.BOTTOM
}

signal signal_created(tile_position: Vector2i, tile_signal: TileSignal)

static var Instance: SignalManager

@export var board: Board

var active_signals: Dictionary[Vector2i, TileSignal]


func _ready() -> void:
	if Instance:
		for connection: Dictionary[String, Variant] in Instance.signal_created.get_connections():
			Instance.signal_created.disconnect(connection["callable"])
	Instance = self


func _process(_delta: float) -> void:
	for active_signal: TileSignal in active_signals.values():
		active_signal.check_validity()


func create_signal(signal_position: Vector2i, source :OurTileData.Side,
			strength: float, perfect_time_seconds: float) -> TileSignal:
	
	var tile_signal := TileSignal.new(
		source,
		strength,
		perfect_time_seconds)
	
	active_signals[signal_position] = tile_signal
	tile_signal.died.connect(
		func(): active_signals.erase(signal_position)
		,CONNECT_ONE_SHOT)
	
	signal_created.emit(signal_position, tile_signal)
	return tile_signal


func get_signal_strength(coordinates: Vector2i) -> float:
	if !active_signals.has(coordinates):
		return 0
	return active_signals[coordinates].calculate_strength()


func spread_emitter_signal(emitter_position: Vector2i, emitter_data: OurTileData,
		perfect_time: float) -> void:
	var new_signal_strength := 1.0
	
	for side: OurTileData.Side in emitter_data.connections.keys():
		var neighbour_position = emitter_position + OurTileData.SIDE_TO_VECTOR[side]
		
		if !board.set_tiles.has(neighbour_position):
			# No tile set there
			continue
		
		var neighbour := board.set_tiles[neighbour_position]
		
		if !neighbour.connections.has(REVERSE_DIRECTION[side]):
			# Tiles are not connected
			continue
		
		if active_signals.has(neighbour_position):
			# Remove the other signal maybe?
			print("has signal! omitting")
			continue
		
		# This doesn't account for players being unable (skill issued)
		# to click two tiles at the same time! TODO TODO
		
		# Also for world boundries. Although this doesn't matter much i suppose
		active_signals[neighbour_position] = create_signal(
			neighbour_position, REVERSE_DIRECTION[side],
			new_signal_strength, perfect_time)


func spread_signal(signal_position: Vector2i) -> void:
	if !active_signals.has(signal_position):
		return
	
	var signal_to_spread: TileSignal = active_signals[signal_position]
	
	var new_signal_strength := signal_to_spread.calculate_strength()
	if is_zero_approx(new_signal_strength):
		active_signals.erase(signal_position)
		return
	
	for side: OurTileData.Side in board.set_tiles[signal_position].connections.keys():
		if side == signal_to_spread.source:
			continue
		
		var neighbour_position = signal_position + OurTileData.SIDE_TO_VECTOR[side]
		
		if !board.set_tiles.has(neighbour_position):
			# No tile set there
			continue
		
		var neighbour := board.set_tiles[neighbour_position]
		
		if !neighbour.connections.has(REVERSE_DIRECTION[side]):
			# Tiles are not connected
			continue
		
		if active_signals.has(neighbour_position):
			# Remove the other signal maybe?
			print("has signal! omitting")
			continue
		
		# This doesn't account for players being unable (skill issued)
		# to click two tiles at the same time! TODO TODO
		
		# Also for world boundries. Although this doesn't matter much i suppose
		active_signals[neighbour_position] = create_signal(
			neighbour_position, REVERSE_DIRECTION[side],
			new_signal_strength, signal_to_spread.perfect_seconds())
