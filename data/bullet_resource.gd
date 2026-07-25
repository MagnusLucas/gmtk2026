class_name BulletResource
extends Resource

@export var texture: Texture
@export var damage: float
@export var fly_time: float
#@export var animation : Animation


func get_speed(distance_to_travel: float) -> float:
	return distance_to_travel / fly_time
