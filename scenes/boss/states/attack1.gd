extends BossState
class_name BossAttack1


func Enter():
	super.Enter()
	
	actor.enter_attack1()

func Update_phy(delta: float):
	super.Update_phy(delta)
	
	actor._physics_process4attack1(delta)


func get_next_state_str() -> String:
	actor = get_actor()
	
	if actor.animation_player.is_playing():
		next_state_str = "Attack1"
	else:
		next_state_str = "PrepareAttack2"
	
	return prefix + next_state_str
