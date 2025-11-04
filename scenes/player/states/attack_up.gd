extends PlayerState
class_name PlayerAttackUp


func Enter():
	super.Enter()

	actor.can_dash = false
	actor.enter_attack_up()

func Exit():
	super.Exit()
	
	actor.exit_attack_up()

func get_next_state_str() -> String:
	if actor.animation_player.is_playing():
		next_state_str =  "AttackUp"
	else:
		next_state_str = "Normal"
	
	return prefix + next_state_str
