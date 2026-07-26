extends Resource
class_name UnitAttributes

@export var name : String
@export var attacks : Array[AttackResource]
@export var animated_texture_frames : SpriteFrames
@export var texture: Texture

@export_category('combo')
@export var combo_cooldown_time := 1 
@export var combo_index := 1
@export var combo_multiplier := 2


var bullet_spawn_point: Vector2
