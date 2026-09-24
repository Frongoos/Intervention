extends level_end_scene
func _ready():
	$AnimatedSprite2D.play("default")
	$StartTimer.connect("timeout",display_sea)
	$StartTimer.start(0.0)
func display_sea():
	$AnimatedSprite2D.play("Sea")
	$SeatoFall.start(0.0)
	$SeatoFall.connect("timeout",fall1)
func fall1():
	$AnimatedSprite2D.play("fall1")
	$Fall1tofall2.connect("timeout",fall2)
	$Fall1tofall2.start(0.0)
func fall2():
	$AnimatedSprite2D.play("fall2")
	$Fall2toEnd.start(0.0)
	$Fall2toEnd.connect("timeout",play_end)
func play_end():
	$AnimatedSprite2D.play("end")
	$AnimatedSprite2D.connect("animation_finished",end)
func end():
	scene_complete.emit()
