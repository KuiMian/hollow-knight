extends Label
class_name TestLabel

@onready var player_state_machine: PlayerStateMachine = $"../PlayerStateMachine"


func _ready() -> void:
	player_state_machine.state_enter.connect(_on_state_change)
	text = player_state_machine.init_state_key.substr(6)

func _on_state_change(state_str: String) -> void:
	text = state_str.substr(6)
