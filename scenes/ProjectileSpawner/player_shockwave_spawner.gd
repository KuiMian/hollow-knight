extends ProjectileSpawner
class_name PlayerShockwaveSpawner


func get_actor() -> Boss:
	actor = get_tree().get_first_node_in_group("players")
	return actor

func get_manager() -> Node:
	manager = get_tree().get_first_node_in_group("ally_manager")
	return manager
