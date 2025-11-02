extends CanvasLayer
class_name HUD

var player_soul := 0 : 
	set(v):
		player_soul = min(max(0, v), 9)
		refresh_player_soul()

var player_health := 9 : 
	set(v):
		player_health = min(max(0, v), 9)
		refresh_player_health()

@onready var player_soul_animation_player: AnimationPlayer = $PlayerSoulAnimationPlayer
@onready var player_health_animation_player: AnimationPlayer = $PlayerHealthAnimationPlayer


func _ready() -> void:
	# 对象构造阶段不会调用setter
	# 这里我们需要手动调用一次
	refresh_player_soul()
	refresh_player_health()


func refresh_player_soul():
	player_soul_animation_player.play("soul" + str(player_soul))

func refresh_player_health():
	player_health_animation_player.play("health" + str(player_health))
