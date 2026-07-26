class_name Beat
extends RefCounted

static var audio_streams: Array[AudioStream] = [
	preload("res://assets/beat1.ogg"),
	preload("res://assets/beat2.ogg"),
	preload("res://assets/beat4.ogg"),
]

static var next_beat := 0

signal died

var audio_idx: int
var interval: float

var signals: Array[TileSignal]


static func next_audio() -> AudioStream:
	return audio_streams[next_beat]


func _init(time_between_sounds: float) -> void:
	interval = time_between_sounds
	audio_idx = next_beat
	next_beat = (next_beat + 1) % audio_streams.size()


func add_signal(tile_signal: TileSignal) -> void:
	signals.append(tile_signal)


func remove_signal(tile_signal: TileSignal) -> void:
	signals.erase(tile_signal)
	if signals.is_empty():
		died.emit()


func get_audio() -> AudioStream:
	return audio_streams[audio_idx]
