extends Node2D


export var grid_size_x: int = 4
export var grid_size_y: int = 4
export var tile_margin: int = 2
export var bombs: int = 5

var turns: int = 0

var tile_scene: PackedScene = preload("res://scenes/minigames/slide_puzzle/tile.tscn")
var tiles: Array # sorted 0 - grid_size_x * grid_size_y
var board: Array # [column][row] -> tile

var width: float
var height: float
var board_solved: bool = false
var animating: bool = false

onready var puzzle_image = $"%PuzzleImage"
onready var grid_offset = puzzle_image.position
onready var end_wait_timer = $"%EndWaitTimer"
onready var end_animation_timer = $"%EndAnimationTimer"
onready var end_animation_fade = $"%EndAnimationFade"
onready var game_timer = $"%GameTimer"
onready var hud_turns = $"%Turns"
onready var hud_bombs = $"%HudBombs"
onready var hud_clock = $"%Clock"
onready var bgm = $"%Bgm"
onready var snd_scream = $"%snd_scream"
onready var snd_move = $"%snd_move_queue"
onready var snd_blocked = $"%snd_blocked"
onready var snd_destroy = $"%snd_destroy"


func _ready():
	# get size of one tile with current settings
	width = puzzle_image.texture.get_width() / grid_size_x * puzzle_image.scale.x
	height = puzzle_image.texture.get_height() / grid_size_y * puzzle_image.scale.y
	
	puzzle_image.visible = false
	
	hud_bombs.value = bombs
	
	bgm.play()


func start_timer():
	# start game
	game_timer.start()


func create_tiles():
	for i in range(grid_size_x * grid_size_y):
		# instantiate tile
		var tile = tile_scene.instance()
		tile.number = i
		tile.grid_position = Vector2(999, 999) # place outside of screen by default
		add_child(tile)
		tile.connect("tile_clicked", self, "on_tile_clicked")
		tile.connect("tile_rightclicked", self, "on_tile_rightclicked")
		tiles.append(tile)
		
		# set texture
		var tile_sprite: Sprite = tile.sprite
		tile_sprite.texture = puzzle_image.texture
		tile_sprite.scale = puzzle_image.scale
		tile_sprite.hframes = grid_size_x
		tile_sprite.vframes = grid_size_y
		tile_sprite.frame = i
		
		# set shape
		tile.collision.position.x = puzzle_image.texture.get_size().x / grid_size_x * puzzle_image.scale.x / 2
		tile.collision.position.y = puzzle_image.texture.get_size().y / grid_size_y * puzzle_image.scale.y / 2
		tile.shape.extents.x = puzzle_image.texture.get_size().x / grid_size_x * puzzle_image.scale.x / 2
		tile.shape.extents.y = puzzle_image.texture.get_size().y / grid_size_y * puzzle_image.scale.y / 2


func shuffle_board():
	var tiles_copy = tiles.duplicate()
	tiles_copy.shuffle()
		
	for c in range(grid_size_x):
		var column: Array
		for r in range(grid_size_y):
			var tile = tiles_copy.pop_front()
			tile.grid_position = Vector2(c, r)
			column.append(tile)
			
		board.append(column)
	
	# delete last tile?
	# could force the use of bombs as a tutorial
	#board[grid_size_x - 1][grid_size_y - 1].grid_position = Vector2(999,999)
	#board[grid_size_x - 1][grid_size_y - 1] = null


func update_board():
	# set position
	for i in range(tiles.size()):
		tiles[i].position = get_position_from_grid(tiles[i].grid_position)


func get_position_from_grid(grid_position: Vector2) -> Vector2:
	return Vector2(
				(grid_position.x * width) + (tile_margin * grid_position.x) + grid_offset.x,
				(grid_position.y * height) + (tile_margin * grid_position.y) + grid_offset.y
			)


func on_tile_clicked(number, grid_position):
	if animating:
		return
	
	if board_solved:
		if not end_wait_timer.is_stopped():
			return
		
		end_animation()
		return
	
	move_tile(number, grid_position)
	
	check_if_won()


func on_tile_rightclicked(number, grid_position):
	if animating:
		return
	
	if board_solved:
		if not end_wait_timer.is_stopped():
			return

		end_animation()
		return
	
	destroy_tile(grid_position)
	
	check_if_won()
	update_board()


func destroy_tile(grid_position: Vector2):
	if bombs <= 0:
		print("no bombs left")
		if not OS.is_debug_build():
			return
	
	# update hud
	bombs -= 1
	hud_bombs.value = bombs
	add_turn()
	
	# play sound
	snd_destroy.play()
	
	# remove tile
	var tile = board[grid_position.x][grid_position.y]
	tile.grid_position = Vector2(999, 999)
	board[grid_position.x][grid_position.y] = null


func check_if_won():
	if is_board_solved():
		end_wait_timer.start()
		board_solved = true
		bgm.stop()
		game_timer.paused = true
		print("slide puzzle solved")
		solve_board()
		update_board()


func move_tile(number: int, grid_position: Vector2):
	var tile = board[grid_position.x][grid_position.y]
	
	var possible_directions = 0
	var direction = Vector2.ZERO
	
	# not on right side of board
	if grid_position.x < grid_size_x - 1:
		# check right
		if board[grid_position.x + 1][grid_position.y] == null:
			direction = Vector2.RIGHT
			possible_directions += 1

	# not on left side of board
	if grid_position.x > 0:
		# check left
		if board[grid_position.x - 1][grid_position.y] == null:
			direction = Vector2.LEFT
			possible_directions += 1

	# not on top side of board
	if grid_position.y > 0:
		# check up
		if board[grid_position.x][grid_position.y - 1] == null:
			direction = Vector2.UP
			possible_directions += 1

	# not on bottom side of board
	if grid_position.y < grid_size_y - 1:
		# check down
		if board[grid_position.x][grid_position.y + 1] == null:
			direction = Vector2.DOWN
			possible_directions += 1
	
	# no clear possible move
	if possible_directions != 1:
		snd_blocked.play()
		animate_shake(tile)
		return
	
	# move
	add_turn()
	snd_move.play()
	match direction:
		Vector2.UP:
			# move up
			board[grid_position.x][grid_position.y - 1] = tile
			tile.grid_position = Vector2(grid_position.x, grid_position.y - 1)
			board[grid_position.x][grid_position.y] = null
			animate_move(tile)
		
		Vector2.RIGHT:
			# move right
			board[grid_position.x + 1][grid_position.y] = tile
			tile.grid_position = Vector2(grid_position.x + 1, grid_position.y)
			board[grid_position.x][grid_position.y] = null
			animate_move(tile)
			
		Vector2.DOWN:
			# move down
			board[grid_position.x][grid_position.y + 1] = tile
			tile.grid_position = Vector2(grid_position.x, grid_position.y + 1)
			board[grid_position.x][grid_position.y] = null
			animate_move(tile)
			
		Vector2.LEFT:
			# move left
			board[grid_position.x - 1][grid_position.y] = tile
			tile.grid_position = Vector2(grid_position.x - 1, grid_position.y)
			board[grid_position.x][grid_position.y] = null
			animate_move(tile)


func animate_move(tile):
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(tile, "position", get_position_from_grid(tile.grid_position), 0.5)


func animate_shake(tile):
	animating = true
	var tween = create_tween()
	tween.connect("finished", self, "_on_animation_finished")
	tween.tween_property(tile, "rotation", tile.rotation + 0.02, 0.05)
	tween.tween_property(tile, "rotation", tile.rotation - 0.02, 0.05)
	tween.tween_property(tile, "rotation", tile.rotation + 0.02, 0.05)
	tween.tween_property(tile, "rotation", tile.rotation - 0.02, 0.05)
	tween.tween_property(tile, "rotation", tile.rotation, 0.1)


func _on_animation_finished():
	animating = false


func add_turn():
	turns += 1
	hud_turns.text = str(turns)


func is_board_solved() -> bool:
	var count = 0
	for y in range(grid_size_y):
		for x in range(grid_size_x):
			print("checking x:", x, "y:", y, " = ", board[x][y])
			if board[x][y] != null:
				if board[x][y].number != count:
					print("tile wrong at ", count, " (", board[x][y].number,")")
					return false
			
			count += 1
	
	return true


func solve_board():
	# fill missing tiles
	var count = 0
	for y in range(grid_size_y):
		for x in range(grid_size_x):
			var tile = tiles[count]
			tile.grid_position = Vector2(x, y)
			board[x][y] = tile
			
			count += 1


func end_animation():
	puzzle_image.visible = true
	hud_bombs.visible = false
	hud_turns.visible = false
	hud_clock.visible = false
	
	free_board()
	
	# play sound
	snd_scream.play()
	
	# animation
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(puzzle_image, "scale", Vector2(3.0, 3.0), 2.0)
	tween.parallel().tween_property(puzzle_image, "position", puzzle_image.position - puzzle_image.texture.get_size(), 2.0)
	tween.parallel().tween_property(end_animation_fade, "modulate", Color(1.0, 1.0, 1.0, 1.0), 2.2).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	
	end_animation_timer.start()


func free_board():
	for i in range(tiles.size()):
		tiles[i].queue_free()
	
	tiles.clear()
	board.clear()


func _on_GameTimer_timeout():
	turns = 998
	add_turn()
	board_solved = true
	solve_board()


func _on_EndAnimationTimer_timeout():
	get_parent().game_won(turns)


func _unhandled_key_input(event: InputEventKey):
	if board_solved:
		return
	
	if event.is_action_pressed("restart"):
		free_board()
		create_tiles()
		shuffle_board()
		update_board()
		bombs = 5
		hud_bombs.value = 5
