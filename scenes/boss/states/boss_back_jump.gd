extends BossState
class_name BossBackJump


func Enter():
	super.Enter()
	
	actor.enter_back_jump()


func Update_phy(delta: float):
	super.Update_phy(delta)
	
	actor._physics_process4back_jump(delta)

func get_next_state_str() -> String:
	if actor.velocity.y > 0:
		next_state_str = "BackFall"
	else:
		next_state_str = "BackJump"
	
	return prefix + next_state_str
