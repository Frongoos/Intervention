extends Control
enum ammo_types{
	twelve_gauge=0,
	nine_mm=1,
	seven_mm=2,
	five_mm=3
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
var root
var shop_vbox
var stats_box
var stats_visible=false
var selected_item: int
var selected_item_object
var ammo_panel

var twelve_gauge_amount= 8
var twelve_gauge_cost= 50

var nine_mm_amount= 25
var nine_mm_cost= 50

var seven_mm_amount= 20
var seven_mm_cost = 50

var five_mm_amount = 20
var five_mm_cost = 50
var purchase_noise_player: AudioStreamPlayer2D
signal weapon_purchased
func _ready():
	visible=false
	root=get_parent()
	purchase_noise_player = $PurchaseNoisePlayer
	shop_vbox=$Divider/LHS/ShopPanel/ShopVbox
	stats_box = $Divider/StatsAndMoney/StatsPanel/StatsBox
	ammo_panel=$Divider/LHS/AmmoPanel
	for item in ammo_panel.get_children():
		item.connect("pressed_data",display_weapon_stats)

	$Divider/StatsAndMoney/StatsPanel/StatsBox/PurchaseButton.mouse_filter=2
	for child in stats_box.get_children():
		child.visible=false
	for hbox in shop_vbox.get_children():
		for item in hbox.get_children():
			item.connect("pressed_data",display_weapon_stats)
	
	$Divider/StatsAndMoney/StatsPanel/StatsBox/PurchaseButton.connect("pressed",purchase_weapon)
	
	# disa
func display_weapon_stats(weapon_id: int, shop_icon):
	selected_item_object=shop_icon
	selected_item=weapon_id
	if not stats_visible:
		$Divider/StatsAndMoney/StatsPanel/StatsBox/PurchaseButton.mouse_filter=0 
		for child in stats_box.get_children():
			child.visible=true
		stats_visible=true
	#weapon case
	if selected_item<=17:
		stats_box.get_child(0).visible=true
		stats_box.get_child(1).visible=true
		stats_box.get_child(2).visible=true
		stats_box.get_child(3).visible=true
		stats_box.get_child(4).visible=true
		stats_box.get_child(5).visible=true
		stats_box.get_child(6).visible=true
		stats_box.get_child(8).visible=false
		$Divider/StatsAndMoney/StatsPanel/StatsBox/PurchaseButton.mouse_filter=0 

		stats_box.get_child(0).text=root.weapon_stats[weapon_id][wp.w_name]
		stats_box.get_child(1).text=root.weapon_stats[weapon_id][wp.type]
		stats_box.get_child(2).text="Damage: "+str(root.weapon_stats[weapon_id][wp.damage])
		stats_box.get_child(3).text="Ammo: "+ str(root.weapon_stats[weapon_id][wp.ammo])
		stats_box.get_child(4).text="Reload Time: "+str(root.weapon_stats[weapon_id][wp.reload_time])+"s"
		stats_box.get_child(5).text="Bullet Speed: "+str(root.weapon_stats[weapon_id][wp.bullet_speed])
		var ammo_type_as_text: String
		match root.weapon_stats[weapon_id][wp.ammo_type]:
			ammo_types.twelve_gauge:
				ammo_type_as_text="Ammo Type: 12 Gauge"
			ammo_types.nine_mm:
				ammo_type_as_text="Ammo Type: 9mm"
			ammo_types.seven_mm:
				ammo_type_as_text="Ammo Type: 7.62mm"
			ammo_types.five_mm:
				ammo_type_as_text="Ammo Type: 5.56mm"
		stats_box.get_child(6).text=ammo_type_as_text
		stats_box.get_child(7).text="Cost: $"+str(root.weapon_stats[weapon_id][wp.cost])
	elif selected_item >=19 and selected_item<=22: # ammo case
		stats_box.get_child(0).visible=true
		stats_box.get_child(1).visible=true
		stats_box.get_child(2).visible=true
		stats_box.get_child(3).visible=false
		stats_box.get_child(4).visible=false
		stats_box.get_child(5).visible=false
		stats_box.get_child(6).visible=false
		stats_box.get_child(8).visible=true
		$Divider/StatsAndMoney/StatsPanel/StatsBox/PurchaseButton.mouse_filter=0 
		
		match selected_item:
			19:# twelve gauge
				stats_box.get_child(0).text="12 Gauge"
				stats_box.get_child(1).text="Used in shotguns"
				stats_box.get_child(2).text="Amount: "+str(twelve_gauge_amount)
				stats_box.get_child(7).text="Cost: "+str(twelve_gauge_cost)
				
			20: # 9mm
				stats_box.get_child(0).text="9mm"
				stats_box.get_child(1).text="Mainly used in handguns"
				stats_box.get_child(2).text="Amount: "+str(nine_mm_amount)
				stats_box.get_child(7).text="Cost: "+str(nine_mm_cost)
			21:
				stats_box.get_child(0).text="7.62mm"
				stats_box.get_child(1).text="Used in hunting rifles"
				stats_box.get_child(2).text="Amount: "+str(seven_mm_amount)
				stats_box.get_child(7).text="Cost: "+str(seven_mm_cost)
			22:
				stats_box.get_child(0).text="5.56mm"
				stats_box.get_child(1).text="NATO rounds"
				stats_box.get_child(2).text="Amount: "+str(five_mm_amount)
				stats_box.get_child(7).text="Cost: "+str(five_mm_cost)
	elif weapon_id==weapon_ids.grenades: # grenade case
		stats_box.get_child(0).visible=true
		stats_box.get_child(1).visible=true
		stats_box.get_child(2).visible=true
		stats_box.get_child(3).visible=false
		stats_box.get_child(4).visible=false
		stats_box.get_child(5).visible=false
		stats_box.get_child(6).visible=false
		stats_box.get_child(8).visible=true
		$Divider/StatsAndMoney/StatsPanel/StatsBox/PurchaseButton.mouse_filter=0 
		
		stats_box.get_child(0).text="Grenades"
		stats_box.get_child(1).text="Throwable fragmentation grenades"
		stats_box.get_child(2).text="Amount: "+str(root.weapon_stats[weapon_id][wp.ammo])
		stats_box.get_child(7).text = "Cost: "+ str(root.weapon_stats[weapon_id][wp.cost])
func purchase_weapon():
	print("Button pressed")
	if selected_item <=17:  #yayay wepaon case
		if root.weapon_stats[selected_item][wp.cost]<=root.player_money: #if funds available
			purchase_noise_player.play(0.0)
			root.player_money-=root.weapon_stats[selected_item][wp.cost]
			$Divider/StatsAndMoney/MoneyBox/Money.text="$"+str(root.player_money)
			root.player_weapon_collection.append(selected_item)
			for child in stats_box.get_children():
				child.visible=false
			$Divider/StatsAndMoney/StatsPanel/StatsBox/PurchaseButton.mouse_filter=2
			stats_visible=false
			#getting rid of icon and moving everything else
			var iterator=selected_item_object.get_parent()
			selected_item_object.queue_free()
			while (iterator.index <3 and iterator.get_parent().get_child(iterator.index+1).get_children().size()>0):
				var moving_node = iterator.get_parent().get_child(iterator.index+1).get_child(0)
				iterator.get_parent().get_child(iterator.index+1).remove_child(moving_node)
				iterator.add_child(moving_node)
				iterator=iterator.get_parent().get_child(iterator.index+1)
			weapon_purchased.emit(selected_item)
	elif selected_item==weapon_ids.grenades:
		if root.weapon_stats[selected_item][wp.cost]<=root.player_money: #if funds available
			root.player_money-=root.weapon_stats[selected_item][wp.cost]
			purchase_noise_player.play(0.0)

			$Divider/StatsAndMoney/MoneyBox/Money.text="$"+str(root.player_money)
			if root.player_grenade_collection <=0: # adding the item to the loadout if there isnt enough
				root.player_weapon_collection.append(selected_item)
				weapon_purchased.emit(selected_item)
			
			root.player_grenade_collection+=root.weapon_stats[selected_item][wp.ammo] # ammo is the amount fro grenades
			

	elif selected_item>=19 and selected_item <=22: #ammo case
		var ammo_type = selected_item-19
		match ammo_type:
			ammo_types.twelve_gauge:
				if root.player_money>=twelve_gauge_cost:
					root.player_money-=twelve_gauge_cost
					purchase_noise_player.play(0.0)

					root.root_player_ammo_collection[ammo_type]+=twelve_gauge_amount
			ammo_types.nine_mm:
				if root.player_money>=nine_mm_cost:
					root.player_money-=nine_mm_cost
					purchase_noise_player.play(0.0)

					root.root_player_ammo_collection[ammo_type]+=nine_mm_amount
			ammo_types.seven_mm:
				if root.player_money>=seven_mm_cost:
					root.player_money-=seven_mm_cost
					purchase_noise_player.play(0.0)

					root.root_player_ammo_collection[ammo_type]+=seven_mm_amount
			ammo_types.five_mm:
				if root.player_money>=five_mm_cost:
					root.player_money-=five_mm_cost
					purchase_noise_player.play(0.0)

					root.root_player_ammo_collection[ammo_type]+=five_mm_amount
		$Divider/StatsAndMoney/MoneyBox/Money.text="$"+str(root.player_money)
