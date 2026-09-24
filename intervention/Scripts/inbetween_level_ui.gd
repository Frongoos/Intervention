extends Control
var vbox_1
var hbox_2
var loadout_button
var store_button
var conretry_button
func _ready():
	loadout_button=$VBoxContainer/HBoxContainer/LoadoutButton
	store_button=$VBoxContainer/StoreButton
	vbox_1=$VBoxContainer
	hbox_2=$VBoxContainer/HBoxContainer
	conretry_button=$VBoxContainer/HBoxContainer/ConRetryButton
	loadout_button.mouse_filter=MouseFilter.MOUSE_FILTER_IGNORE
	store_button.mouse_filter=MouseFilter.MOUSE_FILTER_IGNORE
	conretry_button.mouse_filter=MouseFilter.MOUSE_FILTER_IGNORE

func display(state :int):
	loadout_button.mouse_filter=MouseFilter.MOUSE_FILTER_STOP
	store_button.mouse_filter=MouseFilter.MOUSE_FILTER_STOP
	conretry_button.mouse_filter=MouseFilter.MOUSE_FILTER_STOP
	visible=true
	#state 0 is loss, state 1 is win 
	match state:
		0:
			conretry_button.icon=load("res://Sprites/retry_spirte.png")
		1:
			conretry_button.icon=load("res://Sprites/continue_sprite.png")
