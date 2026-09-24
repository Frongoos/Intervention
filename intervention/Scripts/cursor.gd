extends Node2D
var item1_frame=0
var item2_frame =0
var Player: player
var item_hand
func _ready() -> void:
	$AnimatedSprite2D.connect("animation_finished",reload_finished)
	Player = get_parent()
	top_level=true
	item_hand=get_node("../item_handler")
	item_hand.connect("reload_attempt",stuff)

func _physics_process(delta: float) -> void:
	position=get_global_mouse_position()
func stuff(reload_duration):
	if item_hand.current_weapon.reloading:
		$AnimatedSprite2D.play("reload")
		$AnimatedSprite2D.speed_scale=3/reload_duration
func reload_finished():
	$AnimatedSprite2D.play("idle")
func cancel_animation():
	if item_hand.current_weapon.reloading:
		$AnimatedSprite2D.play("idle")
func connect_attack_fired():
	for child in item_hand.get_children():
		child.connect("attack_fired",cancel_animation)
