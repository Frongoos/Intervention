extends Area2D
class_name vertical_portal
@export var exit_name: NodePath
var exit_location: vertical_portal
var can_teleport =true
@export var up_dowm = 1 # 1 is up -1 is down
func _ready() -> void:
	exit_location=get_node(exit_name)
	connect("area_entered",teleport)
	collision_layer=0
	collision_mask=6
func teleport(hit):
	exit_location.can_teleport=false
	hit.owner.global_position = exit_location.global_position+Vector2(0,(15*-up_dowm))
