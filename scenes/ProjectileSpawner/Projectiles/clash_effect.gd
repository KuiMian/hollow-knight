extends Projectile
class_name ClashEffect


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _process(_delta: float) -> void:
	check_qf_flag()
	
	if queue_free_flag:
		queue_free()

func play_animation() -> void:
	animation_player.play("default")

func check_qf_flag() -> void:
	queue_free_flag = false if animation_player.is_playing() else true
