extends CharacterBody2D
class_name Player

const JUMP_VELOCITY := -400.0
const ACCELERATION := 120
const START_SPEED := 90
const MAX_SPEED := 210
const SHORT_JUMP_FACTOR := 8
const FRICTION_FACTOR := 2 * ACCELERATION
const MAXDASHSPEED := 300
const SECOND_JUMP_VELOCITY := JUMP_VELOCITY
const knockback_speed := 60

@export var debug := true
var time_count := 0.0

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_area: Area2D = $SpriteArea

@onready var player_state_machine: PlayerStateMachine = $PlayerStateMachine

var direction: float = 1.0
var last_facing_direction: int = 1

var can_dash := true

var can_double_jump := true
@export var is_double_jumping := false

@onready var attack_timer: Timer = $AttackTimer

@onready var black_dash: BlackDash = $BlackDash
@export var has_black_dash := false

@onready var hurt_box: PlayerHurtBox = $HurtBox
@onready var attack_1_hit_box: PlayerHitBox = $Attack1HitBox
@onready var attack_2_hit_box: PlayerHitBox = $Attack2HitBox
@onready var attack_up_hit_box: PlayerHitBox = $AttackUpHitBox
@onready var attack_down_hit_box: PlayerHitBox = $AttackDownHitBox

signal attack_down_start(force_state_str: String)



func _ready() -> void:
	# 注入依赖
	player_state_machine.actor = self
	for player_state in player_state_machine.get_children():
		(player_state as PlayerState).actor = self
		
	# Normal -> AttackJump 依赖注入
	attack_down_start.connect((player_state_machine.get_child(0) as Normal)._set_force_state)
	
	_connect_signals()

func _process(delta: float) -> void:
	player_state_machine.process_update(delta)
	
	if debug:
		time_count += delta
		if time_count > 0.1:
			time_count = 0
			print(can_dash)

func _physics_process(delta: float) -> void:
	player_state_machine.process_phy_update(delta)
	move_and_slide()

#region normal state

func _physics_process4normal(delta: float) -> void:
	apply_gravity(delta)

	# 跳跃/二段跳
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif can_double_jump:
			is_double_jumping = true
			can_double_jump = false
			velocity.y = SECOND_JUMP_VELOCITY
	
	# 短跳
	if velocity.y < 0 and not Input.is_action_pressed("jump"):
		velocity.y += SHORT_JUMP_FACTOR * gravity * delta
	
	apply_movement(delta)
	
	# 朝向处理
	update_facing_direction()
	
	# normal state 的各种动画
	update_animation()

func update_facing_direction() -> void:
	if direction != 0:
		sprite_area.scale.x = sign(direction)
		last_facing_direction = sign(direction)
		
		for box in get_tree().get_nodes_in_group("player_boxes"):
			(box as Area2D).scale.x = sign(direction)

func update_animation() -> void:
	if not is_on_floor():
		if is_double_jumping:
			animation_player.play("double_jump")
		else:
			animation_player.play("jump" if velocity.y > 0 else "fall")
	else:
		animation_player.play("move" if velocity.x != 0 else "idle")

#endregion

#region dash state

func enter_dash() -> void:
	var dash_direction: int
	if direction != 0:
		dash_direction = sign(direction)
	else:
		dash_direction = last_facing_direction
	
	velocity.x = dash_direction * MAXDASHSPEED
	velocity.y = 0
	
	if has_black_dash:
		black_dash.spawn_black_dash()
		animation_player.play("black_dash")
	else:
		animation_player.play("dash")


func exit_dash() -> void:
	reset_velocitiy()

func reset_velocitiy() -> void:
	velocity = Vector2.ZERO
	
#endregion dash state

#region attack_up state

func enter_attack(normal_attack_1_flag: bool) -> void:
	attack_timer.start()
	if normal_attack_1_flag:
		animation_player.play("normal_attack_1")  
	else:
		animation_player.play("normal_attack_2")


func _physics_process4attack(delta: float) -> void:
	apply_gravity(delta)
	apply_movement(delta)


func exit_attack() -> void:
	pass

#endregion attack_up state

#region attack_up state

func enter_attack_up() -> void:
	attack_timer.start()
	animation_player.play("attack_up")

func exit_attack_up() -> void:
	pass

#endregion attack_up state


#region attack_down state

func enter_attack_down() -> void:
	attack_timer.start()
	animation_player.play("attack_down")

func exit_attack_down() -> void:
	pass

#endregion attack_down state

#region hit & hurt box

func _on_hurt_box_area_entered(_area: Area2D) -> void:
	pass

func _on_attack_1_hit_box_area_entered(_area: Area2D) -> void:
	velocity.x -= sign(direction) * knockback_speed

func _on_attack_2_hit_box_area_entered(_area: Area2D) -> void:
	velocity.x -= sign(direction) * knockback_speed

func _on_attack_up_hit_box_area_entered(_area: Area2D) -> void:
	print("Attack")

func _on_attack_down_hit_box_area_entered(_area: Area2D) -> void:
	var force_state_str := "AttackJump"
	attack_down_start.emit(force_state_str)

#endregion hit & hurt box

#region attack_jump

func enter_attack_jump() -> void:
	animation_player.play("attack_jump")

func _physics_process4attack_jump(delta: float) -> void:
	velocity.x = 0
	velocity.y = JUMP_VELOCITY / 1.5
	
	apply_gravity(delta)
	apply_movement(delta)


func exit_attack_jump() -> void:
	pass

#endregion attack_jump

#region utils

func _connect_signals() -> void:
	hurt_box.area_entered.connect(_on_hurt_box_area_entered)
	attack_1_hit_box.area_entered.connect(_on_attack_1_hit_box_area_entered)
	attack_2_hit_box.area_entered.connect(_on_attack_2_hit_box_area_entered)
	attack_up_hit_box.area_entered.connect(_on_attack_up_hit_box_area_entered)
	attack_down_hit_box.area_entered.connect(_on_attack_down_hit_box_area_entered)

# 施加重力
func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		can_dash = true
		can_double_jump = true

# 左右移动
func apply_movement(delta: float) -> void:
	direction = Input.get_axis("move_left", "move_right")
	var target_speed = direction * MAX_SPEED if direction != 0 else 0.0
	var acceleration = ACCELERATION if sign(direction) == sign(velocity.x) else FRICTION_FACTOR
	
	# 如果移动方向与键盘输入反向, 立即重置速度
	if sign(direction) * velocity.x < 0:
		velocity.x /= 2
		#velocity.x = 0
	
	# 检测刚开始移动的瞬间
	if direction != 0 and abs(velocity.x) < 0.1:
		# 添加启动冲量
		velocity.x = direction * START_SPEED
	
	velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)

#endregion utils
