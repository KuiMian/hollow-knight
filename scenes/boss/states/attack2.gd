extends BossState
class_name Attack2


func Enter():
	super.Enter()
	
	actor.enter_attack2()

func Update_phy(delta: float):
	super.Update_phy(delta)
	
	actor._physics_process4attack2(delta)

func get_next_state_str() -> String:
	actor = get_actor()
	
	if actor.animation_player.is_playing():
		next_state_str = self.name
	else:
		next_state_str = "Idle"
	
	return next_state_str
