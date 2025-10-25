extends Node2D
class_name BlackDash

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	scale = Vector2(1.2, 1.2)
	sprite_2d.hide()

func spawn_black_dash() -> void:
	#sprite_2d.show()
	animation_player.play("black_dash_BG")
	#await animation_player.animation_finished
	#sprite_2d.hide()
