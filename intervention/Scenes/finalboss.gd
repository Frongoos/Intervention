extends enemy_complete
func take_damage(damage: int, type: damage_types):
	health-=damage
	if health<=0:
		while iterator<money_instances:
			var money_var = money_scene.instantiate()
			money_var.value = randi_range(min_money_drop,max_money_drop)
			money_var.global_position=global_position
			add_sibling(money_var)
			iterator+=1
		create_dead_body()
		get_parent().get_node("EndGameTimer").start(0.0)
		get_parent().get_child(0).movement_enabled=false
		drop_ammo()
		queue_free()
		
	if (state==enemy_state.wander_move_to_point or state==enemy_state.wander_idle):
		setup_rotation(player_target.global_position)
		match (randi_range(0,1)):
			0:
				state=enemy_state.charge
			1:
				state=enemy_state.strafe
