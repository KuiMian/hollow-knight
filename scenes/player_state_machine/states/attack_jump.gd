extends PlayerState
class_name AttackJump

var time_count: float 


func Enter():
	super.Enter()
	
	var player := get_actor()
	player.can_dash = true
	player.can_double_jump = true
	
	time_count = 0.0


func Update_phy(_delta: float):
	super.Update_phy(_delta)
	
	time_count += _delta
	
	var player := get_actor()
	player._physics_process4attack_jump(_delta)
	


func Exit():
	super.Exit()
	
	print("Exit Attack Jump")


func get_next_state_str() -> String:
	var player := get_actor()
	#next_state_str = "Normal" if player.velocity.y > player.JUMP_VELOCITY / 2 else self.name
	
	# 不管黑猫白猫，能抓到耗子的就是好猫
	@warning_ignore("incompatible_ternary")
	next_state_str = "Normal" if time_count > 0.3 else self.name
	
	if Input.is_action_just_pressed("dash") and player.can_dash:
		next_state_str = "Dash"
	
	return next_state_str
