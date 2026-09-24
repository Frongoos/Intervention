extends level_end_scene
func _ready():
	$StartTimer.start(0.0)
	$StartTimer.connect("timeout",play_animation)
func play_animation():
	$StartTimer.disconnect("timeout",play_animation)
	$AnimatedSprite2D.play("default")
	$AnimationTimer.start(0.0)
	$AnimationTimer.connect("timeout",end)
func end():
	$AnimationTimer.disconnect("timeout",end)
	scene_complete.emit()
