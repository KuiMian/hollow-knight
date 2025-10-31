extends BossState
class_name BossPrepareAttack2


func Enter():
	super.Enter()
	
	actor.enter_prepare_attack2()

func get_next_state_str() -> String:
	actor = get_actor()
	
	if actor.animation_player.is_playing():
		next_state_str = "PrepareAttack2"
	else:
		next_state_str = "Attack2"
	
	return prefix + next_state_str
