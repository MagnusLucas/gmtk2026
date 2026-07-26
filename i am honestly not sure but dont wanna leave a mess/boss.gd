class_name Boss
extends Area2D

@export var stats: BossAttributes
var health
#przeciwnik chce mieć
# - życie
# - set of attacks that will change postitions of players????
# - totalny countdown 
@onready var progress_bar: ProgressBar = $ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.sprite_frames = stats.animated_texture_frames
	$AnimationPlayer.play("idle_bounce")
	health = stats.health
	_update_visuals()


func take_damage(amount: float) -> void:
	health -= amount
	_update_visuals()
	if health <= 0:
		queue_free()
		if get_tree().get_node_count_in_group("enemy") == 1:
			get_owner().win()


func _update_visuals() -> void:
	progress_bar.max_value = stats.health
	progress_bar.value = health
