extends Node2D

signal player_died(score, highscore)

@onready var level_generator = $LevelGenerator
@onready var ground_sprite = $GroundSprite

@onready var parallax1 = $ParallaxBackground/ParallaxLayer
@onready var parallax2 = $ParallaxBackground/ParallaxLayer2
@onready var parallax3 = $ParallaxBackground/ParallaxLayer3
@onready var hud = $UILayer/HUD

var player_scene = preload("res://scenes/player.tscn")
var player: Player = null
var player_spawn_pos: Vector2

var camera_scene = preload("res://scenes/game_camera.tscn")
var camera = null

var viewport_size: Vector2

# variables
var score : int = 0
var highscore : int

func _ready():
	viewport_size = get_viewport_rect().size
	var player_spawn_pos_y_offset = 135
	player_spawn_pos.x = viewport_size.x / 2.0
	player_spawn_pos.y = viewport_size.y - player_spawn_pos_y_offset
	
	ground_sprite.global_position.x = viewport_size.x / 2.0
	ground_sprite.global_position.y = viewport_size.y
	
	setup_parallax_layer(parallax1)
	setup_parallax_layer(parallax2)
	setup_parallax_layer(parallax3)
	
	hud.visible = false
	hud.set_score(0)
	ground_sprite.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	#Calculate score
	if player:
		if score < (viewport_size.y - player.global_position.y):
			score = (viewport_size.y - player.global_position.y)
			print(score)
			hud.set_score(score)

func new_game():
	reset_game()
	
	player = player_scene.instantiate()
	player.global_position = player_spawn_pos
	player.died.connect(_on_player_died)
	add_child(player)

	camera = camera_scene.instantiate()
	camera.setup_camera(player)
	add_child(camera)
	
	if player:
		level_generator.setup(player)
		level_generator.start_generation()
	hud.visible = true
	ground_sprite.visible = true
	
	#reset the score to 0
	score = 0

func get_parallax_sprite_scale(parallax_sprite: Sprite2D):
	var parallax_texture = parallax_sprite.get_texture()
	var parallax_texture_width = parallax_texture.get_width()
	
	var sprite_scale = viewport_size.x / parallax_texture_width
	var result = Vector2(sprite_scale, sprite_scale)
	return result

func setup_parallax_layer(parallax_layer: ParallaxLayer):
	var parallax_sprite = parallax_layer.find_child("Sprite2D")
	if parallax_sprite != null:
		parallax_sprite.scale = get_parallax_sprite_scale(parallax_sprite)
		var parallax_layer_mirroring_y = parallax_sprite.scale.y * parallax_sprite.get_texture().get_height()
		parallax_layer.motion_mirroring.y = parallax_layer_mirroring_y

func _on_player_died():
	hud.visible = false
	
	# score and highscore
	if score > highscore:
		highscore = score
	player_died.emit(score, highscore)
	

func reset_game():
	ground_sprite.visible = false
	hud.set_score(0)
	level_generator.reset_level()
	if player != null:
		player.queue_free()
		player = null
		level_generator.player = null
	if camera != null:
		camera.queue_free()
		camera = null

