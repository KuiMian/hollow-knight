extends PlayerState
class_name PlayerAttackDown

var temp_can_dash: bool

func Enter():
	super.Enter()
	
	var player := get_actor()
	temp_can_dash = player.can_dash
	player.can_dash = false
	player.enter_attack_down()


func Exit():
	super.Exit()
	
	var player := get_actor()
	player.can_dash = temp_can_dash
	player.exit_attack_down()


func get_next_state_str() -> String:
	var player := get_actor()
	
	if player.animation_player.is_playing():
		next_state_str =  "AttackDown"
	else:
		next_state_str = "Normal"
	
	return prefix + next_state_str
