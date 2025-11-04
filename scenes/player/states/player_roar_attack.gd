extends PlayerState
class_name PlayerRoarAttack


func Enter():
	super.Enter()
	
	actor.enter_roar_attack()


func Exit():
	super.Enter()
	
	actor.exit_roar_attack()

func get_next_state_str() -> String:
	if actor.animation_player.is_playing():
		next_state_str =  "RoarAttack"
	else:
		next_state_str = "Normal"
	
	return prefix + next_state_str
