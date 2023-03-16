extends Node2D


onready var board = $"%Board"


func _ready():
	start_game()


func start_game():
	board.create_tiles()
	board.shuffle_board()
	board.update_board()


func game_won(required_turns):
	pass
	# scene transition
