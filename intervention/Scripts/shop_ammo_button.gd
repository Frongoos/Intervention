extends Button
class_name shop_ammo_button
var shop_UI: Control
enum ammo_types{ # ihate my life
	twelve_gauge=19,
	nine_mm=20,
	seven_mm=21,
	five_mm=22
}

@export var weapon_id: ammo_types
signal pressed_data
func _ready():
	connect("pressed",when_pressed)
func when_pressed():
	pressed_data.emit(weapon_id,self)
	
