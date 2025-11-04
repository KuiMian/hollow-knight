extends Node2D
class_name ProjectileSpawner

@export var projectile_data: Dictionary = {
	"start_pos": 8,
	"speed_x": 240,
}

@export var projectile_scene: PackedScene

@onready var timer: Timer = $Timer

var actor: Node2D
var manager: Node 
var initial_position: Vector2i
var initial_direction: int

# 子类重构以收紧类型
func get_actor() -> Node2D:
	return actor as Node2D

# 子类重构以收紧类型
func get_manager() -> Node:
	return manager as Node

func get_direction() -> int:
	initial_direction = sign(actor.direction)
	
	return initial_direction

func get_positon() -> Vector2i:
	# 默认从沿着actor的朝向start_pos个像素的位置生成projectile
	initial_position = actor.global_position
	initial_position.x += sign(initial_direction) * projectile_data["start_pos"]
	
	return initial_position


func spawn_projectile() -> void:
	actor = get_actor()
	manager = get_manager()
	
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.load_data(projectile_data)
	
	projectile.direction = get_direction()
	projectile.global_position = get_positon()
	
	#print("Actor:", actor, " Manager:", manager, " Initial position:", get_positon(), " Direction:", get_direction())
	#print(actor.global_position.x, "  ", projectile.global_position.x)
	manager.add_child(projectile)
