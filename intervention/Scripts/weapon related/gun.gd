extends weapon
class_name gun
@export var bullet_speed : float
@export var bullet_scene: PackedScene
@export var bullet_lifetime: float
@export var bullet_reflect: int 
var facing_direction: Vector2
@export var reload_duration: float
@export var ammo_capacity: int
var ammo: int 
var reloading =false
var reload_time:float
@export var reload_sound: AudioStream
@export var move_speed_debuff: float
@export var move_speed_debuff_duration:float
var move_speed_debuff_time: float
var muzzle_flashing = false
@export var flash_intestity: Array[ float]
var ranged =true
var damage_modifier: float
var flash_index= 0
var ammo_needed = 0
var transform2D_process : Transform2D
var velocity_process: Vector2
var color_process : Color
enum ammo_types{
	twelve_gauge=0,
	nine_mm=1,
	seven_mm=2,
	five_mm=3
}

@export var ammo_type: ammo_types
var casing_emitter: GPUParticles2D
func _ready():
	ammo=ammo_capacity
	print("Ammo set from gun:",ammo)
	owner=get_parent().get_parent()
	sprite=$AnimatedSprite2D
	sprite.visible=false
	$MuzzleFlash.energy=0
	wall_layer = get_node("../../../WallLayer")
	damage_modifier=get_parent().get_parent().damage_modifier
	casing_emitter=$CasingEmitter
	if casing_emitter:
		match ammo_type:
			ammo_types.nine_mm:
				casing_emitter.texture=load("res://Sprites/9mmCasing.png")
			ammo_types.seven_mm:
				casing_emitter.texture=load("res://Sprites/7.62mmCasing.png")
			ammo_types.five_mm:
				casing_emitter.texture=load("res://Sprites/5.56mmCasing.png")
			ammo_types.twelve_gauge:
				casing_emitter.texture=load("res://Sprites/12gaugecasing.png")
# Called when the node enters the scene tree for the first time.
func wield():
	sprite.visible=true
	$MuzzleFlash.visible=true

func holster():
	sprite.visible=false
	$MuzzleFlash.visible=false
	if reloading:
		attack_fired.emit()
		reloading=false
		reload_time=0.0
		$ReloadNoise.stop()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(delta):
	if muzzle_flashing:
		$MuzzleFlash.energy=flash_intestity[flash_index]
		flash_index+=1
		if flash_index>=flash_intestity.size():
			muzzle_flashing=false
			$MuzzleFlash.visible=false
			flash_index=0
	t_since_last_attack+=delta
	
	if reloading:
		if reload_time>=reload_duration:
			reloading=false
			reload_time=0
	 
			if ammo_needed>=owner.ammo_collection[ammo_type]: # use the rest of the ammo
				ammo+=owner.ammo_collection[ammo_type]
				owner.ammo_collection[ammo_type]=0
			else:
				ammo+=ammo_needed
				owner.ammo_collection[ammo_type]-=ammo_needed
			reload_complete.emit()
		else:
			reload_time+=delta
	if move_speed_debuff_active:
		move_speed_debuff_time+=delta
		if (move_speed_debuff_time>=move_speed_debuff_duration):
			move_speed_debuff_active=false
			move_speed_debuff_time=0
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
func reload():
	if not reloading:
		if ammo<ammo_capacity:
			if owner.ammo_collection[ammo_type]>0:
				ammo_needed=ammo_capacity-ammo
				reloading=true
				$ReloadNoise.play()
