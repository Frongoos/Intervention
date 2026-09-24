extends Node
var door_open = false
	
func use_e():
	if not door_open:
		door_open=true
		$AnimationPlayer.play("open_door")
		$Button/PointLight2D.visible=false
		get_parent().get_node("NavRegions/NavigationLink2D").enabled=true
func use_f():
	use_e()
