extends BossState
class_name BossEndDashAttack


func Enter():
	super.Enter()
	
	actor.enter_end_dash_attack()

func get_next_state_str() -> String:
	if actor.animation_player.is_playing():
		next_state_str = "EndDashAttack"
	else:
		next_state_str = "ReleaseShockwave"  if randf() > 0.6 else "Idle"
	
	return prefix + next_state_str
