extends BossState
class_name BossPrepareAttack1


func Enter():
	super.Enter()
	
	actor.enter_prepare_attack1()

func get_next_state_str() -> String:
	actor = get_actor()
	
	if actor.animation_player.is_playing():
		next_state_str = "PrepareAttack1"
	else:
		next_state_str = "Attack1"
	
	return prefix + next_state_str
