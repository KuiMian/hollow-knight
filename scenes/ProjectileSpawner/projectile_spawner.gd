extends Node2D
class_name ProjectileSpawner

@export var projectile_data: Dictionary = {
	# offset和speed_x应为非负数，搭配direction计算最终位置
	"offset_x": 0,
	"offset_y": 0,
	"speed_x": 0,
	
	# 这个物理系数没有direction介入，正负皆可
	"speed_y": 0,
}

@export var projectile_scene: PackedScene

@onready var timer: Timer = $Timer

var actor: Node2D
var manager: Node 

# 子类重构以收紧类型
func get_actor() -> Node2D:
	return actor as Node2D

# 子类重构以收紧类型
func get_manager() -> Node:
	return manager as Node

func set_direction_data() -> void:
	projectile_data["initial_direction"] = sign(actor.direction)

func set_positon_data() -> void:
	projectile_data["initial_position"] = actor.global_position


func spawn_projectile() -> void:
	actor = get_actor()
	manager = get_manager()
	
	set_direction_data()
	set_positon_data()
	
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.load_data(projectile_data)
	
	manager.add_child(projectile)
