extends BossState
class_name PrepareAttack1


func Enter():
	super.Enter()
	
	actor.enter_prepare_attack1()

func get_next_state_str() -> String:
	actor = get_actor()
	
	if actor.animation_player.is_playing():
		next_state_str = self.name
	else:
		next_state_str = "Attack1"
	
	return next_state_str
