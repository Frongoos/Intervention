extends Button
class_name loadout_equipped_button#
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
@export var weapon_id:  weapon_ids
signal equiped_button_pressed
enum weapon_types {
	primary=0,
	secondary=1,
	melee=2,
	throwable=3
}
@export var slot: weapon_types
func _ready() -> void:
	connect("pressed",clicked)
func clicked():
	equiped_button_pressed.emit(weapon_id,slot,self)
