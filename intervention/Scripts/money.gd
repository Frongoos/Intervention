extends CharacterBody2D
var speed: float
var direction: Vector2
@export var value: int
var collision: KinematicCollision2D
var pickuptext_ = preload("res://Scenes/pickuptext.tscn")
func _ready():
	$AnimatedSprite2D.play("Idle")

	direction = Vector2(random_negative(),random_negative())
	speed=randf_range(0,50)
	velocity=direction*speed
	$PickUpBox.connect("area_entered",pickup_box_entered)
func _physics_process(delta: float) -> void:
	velocity=speed*direction
	speed*=0.9
	collision=move_and_collide(velocity*delta)
	if collision:
		velocity=velocity.bounce(collision.get_normal())
	if speed<=1:
		speed=0
	

func random_negative() ->int:
	match (randi_range(0,1)):
		0:
			return -1
		1: 
			return 1
	return 1 #shuts the interpreter up 


func pickup_box_entered(area: Area2D) -> void:
	if not area.get_parent() is player:
		return
	area.get_parent().play_money_pickup_noise()
	get_parent().money_collected+=value
	$PickUpSound.play(0.0)
	var pickup = pickuptext_.instantiate()
	pickup.global_position=global_position
	pickup.text="$"+str(value)
	pickup.self_modulate = Color( 0.455,0.655,0.263)
	add_sibling(pickup)
	
	queue_free()
	
