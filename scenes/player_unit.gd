@tool
class_name PlayerUnitSprite
extends Sprite2D

@export var bullet_spawn_point: Node2D
@export var stats: UnitAttributes : set = _set_stats


func _ready() -> void:
	if bullet_spawn_point:
		stats.bullet_spawn_point = bullet_spawn_point.global_position


func _set_stats(value: UnitAttributes) -> void:
	stats = value
	texture = stats.texture
	if bullet_spawn_point:
		stats.bullet_spawn_point = bullet_spawn_point.global_position
