class_name BulletManager
extends Node2D

static var Instance: BulletManager


func _ready() -> void:
	Instance = self


func spawn_bullet(resource: BulletResource, source_position: Vector2,
		target: Node2D, damage_modifier: float) -> void:
	var bullet := Bullet.new_from_resource(
		resource,
		source_position.distance_to(target.global_position),
		damage_modifier,
		target)
	add_child(bullet)
	bullet.global_position = source_position
