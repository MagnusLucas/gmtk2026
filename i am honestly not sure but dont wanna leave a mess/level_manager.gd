class_name LevelManager
extends Node

@export var boss: Boss

@onready var level_timer: Timer = $LevelTimer

func _ready() -> void:
	var time_to_beat_level: float = boss.stats.time_countdown
	level_timer.start(time_to_beat_level)
	level_timer.timeout.connect(_on_countdown_timeout, CONNECT_ONE_SHOT)


func _on_countdown_timeout() -> void:
	get_tree().paused = true
	$LosePopup.visible = true


func win():
	get_tree().paused = true
	$WinPopup.visible = true
