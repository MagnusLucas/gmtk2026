extends Sprite2D


var tile_signal: TileSignal


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tile_signal = TileSignal.new(0, 1, 2.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	scale = Vector2.ONE * tile_signal.calculate_strength()
