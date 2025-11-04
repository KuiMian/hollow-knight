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

func load_data(data: Dictionary) -> void:
	speed_x = data["speed_x"]

"""
子类需待重构，这里以的素材属性设置仅以白波为例
它们也可以放入spawner的data字典里，但是不容易管理。
除非素材有高度的统一性，比如朝向、hframes等素材属性一致。
这些属性涉及动画细节，可以硬写但是没必要。
"""
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
