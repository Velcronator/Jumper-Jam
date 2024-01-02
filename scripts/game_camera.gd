extends Camera2D

var player: Player = null

func _ready() -> void:
	global_position.x = get_viewport_rect().size.x / 2
	

func _process(delta: float) -> void:
	pass

func setup_camera(_player: Player):
	if _player != null:
		player = _player

func _physics_process(delta):
	if player:
		global_position.y = player.global_position.y
