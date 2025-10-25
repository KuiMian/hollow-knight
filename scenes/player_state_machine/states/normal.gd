extends PlayerState
class_name Normal


func Update_phy(_delta: float):
	var player := get_actor()
	player._physics_process4normal(_delta)

func get_next_state_str() -> String:
	var player := get_actor()
	
	if Input.is_action_just_pressed("dash") and player.can_dash:
		next_state_str = "Dash"
	elif Input.is_action_just_pressed("attack") and player.attack_timer.is_stopped():
		if Input.is_action_pressed("look_up"):
			next_state_str = "AttackUp"
		elif !player.is_on_floor() and Input.is_action_pressed("look_down"):
			next_state_str = "AttackDown"
		else:
			next_state_str = "Attack"
	else:
		next_state_str = self.name
	
	return next_state_str
	
