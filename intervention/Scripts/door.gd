extends prop
class_name door
@export var sprite : CompressedTexture2D
var state=0
func _ready():
	$useBox.connect("area_entered",_on_use_box_area_entered)
	$Sprite2D.texture= sprite
	$AnimationPlayer.connect("animation_finished",play_close_noise)
	$AnimationPlayer.assigned_animation="open"
func use_e():
	if state==0 and not $AnimationPlayer.is_playing():
		collision_layer=0
		$AnimationPlayer.play("open")
		$LightOccluder2D.visible=false
		state=1
		$OpenNoise.play(0.0)
	elif state==1 and not $AnimationPlayer.is_playing():
		collision_layer=1
		$LightOccluder2D.visible=true
		$AnimationPlayer.play_backwards("open")
		state=0
func use_f():
	use_e()
func _on_use_box_area_entered(area: hitbox) -> void:
	if area.collision_layer==4 and state==0:
		print("Area entered")
		collision_layer=0
		var prev_time = $AnimationPlayer.current_animation_position
		$AnimationPlayer.play("open")
		$AnimationPlayer.seek(prev_time)

		$LightOccluder2D.visible=false

		state=1
func play_close_noise(animation_name):
	if state ==0: #if it is closed
		$CloseNoise.play(0.0)
