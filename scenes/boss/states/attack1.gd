extends BossState
class_name Attack1


func Enter():
	super.Enter()
	
	actor.enter_attack1()

func get_next_state_str() -> String:
	actor = get_actor()
	
	if actor.animation_player.is_playing():
		next_state_str = self.name
	else:
		next_state_str = "PrepareAttack2"
	
	return next_state_str
