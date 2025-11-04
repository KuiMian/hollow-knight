extends Projectile
class_name PlayerRoar


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_hit_box_area: PlayerHitBox = $PlayerHitBoxArea


func play_animation() -> void:
	animation_player.play("default")

func load_data(data: Dictionary) -> void:
	speed_x = data["speed_x"]

# 这里子类负责重构projectile消失的条件
# 这里当然可以让动画结束调用queue_free()，但是代码管理更舒服，且逻辑清晰。
func check_qf_flag() -> void:
	queue_free_flag = false if animation_player.is_playing() else true
