extends Node

@onready var game = $Game
@onready var screens = $Screens

func _ready():
	screens.start_game.connect(_on_screens_start_game) 
	screens.delete_level.connect(_on_screens_delete_level)
	game.pause_game.connect(on_game_pause_game)
	game.player_died.connect(_on_game_player_died)

func _on_screens_start_game():
	game.new_game()

func _on_game_player_died(score, highscore):
	# Introduce a delay of 0.75 seconds
	await(get_tree().create_timer(0.75).timeout)
	screens.game_over(score, highscore)

func _on_screens_delete_level():
	game.reset_game()

func on_game_pause_game():
	get_tree().paused = true
	screens.pause_game()
