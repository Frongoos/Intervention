extends CanvasLayer
var level_holder
var player_item_handler
var root
var ammo_icon 
var reserve_icon 
var player_var : player
var blood : Control
var blood_hit : AnimatedSprite2D
var blood_overlay: AnimatedSprite2D
var ammo_counter: Control
var blood_death: AnimatedSprite2D
enum types{
	nul=0,
	rifle=1,
	pistol=2,
	melees=3,
	throw=4
}
func _ready():
	blood=$Blood
	blood_hit=$Blood/Bloodhit
	blood_overlay=$Blood/BloodOverlay
	blood_death = $Blood/BloodDeath
	ammo_counter =$AmmoCounter
	ammo_icon = $AmmoCounter/HBoxContainer/Ammo
	reserve_icon=$AmmoCounter/HBoxContainer/Reserve
	level_holder= get_parent()
	root=level_holder.get_parent()
	blood.visible=false
	ammo_counter.visible=false
func setup():
	visible=true
	blood.visible=true
	ammo_counter.visible=true
	blood_overlay.play("Anone")
	blood_death.play("default")
	player_var = level_holder.get_child(1).get_child(0)
	player_var.connect("ammo_picked_up",ammo_picked_up)
	player_item_handler = player_var.get_node("item_handler")
	#connecting to weapon changed in item_holder
	player_item_handler.connect("weapon_changed",ammo_counter_weapon_change)
	for item in player_item_handler.get_children():
		item.connect("reload_complete",ammo_counter_reload)
		item.connect("attack_fired",ammo_counter_attack_fired)
	player_var.connect("hit",player_hit)
	# setting up the ammo for the selected weapon
	if player_item_handler.current_weapon.type==types.melees:
		ammo_counter.visible=false
	elif player_item_handler.current_weapon.type!=types.nul:
		ammo_icon.text=str(player_item_handler.current_weapon.ammo)
		reserve_icon.text = str(player_var.ammo_collection[player_item_handler.current_weapon.ammo_type])
	else:
		ammo_counter.visible=false

func ammo_counter_reload():
	ammo_icon.text=str(player_item_handler.current_weapon.ammo)
	reserve_icon.text = str(player_var.ammo_collection[player_item_handler.current_weapon.ammo_type])
func ammo_counter_attack_fired():
	if player_item_handler.current_weapon.type==types.throw: #grenade case
		if player_item_handler.current_weapon.amount==0:
			ammo_icon.text="0"
			reserve_icon.text="0"
		else:
			print("Ammo counter UI grenade case")
			reserve_icon.text=str(player_item_handler.current_weapon.amount-1)
	else:
		if not player_item_handler.current_weapon.type==types.nul:
			ammo_icon.text=str(player_item_handler.current_weapon.ammo)
	
func ammo_counter_weapon_change(type: int):
	if player_item_handler.current_weapon.type==types.melees:
		ammo_counter.visible=false
	elif player_item_handler.current_weapon.type==types.throw:
		ammo_counter.visible=true
		ammo_icon.text =  "1"
		reserve_icon.text = str( player_item_handler.current_weapon.amount-1)
	else:
		ammo_counter.visible=true
		ammo_icon.text=str(player_item_handler.current_weapon.ammo)
		reserve_icon.text = str(player_var.ammo_collection[player_item_handler.current_weapon.ammo_type])
func ammo_picked_up(): #update ammo
	if player_item_handler.current_weapon.type==types.rifle or player_item_handler.current_weapon.type==types.pistol:
		reserve_icon.text = str(player_var.ammo_collection[player_item_handler.current_weapon.ammo_type])

func desetup(): #level end
	
	blood_hit.frame=0
	blood.visible=false
	ammo_counter.visible=false
func player_hit(health):
	blood_hit.play("hit")
	if health>=30:
		if health>=50:
			if health>=60:
				if health>=70:
					blood_overlay.play("Anone")
				else:
					blood_overlay.play("vld")
			else:
				blood_overlay.play("ld")
		else:
			blood_overlay.play("md")
	else:
		blood_overlay.play("hd")
func cutscene_mode(): #makes invisibe
	visible=false
