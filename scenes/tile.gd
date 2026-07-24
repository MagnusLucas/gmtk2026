class_name Tile
extends Area2D

signal left_clicked
signal right_clicked

const TILE = preload("uid://dxifl4lqvcmsr")
@onready var line_2d: Line2D = $Line2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var tile_data: OurTileData
var animating := false
var receiving_signal := false


static func new_tile(our_tile_data: OurTileData) -> Tile:
	var tile: Tile = TILE.instantiate()
	tile.set_tile_data(our_tile_data)
	return tile


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_event.connect(_on_input_event)
	var signal_texture := SignalTexture.new()
	sprite_2d.texture = signal_texture
	signal_texture.animation_finished.connect(
		func(): 
			receiving_signal = !receiving_signal
			animating = false
	)


func _process(delta: float) -> void:
	if animating:
		if receiving_signal:
			sprite_2d.texture.animate_inward(delta)
		else:
			sprite_2d.texture.animate_outward(delta)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event := event as InputEventMouseButton
		if !mouse_button_event.pressed:
			return
		if mouse_button_event.button_index == MOUSE_BUTTON_LEFT:
			left_clicked.emit()
			return
		if mouse_button_event.button_index == MOUSE_BUTTON_RIGHT:
			right_clicked.emit()
			animating = true


func set_marked(marked: bool) -> void:
	line_2d.visible = marked


func set_tile_data(our_tile_data: OurTileData) -> void:
	tile_data = our_tile_data
	if is_node_ready():
		_update_visuals()
	else:
		ready.connect(_update_visuals, CONNECT_ONE_SHOT)


func _update_visuals() -> void:
	var shader_material: ShaderMaterial = sprite_2d.material as ShaderMaterial
	for enum_value: OurTileData.Side in OurTileData.Side.values():
		var shader_parameter := OurTileData.SIDE_STRING[enum_value]
		var parameter_value := tile_data.connections.has(enum_value) 
		shader_material.set_shader_parameter(shader_parameter, parameter_value)


func get_tile_data() -> OurTileData:
	return tile_data
