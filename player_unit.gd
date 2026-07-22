extends Node2D

@export var stats: UnitAttributes
var target

func _ready() -> void:
	$AnimatedSprite2D.sprite_frames = stats.animated_texture_frames

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		attack()

func attack():
	#weź grupe enemy i pierwszgeo z nich aka bossa l8
	target = get_tree().get_nodes_in_group("enemy")[0]

	target.health -= stats.attacks[0].damage
	if target.health <=0:
		target.queue_free()
		if get_tree().get_node_count_in_group("enemy") == 1:
			get_owner().win()
