extends Node2D
class_name end_level_objective
var level_root_node
var pickuptext_scene = preload("res://Scenes/pickuptext.tscn")
func _ready():
	level_root_node = get_parent()
	$AnimatedSprite2D.play("Idle")
	$Area2D.connect("area_entered",pickup)


func pickup(area: Area2D) -> void:
	if not area.get_parent() is player:
		return
	level_root_node.complete_condition=true
	var pickup_text = pickuptext_scene.instantiate()
	pickup_text.speed=10
	pickup_text.text="Objective Complete"
	pickup_text.global_position=global_position
	add_sibling(pickup_text)
	queue_free()
