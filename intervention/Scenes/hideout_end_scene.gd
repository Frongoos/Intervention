extends level_end_scene
func _ready():
	$AnimatedSprite2D.visible=false
	$StartTimer.start(0.0)
	$StartTimer.connect("timeout",play_phone)

func play_phone():
	$AnimatedSprite2D.visible=true
	$AnimatedSprite2D.play("PhoneScreen")
	$PhoneOpenTimer.start(0.0)
	$PhoneOpenTimer.connect("timeout",open_phone)
func open_phone():
	$AnimatedSprite2D.play("OpenPhone")
	$BetweenOpen.start(0.0)
	$BetweenOpen.connect("timeout",open_messages)
func open_messages():
	$AnimatedSprite2D.play("ViewMessages")
	$EndTimer.start(0.0)
	$EndTimer.connect("timeout",end)
func end():
	scene_complete.emit()
