extends gun
class_name m1_garand 
#only exits to allow for the ping to play.....

func on_attack(rotationP: float) -> void:
	if ammo<=0  or t_since_last_attack<=attack_delay :
		return
	ammo-=1
	attack_fired.emit()

	if reloading:
		reloading=false
		reload_time=0
		$ReloadNoise.stop()

	t_since_last_attack=0
	var new_bullet = bullet_scene.instantiate()
	new_bullet.setup(damage, bullet_speed, bullet_lifetime, bullet_reflect, rotationP, $BarrelPoint.global_position, owner.team, owner.target)
	add_child(new_bullet)
	muzzle_flashing=true
	$UseNoise.play(0.0)
	move_speed_debuff_active=true
	flash_index=0
	$MuzzleFlash.visible=true
	casing_emitter.emit_particle(casing_emitter.global_transform,velocity_process,color_process,color_process,2)
	if ammo==0:
		$Ping.play(0.0)
