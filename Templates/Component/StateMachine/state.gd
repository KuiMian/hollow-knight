extends Node
class_name State

var state_machine: BaseStateMachine
var next_state_str: String

@export var verbose := false


func _ready() -> void:
	# 注意继承
	# super._ready()
	
	state_machine = get_parent()


func Enter():
	# 注意继承
	# super.Enter()
	
	next_state_str = self.name
	state_machine.state_enter.emit(state_machine.current_state_key)
	
	if verbose:
		print("--- 已进入状态[%s] ---" % name)


func Exit():
	# 注意继承
	# super.Exit()
	next_state_str = self.name
	state_machine.state_exit.emit(state_machine.current_state_key)
	
	if verbose:
		print("--- 已退出状态[%s] ---" % name)


func Update(_delta: float):
	# 注意继承
	# super.Update(_delta)
	state_machine.state_update.emit(state_machine.current_state_key)
	
	if verbose:
		print("--- 状态更新中[%s] ---" % name)


func get_next_state_str() -> String:
	return next_state_str
