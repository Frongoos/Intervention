extends CharacterBody2D
class_name ammo_drop
var amount: int 
enum ammo_types{
	twelve_gauge=0,
	nine_mm=1,
	seven_mm=2,
	five_mm=3
}
var ammo_type: ammo_types
var direction: Vector2
var speed: float
var collision: KinematicCollision2D
var pickuptext_scene = preload("res://Scenes/pickuptext.tscn")
func _ready():
	match ammo_type:
		0:
			$AnimatedSprite2D.sprite_frames=load("res://Sprites/resources/12gaugedrop.tres")
		1:
			$AnimatedSprite2D.sprite_frames=load("res://Sprites/resources/9mmdrop.tres")
		2:
			$AnimatedSprite2D.sprite_frames=load("res://Sprites/resources/7.62dropmm.tres")
		3:
			$AnimatedSprite2D.sprite_frames=load("res://Sprites/resources/5.56mmdrop.tres")
	$AnimatedSprite2D.play("Idle")
	direction = Vector2(random_negative(),random_negative())
	speed=randf_range(0,50)
	velocity=direction*speed
	print("Ammo_dropped")
func _physics_process(delta: float) -> void:
	velocity=speed*direction
	speed*=0.9
	collision=move_and_collide(velocity*delta)
	if collision:
		velocity=velocity.bounce(collision.get_normal())
	if speed<=0.01:
		speed=0
func random_negative() ->int:
	match (randi_range(0,1)):
		0:
			return -1
		1: 
			return 1
	return 1 #shuts the interpreter up 


func _on_pick_up_box_area_entered(area: Area2D) -> void:
	if not area.get_parent() is player:
		return
	get_parent().get_child(0).ammo_collection[ammo_type]+=amount
	print(get_parent().get_child(0).ammo_collection[ammo_type])
	get_parent().get_child(0).ammo_picked_up.emit()

	area.get_parent().play_ammo_pickup_noise()
	var pickup = pickuptext_scene.instantiate()
	var ammo_name : String
	match ammo_type:
		ammo_types.twelve_gauge:
			ammo_name = "12 Gauge"
		ammo_types.nine_mm:
			ammo_name="9mm"
		ammo_types.seven_mm:
			ammo_name="7.62mm"
		ammo_types.five_mm:
			ammo_name="5.56mm"
			
	pickup.text =("+"+str(amount))+"  "+ammo_name
	pickup.global_position=global_position

	add_sibling(pickup)
	queue_free()
