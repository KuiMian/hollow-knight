extends PlayerState
class_name PlayerReleaseShockwave


func Enter():
	super.Enter()
	
	actor.enter_release_shockwave()


func Exit():
	super.Enter()
	
	actor.exit_release_shockwave()

func get_next_state_str() -> String:
	if actor.animation_player.is_playing():
		next_state_str =  "ReleaseShockwave"
	else:
		next_state_str = "Normal"
	
	return prefix + next_state_str
