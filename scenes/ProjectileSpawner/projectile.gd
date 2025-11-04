extends Node2D
class_name Projectile

var speed: Vector2

# 这里只考虑水平方向的速度
var direction := 0

@onready var sprite_area: Area2D = $SpriteArea

var queue_free_flag := false


func _ready() -> void:
	_update_facing_direction()
	
	play_animation()

func _process(delta: float) -> void:
	position += speed * delta
	
	check_qf_flag()
	
	if queue_free_flag:
		queue_free()

func play_animation() -> void:
	pass

func load_data(data: Dictionary) -> void:
	direction = data["initial_direction"]
	global_position = data["initial_position"] + Vector2(data["offset_x"] * direction, data["offset_y"]) 
	speed = Vector2(data["speed_x"] * direction, data["speed_y"])

# 子类需重构，添加hit & hurt box的朝向处理
# 另外，本体的朝向可能需要修改±，视素材的朝向而定 
func _update_facing_direction() -> void:
	#sprite_area.scale.x = - sign(direction)
	pass

# 这里子类负责重构projectile消失的条件
func check_qf_flag() -> void:
	pass
