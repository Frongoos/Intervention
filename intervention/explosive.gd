extends CharacterBody2D
class_name explosive
@export var health=30
signal explosion
var is_character=false
@export var on_top_damage =5000
var exploded= false
var explosion_player_scene = preload("res://barrel_explosion_player.tscn")
enum damage_types{
	melee_type,
	bullet,
	fire,
	explosion
}
func _ready():
	$Flash.enabled=false
	$hurtbox.monitoring=false
	$hurtbox.connect("area_entered",deal_damage)
func take_damage(damage, damage_type):
	health-=damage
	if health<=0 and not exploded:
		explosion.emit(global_position)
		exploded=true
		#detonate sequence
		$HurtboxEnabledTimer.start(0.0)
		$AnimationPlayer.play("explode")
		$AnimatedSprite2D.play("explode")
		$HurtboxEnabledTimer.connect("timeout",queue_free)
		$hurtbox.monitoring=true
		$Flash.enabled=true
		var explosion_player = explosion_player_scene.instantiate()
		add_sibling(explosion_player)
		explosion_player.play(0.0)
func deal_damage(hit: hitbox):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position , hit.global_position,1, [self])
	var result = space_state.intersect_ray(query)
	if not result:
		hit.owner.take_damage(  (on_top_damage)/( hit.owner.global_position-global_position).length(), damage_types.explosion  )
