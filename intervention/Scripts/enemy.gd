extends character
class_name enemy
#================Ammo drops============================
@export var ammo_drop_multiplier: float
var ammo_drop_scene = preload("res://Scenes/ammo_drop.tscn")
var dead_body_scene = preload("res://Scenes/dead_body.tscn")
@export var dead_body_frames: SpriteFrames
#=============other stuff===============================
var raycast_interval: float # interval of raycast calls
var collision: KinematicCollision2D
var direction = Vector2.ZERO
var speed = 10
var t_since_raycast =0.0
var t_since_pathupdate=0.0
var path_update_interval = 0.5
var player_target: player
var self_player_distance =0.0
var FOV1_player_distance =0.0
var FOV2_player_distance=0.0
var player_global_pos=Vector2(0,0)
var update_path_interval = 0.25
var item_hand : item_handler_enemy
#====================AI========================

#Preventing being stuck checks
var prev_postion:Vector2
var min_distance_travelled =20
var death_sound: AudioStreamMP3


var rotations = 0
@export var strafe_to_charge_playerseen_time = 3
@export var evade_distance =100
@export var strafe_max_distance = 50
@export var wander_range= 100
var rotating=false
var desired_angle=0.0
var desired_rotation = 0.0
var look_at_coord: Vector2
var min_distance_from_player =38
@export var ignore_min_distance = false
var weapon_index = 0
var t_player_seen_for = 0.0
var t_player_not_seen_for =0.0
@export var forget_and_wander_time= 5
var next_point: Vector2
var navigation_baked=false

#combat states
var health_cutoff = 10
var health_drop_rate = 0
var health_drop_rate_pullout= 3000 #hp per sec
var health_prev=100
#idle
var idle_time = 0
var idle_length= 2

#navigation server stuff
var current_path_index: int = 0
var current_path_point: Vector2
var current_path: PackedVector2Array
var default_2d_map_rid: RID 
var query_parameters := NavigationPathQueryParameters2D.new()
var query_result := NavigationPathQueryResult2D.new()
enum enemy_state{
	wander_move_to_point,
	wander_idle, # wander invovles moving to random points in the world
	seen_player,
	evade,
	strafe,
	charge
}
var player_seen =false
var state = enemy_state.wander_idle
func _ready() -> void:

	prev_postion=global_position
	team = teams.enemy_team
	target=teams.player_team
	health=100
	player_target=get_node("../Player")
	item_hand=$item_handler_enemy

func _physics_process(delta: float) -> void:
	#===========================CHecking for player===================================
	
	if t_since_raycast>= raycast_interval:
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
				player_seen=true
				t_player_seen_for+=delta
				t_player_not_seen_for=0
			else:
				player_seen=false
				t_player_seen_for=0
				t_player_not_seen_for+=delta
		else:
			player_seen=false
			t_player_not_seen_for+=delta
	#=====================Update times========================#
	t_since_raycast+=delta
	t_since_pathupdate+=delta

	
	if not navigation_baked:
		default_2d_map_rid=get_world_2d().get_navigation_map()
	#==========================STATES==========================
	if navigation_baked:
		match (state):
			enemy_state.wander_move_to_point:
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
				#Looking at player weapon handling
				look_at_coord=player_target.global_position

				if player_seen:
					if item_hand.current_weapon.ammo>0:
						item_hand.current_weapon.on_attack(player_target.global_position)
					else:
						weapon_index+=1
						if not item_hand.change_weapon_request(weapon_index):
							weapon_index=0
							item_hand.change_weapon_request(weapon_index)
							item_hand.current_weapon.reload()

				#STATE CHANGES
				health_player_checks(delta)
				if t_since_pathupdate>=update_path_interval:
					if self_player_distance<min_distance_from_player and not ignore_min_distance and player_seen: # too close to player
						state=enemy_state.strafe# opposite direction
					else:
						new_path(player_target.global_position)
					t_since_pathupdate=0
				#finding and moving to the next point
				handle_movement(1)

			enemy_state.evade:
				look_at_coord=player_global_pos
				if t_since_pathupdate>=path_update_interval:
					new_path( (player_global_pos-global_position) *-evade_distance )
					t_since_pathupdate=0
				if player_seen:
					if item_hand.current_weapon.ammo>0:
						item_hand.current_weapon.on_attack(player_target.global_position)
					else:
						weapon_index+=1
						if not item_hand.change_weapon_request(weapon_index):
							weapon_index=0
							item_hand.change_weapon_request(weapon_index)
							item_hand.current_weapon.reload()
				health_player_checks(delta)
				handle_movement(1)

			enemy_state.strafe:
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
				if player_seen:
					if item_hand.current_weapon.ammo>0:
						item_hand.current_weapon.on_attack(player_target.global_position)
					else:
						weapon_index+=1
						if not item_hand.change_weapon_request(weapon_index):
							weapon_index=0
							item_hand.change_weapon_request(weapon_index)
							item_hand.current_weapon.reload()
	
				look_at_coord=player_global_pos
				handle_movement(1)
	#Look at interpolation

	if rotating:
		lerp_rotation()
	else:
		look_at(look_at_coord)
	collision=move_and_collide(velocity*delta)
	if collision:
		velocity = velocity.slide(collision.get_normal())
	else:
		velocity = direction*speed
	
func new_path( target_point: Vector2)->void:
	var safe_goal = NavigationServer2D.map_get_closest_point(default_2d_map_rid,target_point)
	query_parameters.map = default_2d_map_rid
	query_parameters.start_position = global_position
	query_parameters.target_position = target_point
	query_parameters.navigation_layers=1
	query_parameters.path_postprocessing=NavigationPathQueryParameters2D.PATH_POSTPROCESSING_EDGECENTERED
	NavigationServer2D.query_path(query_parameters,query_result)
	current_path=query_result.get_path()
	current_path_index=0
func take_damage(damage: int, type: damage_types):
	health-=damage
	if health<=0:
		create_dead_body()
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
		if item_hand.current_weapon.move_speed_debuff_active:
			velocity = next_point.normalized()*speed*item_hand.current_weapon.move_speed_debuff
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
		_: 
			return 1
func health_player_checks(delta: float)-> void: # checks for healthdrop out n shit, and also checks if thye haven't moved for not 
	health_drop_rate=(health_prev-health)/delta
	health_prev=health
	if health_drop_rate>=health_drop_rate_pullout:
		state=enemy_state.evade
				#If the player hasn't been seen for a while stop chasing 
	elif t_player_not_seen_for>=forget_and_wander_time:
		state=enemy_state.wander_idle
	elif health<=health_cutoff:
		state = enemy_state.evade


func setup_rotation(look_at_point):
	desired_rotation=get_angle_to(look_at_point)
	desired_angle=desired_rotation+rotation
	rotating=true
func lerp_rotation():
	if rotating:
		if rotations<10:
			rotate(( desired_rotation/10.0 ))
			rotations+=1
		else:
			rotation=desired_angle
			rotating=false
			rotations=0
func drop_ammo():
	#droping rifle ammo
	if item_hand.weapons.has(weapon_types.rifle):
		create_ammo_drop(item_hand.weapons[weapon_types.rifle].ammo_type)
	if item_hand.weapons.has(weapon_types.pistol):
		create_ammo_drop(item_hand.weapons[weapon_types.pistol].ammo_type)
func create_dead_body():
	var dead_body = dead_body_scene.instantiate()
	dead_body.setup(dead_body_frames,rotation,death_sound)
	dead_body.global_position=global_position
	add_sibling(dead_body)
func create_ammo_drop(weapon_ammo_type: int):
	var ammo_drop_var = ammo_drop_scene.instantiate()
	ammo_drop_var.ammo_type=weapon_ammo_type
	var ammo_amount_process= 0
	match ammo_drop_var.ammo_type:
		ammo_types.twelve_gauge:
			ammo_amount_process=randi_range(3,6)
		ammo_types.nine_mm:
			ammo_amount_process=randi_range(5,20)
		_: # since 7.62 and 5.56 have the same drop ranges, 
			ammo_amount_process=randi_range(20,30)
	ammo_drop_var.amount =int(ammo_amount_process*ammo_drop_multiplier)
	ammo_drop_var.global_position = global_position
	add_sibling(ammo_drop_var)
	
