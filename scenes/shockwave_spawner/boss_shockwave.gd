extends Projectile
class_name BossShockwave

@onready var enemy_hit_box_area: EnemyHitBox = $EnemyHitBoxArea


func set_texture() -> void:
	sprite_2d.texture = projectile_texture
	sprite_2d.hframes = 4
	sprite_2d.vframes = 1
	sprite_2d.frame = 0
	sprite_2d.position = Vector2(0, -16)

func _update_facing_direction() -> void:
	super._update_facing_direction()
	
	enemy_hit_box_area.scale.x = - sign(direction)
