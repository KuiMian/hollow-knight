extends CharacterBody2D
class_name Boss

@export var debug := false
var time_count := 0.0

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
		if time_count > 1:
			time_count = 0

func _physics_process(delta: float) -> void:
	boss_state_machine.process_phy_update(delta)

func _on_hurt_box_area_entered(_area: Area2D) -> void:
	flash_timer.start()
	sprite_2d.use_parent_material = false
	
	await flash_timer.timeout
	sprite_2d.use_parent_material = true


#region idle state


func _physics_process4idle(_delta: float) -> void:
	face_player()
	#apply_gravity(delta)

	# 跳跃/二段跳
	#if Input.is_action_just_pressed("jump"):
		#if is_on_floor():
			#velocity.y = JUMP_VELOCITY
		#elif can_double_jump:
			#is_double_jumping = true
			#can_double_jump = false
			#velocity.y = SECOND_JUMP_VELOCITY
	
	# 短跳
	#if velocity.y < 0 and not Input.is_action_pressed("jump"):
		#velocity.y += SHORT_JUMP_FACTOR * gravity * delta
	#
	#apply_movement(delta)
	
	# 朝向处理
	#update_facing_direction()
	
	# normal state 的各种动画
	#update_animation()

#func update_facing_direction() -> void:
	#if direction != 0:
		#sprite_area.scale.x = sign(direction)
		#last_facing_direction = sign(direction)
		#
		#for box in get_tree().get_nodes_in_group("player_boxes"):
			#(box as Area2D).scale.x = sign(direction)
#
#func update_animation() -> void:
	#if not is_on_floor():
		#if is_double_jumping:
			#animation_player.play("double_jump")
		#else:
			#animation_player.play("jump" if velocity.y > 0 else "fall")
	#else:
		#animation_player.play("move" if velocity.x != 0 else "idle")

func face_player() -> void:
	var player: Player = get_tree().get_nodes_in_group("players")[0]
	var facing_flag := player.global_position < global_position
	sprite_area.scale.x = 1 if facing_flag else -1
	hurt_box.scale.x = 1 if facing_flag else -1
	body_hit_box.scale.x = 1 if facing_flag else -1
	attack_1_hit_box.scale.x = 1 if facing_flag else -1
	attack_2_hit_box.scale.x = 1 if facing_flag else -1
	

#endregion idle state

#region prepare attack1 state

func enter_prepare_attack1() -> void:
	animation_player.play("prepare_attack1")

#endregion prepare attack1 state

#region attack1 state

func enter_attack1() -> void:
	animation_player.play("attack1")

#endregion attack1 state

#region prepare attack2 state

func enter_prepare_attack2() -> void:
	animation_player.play("prepare_attack2")

#endregion prepare attack2 state

#region attack2 state

func enter_attack2() -> void:
	animation_player.play("attack2")


#endregion attack2 state

#region util

# 注入依赖
func inject_dependency() -> void:
	boss_state_machine.actor = self
	for boss_state in boss_state_machine.get_children():
		(boss_state as BossState).actor = self
	
#endregion
