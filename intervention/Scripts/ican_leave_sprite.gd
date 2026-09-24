extends Sprite2D
var player_var
func _ready():
	player_var = get_parent()
	visible=false
func _physics_process(delta: float) -> void:
	global_position.x=player_var.global_position.x
	global_position.y=player_var.global_position.y+40
func play_end_condition_animation():
	visible=true
	$CanLeaveAnimator.play("i_can_leave")
	


func _on_can_leave_animator_animation_finished(anim_name: StringName) -> void:
	queue_free()
