extends CharacterBody2D
class_name Player

@export var speed = 300
@export var accelerometer_speed = 130.0
@export var slide = 1.0
@export var gravity = 15.0
@export var jump_velocity = -800

var maxFallVelocity = 1000
var viewport_size 

var use_accelerometer = false

@onready var animator = $AnimationPlayer

func _ready():
	viewport_size = get_viewport_rect().size 
	var os_name = OS.get_name()
	if os_name == "Android" || os_name == "iOS":
		use_accelerometer = true


func _process(_delta):
	if velocity.y > 0:
		if animator.current_animation != "fall":
			animator.play("fall")
	elif velocity.y < 0:
		if animator.current_animation != "jump":
			animator.play("jump")
	

func _physics_process(_delta):
	velocity.y += gravity
	if velocity.y > maxFallVelocity:
		velocity.y = maxFallVelocity
	
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
