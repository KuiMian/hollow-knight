extends PlayerState
class_name PlayerDash


func Enter():
	super.Enter()
	
	var player := get_actor()
	player.can_dash = false
	player.enter_dash()

func Exit():
	super.Exit()
	
	var player := get_actor()
	player.exit_dash()


func get_next_state_str() -> String:
	var player := get_actor()
	
	if player.animation_player.is_playing():
		next_state_str =  "Dash"
	else:
		next_state_str = "Normal"
	
	return prefix + next_state_str
