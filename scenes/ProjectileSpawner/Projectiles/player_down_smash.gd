extends Projectile
class_name PlayerDawnSmash

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_hit_box_area: PlayerHitBox = $PlayerHitBoxArea


func play_animation() -> void:
	animation_player.play("default")

func check_qf_flag() -> void:
	queue_free_flag = false if animation_player.is_playing() else true
