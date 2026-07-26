class_name PlayerUnit
extends Node2D

const PACKED_BULLET = preload("res://scenes/bullet.tscn")

@export var stats: UnitAttributes

var target: Node2D
var bullets_to_spawn := 0
var strength_modifier := 0.0
var active_attack: AttackResource
var active_combo_modifier:= 1

@onready var bullet_spawn_interval_timer: Timer = $BulletSpawnIntervalTimer


func _ready() -> void:
	$ComboTimer.wait_time = stats.combo_cooldown_time
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
	if !$ComboTimer.is_stopped():
		active_combo_modifier = stats.combo_multiplier
	else:
		active_combo_modifier = 1 
	
	bullet_spawn_interval_timer.start(active_attack.bullet_interval)
	for player_unit in get_tree().get_nodes_in_group('player_units'):
		player_unit.check_combo(stats.combo_index)

func _on_timer_timeout() -> void:
	BulletManager.Instance.spawn_bullet(active_attack.bullet, global_position,
		target, strength_modifier*active_combo_modifier)
	bullets_to_spawn -= 1
	if bullets_to_spawn == 0:
		bullet_spawn_interval_timer.stop()

func check_combo(combo_index_of_unit):
	#print(combo_index_of_unit,' szescsiedemmmm ', stats.combo_index)
	##w rosnącej kolejności powinno być combo
	# please, refrain from questions about -1, its an artefact that has become a friend.
	# accept -1 as a starting point in your future
	if combo_index_of_unit == stats.combo_index-1 || (combo_index_of_unit == -1 && stats.combo_index == 1 ):
		$ComboTimer.start()
	else:
		$ComboTimer.stop()
