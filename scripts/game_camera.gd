extends Camera2D

@onready var destroyer = $Destroyer
@onready var destroyer_shape = $Destroyer/CollisionShape2D

@export var limit_distance = 420

var depth_of_platform_catcher = 200
var viewport_size

var player: Player = null

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	global_position.x = viewport_size.x / 2
	
	limit_bottom = viewport_size.y
	# not necessary.
	limit_left = 0
	limit_right = viewport_size.x
	
	destroyer.position.y = viewport_size.y
	
	var rect_shape = RectangleShape2D.new()
	var rect_shape_size = Vector2(viewport_size.x, depth_of_platform_catcher)
	rect_shape.set_size(rect_shape_size)
	destroyer_shape.shape = rect_shape

func _process(_delta: float) -> void:
	if player:
		if limit_bottom > player.global_position.y + limit_distance:
			limit_bottom = int(player.global_position.y + limit_distance)
			
	var overlapping_areas = destroyer.get_overlapping_areas()
	if overlapping_areas.size() > 0:
		for area in overlapping_areas:
			if area is Platform:
				area.queue_free()

func setup_camera(_player: Player):
	if _player != null:
		player = _player

func _physics_process(_delta):
	if player:
		global_position.y = player.global_position.y
