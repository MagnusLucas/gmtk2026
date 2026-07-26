class_name Boss
extends Area2D

@export var stats: BossAttributes
var health
#przeciwnik chce mieć
# - życie
# - set of attacks that will change postitions of players????
# - totalny countdown 
@onready var progress_bar: ProgressBar = $ProgressBar
var restarted := true 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.sprite_frames = stats.animated_texture_frames
	$AnimationPlayer.play("idle_bounce")
	health = stats.health
	_update_visuals()

func _process(_delta: float) -> void:
	#print($"../LevelTimer".time_left,' ',int($"../LevelTimer".wait_time *2/3))
	if (is_equal_approx(int($"../LevelTimer".time_left), int($"../LevelTimer".wait_time *2/3))) || is_equal_approx(int($"../LevelTimer".time_left),int($"../LevelTimer".wait_time *1/3)):
		if restarted:
			stats.attacks[0].attack(get_tree().get_nodes_in_group('player_units'))
			restarted = false
	else:
		restarted = true


#func _input(event: InputEvent) -> void:
	#if event.is_action("ui_down"):
		#stats.attacks[0].attack(get_tree().get_nodes_in_group('player_units'))

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
