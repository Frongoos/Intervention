extends Node2D
class_name item_handler
var weapons: Array
var current_weapon: Object
var weapon_count: int
var cursor : Node2D
var prev_weapon
enum types{
	nul=0,
	primary=1,
	secondary=2,
	melee=3,
	throwable=4
}
signal weapon_changed
signal reload_attempt
func ready() -> void:
	cursor=get_node("../Cursor")
	
	for child in get_children():
		weapons.append(child)
		child.used_by_player=true
	current_weapon=weapons[0]
	weapon_count=weapons.size()
	current_weapon.wield()


func _physics_process(delta: float) -> void:
	prev_weapon=current_weapon
	if owner.movement_enabled:
		#TODO this is septic waste 
		if not current_weapon.bullshit_edge_case:
			if Input.is_action_just_pressed("1"):
				if weapon_count>=1:
					current_weapon.holster()
					current_weapon=weapons[0]
					current_weapon.wield()
				
			elif Input.is_action_just_pressed("2"):
				if weapon_count>=2:
					current_weapon.holster()
					current_weapon=weapons[1]
					current_weapon.wield()

			elif Input.is_action_just_pressed("3"):
				if weapon_count>=3:
					current_weapon.holster()
					current_weapon=weapons[2]
					current_weapon.wield()

			elif Input.is_action_just_pressed("4"):
				if weapon_count>=4:
					current_weapon.holster()
					current_weapon=weapons[3]
					current_weapon.wield()
		if Input.is_action_just_pressed("reload"):
			current_weapon.reload()
			if current_weapon.type==types.primary or current_weapon.type==types.secondary:
				reload_attempt.emit(current_weapon.reload_duration)

		if current_weapon.can_hold_attack:
			if Input.is_action_pressed("action"):
				current_weapon.on_attack( owner.rotation)
		else:
			if Input.is_action_just_pressed("action"):
				current_weapon.on_attack(owner.rotation)
		if Input.is_action_just_released("action"):
			current_weapon.on_released(owner.rotation)
		current_weapon.physics_process(delta)
	if prev_weapon!=current_weapon:
		weapon_changed.emit(current_weapon.type)
		
