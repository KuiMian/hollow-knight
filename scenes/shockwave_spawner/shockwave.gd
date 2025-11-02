extends Node2D
class_name Shockwave

const speed_x := 240

var direction := 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_area: Area2D = $SpriteArea
@onready var enemy_hit_box: EnemyHitBox = $EnemyHitBox


func _ready() -> void:
	_update_facing_direction()
	animation_player.play("default")

func _process(delta: float) -> void:
	position.x += direction * speed_x * delta

func _update_facing_direction() -> void:
	sprite_area.scale.x = - sign(direction)
	enemy_hit_box.scale.x = - sign(direction)
