extends BossState
class_name BossFall


func Enter():
	super.Enter()
	
	actor.enter_fall()


func Update_phy(delta: float):
	super.Update_phy(delta)
	
	actor._physics_process4fall(delta)

func get_next_state_str() -> String:
	if not actor.is_on_floor():
		next_state_str = "Fall"
	else:
		next_state_str = "Idle"
		
		# 跳跃后重置攻击间隔
		actor.can_take_action = true
	
	return prefix + next_state_str
