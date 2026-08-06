class_name SignalEmitterTile
extends Area2D

const SIGNAL_EMITTER_TILE = preload("uid://cs0cmi3cu3fio")

signal signal_created(beat_time: float)

@export var tile_data: OurTileData : set = set_tile_data

var animating := false
var is_marked := false
var time_since_last_clicked := 0.0

@onready var line_2d: Line2D = $Line2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var timer: Timer = $Timer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


static func new_emitter(our_tile_data: OurTileData) -> SignalEmitterTile:
	var tile: SignalEmitterTile = SIGNAL_EMITTER_TILE.instantiate()
	tile.set_tile_data(our_tile_data)
	return tile


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_event.connect(_on_input_event)
	var signal_texture := SignalTexture.new()
	signal_texture.signal_colour = Color("a1e55aff")
	sprite_2d.texture = signal_texture
	signal_texture.animation_finished.connect(
		func(): 
			animating = false
	)
	signal_texture._hide_signal()


func _process(delta: float) -> void:
	time_since_last_clicked += delta
	if animating:
		sprite_2d.texture._animate_outward(delta)
	if is_marked:
		texture_progress_bar.value = timer.time_left / timer.wait_time


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event := event as InputEventMouseButton
		if !mouse_button_event.pressed:
			return
		if mouse_button_event.button_index == MOUSE_BUTTON_RIGHT:
			_on_clicked()
			return


func set_marked(marked: bool) -> void:
	is_marked = marked
	line_2d.visible = marked
	texture_progress_bar.visible = marked
	if marked:
		timer.start()


func set_tile_data(our_tile_data: OurTileData) -> void:
	tile_data = our_tile_data
	if is_node_ready():
		_update_visuals()
	else:
		ready.connect(_update_visuals, CONNECT_ONE_SHOT)


func _on_clicked() -> void:
	if is_marked:
		set_marked(false)
		animating = true
		signal_created.emit(time_since_last_clicked)
	else:
		audio_stream_player.stream = Beat.next_audio()
		audio_stream_player.play()
		set_marked(true)
		(sprite_2d.texture as SignalTexture)._show_signal()
	time_since_last_clicked = 0


func _update_visuals() -> void:
	var shader_material: ShaderMaterial = sprite_2d.material as ShaderMaterial
	for enum_value: OurTileData.Side in OurTileData.Side.values():
		var shader_parameter := OurTileData.SIDE_STRING[enum_value]
		var parameter_value := tile_data.connections.has(enum_value) 
		shader_material.set_shader_parameter(shader_parameter, parameter_value)


func get_tile_data() -> OurTileData:
	return tile_data
