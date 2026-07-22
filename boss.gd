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
	
