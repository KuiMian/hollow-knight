extends ProjectileSpawner
class_name RoarSpawner

func get_actor() -> Player:
	actor = get_tree().get_first_node_in_group("players")
	return actor

func get_manager() -> Node:
	manager = get_tree().get_first_node_in_group("ally_manager")
	return manager

# 这里用player.direction不行。
# 因为Normal状态下，若无左右输入，direction为0，从而projectile的direction为0
func set_direction_data() -> void:
	projectile_data["initial_direction"] = sign(actor.last_facing_direction)
