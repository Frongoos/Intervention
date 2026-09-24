extends gun



func _ready():
	cursor=get_node("../../Cursor")
	damage=10
	sprite=$Sprite
	type = types.bullet
	attack_delay = 0.3
	ammo=17
# Called when the node enters the scene tree for the first time.
func wield():
	sprite.visible=true
	$NoisePlayer.stream=equip_sound
	$NoisePlayer.play()
func holster():
	sprite.visible=false
	$NoisePlayer.stream=equip_sound
	$NoisePlayer.play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(delta):
	t_since_last_attack+=delta
	
	if reloading:
		if reload_time>=reload_duration:
			reload_time=0
			ammo=17
			reloading=false
		else:
			reload_time+=delta

func on_attack() -> void:
	if ammo<=0  or t_since_last_attack<=attack_delay:
		return
	t_since_last_attack=0
	var new_bullet = bullet_scene.instantiate()
	new_bullet.setup(damage, bullet_speed, bullet_lifetime, bullet_reflect, cursor.global_position , $BarrelPoint.global_position, owner.team, owner.target, owner.layer)
	add_child(new_bullet)
	ammo-=1
	$Sprite.play("fire")
	cursor.position+=get_recoil_vector()
	$NoisePlayer.stream=use_sound
	$NoisePlayer.play()
	
func reload():
	if ammo<ammo_capacity:
		reloading=true
		$Sprite.play("reload")
func get_recoil_vector() ->Vector2:
	cursor.state=1
	return Vector2( randf_range(-recoil,recoil),randf_range(-recoil,recoil))
