extends Sprite2D

var gradient: Gradient
const SIZE := 0.1
const TIME_MULTIPLIER := 0.001

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gradient = texture.gradient


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var time := Time.get_ticks_msec()
	var max_range := 1.0 - SIZE - 0.01
	var sin_multiplier = max_range / 2 # to not go out of [0.05, 0.95] range
	var pos_1: float = 0.5 - SIZE/2 + sin(time * TIME_MULTIPLIER) * sin_multiplier
	var pos_2: float = 0.5 + SIZE/2 + sin(time * TIME_MULTIPLIER) * sin_multiplier
	
	gradient.set_offset(2, pos_2)
	gradient.set_offset(1, pos_1)
