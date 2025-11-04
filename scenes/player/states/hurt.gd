extends PlayerState
class_name PlayerHurt

var time_count: float 


func Enter():
	super.Enter()
	
	actor.enter_hurt()


func Update_phy(_delta: float):
	super.Update_phy(_delta)


func Exit():
	super.Exit()
	
	actor.exit_hurt()


func get_next_state_str() -> String:
	if actor.animation_player.is_playing():
		next_state_str = "Hurt"
	else:
		next_state_str = "Normal"
	
	if Global_HUD.player_health <= 0:
		next_state_str = "Die1"
	
	return prefix + next_state_str
