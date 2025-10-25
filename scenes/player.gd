extends CharacterBody2D
class_name Player

const JUMP_VELOCITY := -400.0
const ACCELERATION := 180
const MAX_SPEED := 210
const SHORT_JUMP_FACTOR := 8
const FRICTION_FACTOR := 2 * ACCELERATION
const MAXDASHSPEED := 300
const SECOND_JUMP_VELOCITY := JUMP_VELOCITY

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


func _ready() -> void:
	# 注入宿主
	player_state_machine.actor = self
	for player_state in player_state_machine.get_children():
		(player_state as PlayerState).actor = self


func _process(delta: float) -> void:
	player_state_machine.process_update(delta)
	
	if debug:
		time_count += delta
		if time_count > 1:
			time_count = 0
			print(black_dash.scale)


func _physics_process(delta: float) -> void:
	player_state_machine.process_phy_update(delta)
	move_and_slide()

#region normal state

func _physics_process4normal(delta: float) -> void:
	# 施加重力
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		can_dash = true
		can_double_jump = true

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
	
	# 左右移动
	direction = Input.get_axis("move_left", "move_right")
	var target_speed = direction * MAX_SPEED if direction != 0 else 0.0
	var acceleration = ACCELERATION if sign(direction) == sign(velocity.x) else FRICTION_FACTOR
	velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
	
	# 朝向处理
	update_facing_direction()
	
	# normal state 的各种动画
	update_animation()

func update_facing_direction() -> void:
	if direction != 0:
		sprite_area.scale.x = sign(direction)
		last_facing_direction = sign(direction)

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
	# 施加重力
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		can_dash = true
		can_double_jump = true
	
	# 左右移动
	direction = Input.get_axis("move_left", "move_right")
	var target_speed = direction * MAX_SPEED if direction != 0 else 0.0
	var acceleration = ACCELERATION if sign(direction) == sign(velocity.x) else FRICTION_FACTOR
	velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)


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
