extends BossState
class_name BossDie


func Enter():
	super.Enter()
	
	actor.enter_die()


func get_next_state_str() -> String:
	#actor = get_actor()
	#
	#if actor.animation_player.is_playing():
		#next_state_str = "Stun"
	#else:
		#next_state_str = "Idle"
	
	next_state_str = "Die"
	
	return prefix + next_state_str
