extends BossState
class_name BossStun

const NO_FORCE := 'NO_FORCE'
var force_state_str := NO_FORCE

func _set_force_state(new_force_state_str: String) -> void:
	self.force_state_str = new_force_state_str

func Enter():
	super.Enter()
	
	actor.enter_stun()

func Update_phy(delta: float):
	super.Update_phy(delta)
	
	actor._physics_process4stun(delta)

func get_next_state_str() -> String:
	if force_state_str != NO_FORCE:
		var temp_state_str: String = force_state_str
		force_state_str = NO_FORCE
		
		return prefix + temp_state_str
	
	if actor.animation_player.is_playing():
		next_state_str = "Stun"
	else:
		next_state_str = "Idle"
	
	return prefix + next_state_str
