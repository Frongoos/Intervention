extends Node2D
var t_1: float = 0
signal start_game
var playing = false
func _ready():
	$Intro1Bg.self_modulate.a=0
func _on_button_pressed() -> void:

	$FrontPage.visible=false
	$ControlButton.visible=false
	$ControlButton.position=Vector2(-1000,-1000)
	$ControlMenu.visible=true

func start_intro_cutscene():
	playing=true

	$ControlMenu.visible=false
	$Intro1Bg.visible=true
	$ControlButton/Button.mouse_filter=2
	$Intro1Bg/Intro1Animator.play("intro_fadein")
#AFTER INTRO FADE IN
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$Intro1Bg.frame=1
	$Note/NoteAnimator.play("intro_2")
#AFTER NOTE CAME UP

func _on_note_animator_animation_finished(anim_name: StringName) -> void:
	$Intro1Bg.visible=false
	$Note.visible=false
	$GunAndKnifeDrawer.visible=true
	$GunAndKnifeDrawer/DrawerAnimator.play("Gun_knife_fadein")

#Drawer finished


func _on_drawer_animator_animation_finished(anim_name: StringName) -> void:
	$GunAndKnifeDrawer.visible=false
	start_game.emit()
	queue_free()
func _input(event: InputEvent) -> void:
	if playing:
		if event.is_action_pressed("escape"):
			start_game.emit()
			queue_free()
	else:
		if event.is_action_pressed("escape"):
			start_intro_cutscene()
