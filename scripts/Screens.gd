extends CanvasLayer

@onready var console = $Debug/ConsoleLog
@onready var title_screen = $TitleScreen
@onready var pause_screen = $PauseScreen
@onready var game_over_screen = $GameOverScreen

var current_screen = null

func _ready():
	console.visible = false
	register_buttons()

func register_buttons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	if buttons.size() > 0:
		for button in buttons:
			if button is ScreenButton:
				button.clicked.connect(_on_button_pressed)

func _on_button_pressed(button):
	match button.name:
		"TitlePlay":
			print("Play button is pressed")
			change_screen(null)
		"PauseRetry":
			print("PauseRetry button is pressed")
		"PauseBack":
			print("PauseBack button is pressed")
		"PauseClose":
			print("PauseClose button is pressed")
		"GameOverRetry":
			print("GameOverRetry button is pressed")
		"GameOverBack":
			print("GameOverBack button is pressed")

func _process(_delta):
	pass

func _on_toggle_console_pressed() -> void:
	console.visible = !console.visible

func change_screen(new_screen):
	if current_screen != null:
		current_screen.disappear()
	current_screen = new_screen
	if current_screen != null:
		current_screen.appear()
