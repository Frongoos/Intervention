class_name grenade_hold
extends weapon
var grenade_scene = preload("res://Scenes/weapon_related/weapon_scene/grenade_projectile.tscn")
var amount=0
var armed=false
var t_fuse = 0.0
var fuse_time = 5
var grenade_heading =0.0
var reloading=false # disabling changing 
var move_speed_debuff = 0.7
var fuse_timer: Timer
var post_throw_timer
var player_var: player
#grenes have  to be added as a child of the player node to prevent getting removed when out of ammo
func _ready():
	type=types.throw
	fuse_timer=$FuseTime
	post_throw_timer=$PostThrowCoolDown
	fuse_timer.wait_time=fuse_time
	fuse_timer.connect("timeout",fuse_timeout)
	player_var=get_parent().get_parent()
func on_attack(Protation: float):
	if amount>=0 and not armed :
		player_var.cooking_grenade=true
		player_var.torso_sprite.frame=5
		armed =true
		fuse_timer.start(0.0)
		move_speed_debuff_active=true
func on_released(Protation: float):
	if armed and not bullshit_edge_case:
		#changing owner sprite frame
	
		bullshit_edge_case=true # cant fire again
		player_var.torso_sprite.frame=6
		#creating grenade
		var grenade_var = grenade_scene.instantiate()
		grenade_var.setup(Protation,$ThrowableStartPoint.global_position,fuse_time- fuse_timer.time_left)
		player_var.add_child(grenade_var)
		post_throw_timer.start(0.0)
		fuse_timer.stop()
		post_throw_timer.connect("timeout",reset_to_normal)
		amount-=1
		if amount<=0:
			get_parent().weapon_count-=1

		player_var.grenades_used+=1
		attack_fired.emit()

func reset_to_normal():
	move_speed_debuff_active=false
	player_var.cooking_grenade=false
	bullshit_edge_case=false 
	armed=false
	
	if amount<=0:
		type=types.nul

func fuse_timeout():
	reset_to_normal() # you will die anyways sooooo

	var grenade_var = grenade_scene.instantiate()
	grenade_var.setup(0,$ThrowableStartPoint.global_position,fuse_time- fuse_timer.time_left)
	player_var.add_child(grenade_var)

	grenade_var.detonate()
	attack_fired.emit()
func holster():
	if armed:
		print("Run again")
		var grenade_var = grenade_scene.instantiate()
		grenade_var.setup(0,$ThrowableStartPoint.global_position,fuse_time- fuse_timer.time_left)
		fuse_timer.stop()

		player_var.add_child(grenade_var)
		grenade_var.velocity=Vector2.ZERO
		reset_to_normal()
		amount-=1
		player_var.grenades_used+=1
		attack_fired.emit()

	if amount<=0:
		get_parent().weapons.pop_back()
		queue_free()
	
