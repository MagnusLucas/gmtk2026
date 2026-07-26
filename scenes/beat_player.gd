class_name BeatPlayer
extends AudioStreamPlayer

const BEAT_PLAYER = preload("res://scenes/beat_player.tscn")

var beat: Beat

@onready var timer: Timer = $Timer

static func custom_new(a_beat: Beat) -> BeatPlayer:
	var instance: BeatPlayer = BEAT_PLAYER.instantiate()
	instance.stream = a_beat.get_audio()
	instance.beat = a_beat
	instance.ready.connect(instance.set_interval.bind(a_beat.interval), CONNECT_ONE_SHOT)
	instance.beat.died.connect(instance.queue_free, CONNECT_ONE_SHOT)
	return instance


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(play)


func set_interval(time: float) -> void:
	timer.start(time)
