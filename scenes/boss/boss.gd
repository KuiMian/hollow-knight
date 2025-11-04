extends CharacterBody2D
class_name Boss

@export var debug := false
var time_count := 0.0

var direction: int = -1

var gravity: float = 2000


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_area: Area2D = $SpriteArea
@onready var sprite_2d: Sprite2D = $SpriteArea/Sprite2D

@onready var hurt_box: EnemyHurtBox = $HurtBox
@onready var flash_timer: Timer = $FlashTimer

@onready var boss_state_machine: BossStateMachine = $BossStateMachine
@onready var body_hit_box: EnemyHitBox = $BodyHitBox
@onready var attack_1_hit_box: EnemyHitBox = $Attack1HitBox
@onready var attack_2_hit_box: EnemyHitBox = $Attack2HitBox

var player: Player
var player_position: Vector2

@onready var attack_interval_timer: Timer = $AttackIntervalTimer
var can_take_action := true

const BOUNDARY := [16, 288]

@onready var spike_spawner: SpikeSpawner = $SpikeSpawner

@onready var shockwave_spawner: BossShockwaveSpawner = $ShockwaveSpawner

const DASH_SPEED := 400

signal force_transition(force_state_str: String)

var health := 15

signal boss_died

func _ready() -> void:
	inject_dependency()
	
	animation_player.play("idle")
	
	hurt_box.area_entered.connect(_on_hurt_box_area_entered)
	attack_interval_timer.timeout.connect(
		func() -> void:
			can_take_action = true
	)

func _process(delta: float) -> void:
	boss_state_machine.process_update(delta)
	
	if debug:
		time_count += delta
		if time_count > 1:
			time_count = 0
			
			print(health)

func _physics_process(delta: float) -> void:
	boss_state_machine.process_phy_update(delta)
	
	move_and_slide()
	
	locate_player()


func _on_hurt_box_area_entered(_area: Area2D) -> void:
	flash_timer.start()
	sprite_2d.use_parent_material = false
	
	await flash_timer.timeout
	sprite_2d.use_parent_material = true
	
	health -= 1
	
	var force_state_str: String
	# 僵直状态受击迅速脱离僵直
	if boss_state_machine.current_state_key == "BossStun":
		force_state_str = "Idle"
		force_transition.emit(force_state_str)
	
	if health > 0:
		# Idle & Move状态下受击僵直
		if boss_state_machine.current_state_key in ["BossIdle", "BossMove"]:
			force_state_str = "Stun"
			force_transition.emit(force_state_str)
	# 生命值降为0进入死亡状态
	else:
		force_state_str = "Die"
		force_transition.emit(force_state_str)

#region ready state

func exit_ready() -> void:
	print("battle start")
	animation_player.play("idle")

#endregion ready state

#region idle state

func enter_idle() -> void:
	animation_player.play("idle")
	
	reset_velocitiy()


func _physics_process4idle(delta: float) -> void:
	face_player()
	
	reset_velocitiy()
	
	apply_gravity(delta)

#endregion idle state

#region move state

func enter_move() -> void:
	animation_player.play("move")

func _physics_process4move(delta: float) -> void:
	face_player()
	
	velocity.x = 80 * sign(direction)
	
	apply_gravity(delta)

#endregion move state

#region jump state

func enter_jump() -> void:
	face_player()
	animation_player.play("jump")
	
	# 现在boss可以“智能地”跳跃不同的距离
	velocity.x = 160 * (1 + randf()) * sign(direction)
	velocity.y = -600

func _physics_process4jump(delta: float) -> void:
	# 水平方向，大的起步速度，以及相应的摩擦力可以起到更好的视觉效果
	velocity.x -= 20 * sign(direction) * delta
	
	apply_gravity(delta)

#endregion jump state

#region fall state

func enter_fall() -> void:
	animation_player.play("fall")

func _physics_process4fall(delta: float) -> void:
	apply_gravity(delta)

#endregion fall state

#region prepare attack1 state

func enter_prepare_attack1() -> void:
	reset_velocitiy()
	
	animation_player.play("prepare_attack1")

#endregion prepare attack1 state

#region attack1 state

func enter_attack1() -> void:
	animation_player.play("attack1")

func _physics_process4attack1(delta: float) -> void:
	velocity.x = 200 * sign(direction)
	
	apply_gravity(delta)

#endregion attack1 state

#region prepare attack2 state

func enter_prepare_attack2() -> void:
	face_player()
	
	reset_velocitiy()
	
	animation_player.play("prepare_attack2")

#endregion prepare attack2 state

#region attack2 state

func enter_attack2() -> void:
	animation_player.play("attack2")
	velocity.y = -500

func _physics_process4attack2(delta: float) -> void:
	velocity.x = 80 * sign(direction)
	
	apply_gravity(delta)

func exit_attack2() -> void:
	velocity.y = 600

#endregion attack2 state

#region jump2 state

func enter_jump2() -> void:
	face_player()
	animation_player.play("jump")
	
	velocity.x = 600 * sign(direction)
	velocity.y = -600

func _physics_process4jump2(delta: float) -> void:
	velocity.x -= 20 * sign(direction) * delta
	
	apply_gravity(delta)

#endregion jump2 state

#region prepare downthrust state

func enter_prepare_downthrust() -> void:
	reset_velocitiy()
	
	animation_player.play("prepare_downthrust")

#endregion prepare downthrust state

#region downthrust state

func enter_downthrust() -> void:
	animation_player.play("downthrust")
	velocity.y = 200
	velocity.y += 100

func _physics_process4downthrust(delta: float) -> void:
	apply_gravity(delta)

func exit_downthrust() -> void:
	spike_spawner.spawn_spikes()

#endregion downthrust state

#region end downthrust state

func enter_end_downthrust() -> void:
	reset_velocitiy()
	
	animation_player.play("end_downthrust")

#endregion end downthrust state

#region backjump state

func enter_back_jump() -> void:
	face_player()
	animation_player.play("back_jump")
	
	velocity.x = -120 * sign(direction)
	velocity.y = -400

func _physics_process4back_jump(delta: float) -> void:
	velocity.x -= 20 * sign(direction) * delta
	
	apply_gravity(delta)

#endregion backjump state

#region backfall state

func enter_back_fall() -> void:
	face_player()
	animation_player.play("back_fall")

func _physics_process4back_fall(delta: float) -> void:
	apply_gravity(delta)

#endregion backjump state

#region release shockwave state

func enter_release_shockwave() -> void:
	reset_velocitiy()
	face_player()
	animation_player.play("release_shockwave")
	
	shockwave_spawner.timer.start()

func release_shockwave() -> void:
	shockwave_spawner.spawn_projectile()

#endregion release shockwave state

#region dash attack state

func enter_prepare_dash_attack() -> void:
	face_player()
	reset_velocitiy()
	
	animation_player.play("prepare_dash_attack")

#endregion dash attack state

#region dash attack state

func enter_dash_attack() -> void:
	velocity.x = DASH_SPEED * sign(direction)
	
	animation_player.play("dash_attack")

func exit_dash_attack() -> void:
	reset_velocitiy()

#endregion dash attack state

#region dash attack state

func enter_end_dash_attack() -> void:
	reset_velocitiy()
	
	animation_player.play("end_dash_attack")

#endregion dash attack state

#region stun state

func enter_stun() -> void:
	face_player()
	reset_velocitiy()
	animation_player.play("stun")

func _physics_process4stun(delta: float) -> void:
	apply_gravity(delta)

#endregion stun state

#region die state

func enter_die() -> void:
	animation_player.play("die")
	boss_died.emit()

#endregion die state

#region utils

func inject_dependency() -> void:
	boss_state_machine.actor = self
	for boss_state in boss_state_machine.get_children():
		(boss_state as BossState).actor = self
	
	# Normal -> AttackJump 依赖注入
	var node_names := ["BossIdle", "BossMove", "BossStun"]
	for node_name in node_names:
		force_transition.connect((boss_state_machine.get_node(node_name))._set_force_state)
	
	player = get_tree().get_nodes_in_group("players")[0]
	locate_player()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func locate_player() -> void:
	player_position = player.global_position

func face_player() -> void:
	direction = -1 if player_position < global_position else 1
	
	update_facing_direction()

func update_facing_direction() -> void:
	sprite_area.scale.x = - sign(direction)
		
	for box in get_tree().get_nodes_in_group("boss_boxes"):
		(box as Area2D).scale.x = - sign(direction)

func reset_velocitiy() -> void:
	velocity = Vector2.ZERO

#endregion
