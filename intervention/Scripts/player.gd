extends character
class_name player
var t_camera_shake = 0.0
var camera_shake_amplitude_x=0
var camera_shake_amplitude_y=0
var camera_shaking=false
var camera_shake_depreciation=0.8
var camera_shake_frequency = 1
@export var DEBUG= false
var cooking_grenade = false
var movement_enabled =false
var direction = Vector2.ZERO
var speed: int
var camera_zoom_out=3.8
var camera_zoom=4
var camera_zoom_out_v=Vector2(camera_zoom_out,camera_zoom_out) # zoom out while sprinting
var camera_zoom_v=Vector2(camera_zoom,camera_zoom)
var camera_zoom_out_speed = 0.3
var look_direction = Vector2(0,0)
var collision: KinematicCollision2D
var torso_sprite: AnimatedSprite2D
var leg_sprite: AnimatedSprite2D
var item_hand: item_handler
var global_mouse_pos: Vector2
var max_camera_distance =100 
var viewport_size_process: Vector2
var camera : Object
var grenades_used = 0
var cursor_node: AnimatedSprite2D
var use_area: Area2D
var t_use_box_enabled =0.0
var use_box_enabled_interval = 0.5
var footstep_player: AudioStreamPlayer
var heartbeat_player : AudioStreamPlayer
var player_audio_listener : AudioListener2D
var hit_player: AudioStreamPlayer
signal player_death
signal hit
signal ammo_picked_up
func _ready():
	hit_player = $HitPlayer
	player_audio_listener=$PlayerAudioListener
	heartbeat_player=$HeartBeatPlayer
	footstep_player= $FootstepPlayer
	use_area=$UseArea
	use_area.connect("area_entered",use_box_entered)
	item_hand=$item_handler
	cursor_node=$Cursor/AnimatedSprite2D
	ammo_collection[ammo_types.nine_mm]=999
	team=teams.player_team
	target=teams.enemy_team
	torso_sprite=$Torso
	leg_sprite = $Legs
	torso_sprite.animation="idles"
	torso_sprite.connect("animation_finished",torso_animation_finished)
	camera=$PlayerCamera
	for child in get_parent().get_node("Explosives").get_children():
		child.connect("explosion",explosion_nearby)
	
func _physics_process(delta: float) -> void:
	if movement_enabled:
		$PlayerAudioListener.global_position=global_position
		global_mouse_pos=get_global_mouse_position()
		direction=Input.get_vector("A","D","W","S").normalized()
		if direction == Vector2.ZERO:
			leg_sprite.play("idle")
			footstep_player.playing=false
			
		else:
			leg_sprite.play("walk")
			if not footstep_player.playing:
				footstep_player.play(0.0)

		#animation handling 
		if not ( torso_sprite.is_playing() or cooking_grenade):
			torso_sprite.frame = item_hand.current_weapon.type
		# pistol and rifle states need an offset
		if Input.is_action_pressed("shift"):
			speed=sprint_speed
			camera.zoom=lerp(camera.zoom,camera_zoom_out_v,camera_zoom_out_speed)
			$PointLight2D.shadow_item_cull_mask=1

		else:
			speed=walk_speed
			camera.zoom=lerp(camera.zoom,camera_zoom_v,camera_zoom_out_speed)
			$PointLight2D.shadow_item_cull_mask=1
		
		if item_hand.current_weapon.move_speed_debuff_active:
			speed*=item_hand.current_weapon.move_speed_debuff
		#============Usebox handling======================
		if Input.is_action_pressed("Use_E"):
			use_area.monitoring=true
	

		elif Input.is_action_pressed("Use_F"):
			use_area.monitoring=true
		if use_area.monitoring:
			t_use_box_enabled+=delta
			if t_use_box_enabled>=use_box_enabled_interval:
				use_area.monitoring=false
				t_use_box_enabled=0.0
		
		look_at(global_mouse_pos)
		collision=move_and_collide(velocity*delta)
		#=====TORSO ANIMATION HANDLING===================


			
		if collision:
			velocity = velocity.slide(collision.get_normal())
		else:
			velocity = direction*speed
	#camera shake
	if camera_shaking:
		camera_shake(delta)
	#==========================CURSOR VIBRATION============================
	#==========================Camera movement=============================
	#DEBUG

func take_damage(damage, damage_type):
	health-=damage
	hit.emit(health)
	hit_player.play(0.0)
	if health<=30:
		if not heartbeat_player.playing:
			heartbeat_player.play(0.0)
	else:
		heartbeat_player.playing=false
	if health<=0 and not DEBUG:
		
		movement_enabled=false
		var blood_overaly=get_parent().get_parent().get_node("GUI").blood_death
		blood_overaly.play("die")
		await blood_overaly.animation_finished
		player_death.emit()

	if health>100:
		health=100
	hit.emit(health)
func torso_animation_finished():
	torso_sprite.animation="idles"
	torso_sprite.frame=item_hand.current_weapon.type
func camera_shake(delta: float):
	t_camera_shake+=delta
	camera_shake_amplitude_x*=camera_shake_depreciation
	camera_shake_amplitude_y*=camera_shake_depreciation
	if camera_shake_amplitude_x<=1:
		camera_shake_amplitude_x=0
		camera_shake_amplitude_y=0
		camera_shaking=false
		camera.position=Vector2.ZERO
		print("Camera SHake Disabled") #Lol cos(x+1.57) is just sine im so dumb lel
	camera.position = Vector2( cos(t_camera_shake +1.57)*camera_shake_amplitude_x,sin(t_camera_shake)* camera_shake_amplitude_y)
func explosion_nearby(explosion_position):
	print("CAMERA SHAKE ACTIVATED")
	camera_shake_amplitude_x=8000/(explosion_position-global_position).length()* randi_range(-1,1)
	camera_shake_amplitude_y=camera_shake_amplitude_x*randi_range(-1,1)
	camera_shaking=true

func cutscene_mode(look_at_coord: Vector2):
	health=99999
	movement_enabled=false
	item_hand.current_weapon.visible=false
	torso_sprite.animation="idles"
	torso_sprite.frame=0
	leg_sprite.play("idle")
	look_at(look_at_coord)	
	#doing the GUI
	heartbeat_player.stop()
	collision_layer=1
	get_parent().get_parent().get_node("GUI").cutscene_mode()
	$Cursor/AnimatedSprite2D.visible=false
func use_box_entered(area):
	area.get_parent().use_e()
	set_deferred("use_area.monitoring",false)

func play_ammo_pickup_noise():
	$AmmoPickupPlayer.play(0.0)
func play_money_pickup_noise():
	$MoneyPickupPlayer.play(0.0)
