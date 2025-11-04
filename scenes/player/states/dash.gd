extends PlayerState
class_name PlayerDash


func Enter():
	super.Enter()
	
	actor.can_dash = false
	actor.enter_dash()

func Exit():
	super.Exit()
	
	actor.exit_dash()


func get_next_state_str() -> String:
	if actor.animation_player.is_playing():
		next_state_str =  "Dash"
	else:
		next_state_str = "Normal"
	
	return prefix + next_state_str
