extends Node2D
class_name Projectile

@export var speed_x := 240

var direction := 0

@onready var sprite_area: Area2D = $SpriteArea
@onready var sprite_2d: Sprite2D = $SpriteArea/Sprite2D

@export var projectile_texture: Texture2D

var queue_free_flag := false


func _ready() -> void:
	_update_facing_direction()
	
	play_animation()

func _process(delta: float) -> void:
	position.x += direction * speed_x * delta
	
	check_qf_flag()
	
	if queue_free_flag:
		queue_free()

func play_animation() -> void:
	pass

func load_data(_data: Dictionary) -> void:
	# example
	# speed_x = data["speed_x"]
	pass

# 子类需重构，添加hit & hurt box的朝向处理
# 另外，本体的朝向可能需要修改±，视素材的朝向而定 
func _update_facing_direction() -> void:
	#sprite_area.scale.x = - sign(direction)
	pass

# 这里子类负责重构projectile消失的条件
func check_qf_flag() -> void:
	pass
