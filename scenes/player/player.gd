extends CharacterBody2D
class_name Player

#region 变量与信号


const JUMP_VELOCITY := -400.0
const ACCELERATION := 120
const START_SPEED := 90
const MAX_SPEED := 210
const SHORT_JUMP_FACTOR := 8
const FRICTION_FACTOR := 2 * ACCELERATION
const MAXDASHSPEED := 300
const SECOND_JUMP_VELOCITY := JUMP_VELOCITY
const knockback_speed := 60
const DOWNSMASH_SPEED := 360

const NO_FORCE := "NO_FORCE"

@export var debug := true
var time_count := 0.0

var gravity: float = 1200

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

signal force_transition(force_state_str: String)

var hurt_direction := 0 # 0表示没有受击，±1表示水平受击方向

@onready var invincible_timer: Timer = $InvincibleTimer

@onready var shockwave_spawner: PlayerShockwaveSpawner = $ShockwaveSpawner

@onready var roar_spawner: RoarSpawner = $RoarSpawner

@onready var down_smash_spawner: DownSmashSpawner = $DownSmashSpawner

#endregion 变量与信号

func _ready() -> void:
	inject_dependency()
	
	_connect_signals()

func _process(delta: float) -> void:
	player_state_machine.process_update(delta)
	
	if debug:
		time_count += delta
		if time_count > 0.1:
			time_count = 0
			
			print(hurt_box.get_child(0).disabled)

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
	
	var force_state_str := NO_FORCE
	if Global_HUD.player_soul >= 3:
		if Input.is_action_just_pressed("heal"):
			force_state_str = "Heal"
			force_transition.emit(force_state_str)
	
		if Input.is_action_just_pressed("use_skill"):
			if Input.is_action_pressed("look_up"):
				force_state_str = "RoarAttack"
				force_transition.emit(force_state_str)
			elif Input.is_action_pressed("look_down"):
				force_state_str = "PrepareDownSmash1"
			else:
				force_state_str = "ReleaseShockwave"
				force_transition.emit(force_state_str)
	
	if force_state_str != NO_FORCE:
		force_transition.emit(force_state_str)
	
	apply_movement(delta)
	
	update_facing_direction()
	
	# normal state 的各种动画
	update_animation()


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
	can_dash = false
	
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
		(hurt_box.get_child(0) as CollisionPolygon2D).disabled = true
	else:
		animation_player.play("dash")

func exit_dash() -> void:
	if has_black_dash:
		# 无敌状态优先度高于冲刺
		# 这个bug发生于无敌状态下黑冲，无敌时间未结束但被黑冲结束设置hurt_disabled=true
		if invincible_timer.is_stopped():
			(hurt_box.get_child(0) as CollisionPolygon2D).disabled = false
	
	reset_velocitiy()
	
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

#endregion attack_down state

#region hit & hurt box

func _on_hurt_box_area_entered(area: Area2D) -> void:
	hurt_direction = sign(area.global_position.x - self.global_position.x)
	var force_state_str := "Hurt"
	
	force_transition.emit(force_state_str)
	
	# 不同的area造成不同的伤害，复杂情况可以用match
	var v := -1 if area.name == "BodyHitBox" else -2
	update_health(v)

func _on_attack_1_hit_box_area_entered(_area: Area2D) -> void:
	velocity.x -= sign(direction) * knockback_speed
	
	update_soul(1)

func _on_attack_2_hit_box_area_entered(_area: Area2D) -> void:
	velocity.x -= sign(direction) * knockback_speed
	
	update_soul(1)
	

func _on_attack_up_hit_box_area_entered(_area: Area2D) -> void:
	update_soul(1)


func _on_attack_down_hit_box_area_entered(_area: Area2D) -> void:
	var force_state_str := "AttackJump"
	force_transition.emit(force_state_str)
	
	update_soul(1)


#endregion hit & hurt box

#region attack_jump

func enter_attack_jump() -> void:
	animation_player.play("attack_jump")
	
	reset_skill()

func _physics_process4attack_jump(delta: float) -> void:
	velocity.x = 0
	velocity.y = JUMP_VELOCITY / 1.5
	
	apply_gravity(delta)
	apply_movement(delta)


func exit_attack_jump() -> void:
	pass

#endregion attack_jump


#region hurt state

func enter_hurt() -> void:
	#脸朝着敌人被碰离（可以注释掉下面两行，测试一下从左侧跳到敌人右上方碰）
	direction = hurt_direction
	update_facing_direction()
	
	animation_player.play("hurt")
	
	velocity.x = - hurt_direction * 90
	
	invincible(2, true)

func exit_hurt() -> void:
	hurt_direction = 0

func invincible(active_time: float = 2, flash_effect: bool = true) -> void:
	invincible_timer.wait_time = active_time
	invincible_timer.one_shot = true
	invincible_timer.start()
	
	(hurt_box.get_child(0) as CollisionPolygon2D).disabled = true
	
	if flash_effect:
		while not invincible_timer.is_stopped():
			(sprite_area.get_child(0) as Sprite2D).visible = false
			await get_tree().create_timer(0.1).timeout
			(sprite_area.get_child(0) as Sprite2D).visible = true
			await get_tree().create_timer(0.1).timeout
	else:
		await invincible_timer.timeout
	
	(hurt_box.get_child(0) as CollisionPolygon2D).disabled = false
	


#endregion hurt state

#region die1 state

func enter_die1() -> void:
	animation_player.play("die1")

#endregion die1 state

#region die2 state

func enter_die2() -> void:
	animation_player.play("die2")

#endregion die2 state

#region heal state

func enter_heal() -> void:
	reset_velocitiy()
	
	animation_player.play("heal")

func exit_heal() -> void:
	update_soul(-3)
	update_health(1)

#endregion heal state

#region release shockwave state

func enter_release_shockwave() -> void:
	reset_velocitiy()
	
	animation_player.play("release_shockwave")

	shockwave_spawner.timer.start()

func release_shockwave() -> void:
	shockwave_spawner.spawn_projectile()

func exit_release_shockwave() -> void:
	update_soul(-3)

#endregion release shockwave state

#region roar attack state

func enter_roar_attack() -> void:
	reset_velocitiy()
	
	animation_player.play("roar_attack")

	roar_spawner.timer.start()

func release_roar() -> void:
	roar_spawner.spawn_projectile()

func exit_roar_attack() -> void:
	update_soul(-3)

#endregion roar attack state

#region prepare down smash 1 state

func enter_prepare_down_smash_1() -> void:
	reset_velocitiy()
	
	animation_player.play("prepare_down_smash1")

func exit_prepare_down_smash_1() -> void:
	update_soul(-3)

#endregion prepare down smash 1 state

#region prepare down smash 2 state

func enter_prepare_down_smash_2() -> void:
	animation_player.play("prepare_down_smash2")

func _physics_process4prepare_down_smash_2(delta: float) -> void:
	velocity.x = 0
	velocity.y = DOWNSMASH_SPEED
	
	apply_gravity(delta)

#endregion prepare down smash 1 state

#region prepare down smash 2 state

func enter_down_smash() -> void:
	reset_velocitiy()
	
	animation_player.play("down_smash")

	down_smash_spawner.timer.start()

func release_down_smash() -> void:
	down_smash_spawner.spawn_projectile()

#endregion prepare down smash 1 state

#region utils

# 注入依赖
func inject_dependency() -> void:
	player_state_machine.actor = self
	for player_state in player_state_machine.get_children():
		(player_state as PlayerState).actor = self
		
	# Normal -> AttackJump 依赖注入
	force_transition.connect((player_state_machine.get_child(0) as PlayerNormal)._set_force_state)

# 连接信号
func _connect_signals() -> void:
	hurt_box.area_entered.connect(_on_hurt_box_area_entered)
	attack_1_hit_box.area_entered.connect(_on_attack_1_hit_box_area_entered)
	attack_2_hit_box.area_entered.connect(_on_attack_2_hit_box_area_entered)
	attack_up_hit_box.area_entered.connect(_on_attack_up_hit_box_area_entered)
	attack_down_hit_box.area_entered.connect(_on_attack_down_hit_box_area_entered)

# 施加重力
func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
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
		
		# 这里有一个关于手感的"bug"。加速后掉头不会享受到起步速度。可以跟静止后的起步速度作对比。
		# 如果启用下面这行代码，掉头时速度需要衰减时间，来满足下面的abs(velocity.x) < 1 。
		# 这会导致掉头时起步太慢。
		#velocity.x /= 2
		
		# 而 x /= -8 直接掉头，给一个相对较低的启动速度既会有更舒服的手感，又有刹车的感觉。
		# 总之，物理运动参数的数值调整问题也是打磨手感的一部分。不必太纠结。
		velocity.x /= -8
	
	# 检测刚开始移动的瞬间
	if direction != 0 and abs(velocity.x) < 1:
		# 添加启动冲量
		velocity.x = direction * START_SPEED
	
	velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)

# 朝向处理
func update_facing_direction() -> void:
	if direction != 0:
		sprite_area.scale.x = sign(direction)
		last_facing_direction = sign(direction)
		
		for box in get_tree().get_nodes_in_group("player_boxes"):
			(box as Area2D).scale.x = sign(direction)

# 静止状态
func reset_velocitiy() -> void:
	velocity = Vector2.ZERO

# 刷新技能（比如二段跳、冲刺）
func reset_skill() -> void:
	can_dash = true
	can_double_jump = true

# 改变health并同步更新UI
func update_health(v: int) -> void:
	Global_HUD.player_health += v

# 改变soul并同步更新UI
func update_soul(v: int) -> void:
	Global_HUD.player_soul += v

#endregion utils
