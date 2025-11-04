extends PlayerState
class_name PlayerDie1


func Enter():
	super.Enter()
	
	actor.enter_die1()


func get_next_state_str() -> String:
	if actor.animation_player.is_playing():
		next_state_str =  "Die1"
	else:
		next_state_str = "Die2"
	
	return prefix + next_state_str
