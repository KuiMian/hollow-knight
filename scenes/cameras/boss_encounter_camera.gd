extends Camera2D
class_name BossEncounterCamera

var player_position := Vector2.ZERO
@onready var door: Door = $"../DeviceManager/Door"

signal player_enter_battle_area

@export var shake_strength := 0.0
@export var recover_speed := 16.0

func _ready() -> void:
	global_position = Vector2(584, 376)

func _process(delta: float) -> void:
	match_player_position(delta)
	
	offset = Vector2(
		randf_range(-shake_strength, shake_strength), 
		randf_range(-shake_strength, shake_strength),
	).floor()
	
	shake_strength = move_toward(shake_strength, 0, recover_speed * delta)

func match_player_position(delta: float) -> void:
	var player: Player = get_tree().get_first_node_in_group("players")
	player_position = player.global_position
	
	if player_position.x > 304 and player_position.x < 584:
		global_position.x = lerp(player_position.x, global_position.x, pow(2, -7 * delta))
		
	if player_position.x < 304:
		global_position.x = lerp(152.0, global_position.x, pow(2, -7 * delta))
		
		if door.can_work:
			player_enter_battle_area.emit()
	
	if player_position.x > 584:
		global_position.x = lerp(584.0, global_position.x, pow(2, -7 * delta))

func shake_small() -> void:
	shake_strength = 3

func shake_big() -> void:
	shake_strength = 16

func freeze_time(freeze_strength: float = 0.6, active_time: float = 0.03) -> void:
	var freeze_timer := Timer.new()
	freeze_timer.wait_time = active_time
	freeze_timer.one_shot = true
	freeze_timer.timeout.connect(
		func() -> void:
			Engine.time_scale = 1
	)
	
	add_child(freeze_timer)
	
	Engine.time_scale = freeze_strength
	freeze_timer.start()
	
	
	
	
