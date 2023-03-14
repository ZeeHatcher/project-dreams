extends Node2D


export var grid_size: int = 5
export var grid_margin: int = 1
export var grid_position: Vector2 = Vector2(75, 35)


var tiles: Array
var tile_scene: PackedScene = preload("res://scenes/minigames/slide_puzzle/tile.tscn")

onready var puzzle_image = $"%PuzzleImage"



func _ready():
	create_board()


func create_board():
	# tile pos an size
	var current_x: float = grid_position.x + grid_margin
	var current_y: float = grid_position.y + grid_margin
	var width: float = puzzle_image.texture.get_width() / grid_size
	var height: float = puzzle_image.texture.get_height() / grid_size
		
	# create tiles
	for i in range(grid_size * grid_size):		
		# instantiate tile
		var tile = tile_scene.instance()
		tile.position = Vector2(current_x, current_y)
		add_child(tile)
		tiles.append(tile)
		
		# set texture
		var tile_sprite: Sprite = tile.sprite
		tile_sprite.texture = puzzle_image.texture
		tile_sprite.hframes = grid_size
		tile_sprite.vframes = grid_size
		tile_sprite.frame = i
		
		# get next position
		if (i + 1) % grid_size > 0:
			current_x += width + (2 * grid_margin)
			
		else:
			# jump line
			current_y += height + (2 * grid_margin)
			current_x = grid_position.x + grid_margin
