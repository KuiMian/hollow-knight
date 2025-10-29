extends CharacterBody2D
class_name Boss

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

@onready var hit_box: EnemyHitBox = $HitBox
@onready var hurt_box: EnemyHurtBox = $HurtBox
@onready var flash_timer: Timer = $FlashTimer


func _ready() -> void:
	animation_player.play("idle")
	
	hurt_box.area_entered.connect(_on_hurt_box_area_entered)


func _on_hurt_box_area_entered(_area: Area2D) -> void:
	flash_timer.start()
	sprite_2d.use_parent_material = false
	
	await flash_timer.timeout
	sprite_2d.use_parent_material = true
