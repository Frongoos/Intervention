extends Button
class_name loadout_inventory_button
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
var weapon_id: int 
signal item_clicked
func _ready():
	connect("pressed",item_pressed) # i hate this
	var empty_stylebox = StyleBoxEmpty.new()
func item_pressed():
	item_clicked.emit(weapon_id,self)
