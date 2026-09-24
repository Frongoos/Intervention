extends BoxContainer
func disable_buttons():
	for hbox in get_children():
		for thingy in hbox.get_children():
			thingy.mouse_filter=2
func enable_buttons():
	for hbox in get_children():
		for thingy in hbox.get_children():
			thingy.mouse_filter=0
