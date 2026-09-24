extends AudioStreamPlayer2D

func _ready() -> void:
	connect("finished",queue_free)
