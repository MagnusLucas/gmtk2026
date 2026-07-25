class_name PlayerUnit
extends Node2D

const PACKED_BULLET = preload("res://scenes/bullet.tscn")

@export var stats: UnitAttributes

var target: Node2D
var bullets_to_spawn := 0
var strength_modifier := 0.0
var active_attack: AttackResource

@onready var bullet_spawn_interval_timer: Timer = $BulletSpawnIntervalTimer


func _ready() -> void:
	$AnimatedSprite2D.sprite_frames = stats.animated_texture_frames
	bullet_spawn_interval_timer.timeout.connect(_on_timer_timeout)


# This setup will spawn bullets from new active attack if any are remaining,
# but I don't think it'll be a problem in this project
func attack(attack_strength_modifier: float = 1):
	strength_modifier = attack_strength_modifier
	
	active_attack = stats.attacks[0]
	#weź grupe enemy i pierwszgeo z nich aka bossa l8
	target = get_tree().get_nodes_in_group("enemy")[0]
	
	bullets_to_spawn += active_attack.bullet_amount
	bullet_spawn_interval_timer.start(active_attack.bullet_interval)


func _on_timer_timeout() -> void:
	BulletManager.Instance.spawn_bullet(active_attack.bullet, global_position,
			target, strength_modifier)
	bullets_to_spawn -= 1
	if bullets_to_spawn == 0:
		bullet_spawn_interval_timer.stop()
