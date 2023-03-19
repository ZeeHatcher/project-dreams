extends Node2D

onready var progress_amt = $Progress/path/amt
var total_time = 30
var progress_tween
var spawn_tween
var apollo_tween

onready var clouds_right = $CloudsRight
onready var clouds_left = $CloudsLeft

onready var phoenix_spawner_right = $PhonenixSpawnerRight
onready var phoenix_spawner_left = $PhonenixSpawnerLeft

onready var apollo_spawner_right = $ApolloSpawnerRight
onready var apollo_spawner_left = $ApolloSpawnerLeft

onready var icarus = $Icarus

# Called when the node enters the scene tree for the first time.
func _ready():
	clouds_left.show()
	clouds_right.show()

	progress_tween = create_tween()
	progress_tween.tween_property(progress_amt, "unit_offset", 1, total_time)
	progress_tween.tween_callback(self, "win_minigame")

	spawn_tween = create_tween()
	spawn_tween.tween_interval(3)
	spawn_tween.tween_callback(self, "spawn_enemy")

	apollo_tween = create_tween()
	apollo_tween.tween_interval(rand_range(5, 7))
	apollo_tween.tween_callback(self, "spawn_apollo")

	icarus.connect("hurt", self, "fail_minigame")

onready var phoenix_scn = preload("res://entities/sky_traffic/phoenix.tscn")
onready var apollo_scn = preload("res://entities/sky_traffic/apollo.tscn")
onready var enemy_layer = $Enemies

func spawn_enemy():
	var at = phoenix_spawner_right.rand_loc()
	var phx_dir = Vector2.LEFT

	if randi() % 2 == 0:
		at = phoenix_spawner_left.rand_loc()
		phx_dir = Vector2.RIGHT

	var phx = phoenix_scn.instance()
	enemy_layer.add_child(phx)
	phx.global_position = at
	phx.direction = phx_dir
	phx.speed = 250

	spawn_tween = create_tween()
	var intensity = lerp(0, -2, progress_amt.unit_offset)
	spawn_tween.tween_interval(rand_range(3, 5) + intensity)
	spawn_tween.tween_callback(self, "spawn_enemy")

func spawn_apollo():
	var apollo = apollo_scn.instance()
	var at = apollo_spawner_right.rand_loc()
	var dir = Vector2.LEFT

	print("DERP")
	if randi() % 2 == 0:
		print("HERP")
		apollo.flip()
		at = apollo_spawner_left.rand_loc()
		dir = Vector2.RIGHT
	
	apollo.direction = dir
	enemy_layer.add_child(apollo)
	apollo.global_position = at
	apollo.starting_point = at
	apollo.speed = 350
	apollo.horse_count = 4
	apollo.connect("tree_exiting", self, "spawn_apollo", [], CONNECT_DEFERRED)


func fail_minigame():
	MapData.save_minigame_result(Globals.Minigames.SKYFALL, false)

func win_minigame():
	MapData.save_minigame_result(Globals.Minigames.SKYFALL, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
