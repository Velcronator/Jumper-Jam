extends CharacterBody2D
class_name Player

signal died

@onready var animator = $AnimationPlayer
@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D

@export var speed = 300
@export var accelerometer_speed = 130.0
@export var slide = 1.0
@export var gravity = 15.0
@export var jump_velocity = -800

var maxFallVelocity = 1000
var viewport_size 

var use_accelerometer = false

var dead = false

var fall_anim_name = "fall"
var jump_anim_name = "jump"

func _ready():
	viewport_size = get_viewport_rect().size 
	var os_name = OS.get_name()
	if os_name == "Android" || os_name == "iOS":
		use_accelerometer = true


func _process(_delta):
	if velocity.y > 0:
		if animator.current_animation != fall_anim_name:
			animator.play(fall_anim_name)
	elif velocity.y < 0:
		if animator.current_animation != jump_anim_name:
			animator.play(jump_anim_name)
	

func _physics_process(_delta):
	velocity.y += gravity
	if velocity.y > maxFallVelocity:
		velocity.y = maxFallVelocity
	
	if!dead:
		if use_accelerometer:
			var mobile_input = Input.get_accelerometer()
			velocity.x = mobile_input.x * accelerometer_speed
		else:
			var input_direction = Input.get_axis("move_left","move_right")
			if input_direction:
				velocity.x = speed * input_direction
			else:
				velocity.x = move_toward(velocity.x, 0, speed / slide) 
	
	move_and_slide()
	
	var margin = 20
	if global_position.x > viewport_size.x + margin:
		global_position.x = - margin
	elif global_position.x < - margin:
		global_position.x = viewport_size.x + margin

func jump():
	velocity.y = jump_velocity
	SoundFX.fx_play("Jump")

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die()

func die():
	if!dead:
		dead = true
		collision_shape.set_deferred("disabled", true)
		died.emit()
		SoundFX.fx_play("Fall")

func use_new_skin():
	fall_anim_name = "fall_red"
	jump_anim_name = "jump_red"
	
	if sprite:
			sprite.texture = preload("res://assets/textures/character/Skin2Idle.png")
