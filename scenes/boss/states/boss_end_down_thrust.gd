extends BossState
class_name BossEndDownThrust


func Enter():
	super.Enter()
	
	actor.enter_end_downthrust()

func get_next_state_str() -> String:
	actor = get_actor()
	
	if actor.animation_player.is_playing():
		next_state_str = "EndDownThrust"
	else:
		next_state_str = "Idle"
	
	return prefix + next_state_str
