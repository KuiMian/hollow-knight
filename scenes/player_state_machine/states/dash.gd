extends PlayerState
class_name Dash


func Enter():
	var player := get_actor()
	player.can_dash = false
	player.dash()

func Exit():
	var player := get_actor()
	player.reset_velocitiy()

func get_next_state_str() -> String:
	var player := get_actor()
	
	if player.animation_player.is_playing():
		return "Dash"
	
	return "Normal"
