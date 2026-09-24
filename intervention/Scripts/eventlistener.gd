extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for player in owner.get_children():
		for player.item_handler.weapon in player.item_handler.get_children:
			connect(player.item_handler.weapon.)
func _process(delta: float) -> void:
	pass
