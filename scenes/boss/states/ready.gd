extends BossState
class_name BossReady


func Update_phy(_delta: float):
	super.Update_phy(_delta)

func Exit():
	super.Exit()
	
	actor.exit_ready()

func get_next_state_str() -> String:
	# 用main负责的大门close函数或者另设battle信号发射信号触发最佳
	if abs(actor.player_position.x - actor.global_position.x) < 200:
		next_state_str = "Idle"
	else:
		next_state_str = "Ready"
	
	return prefix + next_state_str
