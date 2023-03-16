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
	$Enemy.connect("body_entered", self, "_lose_game")
	
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


func _lose_game(_node : Node):
	print("ah poop")
#	MapData.save_minigame_result(Globals.Minigames.DARK_MAZE, false)


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
