class_name LevelManager
extends Node

@export var boss: Boss

@onready var level_timer: Timer = $LevelTimer
@onready var pause_loaded = preload("res://scenes/pause.tscn")

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
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_cancel'):
		var pause_scene = pause_loaded.instantiate()
		add_child(pause_scene)
		get_viewport().set_input_as_handled()
