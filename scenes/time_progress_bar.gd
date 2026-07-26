class_name TimeProgressBar
extends ProgressBar

@export var timer: Timer

@onready var label: Label = $Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	label.text = str(int(timer.time_left)) + " s"
	max_value = timer.wait_time
	value = timer.time_left
