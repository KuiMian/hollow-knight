extends Projectile
class_name PlayerShockwave

@onready var player_hit_box_area: PlayerHitBox = $PlayerHitBoxArea


func set_texture() -> void:
	sprite_2d.texture = projectile_texture
	sprite_2d.hframes = 4
	sprite_2d.vframes = 1
	sprite_2d.frame = 0
	sprite_2d.position = Vector2(0, -16)

func _update_facing_direction() -> void:
	# 注意黑波与白波的素材朝向不同
	sprite_area.scale.x = sign(direction)
	player_hit_box_area.scale.x = sign(direction)
