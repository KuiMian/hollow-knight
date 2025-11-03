extends BossState
class_name BossIdle


const NO_FORCE := 'NO_FORCE'
var force_state_str := NO_FORCE

@export var next_state_dict: Dictionary = {
	"Jump": 1, 
	"Jump2": 3, 
	"BackJump": 1,
}


func Enter():
	super.Enter()
	
	actor.enter_idle()


func _set_force_state(new_force_state_str: String) -> void:
	self.force_state_str = new_force_state_str

func Update_phy(delta: float):
	super.Update_phy(delta)
	
	actor._physics_process4idle(delta)


func Exit():
	super.Exit()
	
	reset_cooldown_time()

func get_next_state_str() -> String:
	if force_state_str != NO_FORCE:
		var temp_state_str: String = force_state_str
		force_state_str = NO_FORCE
		
		return prefix + temp_state_str
	
	var action_frequency_ls := expand_by_weight_dict(next_state_dict)
	
	if actor.can_take_action:
		if abs(actor.global_position.x - actor.player_position.x) <= 40:
			next_state_str = "PrepareAttack1"
		elif abs(actor.global_position.x - actor.player_position.x) <= 120:
			next_state_str = "Move"
		# Boss太靠近边界不会进入后跳状态
		elif actor.global_position.x <= actor.BOUNDARY.front() or actor.global_position.x >= actor.BOUNDARY.back():
			next_state_str = action_frequency_ls.filter(func(x): return x != "BackJump").pick_random()
		else:
			next_state_str = expand_by_weight_dict(next_state_dict).pick_random()
	else:
		next_state_str = "Idle"
	
	return prefix + next_state_str

func reset_cooldown_time() -> void:
	actor.can_take_action = false
	
	if actor.attack_interval_timer.is_stopped():
		actor.attack_interval_timer.start()

# 辅助函数，应放于global系文件
func expand_by_weight_dict(weight_map: Dictionary) -> Array:
	var _expanded: Array = []
	for key in weight_map.keys():
		for i in range(int(weight_map[key])):
			_expanded.append(key)
	return _expanded

# 辅助函数，应放于global系文件
func dict_head(d: Dictionary, n: int) -> Dictionary:
	var result := {}
	var keys = d.keys()
	
	# 生成 [key, value] 对并按 value 降序排列
	var pairs: Array = []
	for key in keys:
		pairs.append([key, d[key]])
	pairs.sort_custom(func(a, b): return a[1] > b[1])
	
	for i in range(min(n, pairs.size())):
		var k = pairs[i][0]
		result[k] = d[k]
	
	return result
