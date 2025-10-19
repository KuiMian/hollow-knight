extends CharacterBody2D

const SPEED = 2.0
const JUMP_VELOCITY = -400.0
const ACCELERATION := 60
const MAX_SPEED := 250
const SHORT_JUMP_FACTOR := 8

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


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
	if direction:
		velocity.x += direction * ACCELERATION * delta
		velocity.x = clamp(velocity.x, - MAX_SPEED, MAX_SPEED)
		#velocity.x = direction * SPEED
	else:
		#velocity.x = move_toward(velocity.x, 0, MAX_SPEED * 0.8 * delta)
		velocity.x = lerp(.0, velocity.x, pow(0.2, delta))

	move_and_slide()
