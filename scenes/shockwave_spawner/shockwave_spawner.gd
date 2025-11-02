extends Node2D
class_name ShockwaveSpawner

const SHOCKWAVE := preload("uid://bcbrva1jgcim")
const SHOCKWAVE_START_POS := 8

func spawn_shockwave() -> void:
	var boss: Boss = get_tree().get_first_node_in_group("bosses")
	var enemy_manager: Node = get_tree().get_first_node_in_group("enemy_manager")
	
	var shockwave: Shockwave = SHOCKWAVE.instantiate()
	shockwave.global_position.x = boss.global_position.x + sign(boss.direction) * SHOCKWAVE_START_POS
	shockwave.global_position.y = boss.global_position.y
	shockwave.direction = boss.direction
	
	enemy_manager.add_child(shockwave)
	
	# 先挂载节点再调用这个函数，因为里面涉及的节点由onready
	# 这里把这个函数放到shockwave的ready内部调用更好
	#shockwave._update_facing_direction()
	
