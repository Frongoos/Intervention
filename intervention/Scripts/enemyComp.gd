extends enemy
class_name enemy_complete
var leg_sprite: AnimatedSprite2D
var torso_sprite: AnimatedSprite2D
@export var starting_weapons: Array[PackedScene]
var next_coord: Vector2
var melee_range=20
var current_weapon
var money_scene = preload("res://Scenes/money.tscn")
@export var inacuracy: float
@export var min_money_drop: int
@export var max_money_drop: int
@export var max_money_instances: int 
@export var import_torso: SpriteFrames
@export var import_legs: SpriteFrames
var money_instances : int
var iterator=0
var min_distance_from_next_point = 1
var t_stuck_prevention =0.0
var stuck_prevention_interval = 0.7
var stuck_prevention_distance = 2000
var player_seen_process=false
var t_player_seen_process = 0.0
var footstep_player : AudioStreamPlayer2D
var hitPlayer : AudioStreamPlayer
@export var reaction_time =0.15
func _ready():
	min_distance_travelled=20
	money_instances=randi_range(1,3)
	ammo_collection[0]=9999999
	ammo_collection[1]=9999999
	ammo_collection[2]=9999999
	ammo_collection[3]=9999999
	prev_postion=global_position
	team = teams.enemy_team
	target=teams.player_team
	player_target=get_node("../Player")
	hitPlayer=$HitPlayer
	item_hand=$item_handler_enemy
	torso_sprite=$Torso
	leg_sprite=$Legs
	torso_sprite.sprite_frames=import_torso
	leg_sprite.sprite_frames=import_legs
	torso_sprite.connect("animation_finished",torso_animation_finished)
	if not item_hand.change_weapon_request(weapon_types.rifle):
		if not item_hand.change_weapon_request(weapon_types.pistol):
			item_hand.change_weapon_request(weapon_types.melees)
	footstep_player=$FootStepPlayer
	match randi_range(0,4):
		0:
			death_sound=load("res://Sounds/NonWeaponRelated/deathGrunts/deathGrunt1.mp3")
		1:
			death_sound=load("res://Sounds/NonWeaponRelated/deathGrunts/deathGrunt2.mp3")
		2:
			death_sound=load("res://Sounds/NonWeaponRelated/deathGrunts/deathGrunt3.mp3")
		3:
			death_sound=load("res://Sounds/NonWeaponRelated/deathGrunts/deathGrunt4.mp3")
		4:
			death_sound=load("res://Sounds/NonWeaponRelated/deathGrunts/deathGrunt5.mp3")
func torso_animation_finished():
	torso_sprite.animation="idles"
	torso_sprite.frame=current_weapon.type

func _physics_process(delta: float) -> void:
	
	current_weapon=item_hand.current_weapon
	if not torso_sprite.is_playing():
		torso_sprite.frame=current_weapon.type
	if t_since_raycast>= raycast_interval and $VisibleOnScreenNotifier2D.is_on_screen():
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position , player_target.global_position,1, [self])
		var result = space_state.intersect_ray(query)
		t_since_raycast=0
		if not result:
			#====================FOV check=========================
			player_global_pos=player_target.global_position
			self_player_distance=( player_global_pos-global_position).length()
			FOV1_player_distance=(player_global_pos-$FOV1.global_position).length()
			FOV2_player_distance= (player_global_pos-$FOV2.global_position).length()
			if (   (self_player_distance >FOV1_player_distance) or (self_player_distance >FOV2_player_distance)):
				player_seen_process=true

			else:
				player_seen_process=false
				t_player_seen_process=0

		else:
			player_seen_process=false
			t_player_seen_process=0

	#=====================Update times========================
	#===================== processs
	if player_seen_process:
		t_player_seen_process+=delta
		if t_player_seen_process>=reaction_time:
			player_seen=true
		else:
			player_seen=false
	else:
		player_seen=false

	if player_seen:
		t_player_seen_for+=delta
		t_player_not_seen_for=0
	else:
		t_player_not_seen_for+=delta
		t_player_seen_for=0
	t_since_raycast+=delta
	t_since_pathupdate+=delta
	t_stuck_prevention+=delta
	if navigation_baked:
		match (state):
			enemy_state.wander_move_to_point:
				min_distance_from_next_point=1
				speed=walk_speed
				leg_sprite.play("walk")
				next_point = current_path[current_path_index] - global_position
				look_at_coord=current_path[current_path_index]
				if next_point.length()>1:
					velocity = next_point.normalized()*speed
				else:
					if current_path_index < (current_path.size()-1) :
						current_path_index+=1
					else:
						state=enemy_state.wander_idle
				if player_seen:
					look_at_coord=player_global_pos
					setup_rotation(look_at_coord)
					match(randi_range(0,1)):
						0:
							state=enemy_state.charge
						1:
							state=enemy_state.strafe
			enemy_state.wander_idle:
				speed=0
				leg_sprite.play("idle")
				leg_sprite.frame=0
				if idle_time>=idle_length:
					var idgaf = global_position+Vector2(  randi_range(-wander_range,wander_range), randi_range(-wander_range,wander_range) )
					look_at_coord=idgaf
					new_path(look_at_coord)
					setup_rotation(look_at_coord)
					state=enemy_state.wander_move_to_point
					idle_time=0
					t_since_pathupdate=0
				else:
					idle_time+=delta
			#=================Attacking states=========================
			enemy_state.charge:
				speed=sprint_speed
				leg_sprite.play("walk")

				health_player_checks(delta)
				if ignore_min_distance:
					if self_player_distance<=melee_range:
						next_coord=player_target.global_position+Vector2(melee_range*random_negative(),melee_range*random_negative())
					else:
						next_coord=player_target.global_position

					if t_since_pathupdate>=path_update_interval:
						new_path(next_coord)
						t_since_pathupdate=0
					look_at_coord=player_global_pos
					min_distance_from_next_point=1

					handle_movement(min_distance_from_next_point)
				else:
					#put some weapin related shiz here
					if t_since_pathupdate>=path_update_interval:
						next_coord=player_target.global_position+Vector2(melee_range*1.5*random_negative(),melee_range*1.5*random_negative())
						new_path(next_coord)
						t_since_pathupdate=0 
					look_at_coord=player_target.global_position
					min_distance_from_next_point=1
					handle_movement(min_distance_from_next_point)
			enemy_state.evade:
				speed=sprint_speed
				leg_sprite.play("walk")

				if ignore_min_distance:
					state=enemy_state.charge
				else:
					look_at_coord=player_global_pos
					if t_since_pathupdate>=path_update_interval:
						new_path( (player_global_pos-global_position) *-evade_distance )
						t_since_pathupdate=0
					health_player_checks(delta)
					min_distance_from_next_point=1
					handle_movement(min_distance_from_next_point)
					if self_player_distance>=evade_distance:
						match randi_range(0,1):
							0:
								state=enemy_state.charge
							1:
								state=enemy_state.strafe
			enemy_state.strafe:
				speed=sprint_speed
				leg_sprite.play("walk")

				if ignore_min_distance:
					state=enemy_state.charge
				else:
									#finding new path
					if t_since_pathupdate>=path_update_interval:
						new_path(
						player_global_pos
						+Vector2(
						randi_range(min_distance_from_player,strafe_max_distance)*random_negative(),
						randi_range(min_distance_from_player,strafe_max_distance)*random_negative()   )
						)
						t_since_pathupdate=0
					health_player_checks(delta)
					if t_player_not_seen_for>=strafe_to_charge_playerseen_time:
						state=enemy_state.charge
					min_distance_from_next_point=1
					look_at_coord=player_global_pos
					handle_movement(min_distance_from_next_point)
	#Look at interpolation
	if t_stuck_prevention>=stuck_prevention_interval: # checks distance travelled over a second 
		#if it istoo small (probs stuck) then move somewhere else
		if state!=enemy_state.wander_idle:
			stuck_prevention()
		t_stuck_prevention=0
		prev_postion=global_position

	if rotating:
		lerp_rotation()
	else:
		look_at(look_at_coord)
	collision=move_and_collide(velocity*delta)
	if collision:
		velocity = velocity.slide(collision.get_normal())
	else:
		velocity = direction*speed
	handle_weapons()
	match state:
		enemy_state.wander_idle:
			footstep_player.playing=false
		_:
			if not footstep_player.playing:
				footstep_player.play(0.0)
	#===============AUDIO HANDLing==============
func _on_hitbox_area_entered(hit: Area2D) -> void:
	if hit.owner.state==0:
		hit.get_parent().use_e()
func take_damage(damage: int, type: damage_types):
	health-=damage

	t_player_not_seen_for=0
	hitPlayer.play(0.0)
	if health<=0:
		while iterator<money_instances:
			var money_var = money_scene.instantiate()
			money_var.value = randi_range(min_money_drop,max_money_drop)
			money_var.global_position=global_position
			call_deferred("add_sibling",money_var)
			iterator+=1
		create_dead_body()

		drop_ammo()
		queue_free()

	if (state==enemy_state.wander_move_to_point or state==enemy_state.wander_idle):
		setup_rotation(player_target.global_position)
		match (randi_range(0,1)):
			0:
				state=enemy_state.charge
			1:
				state=enemy_state.strafe

func handle_movement(min_distance_from_point: int):
	next_point= current_path[current_path_index]-global_position
	if next_point.length()>min_distance_from_point: # if not at point
		if current_weapon.move_speed_debuff_active:
			velocity = next_point.normalized()*speed*current_weapon.move_speed_debuff
		else:
			velocity = next_point.normalized()*speed
	else:
		# if at point finding the next point
		if current_path_index < (current_path.size()-1):
			current_path_index+=1

func random_negative() ->int:
	match (randi_range(0,1)):
		0:
			return -1
		1: 
			return 1
	return 1 #shuts the interpreter up 
func health_player_checks(delta: float)-> void: # checks for healthdrop out n shit, and also checks if thye haven't moved for not 

	if t_player_not_seen_for>=forget_and_wander_time:
		player_seen=false
		player_seen_process=false
		t_player_seen_process=0
		t_player_seen_for=0
		state=enemy_state.wander_idle
func handle_weapons():
	match state:
		enemy_state.wander_move_to_point:
			item_hand.change_weapon_request(weapon_types.nul)
			return
		enemy_state.wander_idle:
			item_hand.change_weapon_request(weapon_types.nul)
			return
	#equip melee or ranged 
	if item_hand.current_weapon.type== weapon_types.nul:
		if ignore_min_distance:
			item_hand.change_weapon_request(weapon_types.melees)
		else:
			if not item_hand.change_weapon_request(weapon_types.rifle):
				item_hand.change_weapon_request(weapon_types.pistol)
	match state:
		enemy_state.charge:
			if item_hand.current_weapon.ranged:
				if item_hand.current_weapon.ammo<=0 and not item_hand.current_weapon.reloading:
					
					if item_hand.current_weapon.type==weapon_types.rifle:
						if not item_hand.change_weapon_request(weapon_types.pistol):
							item_hand.current_weapon.reload()
					elif item_hand.current_weapon.type==weapon_types.pistol:
						if not item_hand.change_weapon_request(weapon_types.rifle):
							item_hand.current_weapon.reload() 
					#if the weapon turned too has no ammo, reload it , if pistol switch back to rifle tho
					# then reload
					if item_hand.current_weapon.ammo<=0:
						if item_hand.current_weapon.type==weapon_types.pistol:
							item_hand.change_weapon_request(weapon_types.rifle)
							item_hand.current_weapon.reload()
						elif item_hand.current_weapon.type==weapon_types.rifle:
							item_hand.current_weapon.reload()
				else:
					if player_seen:
						item_hand.current_weapon.on_attack(rotation+get_deviation())
			else:
				if self_player_distance<=melee_range:
					item_hand.current_weapon.on_attack(rotation+get_deviation())
		enemy_state.strafe:

			if ignore_min_distance:
				state=enemy_state.charge
			else:
				if player_seen:
					if item_hand.current_weapon.ammo<=0:
						item_hand.current_weapon.reload()
					else:
						item_hand.current_weapon.on_attack(rotation+get_deviation())
		enemy_state.evade:

			if ignore_min_distance:
				state=enemy_state.charge
			else:
				if item_hand.current_weapon.ammo<=0:
					item_hand.current_weapon.reload()
				else:
					if player_seen:
						item_hand.current_weapon.on_attack(rotation+get_deviation())
func get_deviation():
	return randf_range(-inacuracy,inacuracy)
func stuck_prevention():
	if (prev_postion-global_position).length() <min_distance_travelled:
		new_path(Vector2( randi_range(-stuck_prevention_distance,stuck_prevention_distance), randi_range(-stuck_prevention_distance,stuck_prevention_distance)))
func on_navigation_baked():
	default_2d_map_rid=get_world_2d().get_navigation_map()
