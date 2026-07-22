@tool
class_name AtlasCoordsTexture
extends AtlasTexture

const ATLAS_TEXTURE = preload("uid://ciuxyaoktugh5")

@export var region_size := Vector2(64, 64)
@export var region_offset := Vector2(0, 0)

@export var coordinates: Vector2i: set = set_coordinates


func _init() -> void:
	atlas = ATLAS_TEXTURE
	_update_region()


func _update_region() -> void:
	var position := (region_size + region_offset) * Vector2(coordinates)
	region = Rect2(position, region_size)


func set_coordinates(new_coordinates: Vector2i) -> void:
	coordinates = new_coordinates
	_update_region()
