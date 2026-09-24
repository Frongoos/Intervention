extends Control
enum weapon_ids {
	null_weapon=0,
	knife=1,
	m1911=2,
	revolver=3,
	uzi=4,
	glock17=5,
	mossberg500=6,
	DBshotgun=7,
	MP5=8,
	AK47=9,
	AWP=10,
	Saiga12=11,
	m4A1=12,
	SawedOff=13,
	Vector=14,
	M1garand=15,
	NosinNagant=16,
	LMG=17,
	grenades=18,
}
enum wp{ # weapin properties
	w_name=0, # string
	type=1, #string
	damage=2, # int
	ammo=3, # int 
	ammo_type=4, # ammo_type
	bullet_speed=5, # int 
	reload_time=6, # float
	cost=7, # int 
	slot=8 #weapon types enum FUCK	
}
enum weapon_types {
	primary=0,
	secondary=1,
	melees=2,
	throwable=3
}

var loadout : VBoxContainer
var primary_vbox :VBoxContainer
var secondary_vbox :VBoxContainer
var misc_vbox :VBoxContainer
var root: Node2D
var loadout_children : Array
#=========packedscnes
var inventory_button = preload("res://Scenes/loadout_inventory_button.tscn")
func _ready():
	root= get_parent()
	loadout = $FirstVbox/Divider/Loadout
	loadout_children=loadout.get_children()
	primary_vbox=$FirstVbox/Divider/Primary/Primaries/PrimaryScroll/PrimaryVboxScroll
	secondary_vbox =$FirstVbox/Divider/Secondary/Secondaries/SecondaryScroll/Secondaryvbox
	misc_vbox=$FirstVbox/Divider/Misc/Miscs/MiscsScroll/MiscVbox
	get_node("../ShopUI").connect("weapon_purchased",weapon_purchased)
	#connecting equipped buttons 
	for item in loadout_children:
		item.get_child(0).connect("equiped_button_pressed",equipped_button_pressed)
func enable_buttons():
	#loadout buttons
	for item in loadout.get_children():
		item.get_child(0).mouse_filter=0
	for item in primary_vbox.get_children():
		item.mouse_filter=0
	for item in secondary_vbox.get_children():
		item.mouse_filter=0
	for item in misc_vbox.get_children():
		item.mouse_filter=0
	$FirstVbox/MenuButtons/ConRetryButton.mouse_filter=0
	$FirstVbox/MenuButtons/StoreButton.mouse_filter=0
func disable_buttons():
	for item in loadout.get_children():
		item.get_child(0).mouse_filter=2
	for item in primary_vbox.get_children():
		item.mouse_filter=2
	for item in secondary_vbox.get_children():
		item.mouse_filter=2
	for item in misc_vbox.get_children():
		item.mouse_filter=2
	$FirstVbox/MenuButtons/ConRetryButton.mouse_filter=2
	$FirstVbox/MenuButtons/StoreButton.mouse_filter=2

	#everything else
func weapon_purchased(weapon_id: int):
	var new_item = inventory_button.instantiate()
	new_item.weapon_id  = weapon_id
	new_item.icon=match_item_to_sprite(weapon_id)
	new_item.connect("item_clicked",inventory_button_clicked)
	match root.weapon_stats[weapon_id][wp.slot]:
		0:
			primary_vbox.add_child(new_item)
		1:
			secondary_vbox.add_child(new_item)
		_:
			misc_vbox.add_child(new_item)
	
func match_item_to_sprite(weapon_id):
	match weapon_id:
		weapon_ids.knife:
			return load("res://Sprites/weapon_icons/knife_shop_icon.png")
		weapon_ids.m1911:
			return load("res://Sprites/weapon_icons/m1911_shop_icon.png")
		weapon_ids.revolver:
			return load("res://Sprites/weapon_icons/revolver_shop_icon.png")
		weapon_ids.MP5:
			return load("res://Sprites/weapon_icons/mp5_shop_icon.png")
		weapon_ids.uzi:
			return load("res://Sprites/weapon_icons/uzi_shop_icon.png")
		weapon_ids.glock17:
			return load("res://Sprites/weapon_icons/glock17_shop_icon.png")
		weapon_ids.mossberg500:
			return load("res://Sprites/weapon_icons/mossberg500_shop_icon.png")
		weapon_ids.DBshotgun:
			return load("res://Sprites/weapon_icons/dbshotgun_shop_icon.png")
		weapon_ids.AK47:
			return load("res://Sprites/weapon_icons/ak47_shop_icon.png")
		weapon_ids.grenades:
			return load("res://Sprites/weapon_icons/grenade_shop_icon.png")
		weapon_ids.AWP:
			return load("res://Sprites/weapon_icons/AWP_shop_icon.png")
		weapon_ids.Saiga12:
			return load("res://Sprites/weapon_icons/saiga12_shop_icon.png")
		weapon_ids.Vector:
			return load("res://Sprites/weapon_icons/vector_shop_icon.png")
		weapon_ids.m4A1:
			return load("res://Sprites/weapon_icons/M4A1_shop_icon.png")
		weapon_ids.SawedOff:
			return load("res://Sprites/weapon_icons/sawed_off_shop_icon.png")
		weapon_ids.M1garand:
			return load("res://Sprites/weapon_icons/m1GarandShop_icon.png")
		weapon_ids.NosinNagant:
			return load("res://Sprites/weapon_icons/mosgin_nagant_shop_icon.png")
		weapon_ids.LMG:
			return load("res://Sprites/weapon_icons/LMG_shop_icon.png")
		_:
			print(weapon_id)
			return load("res://Sprites/weapon_icons/weapon_shop_test.png")
			
func inventory_button_clicked(weapon_id: int , object):
	print("Signal recieved")
	var slot =loadout_children[root.weapon_stats[weapon_id][wp.slot]].get_child(0)
	if  slot.weapon_id<=0: # if the slot is empty
		print("Case1")
		object.queue_free()
		slot.icon=match_item_to_sprite(weapon_id)
		slot.weapon_id=weapon_id
		root.player_weapon_loadout[root.weapon_stats[weapon_id][wp.slot]]=weapon_id
	elif slot.weapon_id>0 and slot.weapon_id<=18:
		print("Case 2")
		var new_inventory_button = inventory_button.instantiate()
		new_inventory_button.weapon_id = slot.weapon_id
		new_inventory_button.icon = match_item_to_sprite(slot.weapon_id)
		match root.weapon_stats[weapon_id][wp.slot]:
			weapon_types.primary:
				$FirstVbox/Divider/Primary/Primaries/PrimaryScroll/PrimaryVboxScroll.add_child(new_inventory_button)
			weapon_types.secondary:
				$FirstVbox/Divider/Secondary/Secondaries/SecondaryScroll/Secondaryvbox.add_child(new_inventory_button)
			_:
				$FirstVbox/Divider/Misc/Miscs/MiscsScroll/MiscVbox.add_child(new_inventory_button)
		new_inventory_button.get_parent().move_child(new_inventory_button,object.get_index())
		new_inventory_button.connect("item_clicked",inventory_button_clicked)
		object.queue_free()
		slot.icon=match_item_to_sprite(weapon_id)
		slot.weapon_id=weapon_id
		root.player_weapon_loadout[root.weapon_stats[weapon_id][wp.slot]]=weapon_id
func equipped_button_pressed(weapon_id, weapon_slot, object):
	if weapon_id>0:
	#change icon back
		match weapon_slot:
			weapon_types.primary:
				object.icon = load("res://Sprites/weapon_icons/loadout_primary_empty.png")
			weapon_types.secondary:
				object.icon = load("res://Sprites/weapon_icons/loadout_secondary_empty.png")
			weapon_types.melees:
				object.icon = load("res://Sprites/weapon_icons/loadout_melee_empty.png")
			weapon_types.throwable:
				object.icon = load("res://Sprites/weapon_icons/loadout_throwable_empty.png")
		object.weapon_id=-1
		var new_inventory_button = inventory_button.instantiate()
		new_inventory_button.weapon_id =weapon_id
		new_inventory_button.icon = match_item_to_sprite(weapon_id)
		match weapon_slot:
			weapon_types.primary:
				$FirstVbox/Divider/Primary/Primaries/PrimaryScroll/PrimaryVboxScroll.add_child(new_inventory_button)
			weapon_types.secondary:
				$FirstVbox/Divider/Secondary/Secondaries/SecondaryScroll/Secondaryvbox.add_child(new_inventory_button)
			_:
				$FirstVbox/Divider/Misc/Miscs/MiscsScroll/MiscVbox.add_child(new_inventory_button)
		new_inventory_button.connect("item_clicked",inventory_button_clicked)
		root.player_weapon_loadout[weapon_slot]=weapon_ids.null_weapon
		print(root.player_weapon_loadout)
	#adding the node back 
	
func clear_grenades():
	var throwable_button = loadout.get_child(3).get_child(0)
	throwable_button.icon = load("res://Sprites/weapon_icons/loadout_throwable_empty.png")
	throwable_button.weapon_id=-1
	
