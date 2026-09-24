extends CharacterBody2D
class_name character
enum weapon_types{
	nul=0,
	rifle=1,
	pistol=2,
	melees=3,
	throw=4
}
enum damage_types{
	melee=0,
	bullet=1,
	fire=2,
	explosion=3,
	heal=4
	
}
enum teams{
	player_team=2,
	enemy_team=4
}
enum ammo_types{
	twelve_gauge=0,
	nine_mm=1,
	seven_mm=2,
	five_mm=3
}
var ammo_collection ={
	ammo_types.twelve_gauge:0,
	ammo_types.nine_mm:0,
	ammo_types.seven_mm:0,
	ammo_types.five_mm:0
}
#Character properties
@export var health: int
var acceleration: float
@export var sprint_speed: int
@export var walk_speed: int
#Team properties
@export var team: teams
@export var target: teams
@export var damage_modifier =1.0
var is_character = true
var weapons_dict ={
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	pass
func _physics_process(delta: float) -> void:
	pass

func initialise():
	pass

func take_damage(damage: int,type: damage_types):
	pass
