extends CharacterBody2D
@export var bloodsplatter = preload("res://Scenes/BloodSplatter.tscn")
enum damage_types{
	melee,
	bullet,
	fire,
	explosion
}
var damage: int
var bullet_speed: int
var lifetime: int
var life: float
var bullet_refects: int
var direction: Vector2
var collision: KinematicCollision2D
var reflects_left: int

var target_team: teams
var owner_team: teams
#Team related stuff
var has_reflected = false	
var deviation = 0.3
var dead_time = 0 #how long tthe bullet has been dead for
var look_at_vector: Vector2
var temp_vector: Vector2
enum teams{
	player_team=2,
	enemy_team=4
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
func _physics_process(delta: float) -> void:
	if life>=lifetime:
		queue_free()
	life+=delta
	collision=move_and_collide(velocity*delta)
	if collision: #If a collision is detected
		if reflects_left!=0:
			damage*=0.25
			velocity=velocity.bounce( (collision.get_normal()+Vector2(randf_range(-deviation,deviation),randf_range(-deviation,deviation))).normalized()      )
			reflects_left-=1
			look_at(global_position+velocity)
			if not has_reflected:
				$hurtbox.collision_mask=(owner_team+target_team)
				has_reflected=true
		else:
			queue_free()

func setup(damageP: int, bullet_speedP: int , lifetimeP: int, reflectsP: int, rotationP: float, positionP: Vector2, team: teams, target: teams):
	global_position=positionP
	top_level=true
	damage=damageP
	bullet_speed=bullet_speedP
	look_at_vector = Vector2( cos(rotationP),sin (rotationP))
	rotation=rotationP
	velocity=bullet_speed*look_at_vector
	lifetime=lifetimeP
	bullet_refects=reflectsP
	reflects_left=bullet_refects
	owner_team = team
	target_team= target
	$hurtbox.collision_mask=target
	$AnimatedSprite2D.play("trail")
func _on_hurtbox_area_entered(hit: hitbox):
	hit.owner.take_damage(damage, damage_types.bullet )
	if hit.owner.is_character:
		blood_splatter_raycast()
	queue_free()
func blood_splatter_raycast():
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, global_position+velocity*0.13,1)
		var result = space_state.intersect_ray(query)
		if result: # hit a wall
			if result.collider is door:
				pass
			else:
				var new_blood = bloodsplatter.instantiate()
				new_blood.animation="default"
				new_blood.z_index=-3
				new_blood.frame = randi_range(5,9) 

				match result.normal.x:
					0.0:
						match result.normal.y:
							-1.0:
								new_blood.rotation=PI
							1.0:
								pass
					1.0:
						new_blood.rotation=-1.57
					-1.0:
						new_blood.rotation=1.57

				get_parent().wall_layer.add_child(new_blood)
				new_blood.global_position=result.position

		else:
			var new_blood = bloodsplatter.instantiate()
			new_blood.animation="default"
			new_blood.frame = randi_range(0,4) 

			new_blood.global_position=global_position+velocity*randf_range(0.05,0.1)
			new_blood.look_at(global_position+velocity)
			new_blood.z_index=-3
			new_blood.rotate(1.57)
			get_parent().wall_layer.add_child(new_blood)
