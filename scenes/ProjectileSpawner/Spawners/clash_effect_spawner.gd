extends ProjectileSpawner
class_name ClashEffectSpawner


func get_actor() -> Player:
	actor = get_tree().get_first_node_in_group("players")
	return actor

func get_manager() -> Node:
	manager = get_tree().get_first_node_in_group("ally_manager")
	return manager

func set_direction_data() -> void:
	projectile_data["initial_direction"] = sign(actor.last_facing_direction)
