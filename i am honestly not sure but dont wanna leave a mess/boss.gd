class_name Boss
extends Area2D

@export var stats: BossAttributes
var health
#przeciwnik chce mieć
# - życie
# - set of attacks that will change postitions of players????
# - totalny countdown 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.sprite_frames = stats.animated_texture_frames
	%Countdown.wait_time = stats.time_countdown
	%Countdown.start()
	$AnimationPlayer.play("idle_bounce")
	health = stats.health


func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0:
		queue_free()
		if get_tree().get_node_count_in_group("enemy") == 1:
			get_owner().win()
