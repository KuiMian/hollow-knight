extends PlayerState
class_name PlayerAttackDown

var temp_can_dash: bool

func Enter():
	super.Enter()
	
	temp_can_dash = actor.can_dash
	actor.can_dash = false
	actor.enter_attack_down()


func Exit():
	super.Exit()
	
	actor.can_dash = temp_can_dash
	actor.exit_attack_down()


func get_next_state_str() -> String:
	if actor.animation_player.is_playing():
		next_state_str =  "AttackDown"
	else:
		next_state_str = "Normal"
	
	return prefix + next_state_str
