extends Node2D
class_name level_end_scene
signal scene_complete
func _ready():
	$AnimationPlayer.play("hed")
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		scene_complete.emit()
func end():
	scene_complete.emit()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	scene_complete.emit()
