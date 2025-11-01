extends Label
class_name BossTestLabel

@onready var boss_state_machine: BossStateMachine = $"../BossStateMachine"


func _ready() -> void:
	boss_state_machine.state_enter.connect(_on_state_change)
	text = boss_state_machine.init_state_key.substr(4)

func _on_state_change(state_str: String) -> void:
	text = state_str.substr(4)
