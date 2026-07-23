class_name TileSignal
extends RefCounted

signal died

static var max_inaccuracy = 0.5

var source: OurTileData.Side

var wait_time: int
var strength: float

var birth_time: int


func _init(source_side: OurTileData.Side, signal_strength: float,
		perfect_wait_time_seconds: float) -> void:
	strength = signal_strength
	source = source_side
	wait_time = int(perfect_wait_time_seconds * 1000)
	birth_time = Time.get_ticks_msec()
	print(self)


func time_to_live() -> int:
	return round(wait_time * (1 + max_inaccuracy))


func is_valid() -> bool:
	var signal_death_time: int = birth_time + time_to_live()
	if Time.get_ticks_msec() >= signal_death_time:
		return false
	return true


func is_active() -> bool:
	if !is_valid():
		return false
	if Time.get_ticks_msec() < birth_time + wait_time * (1 - max_inaccuracy):
		return false
	
	return true


func check_validity() -> void:
	if is_valid():
		return
	died.emit()


# y = ax + b
func calculate_strength() -> float:
	if !is_active(): return 0
	
	var time_since_birth := Time.get_ticks_msec() - birth_time
	
	var accuracy := calculate_accuracy_cos(time_since_birth)
	
	return strength * accuracy


func calculate_accuracy_abs(time_since_birth: float) -> float:
	var x: float = abs(time_since_birth - wait_time) # peak at perfect wait time
	var b: float = 1.
	var a: float = - 1. / (wait_time * max_inaccuracy)
	
	var accuracy: float = a * x + b
	return accuracy


func calculate_accuracy_cos(time_since_birth: float) -> float:
	var x: float = time_since_birth - wait_time #<-wt * mi, +wt * mi>
	var a: float = (PI/2) / (wait_time * max_inaccuracy)
	
	var accuracy = cos(a * x)
	return accuracy


func _to_string() -> String:
	var result := ""
	
	result += "perfect time: " + str(float(wait_time)/100) + " seconds\n"
	result += "current_time: " + str(float(Time.get_ticks_msec() - birth_time)/ 100)
	result += " seconds\nstrength: " + str(calculate_strength())
	
	return result
