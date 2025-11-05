extends PlayerState
class_name PlayerPrepareDownSmash1

func Enter():
	super.Enter()
	
	actor.enter_prepare_down_smash_1()


func Exit():
	super.Enter()
	
	actor.exit_prepare_down_smash_1()

func get_next_state_str() -> String:
	if actor.animation_player.is_playing():
		next_state_str =  "PrepareDownSmash1"
	else:
		next_state_str = "PrepareDownSmash2"
	
	return prefix + next_state_str
