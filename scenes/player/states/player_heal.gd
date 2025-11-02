extends PlayerState
class_name PlayerHeal


func Enter():
	super.Enter()
	
	var player := get_actor()
	player.enter_heal()


func Exit():
	super.Enter()
	
	var player := get_actor()
	player.exit_heal()

func get_next_state_str() -> String:
	var player := get_actor()
	
	if player.animation_player.is_playing():
		next_state_str =  "Heal"
	else:
		next_state_str = "Normal"
	
	return prefix + next_state_str
