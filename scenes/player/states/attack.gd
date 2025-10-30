extends PlayerState
class_name Attack

var normal_attack_1_flag := true

func Enter():
	super.Enter()
	
	var player := get_actor()
	player.can_dash = false
	player.enter_attack(normal_attack_1_flag)
	normal_attack_1_flag = !normal_attack_1_flag


func Exit():
	super.Exit()
	
	var player := get_actor()
	player.exit_attack()

func get_next_state_str() -> String:
	var player := get_actor()
	
	if player.animation_player.is_playing():
		return "Attack"
	
	return "Normal"
