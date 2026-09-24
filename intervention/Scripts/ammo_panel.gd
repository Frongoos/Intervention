extends HBoxContainer
func disable_buttons():
	for button in get_children():
		button.mouse_filter=2
func enable_buttons():
	for button in get_children():
		button.mouse_filter=0
