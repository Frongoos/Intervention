extends weapon
class_name melee
var hurtbox_enabled  = false
@export var attack_duration: float
var bloodsplatter = preload("res://Scenes/BloodSplatter.tscn")
var ranged = false
var t_hurtbox_enabled = 0
var ammo=1
var reloading =false
var melee_hurtbox: Area2D
func _ready():
	melee_hurtbox=$Area2D
	melee_hurtbox.connect("area_entered",hit)
	owner=get_parent().get_parent()
	wall_layer = get_node("../../../WallLayer")
	type=types.melees
	sprite=$AnimatedSprite2D
	sprite.visible=false
func physics_process(delta: float) -> void:
	t_since_last_attack+=delta
	if hurtbox_enabled:
		t_hurtbox_enabled+=delta
		

		
		if t_hurtbox_enabled>=attack_duration:
			t_hurtbox_enabled=0
			hurtbox_enabled=false
			melee_hurtbox.monitoring=false

func wield():
	$AnimatedSprite2D.visible=true
func holster():
	$AnimatedSprite2D.visible=false
func on_attack(rotationP: float):
	if t_since_last_attack>=attack_delay:
		t_since_last_attack=0
		melee_hurtbox.collision_mask = owner.target
		owner.torso_sprite.play("melee_swing")
		$AnimatedSprite2D.play("melee_swing")
		melee_hurtbox.monitoring=true
		hurtbox_enabled=true
		$SwingPlayer.play(0.0)
func blood_splatter(hit) -> void:
		var space_state = get_world_2d().direct_space_state
		var perp_vector=Vector2(cos(rotation+1.57),-sin(rotation+1.57))
		var query = PhysicsRayQueryParameters2D.create(hit.global_position, 
		hit.global_position+perp_vector*50,1)
		var result = space_state.intersect_ray(query)
		if result: # hit a wall
			if result.collider is door:
				pass
			else:
				var new_blood = bloodsplatter.instantiate()
				
				#rotatio
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
		
				wall_layer.add_child(new_blood)
				new_blood.global_position=result.position

				new_blood.play("knifewall")
				new_blood.z_index=-3

		else:
			var new_blood = bloodsplatter.instantiate()
			new_blood.global_position=hit.global_position+(perp_vector*28)
			new_blood.look_at(hit.global_position+perp_vector)
			new_blood.play("knifefloor")
			new_blood.rotate(-1.57)
			new_blood.z_index=-3
			wall_layer.add_child(new_blood)
func hit( hit: Area2D):
	if not hit.get_parent() is character:
		return
	hit.owner.take_damage(damage, damage_types.melee_type)
	if  hit.get_parent() is enemy_complete:
		blood_splatter(hit)
