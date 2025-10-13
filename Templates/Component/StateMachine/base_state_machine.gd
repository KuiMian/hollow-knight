extends Node
class_name BaseStateMachine


var state_dic: Dictionary = {}
var current_state_key: String
var current_state: State

@export var verbose := false

@export var init_state_key: String

signal state_enter(state_str: String)
signal state_exit(state_str: String)
signal state_update(state_str: String)


func _ready() -> void:
	init_state_machine()
	

func _process(delta: float) -> void:
	var state: String = check_state()
	change_state(state)
	current_state.Update(delta)


func init_state_machine() -> void:
	
	for state in get_children():
		state_dic[state.name] = state
	
	current_state_key = init_state_key
	current_state = state_dic[current_state_key]
	
	#if verbose:
		#for _state_str in state_dic.keys(): 
			#print("[Card State] " + _state_str)


func check_state() -> String:
	
	# TODO 继承后需重载函数!!!
	# 简单逻辑重写check_state
	# 复杂逻辑重写各状态的get_next_state_str
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
