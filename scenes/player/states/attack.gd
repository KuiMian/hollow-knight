extends PlayerState
class_name PlayerAttack

var normal_attack_1_flag := true

func Enter():
	super.Enter()
	
	actor.can_dash = false
	actor.enter_attack(normal_attack_1_flag)
	normal_attack_1_flag = !normal_attack_1_flag


func Exit():
	super.Exit()
	
	actor.exit_attack()

func get_next_state_str() -> String:
	if actor.animation_player.is_playing():
		next_state_str =  "Attack"
	else:
		next_state_str = "Normal"
	
	return prefix + next_state_str
