extends PlayerState
class_name PlayerPrepareDownSmash2


func Enter():
	super.Enter()
	
	actor.enter_prepare_down_smash_2()

func Update_phy(delta: float):
	super.Update_phy(delta)
	
	actor._physics_process4prepare_down_smash_2(delta)

func get_next_state_str() -> String:
	if not actor.is_on_floor():
		next_state_str =  "PrepareDownSmash2"
	else:
		next_state_str = "DownSmash"
	
	return prefix + next_state_str
