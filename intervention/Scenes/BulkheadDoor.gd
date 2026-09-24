extends CharacterBody2D
var state=0 # state 0 closed, state 1 open
var animator : AnimationPlayer
func _ready():
	animator=$AnimationPlayer
	$useBox.connect("area_entered",_on_use_box_area_entered)
func use_e():
	if state==0 and not animator.is_playing():
		animator.play("open")
		state=1
		$NoisePlayer.play(0.0)
	elif state==1 and not animator.is_playing():

		animator.play_backwards("open")
		state=0
		$NoisePlayer.play(0.0)

func use_f():
	use_e()
func _on_use_box_area_entered(area: Area2D) -> void:
	if area.collision_layer>=4 and state==0 and not area.owner is Node2D : # sp scuffed
		collision_layer=0

		var prev_time = animator.current_animation_position
		animator.play("open")
		animator.seek(prev_time)
		state=1
