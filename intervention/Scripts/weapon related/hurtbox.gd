extends Area2D
class_name hurtbox
enum targets{
	player=2,
	enemy=4
} 
var target: targets
var damage: int

enum damage_types{
	melee,
	bullet,
	fire,
	explosion
}
var type: damage_types

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	pass
func area_entered(hit: hitbox):
	hit.owner.take_damage(damage, type)
