extends BossState
class_name BossIdle


#const NO_FORCE := 'NO_FORCE'
#var force_state_str := NO_FORCE


func Enter():
	super.Enter()
	
	actor.enter_idle()


func _set_force_state(new_force_state_str: String) -> void:
	self.force_state_str = new_force_state_str

func Update_phy(delta: float):
	super.Update_phy(delta)
	
	actor._physics_process4idle(delta)


func Exit():
	super.Exit()
	
	reset_cooldown_time()

func get_next_state_str() -> String:
	#if force_state_str != NO_FORCE:
		#var temp_state_str: String = force_state_str
		#force_state_str = NO_FORCE
		#
		#return temp_state_str
	
	#actor = get_actor()
	
	if actor.can_take_action:
		if abs(actor.global_position.x - actor.player_position.x) <= 40:
			next_state_str = "PrepareAttack1"
		elif abs(actor.global_position.x - actor.player_position.x) <= 120:
			next_state_str = "Move"
		else:
			next_state_str = expand_by_weight_dict({"Jump": 2, "Jump2": 1}).pick_random()

	else:
		next_state_str = "Idle"
		
	return prefix + next_state_str

func reset_cooldown_time() -> void:
	actor.can_take_action = false
	
	if actor.attack_interval_timer.is_stopped():
		actor.attack_interval_timer.start()

# 辅助函数，应放于global系文件
func expand_by_weight_dict(weight_map: Dictionary) -> Array:
	var _expanded: Array = []
	for key in weight_map.keys():
		for i in range(int(weight_map[key])):
			_expanded.append(key)
	return _expanded
