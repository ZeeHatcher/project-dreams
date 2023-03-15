extends Node2D


export var grid_size: int = 5
export var tile_margin: int = 1
export var grid_position: Vector2 = Vector2(75, 35)


var tile_scene: PackedScene = preload("res://scenes/minigames/slide_puzzle/tile.tscn")
var tiles: Array # sorted 0 - grid_size ^2
var board: Array # [column][row] -> tile

onready var puzzle_image = $"%PuzzleImage"


func _ready():
	create_tiles()
	shuffle_board()
	update_board()
	
	print(is_board_solved())


func create_tiles():
	for i in range(grid_size * grid_size):
		# instantiate tile
		var tile = tile_scene.instance()
		tile.number = i
		tile.grid_position = Vector2(99, 99) # place outside of screen by default
		add_child(tile)
		tile.connect("tile_clicked", self, "on_tile_clicked")
		tiles.append(tile)
		
		# set texture
		var tile_sprite: Sprite = tile.sprite
		tile_sprite.texture = puzzle_image.texture
		tile_sprite.hframes = grid_size
		tile_sprite.vframes = grid_size
		tile_sprite.frame = i
		
		# set shape
		tile.shape.extents = puzzle_image.texture.get_size() / grid_size / 2


func shuffle_board():
	var tiles_copy = tiles.duplicate()
	tiles_copy.shuffle()
		
	for c in range(grid_size):
		var column: Array
		for r in range(grid_size):
			var tile = tiles_copy.pop_front()
			tile.grid_position = Vector2(c, r)
			column.append(tile)
			
		board.append(column)

	
	# delete last tile
	board[grid_size - 1][grid_size - 1].grid_position = Vector2(99,99)
	board[grid_size - 1][grid_size - 1] = null



func update_board():
	# tile pos an size
	var width: float = puzzle_image.texture.get_width() / grid_size
	var height: float = puzzle_image.texture.get_height() / grid_size
	
	# set position
	for i in range(tiles.size()):
		tiles[i].position.x = (tiles[i].grid_position.x * width) + (tile_margin * tiles[i].grid_position.x) + grid_position.x
		tiles[i].position.y = (tiles[i].grid_position.y * height) + (tile_margin * tiles[i].grid_position.y) + grid_position.y


func on_tile_clicked(number, grid_position):
	move_tile(number, grid_position)
	update_board()
	
	if is_board_solved():
		print("hurray")
	update_board()


func move_tile(number: int, grid_position: Vector2):
	var tile = board[grid_position.x][grid_position.y]
	
	# not on right side of board
	if grid_position.x < grid_size - 1:
		# check right
		if board[grid_position.x + 1][grid_position.y] == null:
			# move right
			board[grid_position.x + 1][grid_position.y] = tile
			tile.grid_position = Vector2(grid_position.x + 1, grid_position.y)
			board[grid_position.x][grid_position.y] = null
			print("moved right")
			return

	# not on left side of board
	if grid_position.x > 0:
		# check left
		if board[grid_position.x - 1][grid_position.y] == null:
			# move left
			board[grid_position.x - 1][grid_position.y] = tile
			tile.grid_position = Vector2(grid_position.x - 1, grid_position.y)
			board[grid_position.x][grid_position.y] = null
			print("moved left")
			return

	# not on top side of board
	if grid_position.y > 0:
		# check up
		if board[grid_position.x][grid_position.y - 1] == null:
			# move up
			board[grid_position.x][grid_position.y - 1] = tile
			tile.grid_position = Vector2(grid_position.x, grid_position.y - 1)
			board[grid_position.x][grid_position.y] = null
			print("moved up")
			return

	# not on bottom side of board
	if grid_position.y < grid_size - 1:
		# check down
		if board[grid_position.x][grid_position.y + 1] == null:
			# move down
			board[grid_position.x][grid_position.y + 1] = tile
			tile.grid_position = Vector2(grid_position.x, grid_position.y + 1)
			board[grid_position.x][grid_position.y] = null
			print("moved down")
			return


func is_board_solved() -> bool:
	var missing_tiles: Array
	var count = 0
	for y in range(grid_size):
		for x in range(grid_size):
			print("checking x:", x, "y:", y, " = ", board[x][y])
			if board[x][y] != null:
				if board[x][y].number != count:
					print("tile wrong at ", count, " (", board[x][y].number,")")
					return false
			else:
				missing_tiles.append(count)
			
			count += 1
	
	# board is solved
	# fill missing tiles
	count = 0
	for y in range(grid_size):
		for x in range(grid_size):
			if missing_tiles.has(count):
				var tile = tiles[count]
				tile.grid_position = Vector2(x, y)
				board[x][y] = tile
			
			count += 1

	
	return true
