extends Node
class_name TimerReactCPT

@export var interval_time: float = 2.0

@onready var timer: Timer = $Timer

# TODO 应重构为export的四元列表[interval_time, timer, siganl_name, *extra_args]


func _ready() -> void:
	# TODO 子类需要调用父类ready方法
	#super._ready()
	
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = interval_time


func _process(delta: float) -> void:
	# TODO 子类需要调用父类process方法
	#super._process()
	
	pass


func _on_timer_timeout() -> void:
	pass
