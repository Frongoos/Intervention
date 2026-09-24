extends CharacterBody2D
var direction: Vector2
var speed=30
var collision: KinematicCollision2D
var death_noise_player: AudioStreamPlayer2D
var death_noise: AudioStreamMP3
func setup(dead_body_frames: SpriteFrames,rotationP: float, death_sound: AudioStreamMP3):
	$DeadBody.sprite_frames=dead_body_frames
	rotation=rotationP
	death_noise=death_sound
func _ready():
	$DeadBody.connect("animation_finished",start_blood_pool)
	$DeadBody.play("die")
	direction=Vector2(-cos(rotation), -sin(rotation))
	velocity=direction*speed
	death_noise_player=$DeathNoise
	death_noise_player.stream=death_noise
	death_noise_player.play(0.0)
	$HitNoise.play(0.0)
func start_blood_pool():
	$BloodPool.play("bloodpool")
func _physics_process(delta: float) -> void:
	velocity=speed*direction
	speed*=0.9
	collision=move_and_collide(velocity*delta)
	if collision:
		velocity=velocity.bounce(collision.get_normal())
	if speed<=1:
		speed=0
