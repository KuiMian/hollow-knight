extends PlayerState
class_name PlayerDie2


func Enter():
	super.Enter()
	
	var player := get_actor()
	player.enter_die2()


func get_next_state_str() -> String:
	#var player := get_actor()
	
	#if player.animation_player.is_playing():
		#next_state_str =  "Die2"
	#else:
	next_state_str = "Die2"
	
	return prefix + next_state_str
