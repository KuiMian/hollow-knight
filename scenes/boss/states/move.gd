extends BossState
class_name BossMove


func Enter():
	super.Enter()
	
	actor.enter_move()


func Update_phy(delta: float):
	super.Update_phy(delta)
	
	actor._physics_process4move(delta)

func get_next_state_str() -> String:
	if abs(actor.global_position.x - actor.player_position.x) >= 40:
		next_state_str = "Move"
	else:
		next_state_str = "PrepareAttack1"
		
	return prefix + next_state_str
