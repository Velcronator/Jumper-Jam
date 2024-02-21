extends Node

@onready var game = $Game
@onready var screens = $Screens

var game_in_progress = false

func _ready():
	DisplayServer.window_set_window_event_callback(_on_window_event)
	
	screens.start_game.connect(_on_screens_start_game) 
	screens.delete_level.connect(_on_screens_delete_level)
	game.pause_game.connect(_on_game_pause_game)
	game.player_died.connect(_on_game_player_died)
	
	#IAP purchase signals
	screens.purchase_skin.connect(_on_screens_purchase_skin)
	


func _on_window_event(event):
	match event:
		DisplayServer.WINDOW_EVENT_FOCUS_IN:
			print("Focus in")
			MyUtility.add_log_msg("Focus in")
		DisplayServer.WINDOW_EVENT_FOCUS_OUT:
			print("Focus out")
			MyUtility.add_log_msg("Focus out")
			
			if game_in_progress == true && !get_tree().paused:
				_on_game_pause_game()
				print("Ed Window minimized, pausing the game!")
				MyUtility.add_log_msg("Mobile Window minimized, pausing the game!")
		DisplayServer.WINDOW_EVENT_CLOSE_REQUEST:
			get_tree().quit()

#func _process(delta):
#	print(game_in_progress)
#print(game_in_progress)
func _on_screens_purchase_skin():
	if game.new_skin_unlocked == false:
		game.new_skin_unlocked = true

func _on_screens_start_game():
	game_in_progress = true
	game.new_game()

func _on_game_player_died(score, highscore):
	game_in_progress = false
	# Introduce a delay of 0.75 seconds
	await(get_tree().create_timer(0.75).timeout)
	screens.game_over(score, highscore)

func _on_screens_delete_level():
	game_in_progress = false
	game.reset_game()

func _on_game_pause_game():
	get_tree().paused = true
	screens.pause_game()

