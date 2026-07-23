extends Node2D

@export var stats: UnitAttributes
var packed_bullet = preload("res://scenes/bullet.tscn")
var target
var attack_queued= []
var cooldown

func _ready() -> void:
	$AnimatedSprite2D.sprite_frames = stats.animated_texture_frames
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		attack(0)
		
	if attack_queued != [] and $Timer.is_stopped() == true:
		add_child(attack_queued[0][0])
		$Timer.wait_time = attack_queued[0][1]
		$Timer.start()
		attack_queued.pop_front()

func attack(attack_index):
	var active_attack = stats.attacks[attack_index]
	#weź grupe enemy i pierwszgeo z nich aka bossa l8
	target = get_tree().get_nodes_in_group("enemy")[0]
	
	
	
	for i in active_attack.bullet_amount:
		var  bullet = packed_bullet.instantiate()
		bullet.get_node("Sprite2D").texture = active_attack.bullet_texture
		bullet.linear_velocity = Vector2(target.position-position).normalized() * active_attack.bullet_speed
		bullet.name = 'bullet_'+bullet.name
		bullet.damage = active_attack.dmg_per_bullet
		attack_queued.append([bullet,active_attack.bullet_interval])
