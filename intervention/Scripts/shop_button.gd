extends Button
class_name shop_button
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
var shop_UI: Control
@export var weapon_id : weapon_ids
signal pressed_data
func _ready():
	connect("pressed",when_pressed)
func when_pressed():
	pressed_data.emit(weapon_id,self)
	
