extends Node2D
#PlayerData
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
var weapon_stats =[
	{
		wp.w_name:"null",
		wp.type: "null",
		wp.damage:0,
		wp.ammo:0,
		wp.ammo_type: 0,
		wp.bullet_speed: 0,
		wp.reload_time:0,
		wp.cost: 0,
		wp.slot: weapon_types.primary
	},
	{
		wp.w_name:"knife",
		wp.type: "melee",
		wp.damage:50,
		wp.ammo:0,
		wp.ammo_type: 0,
		wp.bullet_speed: 0,
		wp.reload_time:0,
		wp.cost: 0,
		wp.slot: weapon_types.melee
	},
		{
		wp.w_name:"M1911",
		wp.type: "Pistol",
		wp.damage:10,
		wp.ammo:17,
		wp.ammo_type: ammo_types.nine_mm,
		wp.bullet_speed: 500,
		wp.reload_time:0.6,
		wp.cost: 0,
		wp.slot: weapon_types.secondary

	},
		{
		wp.w_name:"Revolver",
		wp.type: "Pistol",
		wp.damage:40,
		wp.ammo:6,
		wp.ammo_type: ammo_types.nine_mm,
		wp.bullet_speed: 700,
		wp.reload_time:2,
		wp.cost: 800,
		wp.slot: weapon_types.secondary

	},
		{
		wp.w_name:"Uzi",
		wp.type: "Pistol",
		wp.damage:5,
		wp.ammo:20,
		wp.ammo_type: ammo_types.nine_mm,
		wp.bullet_speed: 500,
		wp.reload_time:1,
		wp.cost: 100,
		wp.slot: weapon_types.secondary

	},
		{
		wp.w_name:"Glock17",
		wp.type: "Pistol",
		wp.damage:7,
		wp.ammo:20,
		wp.ammo_type: ammo_types.nine_mm,
		wp.bullet_speed: 500,
		wp.reload_time:1,
		wp.cost: 70,
		wp.slot: weapon_types.secondary

	},
		{
		wp.w_name:"Mossberg 500",
		wp.type: "Shotgun",
		wp.damage:20,
		wp.ammo:5,
		wp.ammo_type: ammo_types.twelve_gauge,
		wp.bullet_speed: 400,
		wp.reload_time:3,
		wp.cost: 160,
		wp.slot: weapon_types.primary
	},
		{
		wp.w_name:"DB shotgun",
		wp.type: "Shotgun",
		wp.damage:30,
		wp.ammo:2,
		wp.ammo_type: ammo_types.twelve_gauge,
		wp.bullet_speed: 600,
		wp.reload_time:3,
		wp.cost: 500,
		wp.slot: weapon_types.primary

	},
		{
		wp.w_name:"MP5",
		wp.type: "Rifle",
		wp.damage:10,
		wp.ammo:30,
		wp.ammo_type: ammo_types.nine_mm,
		wp.bullet_speed: 600,
		wp.reload_time:1,
		wp.cost: 160,
		wp.slot: weapon_types.primary
	},
		{
		wp.w_name:"AK47",
		wp.type: "Rifle",
		wp.damage:15,
		wp.ammo:30,
		wp.ammo_type: ammo_types.seven_mm,
		wp.bullet_speed: 600,
		wp.reload_time:1.5,
		wp.cost: 500,
		wp.slot: weapon_types.primary
	},
		{
		wp.w_name:"AWP",
		wp.type: "Sniper Rifle",
		wp.damage:80,
		wp.ammo:5,
		wp.ammo_type: ammo_types.seven_mm,
		wp.bullet_speed: 1000,
		wp.reload_time:3,
		wp.cost: 800,
		wp.slot: weapon_types.primary
	},
		{
		wp.w_name:"Saiga12",
		wp.type: "Shotgun",
		wp.damage:5,
		wp.ammo:7,
		wp.ammo_type: ammo_types.twelve_gauge,
		wp.bullet_speed: 500,
		wp.reload_time:2,
		wp.cost: 800,
		wp.slot: weapon_types.primary
	},
		{
		wp.w_name:"M4A1",
		wp.type: "Rifle",
		wp.damage:10,
		wp.ammo:30,
		wp.ammo_type: ammo_types.five_mm,
		wp.bullet_speed: 500,
		wp.reload_time:1,
		wp.cost: 500,
		wp.slot: weapon_types.primary
	},
		{
		wp.w_name:"Sawed off",
		wp.type: "Shotgun",
		wp.damage:30,
		wp.ammo:5,
		wp.ammo_type: ammo_types.twelve_gauge,
		wp.bullet_speed: 400,
		wp.reload_time:2,
		wp.cost: 500,
		wp.slot: weapon_types.primary
		},
		{
		wp.w_name:"Vector",
		wp.type: "Rifle",
		wp.damage:7,
		wp.ammo:30,
		wp.ammo_type: ammo_types.nine_mm,
		wp.bullet_speed: 700,
		wp.reload_time:1.5,
		wp.cost: 800,
		wp.slot: weapon_types.primary
		},
		{
		wp.w_name:"M1 Garand",
		wp.type: "Rifle",
		wp.damage:25,
		wp.ammo:7,
		wp.ammo_type: ammo_types.seven_mm,
		wp.bullet_speed: 700,
		wp.reload_time:1.5,
		wp.cost: 700,
		wp.slot: weapon_types.primary
		},
		{
		wp.w_name:"Mosin Nagant",
		wp.type: "Rifle",
		wp.damage:60,
		wp.ammo:8,
		wp.ammo_type: ammo_types.seven_mm,
		wp.bullet_speed: 800,
		wp.reload_time:2,
		wp.cost: 900,
		wp.slot: weapon_types.primary
		},
		{
		wp.w_name:"LMG",
		wp.type: "Rifle",
		wp.damage:10,
		wp.ammo:60,
		wp.ammo_type: ammo_types.five_mm,
		wp.bullet_speed: 500,
		wp.reload_time:3,
		wp.cost: 2000,
		wp.slot: weapon_types.primary
		},
		{
		wp.w_name:"grenade",
		wp.type: "Throwable",
		wp.damage:100,
		wp.ammo:1, # amount you buy
		wp.ammo_type: ammo_types.twelve_gauge,
		wp.bullet_speed: 500,
		wp.reload_time:3,
		wp.cost: 80,
		wp.slot: weapon_types.throwable
		},
]
enum weapon_types {
	primary=0,
	secondary=1,
	melee=2,
	throwable=3
}

enum ammo_types{
	twelve_gauge=0,
	nine_mm=1,
	seven_mm=2,
	five_mm=3
}
var root_player_ammo_collection = {
	ammo_types.twelve_gauge: 0,
	ammo_types.nine_mm: 34,
	ammo_types.seven_mm: 0,
	ammo_types.five_mm: 0 
	
}
var player_weapon_loadout = {  #This is the starting loadout, m1911 and knife
	weapon_types.primary: weapon_ids.null_weapon,
	weapon_types.secondary: weapon_ids.m1911,
	weapon_types.melee: weapon_ids.knife,
	weapon_types.throwable: weapon_ids.null_weapon

}
var player_weapon_collection=[weapon_ids.knife,weapon_ids.m1911]
var player_grenade_collection = 0
var max_grenades=4
var player_money = 2000

var crack_house_scene = preload("res://Scenes/levels/crackhouse.tscn")
var crack_house_end = preload("res://Scenes//crackhouse_end.tscn")
var warehouse_scene = preload("res://Scenes/levels/warehouse.tscn")
var warehouse_end = preload("res://Scenes/warehouse_end_scene.tscn")
var hideout_scene = preload("res://Scenes/levels/hideout.tscn")
var hideout_end_scene = preload("res://Scenes/hideout_end_scene.tscn")
var harbour_scene = preload("res://Scenes/levels/harbour.tscn")
var harbour_end_scene = preload("res://Scenes/harbour_endscene.tscn")
var cargoship_scene = preload("res://Scenes/levels/cargoship.tscn")
var cargo_ship_end_scene = preload("res://Scenes/cargoship_endScene.tscn")
var level_holder
var levels = [crack_house_scene,warehouse_scene, hideout_scene,harbour_scene, cargoship_scene]
var level_end_animations = [crack_house_end,warehouse_end, hideout_end_scene,harbour_end_scene,cargo_ship_end_scene]
var level_index = 3
var audio_listener: AudioListener2D


func _ready():
	level_holder=$LevelHolder
	level_holder.connect("level_complete",increment_level_index)
	$InbetweenLevelUI/VBoxContainer/HBoxContainer/ConRetryButton.connect("pressed",load_level)
	$ShopUI/Divider/LHS/HBoxContainer/ConRetryButton.connect("pressed",load_level)
	$ShopUI/Divider/LHS/HBoxContainer/LoadoutButton.connect("pressed",display_loadoutUI)
	$LoadoutUI/FirstVbox/MenuButtons/ConRetryButton.connect("pressed",load_level)
	$LoadoutUI/FirstVbox/MenuButtons/StoreButton.connect("pressed",display_ShopUI)

	$InbetweenLevelUI/VBoxContainer/StoreButton.connect("pressed",display_ShopUI)
	$InbetweenLevelUI/VBoxContainer/HBoxContainer/LoadoutButton.connect("pressed",display_loadoutUI)
	audio_listener=$MenuAudioListener
func increment_level_index(): # does more than that now but who cares
	root_player_ammo_collection=$LevelHolder.ammo_collected_temp
	player_money+=$LevelHolder.money_collected_temp
	level_index+=1
func _on_main_menu_start_game() -> void:
	level_holder.load_level_sequence(levels[level_index], level_end_animations[level_index])
func load_level():
	$InbetweenLevelUI.visible=false
	$LoadoutUI.visible=false
	$ShopUI.visible=false
	#disabling the buttons yayayayayayayy: 2 is ignore...
	$InbetweenLevelUI/VBoxContainer/StoreButton.mouse_filter=2
	$InbetweenLevelUI/VBoxContainer/HBoxContainer/LoadoutButton.mouse_filter=2
	$InbetweenLevelUI/VBoxContainer/HBoxContainer/ConRetryButton.mouse_filter=2
	#Shop UI
	$ShopUI/Divider/LHS/HBoxContainer/ConRetryButton.mouse_filter=2
	$ShopUI/Divider/LHS/HBoxContainer/LoadoutButton.mouse_filter=2
	
	level_holder.load_level_sequence(levels[level_index],level_end_animations[level_index])
func display_loadoutUI():
	$InbetweenLevelUI.visible=false
	$InbetweenLevelUI/VBoxContainer/StoreButton.mouse_filter=2
	$InbetweenLevelUI/VBoxContainer/HBoxContainer/LoadoutButton.mouse_filter=2
	$InbetweenLevelUI/VBoxContainer/HBoxContainer/ConRetryButton.mouse_filter=2
	$ShopUI.visible =false
	$ShopUI/Divider/LHS/HBoxContainer/ConRetryButton.mouse_filter=2
	$ShopUI/Divider/LHS/HBoxContainer/LoadoutButton.mouse_filter=2
	$ShopUI/Divider/LHS/AmmoPanel.disable_buttons()
	$ShopUI/Divider/LHS/ShopPanel/ShopVbox.disable_buttons()
	$ShopUI/Divider/StatsAndMoney/StatsPanel/StatsBox/PurchaseButton.mouse_filter=2
	#Enabling loadout
	$LoadoutUI.visible=true
	$LoadoutUI.enable_buttons()
	
	#updaing the ammo amount text text
	
	$LoadoutUI/FirstVbox/MenuButtons/AmmoStores/HBoxContainer/tgauge762mmvbox/tgaugeHbox/tgaugeamount.text="12 Gauge: "+str(root_player_ammo_collection[ammo_types.twelve_gauge])
	$LoadoutUI/FirstVbox/MenuButtons/AmmoStores/HBoxContainer/tgauge762mmvbox/sevenmmHbox/sevenmmAmount.text="7.62mm: "+str(root_player_ammo_collection[ammo_types.seven_mm])
	$LoadoutUI/FirstVbox/MenuButtons/AmmoStores/HBoxContainer/ninemm556mmVbox/fivemmHbox/fivemmAmount.text="5.56mm: "+str(root_player_ammo_collection[ammo_types.five_mm])
	$LoadoutUI/FirstVbox/MenuButtons/AmmoStores/HBoxContainer/ninemm556mmVbox/ninemmHbox/ninemmAmount.text="9mm: "+str(root_player_ammo_collection[ammo_types.nine_mm])
	
	
func display_ShopUI():
	$InbetweenLevelUI.visible=false
	$InbetweenLevelUI/VBoxContainer/StoreButton.mouse_filter=2
	$InbetweenLevelUI/VBoxContainer/HBoxContainer/LoadoutButton.mouse_filter=2
	$InbetweenLevelUI/VBoxContainer/HBoxContainer/ConRetryButton.mouse_filter=2
 	#NOTE when loadout is complete add the button disablers
	$LoadoutUI.visible=false
	$LoadoutUI.disable_buttons()
	$ShopUI.visible=true
	$ShopUI/Divider/LHS/HBoxContainer/ConRetryButton.mouse_filter=0
	$ShopUI/Divider/LHS/HBoxContainer/LoadoutButton.mouse_filter=0
	$ShopUI/Divider/StatsAndMoney/MoneyBox/Money.text="$"+str(player_money)
	$ShopUI/Divider/LHS/AmmoPanel.enable_buttons()
	$ShopUI/Divider/LHS/ShopPanel/ShopVbox.enable_buttons()
	$ShopUI/Divider/StatsAndMoney/StatsPanel/StatsBox/PurchaseButton.mouse_filter=0
