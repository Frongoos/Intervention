extends Node2D
class_name weapon

enum damage_types{
	melee_type,
	bullet,
	fire,
	explosion
}
enum types{
	nul=0,
	rifle=1,
	pistol=2,
	melees=3,
	throw=4
}
@export var damage: int
var cursor: Node2D
signal reload_complete
signal attack_fired
var sprite: AnimatedSprite2D
var damage_type: damage_types
@export var type: types
@export var equip_sound: AudioStream
@export var use_sound: AudioStream
@export var attack_delay: float
var t_since_last_attack: float
@export var can_hold_attack: bool
var move_speed_debuff_active = false
var used_by_player = false
var bullshit_edge_case = false # thanks a lot homeless man
var wall_layer: TileMapLayer
func _ready():
	pass
func wield():
	pass
func holster():
	pass
func on_attack(rotationP: float):
	pass

func physics_process(delta: float) ->void:
	pass
func reload():
	pass
func on_released(rotationP: float):
	pass
