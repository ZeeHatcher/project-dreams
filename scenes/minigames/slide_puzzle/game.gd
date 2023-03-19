extends Node2D


onready var board = $"%Board"


func start_game():
	board.start_timer()
	board.create_tiles()
	board.shuffle_board()
	board.update_board()


func game_won(required_turns):
	if required_turns >= 666:
		MapData.save_minigame_result(Globals.Minigames.SLIDE_PUZZLE, -1)
	else:
		MapData.save_minigame_result(Globals.Minigames.SLIDE_PUZZLE, 1)


func _on_Instructions_closed():
	start_game()
