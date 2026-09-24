extends Node2D
enum weapon_types {
	primary=0,
	secondary=1,
	melee=2,
	throwable=3
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
enum ammo_types{
	twelve_gauge=0,
	nine_mm=1,
	seven_mm=2,
	five_mm=3
}
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
var menu_camera: Object
var loading_screen_sprite: Object
var inbetween_level_UI
signal level_complete
var EndLevelMoneyCounter
var current_end_scene
var black_screen_timer
var money_collected_temp: int
var ammo_collected_temp ={
	ammo_types.twelve_gauge:0,
	ammo_types.nine_mm:0,
	ammo_types.seven_mm:0,
	ammo_types.five_mm:0
}
var shop_conretry_button
var loadout_conretry_button
var root
var GUI
var loadout_UI: Control
var thxforplaying :Sprite2D
func _ready():
	thxforplaying=get_parent().get_node("ThxforPlaying")
	GUI = $GUI
	root=get_parent()
	loadout_UI = get_parent().get_node("LoadoutUI")
	menu_camera = get_node("../MenuCamera")
	loading_screen_sprite = get_node("../LoadingScreen")
	inbetween_level_UI=get_node("../InbetweenLevelUI")
	EndLevelMoneyCounter=get_node("../EndLevelMoneyCounter")
	black_screen_timer=get_node("../LevelFailedAnimationTimer")
	shop_conretry_button=get_node("../ShopUI/Divider/LHS/HBoxContainer/ConRetryButton")
	loadout_conretry_button=get_node("../LoadoutUI/FirstVbox/MenuButtons/ConRetryButton")
func load_level_sequence(level : PackedScene, end_scene: PackedScene):
	
	current_end_scene=end_scene
	loading_screen_sprite.visible=true
	var level_var = level.instantiate()
	add_child(level_var)
	await level_var.navigation_baked

	var level_player=level_var.get_child(0)
	root.audio_listener.clear_current()
	level_player.player_audio_listener.make_current()
	Input.mouse_mode=Input.MOUSE_MODE_HIDDEN
	#loading ammo and weapons
	level_player.ammo_collection[ammo_types.twelve_gauge] = root.root_player_ammo_collection [ammo_types.twelve_gauge]
	level_player.ammo_collection[ammo_types.nine_mm]= root.root_player_ammo_collection[ammo_types.nine_mm]
	level_player.ammo_collection[ammo_types.seven_mm]= root.root_player_ammo_collection[ammo_types.seven_mm]
	level_player.ammo_collection[ammo_types.five_mm]= root.root_player_ammo_collection[ammo_types.five_mm]
	#so i guess i had to do this to pass by value and not reference, ffs

	var empty_slots=0
	for item in root.player_weapon_loadout:
		var item_id = root.player_weapon_loadout[item] #slot is id
		if item_id >=2 and item_id <=17: #no knife
			var new_weapon = match_weapon_id_to_scene(item_id).instantiate()
			level_player.item_hand.add_child(new_weapon)
			if level_player.ammo_collection[root.weapon_stats[item_id][wp.ammo_type]]>=new_weapon.ammo_capacity: # enough ammo
				level_player.ammo_collection[root.weapon_stats[item_id][wp.ammo_type]]-=new_weapon.ammo_capacity
				print("Enough ammo Case")
			else:# if there isnt enough ammo then  set the weapon ammo to the remaining ammo
				print("Not enougn ammo case:",level_player.ammo_collection[root.weapon_stats[item_id][wp.ammo_type]])
				new_weapon.ammo=level_player.ammo_collection[root.weapon_stats[item_id][wp.ammo_type]]
				level_player.ammo_collection[root.weapon_stats[item_id][wp.ammo_type]]=0
				print("Ammo set from holder:",new_weapon.ammo)
		elif item_id==1: # knife case
			var new_weapon = match_weapon_id_to_scene(item_id).instantiate()
			level_player.item_hand.add_child(new_weapon)
		elif item_id==weapon_ids.grenades:
			var grenade_holder = match_weapon_id_to_scene(item_id).instantiate()
			level_player.item_hand.add_child(grenade_holder)
			if root.player_grenade_collection>=root.max_grenades: # 4 is the max amount of grenades
				grenade_holder.amount=root.max_grenades
			else:
				grenade_holder.amount=root.player_grenade_collection
		elif item_id==0:
			empty_slots+=1
	if empty_slots>=4:
		var null_weapon = preload("res://Scenes/weapon_related/weapon_scene/null_weapin.tscn").instantiate()
		level_player.item_hand.add_child(null_weapon)
	level_player.item_hand.ready()
	level_player.get_node("%Cursor").connect_attack_fired()
	level_player.movement_enabled=true

	level_player.camera.make_current()
	loading_screen_sprite.visible=false
	level_var.connect("level_complete",level_complete_sequence)
	level_var.connect("level_failed",level_failed_sequence)
	GUI.setup()
	level_player.cursor_node.visible=true
func level_complete_sequence():
	GUI.desetup()
	var level_var =get_child(1)
	var player_var =get_child(1).get_child(0)
	var player_item_handler = player_var.get_node("item_handler")
	Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	player_var.player_audio_listener.clear_current()
	root.audio_listener.make_current()
	money_collected_temp=level_var.money_collected
	#addding player ammo the the root player ammo
	#checking the reserves first
	ammo_collected_temp=player_var.ammo_collection
	#adding ammo from each gun
	for item in player_item_handler.get_children():
		if item is gun or item is shotgun:
			ammo_collected_temp[item.ammo_type]+=item.ammo
	# handling grenades
	if root.player_weapon_loadout[weapon_types.throwable]==weapon_ids.grenades:
		root.player_grenade_collection-=player_var.grenades_used
		if root.player_grenade_collection<=0:
			#finding grenades in player collection and removing it
			root.player_weapon_collection.erase(weapon_ids.grenades)
			root.player_weapon_loadout[weapon_types.throwable]=weapon_ids.null_weapon
			loadout_UI.clear_grenades()
	level_var.disconnect("level_complete",level_complete_sequence)
	level_var.disconnect("level_failed",level_failed_sequence)
	menu_camera.make_current()
	loading_screen_sprite.visible=true
	#Updating  Saved data
	level_var.queue_free()
	#loading end screen
	var end_scene = current_end_scene.instantiate()
	end_scene.global_position=Vector2.ZERO
	loading_screen_sprite.visible=false
	add_child(end_scene)
	await end_scene.scene_complete
	end_scene.queue_free()
	if root.level_index>=4:
		thxforplaying.visible=true
		thxforplaying.get_child(0).start(0.0)
		await thxforplaying.get_child(0).timeout
		get_tree().quit()
		await thxforplaying.get_child(0).timeout
	EndLevelMoneyCounter.start_count(money_collected_temp)
	level_complete.emit()
	shop_conretry_button.icon = load("res://Sprites/continue_sprite.png")
	loadout_conretry_button.icon = load("res://Sprites/continue_sprite.png")
func level_failed_sequence():
	GUI.desetup()
	var level_var = get_child(1)
	var player_var = level_var.get_child(0)
	player_var.player_audio_listener.clear_current()
	root.audio_listener.make_current()
	Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	
	level_var.disconnect("level_complete",level_complete_sequence)
	level_var.disconnect("level_failed",level_failed_sequence)
	menu_camera.make_current()
	loading_screen_sprite.visible=true
	level_var.queue_free()
	black_screen_timer.start(0.0)
	await black_screen_timer.timeout	
	inbetween_level_UI.display(0)
	shop_conretry_button.icon=load("res://Sprites/retry_spirte.png")
	loadout_conretry_button.icon = load("res://Sprites/retry_spirte.png")
func match_weapon_id_to_scene(weapoon_id):
	match weapoon_id:
		weapon_ids.knife:
			return preload("res://Scenes/weapon_related/weapon_scene/knife.tscn")
		weapon_ids.m1911:
			return preload("res://Scenes/weapon_related/weapon_scene/M1911.tscn")
		weapon_ids.revolver:
			return preload("res://Scenes/weapon_related/weapon_scene/revolver.tscn")
		weapon_ids.uzi:
			return preload("res://Scenes/weapon_related/weapon_scene/uzi.tscn")
		weapon_ids.MP5:
			return preload("res://Scenes/weapon_related/weapon_scene/mp5.tscn")
		weapon_ids.glock17:
			return preload("res://Scenes/weapon_related/weapon_scene/glock_17.tscn")
		weapon_ids.mossberg500:
			return preload("res://Scenes/weapon_related/weapon_scene/Mossberg500.tscn")
		weapon_ids.DBshotgun:
			return preload("res://Scenes/weapon_related/weapon_scene/dbshotgun.tscn")
		weapon_ids.AK47:
			return preload("res://Scenes/weapon_related/weapon_scene/ak_47.tscn")
		weapon_ids.AWP:
			return preload("res://Scenes/weapon_related/weapon_scene/AWP.tscn")
		weapon_ids.Saiga12:
			return preload("res://Scenes/weapon_related/weapon_scene/saiga12.tscn")
		weapon_ids.grenades:
			return preload("res://Scenes/weapon_related/weapon_scene/grenade_hold.tscn")
		weapon_ids.Vector:
			return preload("res://Scenes/weapon_related/weapon_scene/Vector.tscn")
		weapon_ids.m4A1:
			return preload("res://Scenes/weapon_related/weapon_scene/M4A1.tscn")
		weapon_ids.SawedOff:
			return preload("res://Scenes/weapon_related/weapon_scene/sawed_off.tscn")
		weapon_ids.M1garand:
			return preload("res://Scenes/weapon_related/weapon_scene/m_1_garand.tscn")
		weapon_ids.NosinNagant:
			return preload("res://Scenes/weapon_related/weapon_scene/mosin_nagant.tscn")
		weapon_ids.LMG:
			return preload("res://Scenes/weapon_related/weapon_scene/lmg.tscn")
