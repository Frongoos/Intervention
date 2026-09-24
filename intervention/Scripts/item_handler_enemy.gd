extends Node2D
class_name item_handler_enemy
var weapons: Dictionary
var current_weapon: Object
var weapons_size: int
enum types{
	nul=0,
	rifle=1,
	pistol=2,
	melees=3,
	throw=4
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for item in owner.starting_weapons:
		var temp_weapon = item.instantiate()
		add_child(temp_weapon)
		if temp_weapon.type==types.nul:
			pass
		else:
			temp_weapon.sprite.visible=false
		temp_weapon.set_owner(owner)
	
		weapons[temp_weapon.type]=temp_weapon
	current_weapon = weapons[types.nul]
	if owner.starting_weapons.size()<2: # only knife so just get in there 
		owner.ignore_min_distance=true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if current_weapon==null:
		pass
	else:
		current_weapon.physics_process(delta)

func change_weapon_request(weapon_index) ->bool:
	if weapons.has(weapon_index):
		current_weapon.holster()
		current_weapon=weapons[weapon_index]
		current_weapon.wield()
		return true
	else:
		return false
