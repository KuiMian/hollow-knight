extends BossState
class_name Ready


func Update_phy(_delta: float):
	super.Update_phy(_delta)

func Exit():
	super.Exit()
	
	actor.exit_ready()

func get_next_state_str() -> String:
	return "Idle"
