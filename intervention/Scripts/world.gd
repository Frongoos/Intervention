extends Node2D
class_name level
signal navigation_baked
signal level_complete
signal level_failed
var complete_condition = false
var money_collected=0
enum level_failed_reasons{
	player_death=0,
	mission_fail=1
}
var level_failed_reason
var nav_region_holder: Node
var num_of_nav_regions=0
var num_of_baked_regions=0
var delaying=true
var t_delay =0.0
var delay =0.3 
var navigation_regions: Array
# Called when the node enters the scene tree for the first time.
func _ready():
	get_child(0).connect("player_death",player_death)
	nav_region_holder = get_node("NavRegions")
	
	for child in nav_region_holder.get_children():
		if child is NavigationRegion2D:
			num_of_nav_regions+=1
			navigation_regions.append(child)
	for navregion in navigation_regions:
		navregion.connect("bake_finished",nav_region_baked)
		navregion.bake_navigation_polygon(false)
	
func _physics_process(delta: float) -> void:
	if delaying:
		t_delay+=delta
		if t_delay>=delay:
			delaying=false
			navigation_baked.emit()
func exit_door_used():
	level_complete.emit()
	print("Level complete")
		
func player_death() -> void:
	level_failed.emit()
func nav_region_baked():
	num_of_baked_regions+=1
	if num_of_baked_regions>=num_of_nav_regions: 
		for child in get_children():
			if child is enemy_complete:
				child.on_navigation_baked()
				child.navigation_baked=true
		delaying=true		
		print("delaying activated")
