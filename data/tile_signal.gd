class_name TileSignal
extends RefCounted

signal died

static var max_inaccuracy = 0.5

var source: OurTileData.Side

var wait_time: float
var strength: float

var time_since_birth: float


func _init(source_side: OurTileData.Side, signal_strength: float,
		perfect_wait_time: float) -> void:
	strength = signal_strength
	source = source_side
	wait_time = perfect_wait_time


func calculate_strength(time: float) -> float:
	var difference: float = abs(wait_time - time)
	var adjusted_difference: float = difference * 1./max_inaccuracy
	if adjusted_difference >= wait_time:
		return 0
	var accuracy = (wait_time - adjusted_difference)/wait_time
	
	return strength * accuracy
