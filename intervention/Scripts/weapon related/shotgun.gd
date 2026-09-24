extends gun
class_name shotgun
@export var pellets_per_shot: int
@export var pellet_spread: float
var point_process: Vector2
var deviation = 0.0
func _ready():
	super()
	deviation = (pellet_spread*2)/pellets_per_shot
#Only thing Changed is that now several bullets are added
func on_attack(rotationP: float):
	if ammo<=0  or t_since_last_attack<=attack_delay:
		return
	ammo-=1
	attack_fired.emit()

	if reloading:
		reloading=false
		reload_time=0
		$ReloadNoise.stop()
	
	t_since_last_attack=0
	for i in range(0,pellets_per_shot):
		var new_bullet = bullet_scene.instantiate()
		new_bullet.setup(damage*damage_modifier, bullet_speed, bullet_lifetime, bullet_reflect, (rotationP-pellet_spread)+deviation*i, $BarrelPoint.global_position, owner.team, owner.target)
		add_child(new_bullet)
	muzzle_flashing=true
	flash_index=0
	$UseNoise.play()
	move_speed_debuff_active=true
	$MuzzleFlash.visible=true
	casing_emitter.emit_particle(casing_emitter.global_transform,velocity_process,color_process,color_process,2)
