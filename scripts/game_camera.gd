extends Camera2D

@export var limit_distance = 420

var viewport_size

var player: Player = null

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	global_position.x = viewport_size.x / 2
	
	limit_bottom = viewport_size.y
	# not necessary.
	limit_left = 0
	limit_right = viewport_size.x

func _process(_delta: float) -> void:
	if player:
		if limit_bottom > player.global_position.y + limit_distance:
			limit_bottom = player.global_position.y + limit_distance

func setup_camera(_player: Player):
	if _player != null:
		player = _player

func _physics_process(_delta):
	if player:
		global_position.y = player.global_position.y
