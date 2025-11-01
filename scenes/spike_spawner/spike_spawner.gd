extends Node2D
class_name SpikeSpawner

const SPIKE = preload("uid://me2mjg8463y2")
const SPIKE_INTERVAL := 48

const ATTACK_RANGE := [8, 296]

func spawn_spikes() -> void:
	var boss: Boss = get_tree().get_first_node_in_group("bosses")
	var enemy_manager: Node = get_tree().get_first_node_in_group("enemy_manager")
	
	for i in range(1, 6):
		var spike_instance_left: Spike = SPIKE.instantiate()
		var spike_instance_right: Spike = SPIKE.instantiate()
		
		spike_instance_right.global_position.x = boss.global_position.x + i * SPIKE_INTERVAL
		spike_instance_right.global_position.y = 432
		spike_instance_left.global_position.x = boss.global_position.x - i * SPIKE_INTERVAL
		spike_instance_left.global_position.y = 432
		
		if spike_instance_left.global_position.x > 8:
			enemy_manager.add_child(spike_instance_left)
		
		if spike_instance_right.global_position.x < 296:
			enemy_manager.add_child(spike_instance_right)
		
		# 依次生成spike
		await get_tree().create_timer(0.2).timeout
