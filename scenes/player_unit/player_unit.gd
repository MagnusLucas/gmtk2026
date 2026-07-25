class_name PlayerUnit
extends Node2D

@export var stats: UnitAttributes
const PACKED_BULLET = preload("res://scenes/bullet.tscn")
var target: Node

## [0] is bullet instance, [1] is timer wait time
var attack_queued: Array[Array] = []
#var cooldown # unused, so I commented it out


func _ready() -> void:
	$AnimatedSprite2D.sprite_frames = stats.animated_texture_frames
	

func _process(delta: float) -> void:
	if attack_queued != [] and $Timer.is_stopped() == true:
		add_child(attack_queued[0][0])
		$Timer.wait_time = attack_queued[0][1]
		$Timer.start()
		attack_queued.pop_front()


## Attack index as int is not usable in any reasonable way whatsoever,
## it really should be done differently :<
func attack(attack_index: int, attack_strength_modifier: float = 1):
	var active_attack: AttackResource = stats.attacks[attack_index]
	#weź grupe enemy i pierwszgeo z nich aka bossa l8
	target = get_tree().get_nodes_in_group("enemy")[0]
	
	for i in active_attack.bullet_amount:
		var  bullet: Bullet = PACKED_BULLET.instantiate()
		bullet.get_node("Sprite2D").texture = active_attack.bullet_texture
		bullet.linear_velocity = Vector2(target.position-position).normalized() * active_attack.bullet_speed
		bullet.name = 'bullet_'+bullet.name
		bullet.damage = active_attack.dmg_per_bullet * attack_strength_modifier
		attack_queued.append([bullet,active_attack.bullet_interval])
