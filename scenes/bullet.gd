class_name Bullet
extends Area2D

const BULLET = preload("res://scenes/bullet.tscn")

var target: Node2D
var damage: float
var speed: float

var bullet_data: BulletResource

@onready var sprite_2d: Sprite2D = $Sprite2D


static func new_from_resource(bullet_resource: BulletResource, 
		distance_to_travel: float,
		damage_modifier: float,
		target_enemy: Node2D) -> Bullet:
	var instance: Bullet = BULLET.instantiate()
	instance.set_resource(bullet_resource)
	instance._calculate_speed(distance_to_travel)
	instance.damage = bullet_resource.damage * damage_modifier
	instance.target = target_enemy
	return instance


func _process(delta: float) -> void:
	if !target:
		return
	var direction := (target.global_position - global_position).normalized()
	global_position += direction * speed * delta


func set_resource(bullet_resource: BulletResource) -> void:
	if !bullet_resource:
		printerr("setting bullet as null! aborting!")
		return
	bullet_data = bullet_resource
	if is_node_ready():
		_update_visuals()
	else:
		ready.connect(_update_visuals, CONNECT_ONE_SHOT)


func _calculate_speed(distance_to_travel: float) -> void:
	speed = bullet_data.get_speed(distance_to_travel)


func _update_visuals() -> void:
	sprite_2d.texture = bullet_data.texture


func _on_area_entered(area: Area2D) -> void:
	if area is Boss:
		(area as Boss).take_damage(damage)
		queue_free()
