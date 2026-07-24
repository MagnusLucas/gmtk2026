class_name SignalManager
extends Node2D

const REVERSE_DIRECTION: Dictionary[OurTileData.Side, OurTileData.Side] = {
	OurTileData.Side.RIGHT : OurTileData.Side.LEFT,
	OurTileData.Side.LEFT : OurTileData.Side.RIGHT,
	OurTileData.Side.BOTTOM : OurTileData.Side.TOP,
	OurTileData.Side.TOP : OurTileData.Side.BOTTOM
}

signal created_signal(tile_position: Vector2i, tile_signal: TileSignal)

@export var board: Board

var active_signals: Dictionary[Vector2i, TileSignal]


func _process(_delta: float) -> void:
	for active_signal: TileSignal in active_signals.values():
		active_signal.check_validity()


func create_signal(signal_position: Vector2i) -> void:
	active_signals[signal_position] = TileSignal.new(
		3 as OurTileData.Side,
		1,
		3.0)
	#active_signals[signal_position].died.connect(print.bind(
		#str(active_signals[signal_position]) + " died!"
		#), CONNECT_ONE_SHOT)
	created_signal.emit(signal_position, active_signals[signal_position])


func spread_signal(signal_position: Vector2i) -> void:
	if !active_signals.has(signal_position):
		return
	var signal_to_spread: TileSignal = active_signals[signal_position]
	print("\nspreading:\n" + str(signal_to_spread))
	var new_signal_strength := signal_to_spread.calculate_strength()
	if is_zero_approx(new_signal_strength):
		active_signals.erase(signal_position)
		print("erased!-")
		return
	
	for side: OurTileData.Side in OurTileData.Side.values():
		#print(OurTileData.Side.find_key(side))
		if side == signal_to_spread.source:
			print(OurTileData.Side.find_key(side) + " is source")
			continue
		print("spreading " + OurTileData.Side.find_key(side))
		var neighbour_position = signal_position + OurTileData.SIDE_TO_VECTOR[side]
		if active_signals.has(neighbour_position):
			# Remove the other signal maybe?
			print("has signal! omitting")
			continue
		
		# This doesn't account for players being unable (skill issued)
		# to click two tiles at the same time! TODO TODO
		
		# Also for world boundries. Although this doesn't matter much i suppose
		active_signals[neighbour_position] = TileSignal.new(
			REVERSE_DIRECTION[side],
			new_signal_strength,
			float(signal_to_spread.wait_time) / 1000
			)
		active_signals[neighbour_position].died.connect(
			func():
				active_signals.erase(neighbour_position)
		)
		#active_signals[neighbour_position].died.connect(print.bind(
			#str(active_signals[neighbour_position]) + " died!"
			#), CONNECT_ONE_SHOT)
		created_signal.emit(neighbour_position, active_signals[neighbour_position])
