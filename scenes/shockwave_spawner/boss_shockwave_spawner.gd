extends ProjectileSpawner
class_name BossShockwaveSpawner


func get_actor() -> Boss:
	actor = get_tree().get_first_node_in_group("bosses")
	return actor

func get_manager() -> Node:
	manager = get_tree().get_first_node_in_group("enemy_manager")
	return manager
