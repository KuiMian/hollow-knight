extends Node2D

@onready var door: Door = $DeviceManager/Door
@onready var boss: Boss = $EnemyManager/Boss
@onready var boss_encounter_camera: Camera2D = $BossEncounterCamera

func _ready() -> void:
	boss_encounter_camera.player_enter_battle_area.connect(door.close)
	boss.boss_died.connect(door.open)
