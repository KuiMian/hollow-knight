extends CanvasLayer

@onready var state_label: Label = $StateLabel

var state_machine: BaseStateMachine


func _ready() -> void:
	state_machine = get_node("%PlayerStateMachine")
	state_machine.state_enter.connect(StateEnter)
	state_machine.state_exit.connect(StateExit)
	state_machine.state_update.connect(StateUpdate)

func _exit_tree() -> void:
	#state_machine = get_node("PlayerStateMachine")
	state_machine.state_enter.disconnect(StateEnter)
	state_machine.state_exit.disconnect(StateExit)
	state_machine.state_update.disconnect(StateUpdate)


func StateEnter(state_str: String) -> void:
	state_label.text = state_str

func StateExit(state_str: String) -> void:
	pass

func StateUpdate(state_str: String) -> void:
	pass
