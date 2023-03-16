extends Node2D


# Ripping off GDQuest for navigation setup:
# https://www.youtube.com/watch?v=aW4Oa-4dyXA

# Ripping off KidsCanCode for maze generation:
# https://www.youtube.com/watch?v=YShYWaGF3Nc


const N := 1
const E := 2
const S := 4
const W := 8
const MIN_MAP_SIZE := 3
const MAX_MAP_SIZE := 50

var cell_walls = {
	Vector2(0, -1): N,
	Vector2(1, 0): E,
	Vector2(0, 1): S,
	Vector2(-1, 0): W
}

export var maze_width := 10
export var maze_height := 10


func _ready():
	$Enemy.z_index = 20
	$Player.z_index = 30
	
	# warning-ignore:return_value_discarded
	$Enemy.connect("body_entered", self, "_finish_game", [false])
	# warning-ignore:return_value_discarded
	$Goal.connect("body_entered", self, "_finish_game", [true])
	
	# The higher this number, the more sluggish he reacts
	# Currently set to 1.0 seconds
	#$Enemy/Timer.wait_time = 0.5
	
	_make_maze()
	$TileMap.bake_navigation = true
	set_process(true)


func _process(_delta):
	if $Player.position.y > $Enemy.position.y:
		$Player.z_index = 30
	elif $Player.position.y < $Enemy.position.y:
		$Player.z_index = 10


func _finish_game(node : Node, success : bool):
	if node == $Player:
		print("win = " + str(success))
		MapData.save_minigame_result(Globals.Minigames.DARK_MAZE, success)


func _check_neighbors(cell, unvisited):
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list


func _make_maze():
	if maze_width < MIN_MAP_SIZE: maze_width = MIN_MAP_SIZE
	if maze_width > MAX_MAP_SIZE: maze_width = MAX_MAP_SIZE
	if maze_height < MIN_MAP_SIZE: maze_height = MIN_MAP_SIZE
	if maze_height > MAX_MAP_SIZE: maze_height = MAX_MAP_SIZE
	
	randomize()
	
	var unvisited = []
	var stack = []
	var maze = {}
	
	for x in maze_width:
		for y in maze_height:
			unvisited.append(Vector2(x, y))
			maze[Vector2(x, y)] = W|S|E|N
	
	var current = Vector2.ZERO
	unvisited.erase(current)
	
	var exit_coord := Vector2.ZERO
	
	if randi() % 2:
		if randi() % 2:
			exit_coord.x = -1
		else:
			exit_coord.x = maze_width
		
		exit_coord.y = randi() % maze_height
	else:
		if randi() % 2:
			exit_coord.y = -1
		else:
			exit_coord.y = maze_height
		
		exit_coord.x = randi() % maze_width
	
	unvisited.append(exit_coord)
	maze[exit_coord] = W|S|E|N
	
	while(unvisited):
		var neighbors = _check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			
			var dir = next - current
			maze[current] -= cell_walls[dir]
			maze[next] -= cell_walls[-dir]
			
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
	
	for x in maze_width:
		for y in maze_height:
			var template : TileMap = get_node(
				"Cells/" + str(maze[Vector2(x, y)])
			)
			
			var cell_rect := template.get_used_rect()
			
			for i in cell_rect.size.x:
				for j in cell_rect.size.y:
					$TileMap.set_cell(
						cell_rect.size.x * x + i,
						cell_rect.size.y * y + j,
						template.get_cell(i, j)
					)
	
	$Goal.position = Vector2(
		exit_coord.x * 32 * 12 + 192,
		exit_coord.y * 32 * 12 + 192
	)
	
	$Enemy.position = Vector2(
		maze_width / 2 * 32 * 12 + 192,
		maze_height / 2 * 32 * 12 + 192
	)
	
	$Player.position = Vector2(
		(randi() % maze_width) * 32 * 12 + 192,
		(randi() % maze_height) * 32 * 12 + 192
	)
