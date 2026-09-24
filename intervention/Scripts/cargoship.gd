extends level
func _ready() -> void:
	super()
	$EndGameTimer.connect("timeout",end)
func end():
	level_complete.emit()
