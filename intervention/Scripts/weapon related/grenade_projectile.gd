extends CharacterBody2D
class_name grenade
enum damage_types{
	melee_type,
	bullet,
	fire,
	explosion
}
var fuse_time = 5
var t_fuse =0
var speed =400
var max_speed = 150
var collision : KinematicCollision2D
var speed_loss = 0.99
var on_top_damage=50000
var active_time: Timer
var angular_momentum = 1
var detonated =false
var is_character=false
var player_explosion_func: Callable
var explosion_noise_scene = preload("res://Scenes/grenade_explosion_noise_player.tscn")
func _ready() -> void:
	active_time=$HurtboxActiveTime
	$hurtbox.connect("area_entered",deal_damage)
	$hurtbox.monitoring=false
	$AnimatedSprite2D.visible=true
func setup(Protation :float, start_point: Vector2, pt_fuse: float):
	global_position=start_point
	top_level=true
	velocity = Vector2(cos(Protation),sin(Protation))*speed
	t_fuse = pt_fuse
	$AnimatedSprite2D.visible=true
	angular_momentum=speed/1000
func _physics_process(delta: float) -> void:

	collision=move_and_collide(velocity*delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())*0.5
	velocity*=0.95
	t_fuse+=delta
	if t_fuse>=fuse_time and not detonated:
		detonate()
	rotate(angular_momentum)
	angular_momentum*=0.9
func detonate():
	var explosion_player = explosion_noise_scene.instantiate()
	add_sibling(explosion_player)
	explosion_player.play(0.0)
	$AnimationPlayer.play("detonate")
	get_parent().explosion_nearby(global_position)
	detonated=true
	$AnimatedSprite2D.visible=false
	$hurtbox.monitoring=true
	$Flash.enabled=true
	active_time.start(0.0)
	$HurtboxActiveTime.connect("timeout",end)
func deal_damage(hit: hitbox):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position , hit.global_position,1, [self])
	var result = space_state.intersect_ray(query)
	if not result:
		hit.owner.take_damage(  (on_top_damage)/( hit.owner.global_position-global_position).length(), damage_types.explosion  )
	
func end():
	queue_free()
func take_damage(damage, damage_type):
	detonate()
