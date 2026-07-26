@tool
class_name PlayerUnitSprite
extends Sprite2D


@export var stats: UnitAttributes : set = _set_stats


func _set_stats(value: UnitAttributes) -> void:
	stats = value
	texture = stats.texture
