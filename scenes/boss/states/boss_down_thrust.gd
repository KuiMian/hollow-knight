extends BossState
class_name BossDownThrust


func Enter():
	super.Enter()
	
	actor.enter_downthrust()

func get_next_state_str() -> String:
	actor = get_actor()
	
	if actor.is_on_floor():
		next_state_str = "EndDownThrust"
	else:
		next_state_str = "DownThrust"
	
	return prefix + next_state_str
