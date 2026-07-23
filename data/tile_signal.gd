class_name TileSignal
extends RefCounted

signal died

static var max_inaccuracy = 0.5

var source: OurTileData.Side

var wait_time: int
var strength: float

var birth_time: int


func _init(source_side: OurTileData.Side, signal_strength: float,
		perfect_wait_time: int) -> void:
	strength = signal_strength
	source = source_side
	wait_time = perfect_wait_time
	birth_time = Time.get_ticks_msec()


func time_to_live() -> int:
	return round(wait_time * (1 + max_inaccuracy))


func is_valid() -> bool:
	var signal_death_time: int = birth_time + time_to_live()
	if Time.get_ticks_msec() >= signal_death_time:
		return false
	return true


func check_validity() -> void:
	if is_valid():
		return
	died.emit()


# y = ax + b
func calculate_strength() -> float:
	if !is_valid(): return 0
	
	var time_since_birth := Time.get_ticks_msec() - birth_time
	
	var x: int = abs(time_since_birth - wait_time) # peak at perfect wait time
	var b: float = 1.
	var a: float = - 1. / wait_time * max_inaccuracy
	
	var accuracy: float = a * x + b
	
	# We might want to wrap x with cos(), for more pleasent experience
	#var accuracy = a * cos(x) + b
	
	return strength * accuracy
