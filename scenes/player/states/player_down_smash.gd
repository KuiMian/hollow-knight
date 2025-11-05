extends PlayerState
class_name PlayerDownSmash

func Enter():
	super.Enter()
	
	actor.enter_down_smash()

func get_next_state_str() -> String:
	if actor.animation_player.is_playing():
		next_state_str =  "DownSmash"
	else:
		next_state_str = "Normal"
	
	return prefix + next_state_str
