extends PlayerState
class_name PlayerHeal


func Enter():
	super.Enter()
	
	actor.enter_heal()


func Exit():
	super.Enter()
	
	actor.exit_heal()

func get_next_state_str() -> String:
	if actor.animation_player.is_playing():
		next_state_str =  "Heal"
	else:
		next_state_str = "Normal"
	
	return prefix + next_state_str
