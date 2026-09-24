extends CharacterBody2D
class_name exit
@export var sprite: CompressedTexture2D
var pickuptext_scene = preload("res://Scenes/pickuptext.tscn")
var usable = true
func use_e():
	if get_parent().complete_condition:
		owner.exit_door_used()
	else:
		if usable:
			var pickup_text = pickuptext_scene.instantiate()
			usable=false
			pickup_text.speed=10
			match randi_range(0,4):
				0:
					pickup_text.text="Can't leave yet"
				1:
					pickup_text.text="I'm not a coward"
				2:
					pickup_text.text="Haven't found what I'm looking for"
				3:
					pickup_text.text="I'm better than that"
				4:
					pickup_text.text="I won't abandon her"

			pickup_text.global_position=global_position
			add_sibling(pickup_text)
			pickup_text.remove_timer.connect("timeout",make_usable)

func use_f():
	use_e()
func make_usable():
	usable=true
