class_name TestSignalShower
extends Sprite2D

const TEST_SIGNAL_SHOWER = preload("uid://njn23n5efma6")

var tile_signal: TileSignal

static func from_signal(a_tile_signal: TileSignal) -> TestSignalShower:
	var instance: TestSignalShower = TEST_SIGNAL_SHOWER.instantiate()
	instance.tile_signal = a_tile_signal
	instance.tile_signal.died.connect(instance._on_signal_died)
	return instance


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#tile_signal = TileSignal.new(0 as OurTileData.Side, .5, 2.0)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !tile_signal:
		scale *= 0
		return
	scale = Vector2.ONE * tile_signal.calculate_strength()


func _on_signal_died() -> void:
	get_parent().remove_child(self)
	queue_free()
