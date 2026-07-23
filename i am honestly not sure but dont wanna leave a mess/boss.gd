extends Node2D

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
	$"../AnimationPlayer".play("idle_bounce")
	health = stats.health



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Bullet) -> void:
	health -= body.damage
	body.queue_free()
	if health <=0:
		queue_free()
		if get_tree().get_node_count_in_group("enemy") == 1:
			get_owner().win()
