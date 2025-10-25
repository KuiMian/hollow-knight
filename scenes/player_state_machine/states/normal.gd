extends PlayerState
class_name Normal


func Update_phy(_delta: float):
	var player := get_actor()
	player._physics_process4normal(_delta)

func get_next_state_str() -> String:
	var player := get_actor()
	
	if Input.is_action_just_pressed("dash") and player.can_dash:
		next_state_str = "Dash"
	elif Input.is_action_just_pressed("attack"):
		next_state_str = "Attack"
	else:
		next_state_str = self.name
	
	return next_state_str
	
