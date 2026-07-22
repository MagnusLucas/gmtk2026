class_name Tile
extends Area2D

signal left_clicked
signal right_clicked

const TILE = preload("uid://dxifl4lqvcmsr")
@onready var line_2d: Line2D = $Line2D
@onready var sprite_2d: Sprite2D = $Sprite2D


var tile_data: OurTileData


static func new_tile(our_tile_data: OurTileData) -> Tile:
	var tile: Tile = TILE.instantiate()
	tile.set_tile_data(our_tile_data)
	return tile


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_event.connect(_on_input_event)


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


func set_marked(marked: bool) -> void:
	line_2d.visible = marked


func set_tile_data(our_tile_data: OurTileData) -> void:
	if is_node_ready():
		tile_data = our_tile_data
		var atlas_coords_texture := sprite_2d.texture as AtlasCoordsTexture
		atlas_coords_texture.set_coordinates(tile_data.atlas_position)
	else:
		ready.connect(set_tile_data.bind(our_tile_data), CONNECT_ONE_SHOT)


func get_tile_data() -> OurTileData:
	return tile_data
