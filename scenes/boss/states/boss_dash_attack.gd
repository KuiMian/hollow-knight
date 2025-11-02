extends BossState
class_name BossDashAttack


func Enter() -> void:
	super.Enter()
	
	actor.enter_dash_attack()


func Exit() -> void:
	actor.exit_dash_attack()

func get_next_state_str() -> String:
	# 朝左未过左边界 or 朝右未过右边界
	if (actor.direction > 0 and actor.global_position.x < actor.BOUNDARY.back()) or \
		(actor.direction < 0 and actor.global_position.x > actor.BOUNDARY.front()):
		next_state_str = "DashAttack"
	else:
		next_state_str = "EndDashAttack"
	
	return prefix + next_state_str
