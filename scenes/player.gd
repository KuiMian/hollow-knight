extends CharacterBody2D
class_name Player

const JUMP_VELOCITY := -400.0
const ACCELERATION := 180
const MAX_SPEED := 210
const SHORT_JUMP_FACTOR := 8
const FRICTION_FACTOR := 2 * ACCELERATION
const MAXDASHSPEED := 300
const SECOND_JUMP_VELOCITY := JUMP_VELOCITY

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_area: Area2D = $SpriteArea

@onready var player_state_machine: PlayerStateMachine = $PlayerStateMachine

var direction: float = 1.0
var last_facing_direction: int = 1

var can_dash := true

var can_double_jump := true
@export var is_double_jumping := false


func _ready() -> void:
	# 注入宿主
	player_state_machine.actor = self
	for player_state in player_state_machine.get_children():
		(player_state as PlayerState).actor = self


func _process(delta: float) -> void:
	print(is_double_jumping)
	player_state_machine.process_update(delta)


func _physics_process(delta: float) -> void:
	player_state_machine.process_phy_update(delta)
	move_and_slide()

func _physics_process4normal(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		can_dash = true
		can_double_jump = true

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif can_double_jump:
			is_double_jumping = true
			can_double_jump = false
			velocity.y = SECOND_JUMP_VELOCITY
	
	if velocity.y < 0 and not Input.is_action_pressed("jump"):
		velocity.y += SHORT_JUMP_FACTOR * gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("move_left", "move_right")

	#if direction:
		#velocity.x += direction * ACCELERATION * delta
		#velocity.x = clamp(velocity.x, - MAX_SPEED, MAX_SPEED)
		##velocity.x = direction * SPEED
	#
	## 此时反向移动无摩擦力
	#else:
		#velocity.x = move_toward(velocity.x, 0, FRICTION_FACTOR * delta)
		##velocity.x = lerp(.0, velocity.x, pow(0.2, delta))
	
	var target_speed = direction * MAX_SPEED if direction != 0 else 0.0
	var acceleration = ACCELERATION if sign(direction) == sign(velocity.x) else FRICTION_FACTOR
	velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)

	update_facing_direction()
	update_animation()

func dash() -> void:
	var dash_direction: int
	if direction != 0:
		dash_direction = sign(direction)
	else:
		dash_direction = last_facing_direction
	
	velocity.x = dash_direction * MAXDASHSPEED
	velocity.y = 0
	
	#var dash_finish := func(): velocity.x = 0
	#animation_player.animation_finished.connect(dash_finish)
	animation_player.play("dash")
	#animation_player.animation_finished.disconnect(dash_finish)


func update_animation() -> void:
	if not is_on_floor():
		if is_double_jumping:
			animation_player.play("double_jump")
		else:
			animation_player.play("jump" if velocity.y > 0 else "fall")
	else:
		animation_player.play("move" if velocity.x != 0 else "idle")


func update_facing_direction() -> void:
	if direction != 0:
		sprite_area.scale.x = sign(direction)
		last_facing_direction = sign(direction)

func reset_velocitiy() -> void:
	velocity = Vector2.ZERO
