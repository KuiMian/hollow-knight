extends CharacterBody2D

const JUMP_VELOCITY := -400.0
const ACCELERATION := 180
const MAX_SPEED := 210
const SHORT_JUMP_FACTOR := 8
const FRICTION_FACTOR := 2 * ACCELERATION

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if velocity.y < 0 and not Input.is_action_pressed("jump"):
		velocity.y += SHORT_JUMP_FACTOR * gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")

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

	move_and_slide()
	
	update_animation()
	check_facing_direction(direction)


func update_animation() -> void:
	if not is_on_floor():
		animation_player.play("jump" if velocity.y > 0 else "fall")
	else:
		animation_player.play("move" if velocity.x != 0 else "idle")


func check_facing_direction(direction: float) -> void:
	if direction != 0:
		sprite_2d.flip_h = direction < 0
