extends BossState
class_name BossJump

func Enter():
	super.Enter()
	
	actor.enter_jump()


func Update_phy(delta: float):
	super.Update_phy(delta)
	
	actor._physics_process4jump(delta)

func get_next_state_str() -> String:
	if actor.velocity.y > 0:
		next_state_str = "Fall"
	else:
		next_state_str = "Jump"
		
	return prefix + next_state_str
