extends BossState
class_name BossJump2

func Enter():
	super.Enter()
	
	actor.enter_jump2()


func Update_phy(delta: float):
	super.Update_phy(delta)
	
	actor._physics_process4jump2(delta)

func get_next_state_str() -> String:
	if abs(actor.global_position.x - actor.player_position.x) < 16:
		next_state_str = "PrepareDownThrust"
	else:
		next_state_str = "Jump2"
		
	return prefix + next_state_str
