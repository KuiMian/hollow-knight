extends PlayerState
class_name Normal


func Update_phy(_delta: float):
	var player := get_actor()
	player._physics_process4normal(_delta)

func get_next_state_str() -> String:
	@warning_ignore("incompatible_ternary")
	return "Dash" if Input.is_action_just_pressed("dash") else self.name
