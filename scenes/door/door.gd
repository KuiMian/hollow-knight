extends Node2D
class_name Door

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# 门只能关一次
var can_work := true
var open_flag := true


func _ready() -> void:
	animation_player.play("default")

func open() -> void:
	animation_player.play("open")
	open_flag = true

func close() -> void:
	animation_player.play("close")
	
	open_flag = false
	can_work = false
