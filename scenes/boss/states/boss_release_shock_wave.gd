extends BossState
class_name BossReleaseShockwave

func Enter():
	super.Enter()
	
	actor.enter_release_shockwave()

func Update_phy(delta: float):
	super.Update_phy(delta)
	
	#actor._physics_process4release_shockwave(delta)

func get_next_state_str() -> String:
	if actor.animation_player.is_playing():
		next_state_str = "ReleaseShockwave"
	else:
		next_state_str = "Idle"
		
	
	return prefix + next_state_str
