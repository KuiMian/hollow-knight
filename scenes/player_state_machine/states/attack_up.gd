extends PlayerState
class_name AttackUp


func Enter():
	var player := get_actor()
	player.can_dash = false
	player.enter_attack_up()

func Exit():
	var player := get_actor()
	player.exit_attack_up()

func get_next_state_str() -> String:
	var player := get_actor()
	
	if player.animation_player.is_playing():
		return "AttackUp"
	
	return "Normal"
