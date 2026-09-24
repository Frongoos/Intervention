extends Node2D
class_name health_pickup
var pickup_box : Area2D
@export var health = 25
var pickuptext_ = preload("res://Scenes/pickuptext.tscn")

func _ready():
	$AnimatedSprite2D.play("idle")
	pickup_box=$pickupBox
	pickup_box.connect("area_entered",pickup)
func pickup(area: hitbox):
	if not area.get_parent() is player:
		return
	area.owner.take_damage(-health, 4)
	var pickup_text = pickuptext_.instantiate()

	pickup_text.global_position=global_position
	pickup_text.text="+"+str(health)+"HP"
	pickup_text.self_modulate = Color( 0.455,0.655,0.263)
	add_sibling(pickup_text)
	
	queue_free()
