extends CharacterBody2D
class_name Boss

@export var debug := false
var time_count := 0.0

var direction: int = -1

var gravity: float = 6000


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_area: Area2D = $SpriteArea
@onready var sprite_2d: Sprite2D = $SpriteArea/Sprite2D

@onready var hurt_box: EnemyHurtBox = $HurtBox
@onready var flash_timer: Timer = $FlashTimer

@onready var boss_state_machine: BossStateMachine = $BossStateMachine
@onready var body_hit_box: EnemyHitBox = $BodyHitBox
@onready var attack_1_hit_box: EnemyHitBox = $Attack1HitBox
@onready var attack_2_hit_box: EnemyHitBox = $Attack2HitBox



func _ready() -> void:
	inject_dependency()
	
	animation_player.play("idle")
	
	hurt_box.area_entered.connect(_on_hurt_box_area_entered)

func _process(delta: float) -> void:
	boss_state_machine.process_update(delta)
	
	if debug:
		time_count += delta
		if time_count > 0.1:
			time_count = 0
			
			print(velocity)

func _physics_process(delta: float) -> void:
	boss_state_machine.process_phy_update(delta)
	
	move_and_slide()

func _on_hurt_box_area_entered(_area: Area2D) -> void:
	flash_timer.start()
	sprite_2d.use_parent_material = false
	
	await flash_timer.timeout
	sprite_2d.use_parent_material = true

#region ready state

func exit_ready() -> void:
	print("battle start")
	animation_player.play("idle")

#endregion ready state

#region idle state

func enter_idle() -> void:
	animation_player.play("idle")
	
	reset_velocitiy()

func _physics_process4idle(_delta: float) -> void:
	face_player()
	
	reset_velocitiy()
	
	apply_gravity(_delta)

	#apply_movement(delta)
	
	# normal state 的各种动画
	#update_animation()

#
#func update_animation() -> void:
	#if not is_on_floor():
		#if is_double_jumping:
			#animation_player.play("double_jump")
		#else:
			#animation_player.play("jump" if velocity.y > 0 else "fall")
	#else:
		#animation_player.play("move" if velocity.x != 0 else "idle")


#endregion idle state

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
	velocity.y = 0
	
	apply_gravity(delta)

#endregion attack1 state

#region prepare attack2 state

func enter_prepare_attack2() -> void:
	reset_velocitiy()
	
	animation_player.play("prepare_attack2")

#endregion prepare attack2 state

#region attack2 state

func enter_attack2() -> void:
	animation_player.play("attack2")
	
func _physics_process4attack2(delta: float) -> void:
	velocity.x = 80 * sign(direction)
	velocity.y = -300
	
	apply_gravity(delta)

func exit_attack2() -> void:
	velocity.y = 1000

#endregion attack2 state

#region util

func inject_dependency() -> void:
	boss_state_machine.actor = self
	for boss_state in boss_state_machine.get_children():
		(boss_state as BossState).actor = self

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func face_player() -> void:
	var player: Player = get_tree().get_nodes_in_group("players")[0]
	direction = -1 if player.global_position < global_position else 1
	
	update_facing_direction()

func update_facing_direction() -> void:
	sprite_area.scale.x = - sign(direction)
		
	for box in get_tree().get_nodes_in_group("boss_boxes"):
		(box as Area2D).scale.x = - sign(direction)

func reset_velocitiy() -> void:
	velocity = Vector2.ZERO

#endregion
