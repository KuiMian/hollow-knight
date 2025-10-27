extends PlayerState
class_name Normal

const NO_FORCE := 'NO_FORCE'
var force_state_str := NO_FORCE


#func _ready() -> void:
	#call_deferred("_connect_player_signals")
#
#func _connect_player_signals() -> void:
	#var player := actor as Player
	#if player:
		#player.attack_down_start.connect(_set_force_state)
	## defend programming
	#else:
		#push_warning("Normal state: actor not ready, cannot connect signals.")

func _set_force_state(new_force_state_str: String) -> void:
	self.force_state_str = new_force_state_str

func Update_phy(_delta: float):
	super.Update_phy(_delta)
	
	var player := get_actor()
	player._physics_process4normal(_delta)

func get_next_state_str() -> String:
	if force_state_str != NO_FORCE:
		var temp_state_str: String = force_state_str
		force_state_str = NO_FORCE
		
		return temp_state_str
	
	var player := get_actor()
	
	if Input.is_action_just_pressed("dash") and player.can_dash:
		next_state_str = "Dash"
	elif Input.is_action_just_pressed("attack") and player.attack_timer.is_stopped():
		if Input.is_action_pressed("look_up"):
			next_state_str = "AttackUp"
		elif !player.is_on_floor() and Input.is_action_pressed("look_down"):
			next_state_str = "AttackDown"
		else:
			next_state_str = "Attack"
	else:
		next_state_str = self.name
	
	return next_state_str
	
