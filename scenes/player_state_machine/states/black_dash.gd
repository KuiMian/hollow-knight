extends Node2D
class_name BlackDash

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var has_black_dash := false


func spawn_black_dash() -> void:
	animation_player.play("black_dash_BG")
