extends Projectile
class_name PlayerShockwave

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_hit_box_area: PlayerHitBox = $PlayerHitBoxArea


func _ready() -> void:
	# 这里可以产生碰撞时销毁projectile
	player_hit_box_area.area_entered.connect(
		func(_area: Area2D) -> void:
			queue_free_flag = true
	)
	
	super._ready()

func play_animation() -> void:
	animation_player.play("default")

func _update_facing_direction() -> void:
	# 注意黑波与白波的素材朝向不同
	sprite_area.scale.x = sign(direction)
	player_hit_box_area.scale.x = sign(direction)

func check_qf_flag() -> void:
	var player: Player = get_tree().get_first_node_in_group("players")
	if abs(global_position.x - player.global_position.x) > 600:
		queue_free_flag = true
