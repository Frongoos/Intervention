extends Label
class_name pickuptext
var speed =15
var remove_timer
func _ready():
	remove_timer=$RemoveTimer
	remove_timer.start(0.0)
	remove_timer.connect("timeout",queue_free)
func _physics_process(delta: float) -> void:
	global_position.y-=speed*delta
