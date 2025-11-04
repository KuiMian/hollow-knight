extends Projectile
class_name BossShockwave

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var enemy_hit_box_area: EnemyHitBox = $EnemyHitBoxArea


func _ready() -> void:
	# 这里可以产生碰撞时销毁projectile
	enemy_hit_box_area.area_entered.connect(
		func(_area: Area2D) -> void:
			queue_free_flag = true
	)
	
	super._ready()

func play_animation() -> void:
	animation_player.play("default")

func _update_facing_direction() -> void:
	sprite_area.scale.x = - sign(direction)
	enemy_hit_box_area.scale.x = - sign(direction)

func check_qf_flag() -> void:
	if global_position.x < -64 or global_position.x > 360:
		queue_free_flag = true
