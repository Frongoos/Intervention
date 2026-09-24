extends Area2D
class_name exitIndicatorArea
var text_sprite
var jitter_amount=0.1
func _ready(): # o
	text_sprite=$ExitSign
	collision_layer=0
	collision_mask=2
	text_sprite.visible=false
	connect("area_entered",display_text)
	connect("area_exited",hide_text)

func display_text(area):
	text_sprite.visible=true
func hide_text(area):
	text_sprite.visible=false
