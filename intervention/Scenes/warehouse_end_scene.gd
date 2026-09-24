extends level_end_scene
var animation = 0 # 0 is floppy 1 is computer
func _ready():
	$StartTimer.start(0.0)
	$StartTimer.connect("timeout",start)
func start():
	$AnimatedSprite2D.visible=true
	$AnimatedSprite2D.play("FloppyLoad")
	$AnimatedSprite2D.connect("animation_finished",animation_finished)
func animation_finished():
	if animation ==0:
		$AfterFLoppyDelay.start(0.0)
		$AfterFLoppyDelay.connect("timeout",start_computer)
	else:
		$AfterComputerDelay.start(0.0)
		$AfterComputerDelay.connect("timeout",end)
func start_computer():
	$AnimatedSprite2D.play("Computer")
	animation+=1
func end():
	scene_complete.emit()
