extends BossState
class_name BossPrepareDashAttack


func Enter():
	super.Enter()
	
	actor.enter_prepare_dash_attack()


func get_next_state_str() -> String:
	if actor.animation_player.is_playing():
		next_state_str = "PrepareDashAttack"
	else:
		next_state_str = "DashAttack"
	
	return prefix + next_state_str
