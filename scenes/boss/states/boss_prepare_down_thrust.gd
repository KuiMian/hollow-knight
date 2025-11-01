extends BossState
class_name BossPrepareDownThrust


func Enter():
	super.Enter()
	
	actor.enter_prepare_downthrust()

func get_next_state_str() -> String:
	actor = get_actor()
	
	if actor.animation_player.is_playing():
		next_state_str = "PrepareDownThrust"
	else:
		next_state_str = "DownThrust"
	
	return prefix + next_state_str
