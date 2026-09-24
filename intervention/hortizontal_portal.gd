extends Area2D
class_name horizontal_portal
@export var exit_name: NodePath
var exit_location: horizontal_portal
var can_teleport =true
@export var enter_direction_left_right = 1 # 1 is right and -1 is left, enter direction
func _ready() -> void:
	exit_location=get_node(exit_name)
	connect("area_entered",teleport)
	collision_layer=0
	collision_mask=6
func teleport(hit):
	exit_location.can_teleport=false
	hit.owner.global_position = exit_location.global_position+Vector2((30*enter_direction_left_right),0)
