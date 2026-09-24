extends Node
var player_node: player
var cutscene_camera: Camera2D
var fade_out_timer: Timer
var fade_out_player: AnimationPlayer
func _ready():
	cutscene_camera=$CustsceneCamera
	fade_out_timer=$FadeOutTimer
	player_node = get_parent().get_child(0)
	fade_out_player=$BlackFadeOut/BlackFadeOutPLayer
	$Area2D.connect("area_entered",end)
func start_black_fadein():
	fade_out_timer.disconnect("timeout",start_black_fadein)
	fade_out_player.play("fadeout")
	fade_out_player.connect("animation_finished",level_complete)
func level_complete():
	get_parent().exit_door_used()


func end( area) -> void:

	player_node.cutscene_mode(Vector2(1558,565)  )
	cutscene_camera.make_current()
	fade_out_timer.start(0.0)
	fade_out_timer.connect("timeout",start_black_fadein)


func _on_black_fade_out_p_layer_animation_finished(anim_name: StringName) -> void:
	get_parent().exit_door_used()
