extends BossState
class_name Idle


#const NO_FORCE := 'NO_FORCE'
#var force_state_str := NO_FORCE


func Enter():
	super.Enter()
	
	actor.enter_idle()


func _set_force_state(new_force_state_str: String) -> void:
	self.force_state_str = new_force_state_str

func Update_phy(_delta: float):
	super.Update_phy(_delta)
	
	actor._physics_process4idle(_delta)

func get_next_state_str() -> String:
	#if force_state_str != NO_FORCE:
		#var temp_state_str: String = force_state_str
		#force_state_str = NO_FORCE
		#
		#return temp_state_str
	
	#actor = get_actor()
	
	if Input.is_action_just_pressed("test_boss"):
		next_state_str = "PrepareAttack1"
	else:
		next_state_str = self.name
		
	return next_state_str
