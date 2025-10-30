extends Node
class_name BaseStateMachine

#region 状态机类型
# 自治：每个状态节点不仅负责内部的逻辑，还负责状态的转换；或状态机负责状态转换。
# 委托：每个节点只负责调用宿主对象封装的逻辑函数和状态转化。
# 改良：状态机节点负责状态转换，宿主对象封装逻辑函数，状态节点负责调用宿主对象的函数。
#endregion

#region 依赖注入
# 宿主对象，应在状态机和状态重载时需要注明类型
# 注意注入顺序，宿主在ready注入状态机，状态机在ready注入状态
var actor: Node

func get_actor() -> Node:
	# 在子类中重载为宿主的类型
	return actor as Node
#endregion

var state_dic: Dictionary = {}
var current_state_key: String
var current_state: State

@export var verbose := false
@export var init_state_key: String

@warning_ignore("unused_signal")
signal state_enter(state_str: String)
@warning_ignore("unused_signal")
signal state_exit(state_str: String)
@warning_ignore("unused_signal")
signal state_update(state_str: String)
@warning_ignore("unused_signal")
signal state_update_phy(state_str: String)


func _ready() -> void:
	init_state_machine()

func process_update(delta: float) -> void:
	current_state.Update(delta)

# 在phy_process_update里确认是否状态
# 因此actor需要在phy_process调用状态机的这个函数
# 记得在后面加上move_and_slde()
func process_phy_update(delta: float) -> void:
	var state: String = check_state()
	call_deferred("change_state", state)
	current_state.Update_phy(delta)


func init_state_machine() -> void:
	for state in get_children():
		state_dic[state.name] = state
	
	current_state_key = init_state_key
	current_state = state_dic[current_state_key]
	
	if verbose:
		print("初始状态 [%s]" % current_state_key)


func check_state() -> String:
	
	# TODO 继承后需重载函数!!!
	# 简单逻辑重载check_state
	# 复杂逻辑重载各状态的get_next_state_str
	return current_state.get_next_state_str()


func change_state(state_key: String) -> void:
	
	if !state_key:
		return
	
	if state_key == current_state_key:
		return
	
	if current_state != null:
		current_state.Exit()
	
	if verbose:
		print("--- 已退出状态[%s]，准备进入状态[%s] ---" % [current_state_key, state_key])
	
	
	current_state_key = state_key
	current_state = state_dic[current_state_key]
	current_state.Enter()
