extends Node2D
class_name Projectile

@export var speed_x := 240

var direction := 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_area: Area2D = $SpriteArea
@onready var sprite_2d: Sprite2D = $SpriteArea/Sprite2D

@export var projectile_texture: Texture2D


func _ready() -> void:
	set_texture()
	_update_facing_direction()
	animation_player.play("default")



# 子类需待重构，这里以白波为例
func set_texture() -> void:
	sprite_2d.texture = projectile_texture
	sprite_2d.hframes = 4
	sprite_2d.vframes = 1
	sprite_2d.frame = 0
	sprite_2d.position = Vector2(0, -16)

func _process(delta: float) -> void:
	position.x += direction * speed_x * delta

# 子类需重构，添加hit & hurt box的朝向处理
# 另外，本体的朝向可能需要修改±，视素材的朝向而定 
func _update_facing_direction() -> void:
	sprite_area.scale.x = - sign(direction)
