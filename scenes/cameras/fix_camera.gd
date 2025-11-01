extends Camera2D

var player_position := Vector2.ZERO
@onready var door: Door = $"../DeviceManager/Door"


func _ready() -> void:
	global_position = Vector2(584, 376)

func _process(delta: float) -> void:
	match_player_position()
	
	if player_position.x > 304 and player_position.x < 584:
		global_position.x = lerp(player_position.x, global_position.x, pow(2, -7 * delta))
		
	if player_position.x < 304:
		global_position.x = lerp(152.0, global_position.x, pow(2, -7 * delta))
		
		if door.can_work:
			door.close()
	
	if player_position.x > 584:
		global_position.x = lerp(584.0, global_position.x, pow(2, -7 * delta))

func match_player_position() -> void:
	var player: Player = get_tree().get_first_node_in_group("players")
	player_position = player.global_position
