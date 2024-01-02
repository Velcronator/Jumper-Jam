extends CharacterBody2D
class_name Player

@export var speed = 300
@export var slide = 1
@export var gravity = 15.0

var maxFallVelocity = 1000
var viewport_size 

func _ready():
	viewport_size = get_viewport_rect().size 

func _process(delta):
	pass

func _physics_process(delta):
	velocity.y += gravity
	if velocity.y > maxFallVelocity:
		velocity.y = maxFallVelocity

	
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



